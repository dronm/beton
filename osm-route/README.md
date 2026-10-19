# Shipment route: PHP + OpenLayers + AppSrv

A new standalone customer page based on the supplied **`route_app.zip`**. It displays an existing shipment route over OpenStreetMap tiles using **OpenLayers 10.10.0**, and receives changes through the existing **AppSrv WebSocket client**.

There is **no HTTP polling, no long polling, no polling fallback, and no new WebSocket server**. PHP supplies initial data. AppSrv supplies subsequent events. A normal HTTP request retrieves an oversized route only when the server explicitly sends `long_route_rest: true`, as in the original 2GIS implementation.

**Smooth vehicle movement is enabled by default.** Accepted GPS updates animate for 1.2 seconds, with the following camera driven by the same local frame loop. This adds no polling, data-refresh requests, or prediction.

The PHP page, endpoints, templates, TypeScript source, compiled application JavaScript, styles and tests are included. **OpenLayers itself and your existing AppSrv files are not included.** OpenLayers defaults to the pinned CDN build; local hosting is supported below. AppSrv loads from the existing application paths without manual configuration.

## Install alongside the old page

Place `route-osm/` beside `route/`, keeping both at the same directory depth:

```text
application/
	Config.php
	version.php
	functions/
		VehicleRoute.php
		db_con_f.php
	js20/
		core/
			extend.js
			CommonHelper.js
			EventHelper.js
			AppSrv.js
		custom_controls/
			TrackConstants.js
	route/                  Existing 2GIS implementation, unchanged
	route-osm/              This application
```

Open a valid, active shipment:

```text
/route-osm/?219684
/route-osm/index.php?219684
/route-osm/?id=219684
/route-osm/?m219684
/route-osm/?id=m219684
```

The `m` prefix retains the non-customer display mode: the location-sharing button and its write token are omitted. It is not a distinct authenticated role.

The existing `SessManager`, database connection and shipment eligibility rules are reused. No migration or new database connection configuration is required. The page expects the same `Маршруты` application user that the old page uses when it creates a shipment login. It retains the original active schedule states (`busy` or `at_dest`), the destination-zone requirement, and the `client_route_done` check.

This is standalone **within the PHP application**, not independent of its database/framework. `FRAME_WORK_PATH`, `SessManager`, the two existing field classes and `VehicleRoute::getRoute()` remain dependencies. The old shared HTML views, template cache, 2GIS loader, old renderer, and device-detector library are not used.

After testing, the directory can replace the old `route/` directory. Its internal links do not depend on the name `route-osm`. Back up the old directory first, and replace rather than merge its contents so that unused old endpoints are not left deployed.

## OpenLayers deployment and optional Node tooling

The compiled `assets/route.js` is included. Opening the page does not require a Node service or a frontend build. With no local vendor files present, PHP loads these pinned files:

```text
https://cdn.jsdelivr.net/npm/ol@10.10.0/dist/ol.js
https://cdn.jsdelivr.net/npm/ol@10.10.0/ol.css
```

For production, prepare local library files on a development machine with npm/network access:

```bash
cd route-osm
npm install
npm run vendor
```

Deploy the generated `vendor/ol/` directory together with the PHP page. PHP automatically prefers it when both `ol.js` and `ol.css` exist. The vendor tool also copies the OpenLayers license. No CDN is then needed for the library; map tiles still come from the configured tile provider.

The application is authored in TypeScript and compiled to a single classic script, so the old global AppSrv client and its dependencies can load in their original order. Node/npm are only development tools. After editing `src/*.ts`:

```bash
npm run build
```

Publish the updated `assets/route.js`. Styles are edited directly in `assets/route.css`. Node 18+ is needed for the frontend tests; the checked build used Node 22 and TypeScript 5.8.3. The PHP code targets PHP 7.4+ and was checked on PHP 8.4.

The archive does not contain an npm lockfile: package downloads were unavailable in the implementation environment. Direct package versions are pinned in `package.json`; `npm install` generates a lockfile, which should be committed in your repository. The local-vendoring command has not been exercised against a downloaded npm package here.

For a minimal production deployment, copy `index.php`, `location.php`, `long_route_rest.php`, `favicon.ico`, `lib/`, `templates/`, `assets/`, `img/`, and the optional `vendor/` directory. Development files, tests and `node_modules/` are not needed on the web server.

## AppSrv: the original contract

Dependency URLs are already set to the paths from the supplied template, in this order:

```text
../js20/core/extend.js
../js20/core/CommonHelper.js
../js20/core/EventHelper.js
../js20/core/AppSrv.js
../js20/custom_controls/TrackConstants.js
```

They load as ordered deferred scripts, followed by the compiled application. All receive the existing `VERSION` for cache busting. The main application's old `route.js` must not also be loaded.

`src/live.ts` constructs AppSrv with `host`, `port`, `appId`, `token`, and `tokenExpires: null`; it calls **`connect()` followed by `subscribe()`**, matching the old page. The token remains:

```php
$shipment_id.':'.md5('route_'.$shipment_id)
```

| Event / callback | Action |
| --- | --- |
| `Vehicle.position.<tracker_id>` | Update `params.lon`, `params.lat`, `params.period`; apply any remaining distance and route. |
| `Vehicle.route_redraw.<tracker_id>` | Replace the route from `params.route_rest`, or fetch it when `params.long_route_rest === true`. |
| `Vehicle.route_end.<tracker_id>` | Reload the page so PHP checks shipment/session state. |
| `User.logout` | Reload the page. |
| `onWakeup` | Reload the page, as in the original implementation. |

Both position and redraw events can carry `route_rest_len`, including **zero**. Missing fields leave the existing value unchanged. Explicit empty/null inline routes clear the line. Invalid geometry is rejected without removing the last valid route. Events for unrelated trackers are ignored.

The route coordinate format remains `lon lat,lon lat,...`. OpenLayers receives longitude/latitude coordinates and projects them for display; the old 2GIS latitude/longitude swapping is not reused. Destination zones are read as GeoJSON. Existing SRID-0 zones are assumed to contain longitude/latitude degrees, consistent with the original page; other SRIDs are transformed to WGS84.

AppSrv owns its WebSocket transport, heartbeat and reconnection behavior. This application does not invent additional AppSrv callbacks or implement another reconnection loop. The status label reports **waiting for events** or the **last event receipt time**; it does not claim that `connect()` synchronously confirmed a live socket. When the browser reports it is offline, that is shown separately.

A failed/missing AppSrv dependency leaves the initial map visible with an error. It never activates polling.

## Backend endpoints

`index.php` validates the shipment, resumes or creates its existing shipment session, retrieves the initial position and calls `VehicleRoute::getRoute()`. It embeds data as script-safe JSON in its own local template.

`long_route_rest.php?id=<shipment_id>` requires the page's read token in `X-Route-Token`. It revalidates shipment/session state and resolves the tracker from the shipment—not from a caller-supplied tracker ID—before reading `route_rests.route_rest`. It returns a small JSON response containing `route`. A route not yet available in the cache returns 409; an explicitly empty string is returned as an empty route. There is no automatic retry: another AppSrv notification or a manual page refresh is needed.

Only one route fetch is in flight. A burst of oversized-route notifications is coalesced into at most one pending follow-up. Inline WebSocket routes invalidate/abort obsolete HTTP requests, so delayed responses cannot overwrite newer geometry.

`location.php?id=<shipment_id>` accepts **POST JSON** containing `lon` and `lat`, with a separate location token in `X-Route-Token`. The customer must click **“Я на объекте”**, confirm they are at the unloading point, and permit geolocation. It is not requested automatically on mobile devices. When coordinates already exist, the control is omitted, matching the old page's condition for requesting location.

The endpoint resolves customer, destination and tracker from the shipment. It performs the original location upsert, `vehicle_route_cashe` invalidation and `Vehicle.rebuild_route` notification in one transaction. After success, the browser waits for AppSrv; it does not fetch refreshed state.

This changes the new page's endpoint protocol: old GET location requests and unauthenticated tracker-only long-route requests are deliberately not supported by these new endpoints. Keep each renderer with its matching endpoints during parallel testing.

**Routing is not replaced.** OpenStreetMap supplies the basemap, OpenLayers renders the map, and `VehicleRoute::getRoute()` still provides the road route. That helper's source was not supplied; any routing service it uses internally is unchanged.

## Optional configuration in `../Config.php`

No new constant is required for the default paths. `Config.example.php` documents all optional settings and is not included automatically. The most useful settings are:

```php
define('ROUTE_OSM_FOLLOW_VEHICLE', true);
define('ROUTE_OSM_ANIMATION_DURATION_MS', 1200);
define('ROUTE_OSM_ANIMATION_MAX_GAP_MS', 30000);
define('ROUTE_OSM_ANIMATION_MAX_DISTANCE_M', 1000);
define('ROUTE_OSM_SHOW_ZONE', true);
define('ROUTE_OSM_ENABLE_LOCATION', true);
define('ROUTE_OSM_REQUIRE_LOCATION_IN_ZONE', false);
define('ROUTE_OSM_REQUEST_TIMEOUT_MS', 15000);
```

`ROUTE_OSM_REQUIRE_LOCATION_IN_ZONE` defaults to **false**, preserving the supplied `location.php` behavior: its zone-enforcement condition was commented out. Set it to true to check the point against the destination zone, including the boundary. This is a business rule, not a GPS accuracy guarantee.

Without `ROUTE_OSM_INITIAL_ZOOM`, the frontend uses `TRACK_CONSTANTS.INI_ZOOM`, then 14 as a fallback. Center coordinates still come from `const_map_default_lon_val()` / `const_map_default_lat_val()`.

`APP_NAME`, `APP_SERVER_HOST`, `APP_SERVER_PORT`, and `APP_SERVER_PORT_SECURED` are reused. HTTPS detection treats `HTTPS=off` as false. When TLS terminates at a reverse proxy and PHP cannot detect it, configure the proxy correctly or explicitly override the existing secured port:

```php
define('ROUTE_OSM_APPSRV_PORT', APP_SERVER_PORT_SECURED);
```

Do not create duplicate definitions for constants already present in `Config.php`. The old `ROUTE_OL_*` constants from earlier experimental implementations are not used here; this fresh application uses `ROUTE_OSM_*`.

## Smooth vehicle movement

`src/movement.ts` contains the finite animation controller and timestamp-ordering helper. `src/map.ts` integrates it with the existing OpenLayers vehicle feature. Each accepted AppSrv fix supplies a target; `requestAnimationFrame()` interpolates the existing Point's projected coordinates toward it. The vehicle geometry and styles are not recreated per update.

The default transition lasts **1200 ms**. A fix received before it finishes replaces the target and starts from the **currently displayed position**, not the previous GPS fix. At most one animation frame is pending. Repeated fixes at the same target do not restart the transition. The frame loop stops at the latest received coordinate; it does not continue moving an unobserved vehicle.

The following camera uses the same rendered coordinates. Enabling follow while the vehicle is moving also removes any camera offset gradually. Turning follow off, dragging, scrolling, pressing an arrow key, or selecting **“Весь маршрут”** leaves vehicle animation running but stops automatic camera movement. **“Найти машину”** enables following again.

Optional settings in `../Config.php`:

| Constant | Default | Meaning |
| --- | --- | --- |
| `ROUTE_OSM_ANIMATION_DURATION_MS` | `1200` | Transition duration, bounded to 0–5000 ms. **0 disables marker animation.** |
| `ROUTE_OSM_ANIMATION_MAX_GAP_MS` | `30000` | Snap instead of animating after a gap longer than this in receipt time or comparable GPS timestamps. Bounded to 1000–300000 ms. |
| `ROUTE_OSM_ANIMATION_MAX_DISTANCE_M` | `1000` | Snap instead of animating a correction larger than this between consecutive received fixes, measured in ground metres. Bounded to 1–10000 m. |

Invalid/non-numeric values use the defaults. The new `movement` bootstrap settings are optional in the frontend, so an older PHP bootstrap still gets the default behavior. The PHP business operations, shipment access rules, route resolver and AppSrv protocol are unchanged.

The first position is always shown immediately. A large position correction, long update gap or world-boundary crossing is also shown immediately rather than animating a misleading journey. Hidden tabs have no movement frame loop: incoming fixes are retained without animation. Restoring a hidden/back-forward-cached page does not replay old fixes; the first subsequent fix snaps, then normal animation resumes. Permanently leaving the page cancels movement and removes its listeners. The browser's reduced-motion preference disables interpolation and is respected if changed while the page is open.

`src/live.ts` rejects demonstrably older position packets **before** their position, timestamp, distance or bundled route is applied. Ordering is seeded with the initial PHP position. SQL/ISO timestamps with UTC offsets are compared as instants; unzoned timestamps are compared only to other unzoned timestamps, without assigning the customer's timezone. Missing/unrecognized timestamps remain accepted in arrival order, and equal timestamps remain accepted for corrections. Independent route-redraw events retain their original behavior.

The position timestamp and distance labels reflect received server values immediately; intermediate values are not invented. **Interpolation is a straight segment between GPS fixes, not road matching.** It can visually cut a corner between sparse fixes. The remaining-route geometry is unchanged and is not used to force the vehicle onto a planned road. For example, fixes arriving ten seconds apart produce a 1.2-second transition followed by a stop, not ten seconds of predicted movement.

### Updating an existing `route-osm/` deployment

Copy the updated files over your existing directory, retaining any local `vendor/ol/` files and your common `../Config.php`. The rebuilt **`assets/route.js` is included**, so deployment does not require Node or a frontend build. `lib/backend.php` exposes the optional animation constants. No database migration or AppSrv dependency-path change is needed.

For a source checkout, keep the new `src/movement.ts`, updated source/declarations and `tsconfig.json` together. Run `npm run build` after future TypeScript edits. The page already versions its compiled script using its file modification time; reload the page after deploying.

## Map behavior and operating notes

The responsive Russian-language page contains the vehicle plate, remaining distance, position timestamp, route, mixer marker, destination marker and optional zone. **“Найти машину”** centers on the mixer and enables following; **“Весь маршрут”** fits the route and disables following. Dragging, wheel interaction or arrow-key panning disables following. The follow control can re-enable it. Missing GPS, a one-point route, and an empty route do not prevent initialization.

GPS timestamps are displayed in the time supplied by the tracking system, not silently converted using the customer's timezone. The complete raw timestamp is available in the timestamp element's title. The latest AppSrv event receipt time uses the browser's local time.

Default tiles are requested over HTTPS with visible attribution, ordinary browser caching, no bulk download feature, and no tile preloading. The PHP page's `no-store` policy applies to shipment HTML/JSON, not to tile requests. `Referrer-Policy: origin` lets tile requests include the site origin without exposing the shipment query string.

Public OSM tile infrastructure has limited capacity and no SLA. For a high-traffic/customer-critical deployment, use a suitable tile provider or your own tiles; change `ROUTE_OSM_TILE_URL` and `ROUTE_OSM_TILE_ATTRIBUTION` together. Existing CSP rules must allow the selected tile source, AppSrv WebSocket endpoint, and—only while using CDN mode—the CDN script/stylesheet.

## Access model

The legacy numeric shipment links and deterministic AppSrv token are retained for compatibility. **They are not newly introduced cryptographic authorization.** Anyone who can obtain a valid shipment link can open it under the existing access model. The `m` prefix is a UI mode, not a security boundary.

The extra random tokens protect the new HTTP endpoint calls against blind requests/CSRF, but they do not make predictable public shipment links unguessable. Stronger link access would require coordinated changes to link generation and AppSrv verification. Do not describe this page as private solely because it uses the original MD5 token.

Inputs and SQL strings are validated/escaped, page data is HTML/JSON escaped, endpoint access is checked, sessions are closed before slow route operations, and internal exception details are logged rather than rendered to customers. The old shared shipment session design itself is preserved.

## Validation

See `TESTING.md`. The checked build passed **359 assertions**: 67 deterministic movement/clock checks, 102 TypeScript/data/AppSrv/API checks, 57 PHP helper checks, 70 HTTP endpoint checks against a fixture database/session adapter, and 63 offline browser checks with map/socket/network doubles.

Actual PostgreSQL/PostGIS execution, your real `SessManager`, AppSrv transport/server, real OpenLayers rendering and live OSM tiles have **not** been verified end to end. The browser checks run the rebuilt application with explicit OpenLayers/AppSrv doubles; they do not test the real map renderer or transport. The external OpenLayers download could not be resolved in this environment, so local vendoring remains an installation step, not an already completed step.

## Upstream references

OpenLayers release and distribution: <https://openlayers.org/> and <https://openlayers.org/download/>.

OpenLayers OSM source options: <https://openlayers.org/en/latest/apidoc/module-ol_source_OSM-OSM.html>.

OpenStreetMap tile policy: <https://operations.osmfoundation.org/policies/tiles/>.

Animation API references: <https://openlayers.org/en/latest/apidoc/module-ol_geom_Point-Point.html>, <https://openlayers.org/en/latest/apidoc/module-ol_View-View.html>, and <https://developer.mozilla.org/en-US/docs/Web/API/Window/requestAnimationFrame>.
