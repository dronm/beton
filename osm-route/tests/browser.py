"""Offline DOM checks. OpenLayers, AppSrv, fetch and geolocation are explicit test doubles.

No browser URL navigation or external tiles are used. Real PHP HTTP entrypoints
are exercised separately by integration.py. This does NOT verify real map rendering.
"""
import base64
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import urllib.request
from playwright.sync_api import sync_playwright
from integration import APP, fixture_server


def main():
	subprocess.run(["tsc", "--strict", "--target", "ES2020", "--module", "none", "--lib", "ES2020,DOM", "--outFile", str(APP / ".test-build/browser-mock.js"), str(APP / "tests/browser-mock.ts")], check=True)
	mock = (APP / ".test-build/browser-mock.js").read_text()
	compiled = (APP / "assets/route.js").read_text()
	css = (APP / "assets/route.css").read_text()
	output = APP / ".test-build"
	checks = 0
	def check(value, message):
		nonlocal checks
		checks += 1
		if not value:
			raise AssertionError(message)

	with fixture_server() as (root, base, state_file), sync_playwright() as playwright:
		def offline_html(path):
			with urllib.request.urlopen(base + "/route-osm/" + path, timeout=5) as response:
				html = response.read().decode()
			html = re.sub(r'<script\b[^>]*\bsrc="[^"]*"[^>]*></script>', "", html)
			html = re.sub(r'<link\b[^>]*>', "", html)
			icon = base64.b64encode((APP / "img/mixer.png").read_bytes()).decode()
			return html.replace('src="img/mixer.png"', 'src="data:image/png;base64,' + icon + '"')
		binary = os.environ.get("CHROMIUM_PATH") or shutil.which("chromium") or shutil.which("chromium-browser")
		launch_options = {"headless": True, "args": ["--no-sandbox", "--disable-dev-shm-usage"]}
		if binary:
			launch_options["executable_path"] = binary
		browser = playwright.chromium.launch(**launch_options)
		context = browser.new_context(viewport={"width": 1440, "height": 900})
		page = context.new_page()
		errors = []
		page.on("pageerror", lambda error: errors.append(str(error)))
		page.set_content(offline_html("?101"))
		page.add_style_tag(content=css)
		page.add_script_tag(content=mock)
		page.add_script_tag(content=compiled)
		check(not errors, "No browser initialization errors: " + str(errors))
		check(page.locator("#map-message").is_hidden(), "Map adapter initialized")
		check(page.locator("#distance").inner_text() == "0 м", "Zero distance shown")
		check(page.locator("#position-time").inner_text() == "09:21:00 · 21.09", "Initial timestamp")
		check(page.evaluate("window.routeFixture.calls") == ["construct", "connect", "subscribe"], "AppSrv call order in browser")
		check(page.evaluate("window.routeFixture.requests.length") == 0, "No startup API request")
		check(page.locator("#follow-vehicle").get_attribute("aria-pressed") == "true", "Follow default")
		page.locator("#fit-route").click()
		check(page.locator("#follow-vehicle").get_attribute("aria-pressed") == "false", "Whole route disables follow")
		page.locator("#find-vehicle").click()
		check(page.locator("#follow-vehicle").get_attribute("aria-pressed") == "true", "Find re-enables follow")
		page.evaluate("window.routeFixture.drag()")
		check(page.locator("#follow-vehicle").get_attribute("aria-pressed") == "false", "Map drag disables follow")
		page.evaluate("window.routeFixture.emit", {"eventId": "Vehicle.position.tracker-7", "params": {"lon": 60.61, "lat": 56.835, "period": "2026-09-21T09:25:00+05:00", "route_rest_len": 1500, "route_rest": "60.61 56.835,60.62 56.837"}})
		check(page.locator("#distance").inner_text() == "1,5 км", "WebSocket distance update")
		check(page.locator("#position-time").inner_text() == "09:25:00 · 21.09", "WebSocket position update")
		check(page.locator("#live-status").get_attribute("data-kind") == "received", "Event receipt status")
		check(page.evaluate("window.routeFixture.featureExtents()")[0] == [60.61, 56.835, 60.62, 56.837], "Inline geometry sent to map adapter")
		page.evaluate("window.routeFixture.emit", {"eventId": "Vehicle.position.someone-else", "params": {"lon": 0, "lat": 0, "route_rest_len": 999}})
		check(page.locator("#distance").inner_text() == "1,5 км", "Other tracker ignored")
		page.evaluate("window.routeFixture.emit", {"eventId": "Vehicle.route_redraw.tracker-7", "params": {"long_route_rest": True}})
		page.wait_for_function("window.routeFixture.featureExtents()[0][0] === 60.6")
		check(page.evaluate("window.routeFixture.requests.length") == 1, "Exactly one event-triggered fetch")
		check(page.evaluate("window.routeFixture.requests[0].url") == "long_route_rest.php?id=101", "Correct shipment-scoped route URL")
		page.on("dialog", lambda dialog: dialog.accept())
		page.locator("#share-location").click()
		page.locator("#location-panel").wait_for(state="hidden")
		check("Место разгрузки передано" in page.locator("#notice").inner_text(), "Location confirmation")
		check(page.evaluate("window.routeFixture.requests[1].method") == "POST", "Location POST")
		check(json.loads(page.evaluate("window.routeFixture.requests[1].body")) == {"lon": 60.62, "lat": 56.837}, "Location payload")
		page.wait_for_timeout(150)
		check(page.evaluate("window.routeFixture.requests.length") == 2, "No refresh request after location submission")
		check(page.evaluate("document.documentElement.scrollWidth <= innerWidth"), "No desktop overflow")
		page.screenshot(path=str(output / "desktop-mocked.png"), full_page=True)
		page.set_viewport_size({"width": 390, "height": 844})
		check(page.evaluate("document.documentElement.scrollWidth <= innerWidth"), "No mobile overflow")
		check(page.locator("#map").bounding_box()["height"] >= 270, "Usable mobile map height")
		page.screenshot(path=str(output / "mobile-mocked.png"), full_page=True)
		page.set_viewport_size({"width": 320, "height": 700})
		check(page.evaluate("document.documentElement.scrollWidth <= innerWidth"), "No overflow at 320px")
		check(not errors, "No runtime browser errors")

		animation = context.new_page()
		animation_errors = []
		animation.on("pageerror", lambda error: animation_errors.append(str(error)))
		animation.set_content(offline_html("?101"))
		animation.add_style_tag(content=css)
		animation.add_script_tag(content=mock)
		animation.evaluate("window.routeFixture.manualFrames()")
		animation.add_script_tag(content=compiled)
		animation.evaluate("window.routeFixture.captureGeometry()")
		def position(lon, second, distance=100):
			animation.evaluate("window.routeFixture.emit", {"eventId": "Vehicle.position.tracker-7", "params": {
				"lon": lon, "lat": 56.83, "period": f"2026-09-21T09:{21 + second // 60:02d}:{second % 60:02d}+05:00", "route_rest_len": distance,
			}})
		def vehicle():
			return animation.evaluate("window.routeFixture.vehicle()")
		def camera():
			return animation.evaluate("window.routeFixture.camera()")
		def advance(milliseconds):
			animation.evaluate("window.routeFixture.tick", milliseconds)
		def pending():
			return animation.evaluate("window.routeFixture.pendingFrames()")
		check(vehicle() == [60.58, 56.83] and pending() == 0, "Initial map fix is immediate and idle")
		position(60.5812, 10)
		check(vehicle() == [60.58, 56.83] and pending() == 1, "AppSrv starts animation without teleporting")
		check(animation.locator("#position-time").inner_text() == "09:21:10 · 21.09", "GPS timestamp updated immediately, not animated")
		advance(600)
		check(abs(vehicle()[0] - 60.5806) < 1e-10, "Map adapter displays intermediate vehicle coordinate")
		check(camera() == vehicle(), "Following camera moves with intermediate marker")
		before = vehicle()
		position(60.582, 20, 80)
		check(vehicle() == before and pending() == 1, "Rapid AppSrv retarget does not jump or queue transitions")
		advance(1200)
		check(vehicle() == [60.582, 56.83] and pending() == 0, "Latest target reached and animation stops")
		check(animation.evaluate("window.routeFixture.sameGeometry()"), "One Point geometry reused across frames and fixes")
		position(60.1, 19, 999)
		check(vehicle() == [60.582, 56.83] and pending() == 0, "Stale WebSocket fix cannot move marker backward")
		check(animation.locator("#position-time").inner_text() == "09:21:20 · 21.09", "Stale packet cannot regress timestamp label")
		check(animation.locator("#distance").inner_text() == "80 м", "Stale packet cannot regress distance label")
		position(60.582, 21)
		check(pending() == 0, "Repeated stationary fix stays idle in map adapter")
		position(60.5832, 22)
		advance(300)
		animation.evaluate("window.routeFixture.drag()")
		fixed_camera = camera()
		before = vehicle()
		advance(300)
		check(vehicle() != before and camera() == fixed_camera, "Dragging stops camera follow but not vehicle animation")
		animation.evaluate("document.getElementById('find-vehicle').click()")
		advance(100)
		check(animation.locator("#follow-vehicle").get_attribute("aria-pressed") == "true", "Find re-enables follow during animation")
		advance(500)
		check(camera() == vehicle(), "Camera catches moving vehicle by transition end")
		position(60.5844, 25)
		advance(300)
		animation.evaluate("document.getElementById('fit-route').click()")
		fixed_camera = camera()
		advance(900)
		check(camera() == fixed_camera and vehicle() == [60.5844, 56.83], "Whole route view is not overridden by remaining animation frames")
		position(60.5856, 30)
		advance(100)
		animation.evaluate("window.routeFixture.hidden", True)
		check(vehicle() == [60.5856, 56.83] and pending() == 0, "Hiding tab cancels animation and settles latest fix")
		position(60.586, 40)
		check(vehicle() == [60.586, 56.83] and pending() == 0, "Hidden-tab AppSrv events update without animation")
		animation.evaluate("window.routeFixture.hidden", False)
		check(pending() == 0, "Showing tab does not replay old fixes")
		position(60.587, 50)
		check(vehicle() == [60.587, 56.83] and pending() == 0, "First post-resume fix snaps")
		position(60.588, 60)
		check(pending() == 1, "Further visible updates animate normally")
		animation.evaluate("window.dispatchEvent(new PageTransitionEvent('pagehide', {persisted: true}))")
		check(pending() == 0 and vehicle() == [60.588, 56.83], "Back/forward cache suspension stops animation")
		animation.evaluate("window.dispatchEvent(new PageTransitionEvent('pageshow', {persisted: true}))")
		position(60.589, 70)
		position(60.590, 80)
		check(pending() == 1, "Restored page retains a working map and subscriber")
		animation.emulate_media(reduced_motion="reduce")
		animation.wait_for_timeout(100)
		check(pending() == 0 and vehicle() == [60.590, 56.83], "Live reduced-motion preference stops transition")
		position(60.591, 90)
		check(vehicle() == [60.591, 56.83] and pending() == 0, "Reduced-motion fixes are immediate")
		animation.emulate_media(reduced_motion="no-preference")
		animation.wait_for_timeout(100)
		position(60.592, 100)
		check(pending() == 1, "Switching reduced motion off restores smoothing")
		animation.evaluate("window.dispatchEvent(new PageTransitionEvent('pagehide', {persisted: false}))")
		check(pending() == 0, "Permanent page exit cancels frames")
		before = vehicle()
		position(60.593, 110)
		advance(1200)
		check(vehicle() == before and pending() == 0, "Disposed map and subscriber ignore late events")
		check(animation.evaluate("window.routeFixture.requests.length") == 0, "All smoothing checks made zero HTTP requests")
		check(not animation_errors, "No animation browser errors: " + str(animation_errors))
		animation.close()

		for mode in ["missing-appsrv", "missing-openlayers", "noncustomer", "missing-gps"]:
			test_page = context.new_page()
			if mode == "missing-gps":
				state = json.loads(state_file.read_text())
				state["shipments"]["101"]["pos_data"] = None
				state["initial_route"] = ""
				state_file.write_text(json.dumps(state))
			test_page.set_content(offline_html("?m101" if mode == "noncustomer" else "?101"))
			test_page.add_style_tag(content=css)
			if mode != "missing-openlayers":
				test_page.add_script_tag(content=mock)
			if mode == "missing-appsrv":
				test_page.evaluate("delete window.AppSrv")
			test_page.add_script_tag(content=compiled)
			if mode == "missing-appsrv":
				check(test_page.locator("#map-message").is_hidden(), "Map remains available without AppSrv")
				check("AppSrv не загружен" == test_page.locator("#live-status").inner_text(), "Missing AppSrv clearly reported")
				check(test_page.evaluate("window.routeFixture.requests.length") == 0, "No polling fallback")
			elif mode == "missing-openlayers":
				check("Не удалось загрузить OpenLayers" in test_page.locator("#map-message").inner_text(), "Unavailable map library reported")
			elif mode == "noncustomer":
				check(test_page.locator("#share-location").count() == 0, "m view hides location")
			else:
				check(test_page.locator("#map-message").is_hidden(), "Missing GPS/route does not crash")
				check(test_page.locator("#find-vehicle").is_disabled(), "No GPS disables find control")
			test_page.close()
		browser.close()
	print(f"Offline browser checks passed with map/socket/network doubles: {checks}")


if __name__ == "__main__":
	main()
