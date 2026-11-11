# Production plant manager

The PHP/JavaScript project includes the latest uploaded Beton source plus the previously saved client-merge changes (version 2). The companion `ebserver.zip` includes the previously saved ds/v4 server migration and the command changes needed by this form.

## Installation

1. Extract `beton.zip` over the PHP project and `ebserver.zip` over the Go WebSocket server project. Both updates are required. Shared `common`, OSBE and gobizapp libraries need no changes for this feature.
2. Apply migration `000128_production_site_manager.up.sql` using the project's normal migration command. If the earlier client-merge changes have not been installed, apply their migrations 000126 and 000127 first.
3. Build and restart the Go server. The existing Go module replacements must point to your local libraries, as before.
4. Open `?t=ProductionSiteManager` in the logged-in PHP application. In the menu constructor, add view **10064**, **Справочники → Управление заводами**, to the desired menu. Existing stored menus are not overwritten.
5. Refresh browser assets. Source registrations and generated assets for the new form are included. A later normal XSLT build retains the feature; it does not require TypeScript, Vue, npm dev, or a separately supplied session token.

No files need to be deleted. Migration 000128 only registers the view; it does not alter plant data. Its down migration removes the registration.

## Form

The form reuses `ProductionSiteEdit` and the shared `AppSrv` connection. It offers all requested parameters in separate `get`, `set`, and `fetch_production` panels. The readonly result area shows timestamps, the original plant, a unique query ID, HTTP responses, WebSocket replies and errors. A changed selection does not reassign a pending result to another plant.

Integer settings are sent as JSON numbers; zero is supported for debounce, shutdown and last production. Query interval and production count must be positive. `log_file` can be empty. Other string values are sent as literal strings. Connection settings are shown only after the command API authorizes the request; the HTTP command methods are available to logged-in `admin`, `owner` and `boss` users.

The plant client's `set` command sends no success acknowledgement. The manager therefore reads its configuration using `fetch-config` after sending a setting and compares the returned value. Nested production settings and `log_file`/`log_file_name` are mapped correctly. Changing the plant's WebSocket address can prevent readback until the plant reconnects; a timeout does not establish whether the update was applied.

The existing `fetch_production` command adds a production ID to the plant's polling queue. It sends no completion reply. The manager reports command dispatch and displays any subsequent query-correlated error; it does not label an HTTP success as a completed production import.

Replies time out after 60 seconds. Closing the form or losing the connection releases listeners and aborts local HTTP waits. Commands are never automatically repeated. Queued commands may still run on the plant after a local timeout or navigation away. Output stays in page memory and can be cleared.

## API contract

The default address retains the existing application's proxy path: `eurobeton/api-post/elkon-production-cmd/`, resolved against `basePath`. Absolute URLs are now handled correctly. Browser requests use the existing `token` cookie through `credentials: include`, rather than attempting to set the forbidden `Cookie` header. If an installation uses another proxy location, `app.m_servVars.elkonCommandApiURL` can specify its API directory before opening the form.

All requests use POST, JSON and a unique `Query-Id` header. The current reflection API binds values in property order, so the plant ID is deliberately serialized first.

| Method | JSON body |
| --- | --- |
| `get` | `{ "production_site_id": 4, "param": "last_production" }` |
| `set-config-params` | `{ "production_site_id": 4, "params": { "query_interval_s": 10 } }` |
| `fetch-production` | `{ "production_site_id": 4, "production_id": 23274 }` |
| `fetch-config` | `{ "production_site_id": 4 }` |

The Go service emits client commands `get`, `set`, `fetch_production` and `fetch_config`. Direct replies have `{event_id, query_id, payload, error}`. AppSrv now dispatches this envelope by query ID while retaining its legacy `Event_Model` handling. Direct responses need no `Event.subscribe` request: the server routes them to the initiating session.

The server update also adds the missing `Get` sender, fixes reflection binding of set objects/null, preserves string/number/object/null Get replies, forwards plant errors to the initiating query, and restricts the plant-command HTTP service. No plant client update is required.

## Source and generated assets

- `js20/views/ProductionSiteManager_View.js`: hand-maintained pure JavaScript form.
- `js20/core/AppSrv.js`: direct response listeners and cleanup.
- `js20/custom_controls/AppBeton.js`: corrected HTTP command helper.
- `build/metadata.xml`: view, server template and script registrations.
- `build/templates/tmpl/ProductionSiteManager_html.xsl` and `tmpl/ProductionSiteManager.html`: form shell.
- `migrations/000128_production_site_manager.*.sql`: view registration and rollback.
- `views/ViewBase.php`, `js20/tmpl/App.templates.js`, `js20/lib.js`: runtime registration and production bundle overrides for the new feature. Normal regeneration replaces the appended overrides with the registered source methods.
- `build/templates/views/ViewBase_php.xsl`: production bundle cache timestamp now uses the bundle file itself.
- `tests/production-site-manager.test.cjs`: dependency-free command and lifecycle regression tests.

The earlier client-merge source changes are preserved, including their own build instructions in `README_CLIENT_MERGE.md`. The new runtime bundle patch does not regenerate the earlier feature's PHP controllers/models.

## Validation

Run the new suite without installing dependencies:

```bash
cd tests
npm run test:plants
```

All 14 plant-manager tests passed. They cover option/type handling, early socket responses, concurrent plant/query correlation, set readback, HTTP and asynchronous errors, timeouts, connection loss, disposal, and legacy event compatibility. Tests use controlled DOM and session fixtures. Source JavaScript and bundled JavaScript syntax, metadata registration and the generated HTML transform also passed checks.

Go reflection/permission/response-type regression tests are included in the server archive. They were not executed because Go is unavailable in this environment. PHP CLI and a browser renderer were also unavailable. A full XSLT project regeneration needs the shared build imports supplied in your normal environment. No commands were sent to a live production plant.
