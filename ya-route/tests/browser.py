"""Offline Chromium tests of real PHP markup and compiled TypeScript, with explicit SDK/socket doubles.
Requires Python playwright, tsc, PHP and a Chromium executable (CHROMIUM_PATH override).
No real Yandex request, database, GPS or WebSocket is used.
"""
import base64
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import urllib.request
from urllib.parse import urlparse, parse_qs
from playwright.sync_api import sync_playwright
from integration import APP, fixture_server, parse_boot


def main():
	out = APP / ".test-build"
	out.mkdir(exist_ok=True)
	subprocess.run(["tsc", "--target", "ES2020", "--module", "none", "--strict", "--outFile", str(out / "browser-mock.js"), str(APP / "tests/browser-mock.ts")], check=True)
	checks = 0
	def check(condition, label):
		nonlocal checks
		checks += 1
		if not condition:
			raise AssertionError(label)
	def near(point, expected):
		return point is not None and all(abs(point[i] - expected[i]) < 0.0000001 for i in range(2))
	with fixture_server() as (_, base, _state), sync_playwright() as pw:
		html = urllib.request.urlopen(base + "/yandex-route/?101").read().decode()
		config = parse_boot(html)
		icon = "data:image/png;base64," + base64.b64encode((APP / "img/mixer.png").read_bytes()).decode()
		config["iconUrl"] = icon
		shell = re.sub(r'<script[^>]+src="[^"]+"[^>]*></script>', '', html)
		shell = re.sub(r'<link[^>]*>', '', shell)
		shell = shell.replace('src="img/mixer.png"', 'src="' + icon + '"')
		browser = pw.chromium.launch(executable_path=os.environ.get("CHROMIUM_PATH") or shutil.which("chromium"), headless=True, args=["--no-sandbox"])
		def page_setup(changes=None, before="", wait=True, width=1280, height=800, sdk_response=None):
			page = browser.new_page(viewport={"width": width, "height": height})
			errors = []
			page.on("pageerror", lambda error: errors.append(str(error)))
			page.route("**/*", lambda route: route.abort())
			if sdk_response:
				page.route("https://api-maps.yandex.ru/v3/**", sdk_response)
			boot = dict(config)
			boot.update(changes or {})
			body = re.sub(r'(<script id="route-config" type="application/json">).*?(</script>)', lambda m: m[1] + json.dumps(boot).replace("</", "<\\/") + m[2], shell, flags=re.S)
			page.set_content(body, wait_until="domcontentloaded")
			page.add_style_tag(path=str(APP / "assets/route.css"))
			page.add_script_tag(path=str(out / "browser-mock.js"))
			if before:
				page.evaluate(before)
			page.add_script_tag(path=str(APP / "assets/route.js"))
			if wait:
				page.wait_for_function("document.getElementById('map-message').hidden")
			return page, errors
		def get(page, name):
			return page.evaluate(f"window.routeFixture.{name}()")
		def event(page, kind, params):
			page.evaluate("(e) => window.routeFixture.emit(e)", {"eventId": "Vehicle." + kind + ".tracker-7", "params": params})
		def position(page, lon, second, lat=56.83, **extra):
			event(page, "position", {"lon": lon, "lat": lat, "period": f"2026-09-21T09:21:{second:02d}+05:00", **extra})
		def tick(page, ms):
			page.evaluate("(ms) => window.routeFixture.tick(ms)", ms)
		def pressed(page):
			return page.get_attribute("#follow-vehicle", "aria-pressed") == "true"
		p, errors = page_setup()
		check(near(get(p, "vehicle"), [60.58, 56.83]), "initial fix shown immediately with longitude first")
		check(p.inner_text("#distance") == "0 м", "zero remaining distance visible")
		check(p.evaluate("routeFixture.calls") == ["construct", "connect", "subscribe"], "original AppSrv sequence")
		check(len(get(p, "events")) == 4, "all four original subscriptions")
		check(p.evaluate("routeFixture.requests.length") == 0, "no startup data request")
		check(get(p, "marker")["disableRoundCoordinates"] is True, "subpixel native markers")
		check(get(p, "options")["mode"] == "auto", "official automatic render mode")
		check("copyrights" not in get(p, "options"), "native attribution not disabled")
		check(len(get(p, "zones")) == 1 and len(get(p, "route")["coordinates"]) == 4, "route and destination polygon created")
		check(near(get(p, "destination"), [60.62, 56.837]), "route endpoint marker")
		position(p, 60.584, 2, route_rest_len=120)
		check(near(get(p, "vehicle"), [60.58, 56.83]), "fix does not jump before animation")
		tick(p, 600)
		mid = get(p, "vehicle")
		check(60.58 < mid[0] < 60.584, "vehicle intermediate animation position")
		position(p, 60.586, 3)
		check(near(get(p, "vehicle"), mid), "interrupt retargets from displayed position")
		tick(p, 1200)
		check(near(get(p, "vehicle"), [60.586, 56.83]), "marker reaches latest fix")
		check(near(get(p, "camera"), get(p, "vehicle")), "following camera reaches fix")
		check(get(p, "frames") == 0, "finite animation loop stops")
		check(get(p, "vehicleCreations") == 1, "native marker is reused")
		position(p, 60.57, 1, route_rest_len=999, route_rest="60 56,61 57")
		check(near(get(p, "vehicle"), [60.586, 56.83]), "stale fix rejected")
		check(p.inner_text("#distance") != "999 м", "stale packet cannot overwrite distance")
		check(len(get(p, "route")["coordinates"]) == 4, "stale packet cannot overwrite route")
		for action in ["drag", "pinchZoom", "scrollZoom", "dblClick", "oneFingerZoom"]:
			p.evaluate("type => routeFixture.action(type)", action)
			check(not pressed(p), "user map action stops follow: " + action)
			p.click("#find-vehicle")
			check(pressed(p), "find re-enables follow: " + action)
		p.click("#fit-route")
		check(not pressed(p), "whole route stops following")
		camera = get(p, "camera")
		position(p, 60.587, 4)
		tick(p, 600)
		check(near(get(p, "camera"), camera), "disabled follow leaves camera fixed")
		p.click("#find-vehicle")
		tick(p, 600)
		check(near(get(p, "camera"), get(p, "vehicle")), "find during animation converges camera")
		p.focus("#map")
		p.keyboard.press("ArrowRight")
		check(not pressed(p), "keyboard navigation stops follow")
		old_zoom = get(p, "zoom")
		p.click("#zoom-in")
		check(get(p, "zoom") > old_zoom, "zoom in control")
		p.click("#zoom-out")
		check(get(p, "zoom") == old_zoom, "zoom out control")
		event(p, "route_redraw", {"route_rest": "60.58 56.83,60.59 56.84"})
		check(len(get(p, "route")["coordinates"]) == 2, "route redraw replaces geometry")
		event(p, "route_redraw", {"route_rest": "bad geometry"})
		check(len(get(p, "route")["coordinates"]) == 2, "malformed route retains geometry")
		event(p, "route_redraw", {"route_rest": "60.6 56.84"})
		check(get(p, "route") is None and near(get(p, "destination"), [60.6, 56.84]), "one point has endpoint but no invalid line")
		event(p, "route_redraw", {"route_rest": ""})
		check(get(p, "route") is None, "explicit empty route clears line")
		event(p, "route_redraw", {"long_route_rest": True})
		p.wait_for_function("routeFixture.requests.length === 1")
		p.wait_for_function("routeFixture.route()?.coordinates.length === 2")
		request = p.evaluate("routeFixture.requests[0]")
		check("long_route_rest.php" in request["url"] and request["method"] == "GET", "one event-triggered long-route GET")
		check(request["headers"]["X-Route-Token"] == config["readToken"], "scoped read token")
		p.click("#share-location")
		p.wait_for_function("document.getElementById('location-panel').hidden")
		check(p.evaluate("routeFixture.requests.length") == 2, "location causes only a single POST")
		request = p.evaluate("routeFixture.requests[1]")
		check(request["method"] == "POST" and json.loads(request["body"]) == {"lon": 60.62, "lat": 56.837}, "location payload unchanged")
		check(request["headers"]["X-Route-Token"] == config["locationToken"], "separate write token")
		tick(p, 120000)
		check(p.evaluate("routeFixture.requests.length") == 2, "animation/time does not request more data")
		position(p, 60.59, 6)
		check(near(get(p, "vehicle"), [60.59, 56.83]), "long arrival gap snaps to latest fix")
		position(p, 61, 7)
		check(near(get(p, "vehicle"), [61, 56.83]), "large correction snaps")
		position(p, 61.001, 8)
		p.evaluate("routeFixture.reduced(true)")
		check(near(get(p, "vehicle"), [61.001, 56.83]) and get(p, "frames") == 0, "reduced motion completes and cancels animation")
		p.evaluate("routeFixture.reduced(false)")
		position(p, 61.002, 9)
		p.evaluate("routeFixture.hidden(true)")
		check(get(p, "frames") == 0, "background stops animation")
		position(p, 61.003, 10)
		p.evaluate("routeFixture.hidden(false)")
		check(near(get(p, "vehicle"), [61.003, 56.83]), "foreground displays latest background fix without replay")
		p.evaluate("window.dispatchEvent(new PageTransitionEvent('pagehide', {persisted: true}))")
		check(not get(p, "destroyed"), "bfcache page retained")
		p.evaluate("window.dispatchEvent(new PageTransitionEvent('pageshow', {persisted: true}))")
		p.evaluate("window.dispatchEvent(new PageTransitionEvent('pagehide', {persisted: false}))")
		check(get(p, "destroyed") and get(p, "frames") == 0, "page unload disposes map and frames")
		check(not errors, "no unhandled browser errors")
		p.close()

		p, errors = page_setup(before="routeFixture.deferReady()", wait=False)
		check(p.evaluate("routeFixture.calls.length") == 3, "subscribe before SDK readiness")
		position(p, 60.59, 1)
		position(p, 60.595, 2)
		check(get(p, "vehicle") is None, "no map created before readiness")
		p.evaluate("routeFixture.resolveReady()")
		p.wait_for_function("document.getElementById('map-message').hidden")
		check(near(get(p, "vehicle"), [60.595, 56.83]) and get(p, "frames") == 0, "newest buffered fix displayed immediately")
		check(not errors, "delayed readiness no browser errors")
		p.close()

		p, _ = page_setup({"yandex": {**config["yandex"], "apiKey": ""}}, wait=False)
		p.wait_for_function("document.getElementById('map-message').textContent.includes('ROUTE_YANDEX_API_KEY')")
		check(p.is_hidden("#map-controls") and p.is_disabled("#find-vehicle"), "missing key visible error and disabled map controls")
		check(p.evaluate("document.getElementById('yandex-maps-api') === null"), "missing key does not load SDK")
		p.close()
		p, _ = page_setup(before="routeFixture.deferReady()", wait=False)
		p.evaluate("routeFixture.rejectReady()")
		p.wait_for_function("document.getElementById('map-message').textContent.includes('отклонили')")
		check(get(p, "vehicle") is None, "SDK rejection leaves no partially initialized map")
		p.close()
		p, _ = page_setup({"yandex": {**config["yandex"], "loadTimeoutMs": 50}}, before="routeFixture.deferReady()", wait=False)
		p.wait_for_function("document.getElementById('map-message').textContent.includes('вовремя')")
		p.evaluate("routeFixture.resolveReady()")
		check(get(p, "vehicle") is None, "late SDK cannot initialize after deadline")
		p.close()

		sdk_requests = []
		def sdk_ok(route):
			sdk_requests.append(route.request.url)
			route.fulfill(status=200, content_type="application/javascript", body="window.ymaps3 = window.routeFixture.sdk;")
		p, errors = page_setup(before="delete window.ymaps3", sdk_response=sdk_ok)
		check(len(sdk_requests) == 1, "loader inserts one SDK request")
		parsed = urlparse(sdk_requests[0])
		check(parsed.hostname == "api-maps.yandex.ru" and parsed.path == "/v3/", "official HTTPS v3 SDK URL")
		check(parse_qs(parsed.query) == {"apikey": [config["yandex"]["apiKey"]], "lang": ["ru_RU"]}, "key and locale encoded in loader")
		check(p.get_attribute("#yandex-maps-api", "referrerpolicy") == "origin", "origin-only SDK referrer")
		check(not errors, "dynamic SDK load no unhandled error")
		p.close()
		p, _ = page_setup(before="delete window.ymaps3", wait=False)
		p.wait_for_function("document.getElementById('map-message').textContent.includes('Не удалось загрузить')")
		check(get(p, "vehicle") is None, "blocked SDK gives visible error")
		p.close()

		p, _ = page_setup({"position": None, "route": "", "destinationZone": None})
		check(p.is_disabled("#find-vehicle") and p.is_disabled("#fit-route"), "empty route/GPS disables unavailable actions")
		position(p, 60.6, 1)
		check(not p.is_disabled("#find-vehicle") and near(get(p, "vehicle"), [60.6, 56.83]), "first websocket fix enables vehicle controls")
		p.close()
		p, _ = page_setup({"destinationZone": {"type": "Polygon", "coordinates": "bad"}})
		check(p.is_visible("#notice") and get(p, "vehicle") is not None, "bad zone degrades gracefully")
		p.close()

		for name, width, height in [("desktop", 1440, 900), ("mobile", 390, 844), ("small-mobile", 320, 700), ("landscape", 844, 390)]:
			p, errors = page_setup(width=width, height=height)
			check(p.evaluate("document.documentElement.scrollWidth <= window.innerWidth + 1"), name + " no horizontal overflow")
			check(p.locator("#map").bounding_box()["height"] >= 200, name + " usable map height")
			check(p.locator("#map-controls").bounding_box()["y"] >= p.locator("#map").bounding_box()["y"], name + " controls inside map")
			check(not errors, name + " no unhandled errors")
			p.screenshot(path=str(out / (name + "-mocked.png")), full_page=True)
			p.close()
		browser.close()
	print(f"Offline browser checks passed: {checks}")


if __name__ == "__main__":
	main()
