# Client merge: persistent selections and order counts

This overlay contains the complete feature, including the earlier merge implementation and these corrections. Browser code and tests use plain JavaScript. Copy the overlay into the Beton project root. No existing project files need deleting. `common` and `osbe` need no changes.

## Corrected behavior

- Double-click a client row to select it. A single click only highlights it.
- The server saves selections in `public.client_merge_selections`, keyed by authenticated `user_id` and `client_id`. Each user's selection survives page reloads and is shared between that user's sessions/tabs. Other users maintain independent selections.
- Selected clients disappear from that user's available collection, including its filtered/paged results and total count. They remain in the normal client reference list and remain available to other users.
- The top selection table shows name, code, INN, telephone and number of orders, with a radio button for the main client. Removing a client returns it to the available collection; the clear button returns all selected clients.
- Both collections read live `orders_count` from the dedicated `public.client_merge_list` SQL view. It reads directly from `clients`, using `(SELECT count(*) FROM orders WHERE client_id = clients.id)`. It does not use `clients_list`, and `order_garbage` is not counted.
- The available collection uses its own `ClientMergeList_Model`; the selected collection uses `ClientMergeSelectedList_Model`. `ClientMerge_View.js` now extends `ViewAjxList` directly and builds its own grid. It does not inherit from or instantiate `ClientList_View`.
- Selected rows initially sort by order count descending, then name/code. The first row is the initial main client. The user can choose another main client; the choice remains during refresh while that client is still selected.
- The limit is 100 clients per user. Mutations refresh both collections. Successful selection changes reset the available page to the start while preserving filters.

## Installation: upgrading the previous archive

1. Copy this overlay into your project root.
2. Apply **only the new migration `000127_client_merge_selection.up.sql`** if 000126 is already installed. Migration 000126 is unchanged. For a fresh installation starting from the original uploaded project, apply 000126 and then 000127 in order. Check that migration 000127 has not already been allocated in your working tree.
3. Run your normal XSLT build, using your shared build imports:
   - Generate PHP and JavaScript models `ClientMergeList` and `ClientMergeSelectedList` from the new model templates/metadata. The private physical-table model `ClientMergeSelection` is also described in metadata with its normal generation wrappers; its JavaScript is not registered because the UI does not use it directly.
   - Rebuild the PHP and JavaScript **Client** controller and permissions.
   - Rebuild `ClientMerge` HTML, the template registry (`js20/tmpl/App.templates.js`), script registrations (`ViewBase`) and combined bundle if used. Metadata registers the two new JavaScript list models and the existing merge-page script.
4. View **10063** now calls `Client_Controller.get_merge_list`. In your menu constructor, reopen and save any existing menu containing **Объединение клиентов** so its stored menu XML picks up the updated view method. For a new installation, add the view to the desired menus.
5. Update direct links/bookmarks to `?c=Client_Controller&f=get_merge_list&t=ClientMerge`, then refresh browser assets.

Do not reopen this page with the earlier `f=get_list` URL: that returns the ordinary client model rather than the dedicated merge model.

Generated controller/model files and the combined bundle are not patched by hand in this archive. The template and metadata changes are authoritative. `tmpl/ClientMerge.html` is included as the output of the self-contained HTML template. The uploaded OSBE archive lacks its `build` directory and Beton's shared model/controller XSLT imports are unresolved absolute symlinks, so full generation must run in your environment where those files exist.

## API and isolation

All methods belong to `Client_Controller`:

| Method | Parameters | Purpose |
| --- | --- | --- |
| `get_merge_list` | Usual list filters/order/paging | Available clients excluding the current user's saved selection |
| `get_merge_selected` | No parameters needed by the page | Complete selected list with current order counts; maximum 100 |
| `merge_select` | `client_id` | Add one client to the current user's selection |
| `merge_unselect` | `client_id` | Remove one client from that selection |
| `merge_clear_selection` | None | Clear that selection |
| `merge_selected` | `main_client_id`, `client_ids` | Merge the persisted selection, validating it against the confirmed visible IDs |

Mutations use POST. PHP takes the user ID from `$_SESSION['user_id']`; no request parameter can choose another user's selection. Selection/list reads use the master database so a just-selected client does not reappear because of replica delay.

The list controller uses OSBE's regular query options and model selection path. It groups client-supplied filters, then adds an obligatory server-generated `EXISTS`/`NOT EXISTS` user predicate. The same predicate applies to results and pagination totals. `setSelectQueryText` is deliberately avoided because this framework bypasses ordinary filters, sorting and pagination when a custom query is supplied there.

The saved selection is authoritative when merging. The browser also sends the IDs displayed at confirmation; PostgreSQL compares that snapshot with the locked saved set. If another tab changed the selection, the operation stops with a refresh message before changing client data. The main ID must belong to the current selection.

The existing broad staff permission rules cover the new methods after permission regeneration. Restricted client/vehicle-owner/guest roles receive no additional grants.

## Merge rules retained

The operation still transfers `client_id` in all 15 requested tables, moves modern `entity_contacts` links and deletes the selected source clients. The main client's own attributes remain unchanged. Pure duplicate membership links collapse; conflicting business rows, financial balances, prices, destination keys or legacy telephone keys abort the whole operation rather than silently selecting a value.

All updates, source deletion and selection cleanup occur in the same transaction. Errors preserve the saved selections. Success clears the initiating user's selection. Deleted source clients are removed from every user's selection so stale references cannot block deletion; another user's selection of the surviving main client remains.

The original residual-foreign-key check remains active for all other references, including cascading ones. Unknown polymorphic links or columns without foreign keys are not discoverable by that check; the known contact links and requested tables are explicitly handled.

Basket mutations serialize per user using a transaction-scoped advisory lock. The merge also retains its existing client/table locks, so concurrent writes to affected business tables may briefly wait. Lock order was reviewed; the included tests do not simulate concurrent database sessions.

Legacy `merge(main_client_id, client_ids)` and `union(...)` remain available for existing integrations. The new page uses `merge_selected`.

## Source files

| Location | Purpose |
| --- | --- |
| `build/metadata.xml` | Private table model, dedicated list models, API methods, view 10063 and script registrations |
| `build/templates/controllers/Client_Controller_php.xsl` | Authenticated user scoping, list methods and selection/merge endpoints |
| `build/templates/models/ClientMerge*_Model_{php,js}.xsl` | Normal model generation wrappers |
| `js20/views/ClientMerge_View.js` | Dedicated JavaScript grid and selected-clients table |
| `build/sql/client_merge_selections.sql` | Physical per-user table and source-client index |
| `build/sql/client_merge_list.sql` | Independent client list with live order count |
| `build/sql/clients_merge_selection.sql` | Selection mutation and saved-selection merge functions |
| `build/sql/clients_merge.sql` | Merge function, now including transient-selection cleanup |
| `migrations/000127_client_merge_selection.{up,down}.sql` | Forward upgrade and rollback to the previous feature version |
| `tests/` | Database and UI behavior tests |

Migration 000127 down removes persisted selections and restores the previous SQL merge function and view method. Rollback requires matching previous application sources. Neither migration can undo already completed client merges.

## Validation

The test suite covers the original 18 merge scenarios, 26 persistent-selection/stale-snapshot scenarios and 8 dedicated-list scenarios. It checks per-user isolation, duplicate/cap validation, persistence, live zero/multiple-order counts, independent sorting/filtering/paging and total counts, remove/clear behavior, successful selection cleanup, merge rollback, cross-user source cleanup and migration rollback/reapply.

The UI test loads the actual supplied JavaScript framework in jsdom with fixtures for the newly generated models and server API. It checks single versus double click, persistent selection reload, hiding/returning available clients, both order counts, main radio choice, confirmation/request values, busy/error handling and cleanup. It does not require `ClientList_View`.

Metadata consistency, XML syntax, the isolated custom controller XSLT transform, rendered PHP syntax and JavaScript syntax were checked. A full production build, PHP execution with a real application session, production database triggers and visual browser rendering were not available here.

After applying this overlay to the complete project, use Node.js 24 or newer to run the tests:

```bash
cd tests
npm install
npm test
```

For a separate fixture project, set `BETON_PROJECT_ROOT` to its full project root. All database tests use isolated in-memory PGlite databases and never connect to production.

Suggested commit message: `feat(clients): persist merge selections per user and show order counts`
