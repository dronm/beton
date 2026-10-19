# Yandex shipment route

Standalone PHP + TypeScript customer map using **Yandex Maps JavaScript API v3**. Based on the working OSM smooth-route application in this conversation, with a native Yandex renderer instead of OpenLayers. It is a separate application: the existing `route/` and `osm-route/` directories do not need to change.

## Important: license and API key

Yandex's published free-use conditions explicitly prohibit using its API to track vehicles or mobile employees in real time. This page does exactly that. **Arrange a Yandex license that permits your vehicle-tracking use case before production use.** A public customer URL does not remove that restriction. Check the conditions of any trial separately with Yandex.

Official conditions: https://yandex.ru/dev/commercial/doc/ru/?from=mapsapi

Obtain a key for the **JavaScript API**, not only a geocoding or routing service. API v3 requires a configured HTTP Referer restriction. Add the domain `eurobeton.katren.org` in the developer account's allowed domains; add each other legitimate deployment domain separately. The browser, not your PHP server, loads the SDK, so restricting it to a backend server's IP is not the appropriate browser-key configuration. Key/restriction changes can take time to propagate; Yandex documents activation within 15 minutes.

The JavaScript API key is necessarily visible in page data/network requests. Keep it out of public source repositories and restrict its permitted domains; it is not a server-side secret. No real key is included in this archive.

Official setup:
- https://yandex.com/maps-api/docs/js-api/common/quickstart.html
- https://yandex.ru/maps-api/docs/js-api/limit.html

## Install

Place `yandex-route/` next to the existing route directories:

```text
application/
	Config.php
	version.php
	functions/
	js20/
	route/
	osm-route/
	yandex-route/
```

Add this to the **existing** `application/Config.php`; do not replace that common file:

```php
define('ROUTE_YANDEX_API_KEY', 'YOUR_YANDEX_JAVASCRIPT_API_KEY');
```

Use an active shipment ID, for example:

```text
/yandex-route/?265668
/yandex-route/index.php?265668
/yandex-route/?id=265668
/yandex-route/?m265668
/yandex-route/?id=m265668
```

The example ID is not guaranteed still to be active. A completed/invalid route produces the standalone styled error page, not the main application's login form. Do not add additional query parameters to these page URLs: the legacy shipment parser deliberately accepts exactly one parameter. `m` retains the original non-customer display mode and hides the location-sharing control.

**Deploy to every serving application instance.** Verify the directory, compiled assets, required shared scripts and common configuration on each instance, not just one successful request through the public address. Preserve your existing shared session and database arrangements. Your prior missing-directory problem was caused by inconsistent deployment across servers.

Runtime files are `index.php`, `location.php`, `long_route_rest.php`, `lib/`, `templates/`, `assets/`, `img/`, and `favicon.ico`. Source, tests, examples and documentation are useful on the development machine but do not need to be publicly served. No migration, Node server, background worker, Composer install or shared template-cache clearing is needed.

## Runtime dependencies

Exactly these five scripts are loaded from the existing client library, in this order:

```text
../js20/core/extend.js
../js20/core/CommonHelper.js
../js20/core/EventHelper.js
../js20/core/AppSrv.js
../js20/custom_controls/TrackConstants.js
```

They receive the common version suffix and `defer`. The page then loads its compiled `assets/route.js`. The application loads Yandex's official SDK once, using:

```text
https://api-maps.yandex.ru/v3/?apikey=YOUR_KEY&lang=ru_RU
```

It waits for `ymaps3.ready` before creating the map. Events received during this wait are retained as the latest position/route, not replayed as a backlog. The SDK and its own modules/assets are hosted by Yandex; **they are not included or self-hosted in this ZIP**. No OpenLayers, Leaflet, React, Vue, jQuery, Bootstrap, `AppBeton`, main `js20/lib.js`, or main-application service-worker registration is added.

The native Yandex logo, copyright information and “Open in Maps” controls remain enabled. Do not hide or cover them when customizing the page. The page sends only its origin as the Referer, retaining domain-key verification without exposing the shipment ID in that header.

PHP integration uses the same `SessManager`, `db_con()`, `VehicleRoute::getRoute()`, tables and shipment eligibility logic as the OSM application. The common configuration must define `FRAME_WORK_PATH`, `APP_NAME` and the existing database/AppSrv constants. PHP 7.4+ syntax is used; tests in this environment ran on PHP 8.4.23. Session autostart must not run before this page starts its shipment session.

## AppSrv, not polling

The original `new AppSrv(options)`, `connect()`, `subscribe({events, onEvent, onWakeup})` sequence and original shipment token format are preserved.

| AppSrv event/callback | Action |
| --- | --- |
| `Vehicle.position.<tracker_id>` | Update vehicle fix/time, distance and any supplied remaining route. |
| `Vehicle.route_redraw.<tracker_id>` | Replace remaining route from the supplied payload. |
| `long_route_rest: true` on either data event | Fetch `long_route_rest.php?id=...` with a scoped token. |
| `Vehicle.route_end.<tracker_id>` | Reload; PHP rechecks shipment eligibility. |
| `User.logout` | Reload. |
| `onWakeup` | Reload to obtain fresh initial data, matching the original implementation. |

**There is no periodic HTTP request, startup data fetch or polling fallback.** `long_route_rest.php` exists only for event-triggered oversized geometry retrieval. Concurrent notifications are coalesced; a slow HTTP response cannot overwrite newer inline geometry. Reconnection/heartbeat logic belongs to the existing AppSrv client.

The initial page already contains the current fix and route. Road-route calculation is unchanged: this app displays the geometry from `VehicleRoute::getRoute()` and AppSrv; it does not call the Yandex routing/geocoding services. Any routing provider used by that PHP helper remains in use, subject to that provider's own terms.

## Smooth movement and controls

A native `YMapMarker` is reused and updated on browser animation frames with subpixel positioning enabled. The first fix is immediate. Subsequent fixes move from the **currently displayed** position to the latest known position over 1.2 seconds by default. A new packet retargets an unfinished movement without a jump back or a queue of obsolete moves. The camera follows the same interpolated location when following is enabled.

Movement stops at the received fix. It is **not prediction, delayed continuous playback or road snapping**. Sparse updates still leave pauses between transitions, and a straight transition may cut across a road corner. Timestamps and distances always reflect received data rather than invented intermediate telemetry.

Older fixes are ignored when their timestamps can be reliably compared. A gap over 30 seconds or a change over 1,000 metres snaps to the new fix. Hidden/bfcache pages suspend animation; restoration does not replay old movement. The browser reduced-motion setting is respected. All renderer input uses longitude, latitude order.

“Найти машину” re-enables following and centers the mixer. “Весь маршрут”, dragging, pinch/wheel/double-click zoom and keyboard navigation stop following. Zoom buttons and the arrow keys operate the map without adding another UI package. The default renderer mode is `auto`; `raster` and `vector` can be configured.

Empty, single-point and malformed lines, missing GPS, and malformed destination polygons are handled without deliberately constructing invalid Yandex geometry. Destination polygons support holes and multiple polygons. This delivery-tracking UI and its local Mercator fit/interpolation are intended for regional routes, not polar/global routes crossing the antimeridian.

## Customer location and access

“Я на объекте” appears only in customer mode when location sharing is enabled and no client location is recorded. It requires an explicit click, confirmation and browser geolocation permission. The POST uses the existing transaction to update `client_destinations`, invalidate `vehicle_route_cashe`, and notify `Vehicle.rebuild_route`. The page waits for AppSrv afterward; no extra refresh is requested.

`ROUTE_YANDEX_REQUIRE_LOCATION_IN_ZONE` defaults to false, preserving the supplied 2GIS behavior. Set it to true to enforce the database destination polygon server-side.

The existing shipment session naming and predictable legacy AppSrv token format are retained for compatibility. This is **not a redesign of shipment-link authorization**. Shipment IDs and the `m` prefix are not secret credentials; `m` is a UI mode, not an access-control boundary. Endpoints additionally validate active shipment state and separate random per-session read/write tokens. Yandex token keys have their own session namespace, so they do not overwrite the OSM page's tokens. No caller-supplied tracker/client/destination ID is trusted by the endpoints.

## Optional settings

All new options use `ROUTE_YANDEX_*`; older `ROUTE_OSM_*` and `ROUTE_OL_*` settings do not affect this application.

```php
define('ROUTE_YANDEX_INITIAL_ZOOM', 14);
define('ROUTE_YANDEX_FIT_MAX_ZOOM', 16);
define('ROUTE_YANDEX_MAX_ZOOM', 19);
define('ROUTE_YANDEX_MAP_MODE', 'auto');

define('ROUTE_YANDEX_FOLLOW_VEHICLE', true);
define('ROUTE_YANDEX_SHOW_ZONE', true);
define('ROUTE_YANDEX_ANIMATION_DURATION_MS', 1200);
define('ROUTE_YANDEX_ANIMATION_MAX_GAP_MS', 30000);
define('ROUTE_YANDEX_ANIMATION_MAX_DISTANCE_M', 1000);

define('ROUTE_YANDEX_ENABLE_LOCATION', true);
define('ROUTE_YANDEX_REQUIRE_LOCATION_IN_ZONE', false);
define('ROUTE_YANDEX_REQUEST_TIMEOUT_MS', 15000);
define('ROUTE_YANDEX_LOAD_TIMEOUT_MS', 20000);
```

Set animation duration to `0` to disable interpolation. With no explicit initial zoom, `TRACK_CONSTANTS.INI_ZOOM` is used when numeric, otherwise 14. The full configuration example also includes optional AppSrv host/port/script overrides. With the default five dependency paths, those overrides are unnecessary.

HTTPS pages use `APP_SERVER_PORT_SECURED`; HTTP pages use `APP_SERVER_PORT`. Behind TLS termination, preserve the existing correct PHP HTTPS indicators or explicitly set `ROUTE_YANDEX_APPSRV_PORT` to the secure WebSocket port. Host/port/path semantics remain those of your original AppSrv client.

A missing API key, blocked script, rejected `ymaps3.ready` or SDK timeout produces a visible Russian error, not a fallback to OSM or periodic retries. The configured SDK timeout is a one-shot deadline, not polling.

## Development

The compiled `assets/route.js` is included. For ordinary deployment **do not run npm**. To edit/rebuild on a development machine:

```bash
cd yandex-route
npm install
npm run typecheck
npm run build
npm test
```

Node is development tooling only. TypeScript 5.8.3 is the only npm development dependency. PHP is used by the build's indentation formatter; PHP and Python 3 are needed by the test suite.

The narrow local `src/yandex-global.d.ts` declaration models only the documented v3 members used here. It does not implement/mock Yandex at runtime and is not the complete official `@yandex/ymaps3-types` package. The actual SDK is always loaded from Yandex. See `TESTING.md` for what was validated and what remains to be tested with a real key.

For optional offline browser tests, install Python Playwright and Chromium, then run:

```bash
npm run build
npm run test:browser
```

`tests/browser.py` uses an installed `chromium` executable, or `CHROMIUM_PATH`. Its map/socket doubles are **test fixtures only** and are never loaded by the production page.

## Source layout

```text
index.php                   Initial data, session and standalone page
long_route_rest.php         Event-triggered oversized route endpoint
location.php                Confirmed customer location POST
lib/backend.php             Existing database/session integration + settings
lib/common.php              Validation, escaping and response helpers
templates/                  Standalone normal/error HTML
src/loader.ts               Official Yandex SDK loading/readiness
src/map.ts                  Native Yandex renderer and following
src/geo.ts                  Projection, viewport fit and polygon helpers
src/movement.ts             Finite, retargetable smooth-motion controller
src/live.ts                 Existing AppSrv event adapter and route queue
src/data.ts, src/api.ts      Parsing and scoped HTTP requests
assets/route.js              Compiled application (included)
assets/route.css             Responsive page/marker presentation
```

Additional primary references used during implementation:
- https://yandex.com/maps-api/docs/js-api/map/YMap.html
- https://yandex.com/maps-api/docs/js-api/object/markers/YMapMarker.html
- https://yandex.com/maps-api/docs/js-api/object/geo-objects/YMapFeature.html
- https://yandex.com/maps-api/docs/js-api/object/events/YMapListener.html
- https://yandex.com/maps-api/docs/js-api/ref/index.html

Documentation and implementation prepared 2026-09-22. Recheck provider terms and keys before production deployment.
