"""Exercise real PHP HTTP entrypoints against a fixture database/session adapter."""
import contextlib
import http.cookiejar
import json
import os
from pathlib import Path
import re
import shutil
import socket
import subprocess
import tempfile
import time
import urllib.error
import urllib.request

APP = Path(__file__).resolve().parents[1]


def sample_state():
	shipment = {
		"vehicle_id": 7, "tracker_id": "tracker-7", "vehicle_plate": "А123АА 96",
		"shipment_state": "busy", "client_route_done": "f", "destination_id": 22,
		"client_id": 33, "client_location_exists": "f", "user_id": 10,
		"map_def_lon": 60.6, "map_def_lat": 56.83,
		"pos_data": json.dumps({"lon": 60.58, "lat": 56.83, "period": "2026-09-21T09:21:00+05:00"}),
		"dest_zone": json.dumps({"type": "Polygon", "coordinates": [[[60.62, 56.835], [60.625, 56.835], [60.625, 56.84], [60.62, 56.84], [60.62, 56.835]]]}),
	}
	return {
		"shipments": {"101": shipment}, "logins": {}, "queries": [], "distance": 0,
		"initial_route": "60.58 56.83,60.59 56.832,60.60 56.832,60.62 56.837", "route_rest": "60.60 56.832,60.62 56.837",
	}


@contextlib.contextmanager
def fixture_server():
	with tempfile.TemporaryDirectory(prefix="route-osm-") as directory:
		root = Path(directory)
		shutil.copytree(APP / "tests" / "fixtures", root, dirs_exist_ok=True)
		shutil.copytree(APP, root / "route-osm", ignore=shutil.ignore_patterns("tests", "node_modules", ".test-build", ".git"))
		state_file = root / "state.json"
		state_file.write_text(json.dumps(sample_state()), encoding="utf-8")
		(root / "sessions").mkdir()
		with socket.socket() as listener:
			listener.bind(("127.0.0.1", 0))
			port = listener.getsockname()[1]
		environment = dict(os.environ, ROUTE_FIXTURE_STATE=str(state_file), ROUTE_FIXTURE_SESSIONS=str(root / "sessions"))
		with (root / "server.log").open("w+") as log:
			server = subprocess.Popen(["php", "-d", "display_errors=0", "-S", f"127.0.0.1:{port}", "-t", str(root)], env=environment, stdout=log, stderr=log)
			try:
				for _ in range(100):
					try:
						with socket.create_connection(("127.0.0.1", port), timeout=0.1):
							break
					except OSError:
						time.sleep(0.03)
				else:
					raise RuntimeError("PHP fixture server did not start")
				yield root, f"http://127.0.0.1:{port}", state_file
			finally:
				server.terminate()
				server.wait(timeout=5)


def parse_boot(html):
	match = re.search(r'<script id="route-config" type="application/json">(.*?)</script>', html, re.S)
	assert match, "Missing bootstrap JSON"
	return json.loads(match.group(1))


def main():
	checks = 0
	def check(condition, label):
		nonlocal checks
		checks += 1
		if not condition:
			raise AssertionError(label)

	with fixture_server() as (root, base, state_file):
		opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(http.cookiejar.CookieJar()))
		def request(path, method="GET", body=None, token=None, headers=None):
			request_headers = dict(headers or {})
			if token:
				request_headers["X-Route-Token"] = token
			if isinstance(body, dict):
				request_headers["Content-Type"] = "application/json"
				body = json.dumps(body).encode()
			req = urllib.request.Request(base + "/route-osm/" + path, data=body, method=method, headers=request_headers)
			try:
				response = opener.open(req, timeout=10)
			except urllib.error.HTTPError as error:
				response = error
			with response:
				return response.status, response.read().decode(), response.headers
		def state():
			return json.loads(state_file.read_text())
		def save(data):
			state_file.write_text(json.dumps(data), encoding="utf-8")

		status, html, headers = request("?101")
		check(status == 200, "valid legacy URL")
		boot = parse_boot(html)
		check(boot["id"] == 101, "shipment bootstrap")
		check(boot["trackerId"] == "tracker-7", "tracker from database")
		check(boot["distance"] == 0, "zero distance bootstrap")
		check(boot["movement"] == {"durationMs": 1200, "maxGapMs": 30000, "maxDistanceM": 1000}, "animation settings in PHP bootstrap")
		check(boot["position"]["lon"] == 60.58, "initial GPS from database")
		check(boot["destinationZone"]["type"] == "Polygon", "zone GeoJSON")
		check(len(boot["readToken"]) == 64, "random read token")
		check(len(boot["locationToken"]) == 64 and boot["locationToken"] != boot["readToken"], "separate write token")
		check(boot["appSrv"]["port"] == 8080, "insecure port selected for HTTP")
		check("no-store" in headers["Cache-Control"], "private page no-store")
		check(headers["Referrer-Policy"] == "origin", "tile requests may send origin without shipment ID")
		paths = ["../js20/core/extend.js", "../js20/core/CommonHelper.js", "../js20/core/EventHelper.js", "../js20/core/AppSrv.js", "../js20/custom_controls/TrackConstants.js"]
		indices = [html.index(path) for path in paths]
		check(indices == sorted(indices), "exact dependency order from supplied template")
		check(all(f'src="{path}?v=fixture-1"' in html for path in paths), "versioned dependency paths")
		check("maps.api.2gis" not in html, "no 2GIS loader")
		check('type="application/json"' in html and "window.onload" not in html, "safe JSON boot, no interpolated executable template")
		check(len(state()["logins"]) == 1, "login registered")
		for url in ["index.php?101", "?id=101", "index.php?id=101"]:
			code, page, _ = request(url)
			check(code == 200 and parse_boot(page)["readToken"] == boot["readToken"], "URL variant reuses session")
		for url in ["?m101", "index.php?id=m101"]:
			code, page, _ = request(url)
			mode = parse_boot(page)
			check(code == 200 and not mode["locationEnabled"] and mode["locationToken"] is None, "m view is read-only UI")
			check('id="share-location"' not in page, "no location control in m view")
		for path in ["", "?0", "?101oops", "?id[]=101", "?id=2147483648", "?id=101&other=1"]:
			code, _, _ = request(path)
			check(code == 400, f"invalid URL: {path}")
		check(request("?999")[0] == 404, "nonexistent shipment")
		check(request("?101", method="POST")[0] == 405, "page GET only")
		check(request("long_route_rest.php?id=101")[0] == 403, "read endpoint needs token")
		check(request("long_route_rest.php?id=101", token="a" * 64)[0] == 403, "bad token denied")
		check(request("long_route_rest.php?tracker-7", token=boot["readToken"])[0] == 400, "unscoped old tracker endpoint not exposed")
		code, text, response_headers = request("long_route_rest.php?id=101", token=boot["readToken"])
		check(code == 200 and json.loads(text)["route"] == state()["route_rest"], "long route returned")
		check("application/json" in response_headers["Content-Type"], "JSON response")
		request("long_route_rest.php?id=101&tracker_id=other", token=boot["readToken"])
		check("tracker_id = 'tracker-7'" in state()["queries"][-1], "caller cannot choose another tracker")
		data = state()
		data["route_rest"] = None
		save(data)
		check(request("long_route_rest.php?id=101", token=boot["readToken"])[0] == 409, "pending cache not mistaken for ended route")
		data["route_rest"] = ""
		save(data)
		code, text, _ = request("long_route_rest.php?id=101", token=boot["readToken"])
		check(code == 200 and json.loads(text)["route"] == "", "empty route explicitly returned")

		check(request("location.php?id=101")[0] == 405, "location rejects GET")
		check(request("location.php?id=101", "POST", b"{}", boot["locationToken"])[0] == 415, "requires JSON content type")
		check(request("location.php?id=101", "POST", {"lon": 60, "lat": 56}, boot["readToken"])[0] == 403, "read token cannot write")
		for point in [{}, {"lon": 60, "lat": ""}, {"lon": 181, "lat": 56}, {"lon": True, "lat": 56}, {"lon": "60;DROP TABLE orders", "lat": 56}]:
			check(request("location.php?id=101", "POST", point, boot["locationToken"])[0] == 400, "bad coordinates rejected")
		code, text, _ = request("location.php?id=101", "POST", {"lon": 60.62, "lat": 56.837}, boot["locationToken"])
		check(code == 200 and json.loads(text)["ok"], "location accepted")
		queries = state()["queries"]
		check(queries[-5] == "BEGIN" and queries[-1] == "COMMIT", "location transaction")
		check("INSERT INTO client_destinations" in queries[-4], "location upsert")
		check("UPDATE vehicle_route_cashe" in queries[-3] and "shipment_id = 101" in queries[-3], "invalidate current shipment cache")
		check("pg_notify('Vehicle.rebuild_route'" in queries[-2] and '"tracker_id":"tracker-7"' in queries[-2], "original rebuild notification")
		data = state()
		data["zone_required"] = True
		save(data)
		check(request("location.php?id=101", "POST", {"lon": 60, "lat": 56}, boot["locationToken"])[0] == 422, "optional zone enforcement")
		data = state()
		data["inside_zone"] = True
		save(data)
		check(request("location.php?id=101", "POST", {"lon": 60, "lat": 56}, boot["locationToken"])[0] == 200, "point inside zone accepted")
		data = state()
		data["zone_required"] = False
		data["fail_sql"] = "UPDATE vehicle_route_cashe"
		save(data)
		code, text, _ = request("location.php?id=101", "POST", {"lon": 60, "lat": 56}, boot["locationToken"])
		check(code == 500 and "database" not in text, "database failure does not leak detail")
		check(state()["queries"][-1] == "ROLLBACK", "failed write rolled back")
		data = state()
		data.pop("fail_sql")
		data["location_enabled"] = False
		save(data)
		check(request("location.php?id=101", "POST", {"lon": 60, "lat": 56}, boot["locationToken"])[0] == 403, "location feature disabled server-side")

		data = state()
		data["https"] = True
		data["shipments"]["101"]["vehicle_plate"] = '</script><script>alert("x")</script>'
		data["shipments"]["101"]["pos_data"] = None
		data["initial_route"] = ""
		save(data)
		code, page, _ = request("?101")
		check(code == 200 and parse_boot(page)["position"] is None, "missing GPS does not break page")
		check(parse_boot(page)["appSrv"]["port"] == 8443, "HTTPS secured port")
		check('</script><script>alert("x")</script>' not in page, "plate cannot inject script")
		check(parse_boot(page)["vehiclePlate"] == data["shipments"]["101"]["vehicle_plate"], "escaped plate roundtrip")
		data["route_error"] = True
		save(data)
		code, page, _ = request("?101")
		check(code == 200 and "Линия маршрута пока недоступна" in page and "Private route service failure" not in page, "route service failure degrades to map with message")
		data["shipments"]["101"]["client_route_done"] = "t"
		save(data)
		check(request("?101")[0] == 404, "finished shipment page")
		check(request("long_route_rest.php?id=101", token=boot["readToken"])[0] == 404, "API revalidates completion")
		data["shipments"]["101"]["client_route_done"] = "f"
		data["shipments"]["101"]["shipment_state"] = "free"
		save(data)
		check(request("?101")[0] == 404, "inactive schedule rejected")
		data["shipments"]["101"]["shipment_state"] = "busy"
		data["logins"]["101"]["active"] = "f"
		save(data)
		code, page, _ = request("?101")
		check(code == 404 and "Маршрут завершён" in page, "recent logout message")
		data["logins"]["101"]["expired"] = "t"
		save(data)
		code, page, _ = request("?101")
		check(code == 404 and "Неверная ссылка" in page, "expired logout message")
		compiled = (APP / "assets" / "route.js").read_text()
		check("setInterval(" not in compiled, "no frontend polling interval")
		check(not (APP / "state.php").exists(), "no polling endpoint")
		print(f"PHP HTTP integration checks passed: {checks}")


if __name__ == "__main__":
	main()
