# Validation record

The implementation was built and checked in this workspace. The tests use synthetic shipment data. They do not connect to your production application.

## Executed successfully

```text
npm run build
    TypeScript 5.8.3 compilation and tab formatting: passed

PHP syntax checks
    All application, template, utility and fixture PHP files: passed

npm run test:frontend
    Movement checks passed: 67
    Frontend checks passed: 102

php tests/helpers.php
    PHP helper checks passed: 57

python3 tests/integration.py
    PHP HTTP integration checks passed: 70

npm run test:browser
    Offline browser checks passed with map/socket/network doubles: 63
```

Total: **359 assertions**. The commands were rerun after the final frontend rebuild.

## Coverage and boundaries

The movement tests use a deterministic injected frame clock. They verify intermediate coordinates, elapsed-time progress, retargeting from the displayed point, a single scheduled frame, stationary duplicates, exact completion, no extrapolation, duration limits, invalid coordinates, long receipt/GPS gaps, large ground-distance corrections, antimeridian handling, hidden/resumed pages, reduced-motion changes and disposal. Timestamp tests cover SQL/ISO formats, offsets, microseconds, invalid dates, equal-time corrections and independent zoned/unzoned clock ordering.

Additional AppSrv tests verify that a stale position packet cannot regress the marker, timestamp, distance or bundled route, or trigger an oversized-route fetch. Route-redraw handling, missing-period compatibility and equal-time corrections remain covered.


The frontend tests compile the actual data parser, event adapter, route-fetch queue and HTTP helper. They verify the original `construct → connect → subscribe` sequence and event names, zero distance, invalid/missing data, wrong-tracker filtering, on-demand oversized-route fetches, coalescing, stale-response protection, terminal-event/wakeup reload callbacks, cancellation, timeout handling and the absence of automatic retries or startup fetching.

The HTTP tests start the actual PHP entrypoints in a temporary application root and use a fixture `db_con()` and `SessManager`. They check all URL variants, input validation, script-safe bootstrap data, dependency paths/order, session-token reuse, read/write token separation, invalid/expired shipment handling, route lookup scoping, location requests, transaction/rollback calls, route invalidation and rebuild notifications. They do **not** execute SQL in PostgreSQL or validate your real framework/session implementation.

Offline DOM tests execute the rebuilt application in Chromium. Thirty additional browser assertions exercise the actual map adapter and UI with a deterministic frame clock: intermediate vehicle/camera positions, live retargeting, reuse of the Point geometry, immediate labels, stale packets, follow/find/fit controls, hidden tabs, simulated back/forward-cache lifecycle events, live reduced-motion preferences, cleanup and zero data requests from smoothing. The frame scheduler and page visibility are explicitly controlled in this scenario; it does not measure real-world frame rate.

The existing offline layout tests also execute the application in Chromium. OpenLayers, AppSrv, HTTP fetches and geolocation are explicitly replaced with test doubles. They check controls, displayed updates, geometry passed to the map adapter, no polling fallback, location workflow, empty GPS/route handling, and page widths of 1440, 390 and 320 pixels. Test screenshots are labeled with a mocked-map placeholder and are not examples of real OpenStreetMap rendering.

The smoothing update was tested offline in Chromium with the stated doubles. It does not assert that live browser navigation, real OpenLayers rendering, your WebSocket server or OSM tiles were tested successfully. A direct download attempt for the pinned OpenLayers distribution failed because the CDN hostname could not be resolved in this environment.

The existing package dependency and vendoring setup are unchanged; external distribution downloads were unavailable. The compiled application was produced with the installed TypeScript compiler. The archive does not contain a downloaded OpenLayers build or a generated npm lockfile. `npm install` / `npm run vendor` remain deployment preparation steps on a network-enabled development machine.

## Re-run locally

The non-browser tests require Node 18+, TypeScript, PHP CLI and Python 3:

```bash
npm install
npm run build
npm test
```

The optional offline browser test requires Python Playwright and Chromium. `CHROMIUM_PATH` can select an existing Chromium executable; otherwise the test uses an installed Chromium or Playwright's browser:

```bash
python3 -m venv .venv
.venv/bin/pip install playwright
.venv/bin/python -m playwright install chromium
.venv/bin/python tests/browser.py
```

The `tsc` executable must be on PATH for a direct Python invocation; `npm run test:browser` automatically adds local `node_modules/.bin` to PATH. A typical combined invocation is:

```bash
PATH="$PWD/node_modules/.bin:$PATH" .venv/bin/python tests/browser.py
```

## Production smoke check

Start with a known active shipment in the new directory while retaining the 2GIS page. Confirm the initial vehicle position and road route match, and check the browser Network/WebSocket panels for the same AppSrv subscription events. Idle route JSON requests should be absent; requests to OSM for map tiles are normal.

Exercise a position update and a route redraw, then confirm `long_route_rest: true` causes one event-triggered route request. A terminal event or AppSrv wakeup must reload the page. Check missing GPS and distance zero, follow/pan controls on a phone, and the customer location flow against a test shipment. Verify that route completion and expired links are rejected by PHP.

Test local `vendor/ol/` files and your HTTPS/WebSocket proxy configuration before replacing the old customer-facing directory.

## Smoothing smoke check on a real shipment

Observe two nearby position events less than 30 seconds apart. The mixer should glide for about 1.2 seconds and stop at the latest known point. During follow, the camera should move with it. Pan or choose the whole-route view mid-transition; the vehicle should keep moving while the camera stays under user control. Re-enable follow while movement is active.

With browser tools, test backgrounding/restoring the page and reduced-motion preference. No past movement should replay. Test a delayed packet with a reliably older GPS timestamp: neither the timestamp/distance label nor the marker should regress. Large corrections and the first position after a gap intentionally snap. Confirm there are no periodic application JSON requests; normal map-tile requests are unrelated to the animation controller.
