# Validation record

Validated 2026-09-22 in the working environment. These results are not a claim of production or real-SDK end-to-end verification.

## Commands

```bash
npm run typecheck
npm run build
npm test
npm run test:browser
find . -name '*.php' -not -path './node_modules/*' -print0 | xargs -0 -n1 php -l
node --check assets/route.js
```

Environment: TypeScript 5.8.3, Node 22.16.0, PHP 8.4.23, Python 3, headless Chromium via Python Playwright.

## Automated checks: 413 assertions

| Suite | Checks | Scope |
| --- | ---: | --- |
| Movement controller | 67 | Position order, interruption/retargeting, zero duration, long gap, large displacement, reduced motion, background behavior, finite frame loops. |
| Geography helpers | 22 | Longitude/latitude projection roundtrips, viewport fit, coordinate validation, polygons/holes/concave zones. |
| Frontend parsing + AppSrv | 102 | Original event contract, position/route/distance parsing, malformed/stale packets, oversized-route queue, race protection, reload callbacks. |
| PHP helpers | 57 | Shipment URL parsing, numbers, coordinates, JSON/HTML escaping, HTTPS detection. |
| PHP HTTP fixture integration | 78 | Actual PHP pages/endpoints against a fake DB/session wrapper: tokens, SQL sequencing, location transaction/rollback, completed routes, dependency paths, Yandex config, no OSM or main-app script imports. |
| Offline Chromium integration | 87 | Actual PHP HTML and compiled app with explicit SDK/AppSrv doubles: smooth intermediate positions, reused marker, native listener contract, camera following, buttons, keyboard, SDK readiness buffering, missing/rejected/blocked/timed-out SDK, one dynamic loader request, location POST, no data polling, lifecycle cleanup, responsive layouts. |

PHP syntax, generated JavaScript syntax and TypeScript compilation also passed (not included in assertion counts).

## Browser test boundaries

The Chromium suite uses the actual compiled `assets/route.js`, actual `assets/route.css`, and HTML produced by `index.php` in a temporary fixture application. `tests/browser-mock.ts` replaces Yandex, AppSrv, geolocation and endpoint fetch responses. An optional SDK request is intercepted and fulfilled with that same test double to validate the production loader path. No vendor script or tile is fetched in these tests.

Map constructors, properties and callbacks in that double implement the documented subset used by this app. This verifies our integration logic against that subset, **not the correctness of every assumption against a running Yandex SDK**. The local declaration file is similarly a narrow declared interface, not official SDK package validation.

Checked layouts: 1440×900, 390×844, 320×700 and 844×390. Assertions cover horizontal overflow, usable map height and control placement. Generated screenshots are clearly marked “TEST PLACEHOLDER — Yandex map is not loaded”. They are layout checks, not real map previews, and are omitted from the release ZIP.

## Not verified here

- A valid Yandex JavaScript API key, Referer restrictions, commercial/trial entitlement and actual provider responses.
- Live native Yandex rendering, tile/label loading, native copyrights/distribution controls, geographic alignment, touch interaction and continuous camera performance against the actual SDK.
- Your real database wrapper, `SessManager`, production data, `VehicleRoute::getRoute()` and production AppSrv connection.
- PHP versions other than 8.4.23. Source targets PHP 7.4+ syntax, but older runtimes were not run here.
- Fresh npm installation: npm registry access returned EAI_AGAIN in this environment. Compilation used the installed TypeScript 5.8.3 compiler; no npm-installed Yandex code was used.
- Per-instance production deployment and shared configuration/session consistency.

## Production smoke test

Deploy the same runtime and API-key configuration on every serving instance. With a licensed key restricted to the correct domain, load a currently active shipment. Confirm all five shared scripts load from `/js20/`, the official v3 loader succeeds, and the map—not the main login page—is returned. Check SDK errors in the Console and preserve Yandex's native attribution and “Open in Maps” controls.

Verify the initial marker/route align with real roads. Receive several AppSrv position packets, check smooth movement followed by a stationary marker at the latest fix, and try following, fit, drag, zoom and reduced motion. Test a long-route event and confirm it alone triggers the auxiliary GET. Send one confirmed location and verify the existing database transaction/rebuild flow; no timed polling or post-submit refresh should appear.

Repeat after reconnect, page restoration, route completion and on a narrow mobile screen. An API key is publicly visible by design: never send session cookies, database credentials or private configuration while reporting results.
