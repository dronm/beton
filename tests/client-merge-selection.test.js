import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { PGlite } from "@electric-sql/pglite";

const db = new PGlite();
const tables = [
	"orders", "order_garbage", "offer", "ast_calls", "client_tels", "specialist_requests",
	"client_valid_duplicates", "vehicle_owners", "vehicle_owner_clients", "vehicle_owner_concrete_prices",
	"client_destinations", "client_specifications", "quality_passports", "client_contracts_1c", "client_debts",
];
const basicTables = tables.filter((table) => !["client_tels", "client_valid_duplicates", "vehicle_owner_clients"].includes(table));
const sql = (path) => readFileSync(new URL(path, import.meta.url), "utf8");
const rows = async (query, params = []) => (await db.query(query, params)).rows;
const call = async (name, ...params) => {
	await db.query(`SELECT public.${name}(${params.map((value, index) => `$${index + 1}::${name === "clients_merge_selected" && index === 2 ? "integer[]" : "integer"}`).join(", ")})`, params);
};
let checks = 0;
const test = async (name, run) => {
	await db.exec(`
		TRUNCATE users, clients, client_merge_selections, ${tables.join(", ")}, entity_contacts, unexpected_links;
		INSERT INTO users VALUES (1), (2), (3);
		INSERT INTO clients VALUES (1, 'Main', '111', '100'), (2, 'Source', '222', '200'),
			(3, 'Third', '333', '300'), (4, 'Other', '444', '400');
	`);
	await run();
	checks++;
	console.log(`PASS ${name}`);
};
const basket = async (user) => rows("SELECT client_id FROM public.client_merge_selections WHERE user_id = $1 ORDER BY client_id", [user]);
const pick = async (user, ids) => {
	for (const id of ids) {
		await call("clients_merge_select", user, id);
	}
};

await db.exec(`
	CREATE TABLE users (id integer PRIMARY KEY);
	CREATE TABLE clients (id integer PRIMARY KEY, name text, inn text, phone_cel text);
	CREATE TABLE views (id text PRIMARY KEY, c text, f text, t text, section text, descr text, limited boolean);
	${basicTables.map((table) => `CREATE TABLE ${table} (id integer PRIMARY KEY, client_id integer REFERENCES clients);`).join("\n")}
	CREATE TABLE client_tels (id integer PRIMARY KEY, client_id integer REFERENCES clients, tel text, UNIQUE(client_id, tel));
	CREATE TABLE client_valid_duplicates (client_id integer REFERENCES clients, tel text, PRIMARY KEY(client_id, tel));
	CREATE TABLE vehicle_owner_clients (vehicle_owner_id integer, client_id integer REFERENCES clients, PRIMARY KEY(vehicle_owner_id, client_id));
	CREATE TABLE entity_contacts (id integer PRIMARY KEY, entity_type text, entity_id integer, contact_id integer, UNIQUE(entity_type, entity_id, contact_id));
	CREATE TABLE unexpected_links (client_id integer REFERENCES clients ON DELETE CASCADE);
`);
await db.exec(sql("../migrations/000126_clients_merge.up.sql"));
const originalMerge = (await rows("SELECT prosrc FROM pg_proc WHERE oid = 'public.clients_merge(integer,integer[])'::regprocedure"))[0].prosrc;
await db.exec(sql("../migrations/000127_client_merge_selection.up.sql"));
assert.deepEqual(await rows("SELECT f FROM views WHERE id = '10063'"), [{ f: "get_merge_list" }]);

await test("persists selections per user without sharing baskets", async () => {
	await pick(1, [1, 2]);
	await pick(2, [2, 3]);
	assert.deepEqual(await basket(1), [{ client_id: 1 }, { client_id: 2 }]);
	assert.deepEqual(await basket(2), [{ client_id: 2 }, { client_id: 3 }]);
	assert.deepEqual(await basket(3), []);
	assert.equal((await rows("SELECT count(*)::integer AS n FROM client_merge_selections WHERE selected_at IS NOT NULL"))[0].n, 4);
});

await test("reselecting a client is idempotent and preserves its original selection time", async () => {
	await pick(1, [2]);
	const before = await rows("SELECT selected_at FROM client_merge_selections WHERE user_id = 1");
	await pick(1, [2, 2]);
	assert.deepEqual(await basket(1), [{ client_id: 2 }]);
	assert.deepEqual(await rows("SELECT selected_at FROM client_merge_selections WHERE user_id = 1"), before);
});

await test("unselect and clear affect only the authenticated user's basket", async () => {
	await pick(1, [1, 2]);
	await pick(2, [1, 2]);
	await call("clients_merge_unselect", 1, 1);
	await call("clients_merge_unselect", 1, 1);
	assert.deepEqual(await basket(1), [{ client_id: 2 }]);
	await call("clients_merge_clear", 1);
	await call("clients_merge_clear", 1);
	assert.deepEqual(await basket(1), []);
	assert.deepEqual(await basket(2), [{ client_id: 1 }, { client_id: 2 }]);
	assert.equal((await rows("SELECT count(*)::integer AS n FROM clients"))[0].n, 4);
});

for (const [name, params] of [
	["missing user", [99, 1]], ["null user", [null, 1]], ["zero user", [0, 1]],
	["missing client", [1, 99]], ["null client", [1, null]], ["negative client", [1, -1]],
]) {
	await test(`rejects ${name} without changing baskets`, async () => {
		await assert.rejects(() => call("clients_merge_select", ...params));
		assert.deepEqual(await basket(1), []);
	});
}

await test("limits each user to 100 selections while allowing an idempotent 100th selection", async () => {
	await db.exec("INSERT INTO clients (id, name) SELECT n, 'Client ' || n FROM generate_series(5, 101) AS n;");
	await pick(1, Array.from({ length: 100 }, (_, index) => index + 1));
	await pick(1, [100]);
	await assert.rejects(() => pick(1, [101]), /100/);
	await pick(2, [101]);
	assert.equal((await basket(1)).length, 100);
	assert.deepEqual(await basket(2), [{ client_id: 101 }]);
	await call("clients_merge_unselect", 1, 50);
	await pick(1, [101]);
	assert.equal((await basket(1)).length, 100);
});

for (const [name, ids, main] of [
	["empty basket", [], 1], ["one selected client", [1], 1],
	["main outside the user's basket", [1, 2], 3], ["null main", [1, 2], null],
]) {
	await test(`merge rejects ${name} without clearing selections`, async () => {
		await pick(1, ids);
		await pick(2, [3, 4]);
		await assert.rejects(() => call("clients_merge_selected", 1, main, ids));
		assert.deepEqual(await basket(1), ids.map((id) => ({ client_id: id })));
		assert.deepEqual(await basket(2), [{ client_id: 3 }, { client_id: 4 }]);
		assert.equal((await rows("SELECT count(*)::integer AS n FROM clients"))[0].n, 4);
	});
}

for (const [name, expected] of [
	["unseen addition in another tab", [1]], ["unseen removal in another tab", [1, 2, 3]],
	["empty visible list", []], ["null visible list", null], ["invalid ID", [1, -1]],
	["null ID", [1, null]], ["too many visible IDs", Array(101).fill(1)],
]) {
	await test(`rejects stale or invalid expected IDs: ${name}`, async () => {
		await pick(1, [1, 2]);
		await pick(2, [2, 3]);
		await db.exec("INSERT INTO orders VALUES (1, 2);");
		await assert.rejects(() => call("clients_merge_selected", 1, 1, expected), /Выбор клиентов изменился/);
		assert.deepEqual(await basket(1), [{ client_id: 1 }, { client_id: 2 }]);
		assert.deepEqual(await basket(2), [{ client_id: 2 }, { client_id: 3 }]);
		assert.deepEqual(await rows("SELECT client_id FROM orders"), [{ client_id: 2 }]);
		assert.equal((await rows("SELECT count(*)::integer AS n FROM clients"))[0].n, 4);
	});
}

await test("merges the server basket and clears only source references in other users' baskets", async () => {
	await pick(1, [1, 2]);
	await pick(2, [1, 2, 3]);
	await pick(3, [2, 4]);
	await db.exec("INSERT INTO orders VALUES (1, 1), (2, 2), (3, 2), (4, 3);");
	await call("clients_merge_selected", 1, 2, [2, 1, 2]);
	assert.deepEqual(await rows("SELECT id FROM clients ORDER BY id"), [{ id: 2 }, { id: 3 }, { id: 4 }]);
	assert.deepEqual(await basket(1), []);
	assert.deepEqual(await basket(2), [{ client_id: 2 }, { client_id: 3 }]);
	assert.deepEqual(await basket(3), [{ client_id: 2 }, { client_id: 4 }]);
	assert.equal(Number((await rows("SELECT orders_count FROM client_merge_list WHERE id = 2"))[0].orders_count), 3);
});

await test("unknown business references roll back reference transfers and all basket cleanup", async () => {
	await pick(1, [1, 2]);
	await pick(2, [2, 3]);
	await db.exec("INSERT INTO orders VALUES (1, 2); INSERT INTO unexpected_links VALUES (2);");
	await assert.rejects(() => call("clients_merge_selected", 1, 1, [1, 2]), /unexpected_links/);
	assert.deepEqual(await rows("SELECT client_id FROM orders"), [{ client_id: 2 }]);
	assert.deepEqual(await basket(1), [{ client_id: 1 }, { client_id: 2 }]);
	assert.deepEqual(await basket(2), [{ client_id: 2 }, { client_id: 3 }]);
	assert.equal((await rows("SELECT count(*)::integer AS n FROM clients"))[0].n, 4);
});

await test("conflicting records preserve selections for correction and retry", async () => {
	await pick(1, [1, 2]);
	await db.exec("INSERT INTO orders VALUES (1, 2); INSERT INTO client_tels VALUES (1, 1, '100'), (2, 2, '100');");
	await assert.rejects(() => call("clients_merge_selected", 1, 1, [1, 2]), /client_tels/);
	assert.deepEqual(await rows("SELECT client_id FROM orders"), [{ client_id: 2 }]);
	assert.deepEqual(await basket(1), [{ client_id: 1 }, { client_id: 2 }]);
	await db.exec("DELETE FROM client_tels WHERE id = 2;");
	await call("clients_merge_selected", 1, 1, [1, 2]);
	assert.deepEqual(await basket(1), []);
	assert.deepEqual(await rows("SELECT client_id FROM orders"), [{ client_id: 1 }]);
});

await test("direct legacy merge also cleans source selections across all users", async () => {
	await pick(1, [1, 2]);
	await pick(2, [2, 3]);
	await db.query("SELECT public.clients_merge($1::integer, $2::integer[])", [1, [1, 2]]);
	assert.deepEqual(await basket(1), [{ client_id: 1 }]);
	assert.deepEqual(await basket(2), [{ client_id: 3 }]);
});

await test("user and client deletion cascade only their ephemeral selections", async () => {
	await pick(1, [1, 2]);
	await pick(2, [2, 3]);
	await db.exec("DELETE FROM users WHERE id = 1; DELETE FROM clients WHERE id = 3;");
	assert.deepEqual(await basket(1), []);
	assert.deepEqual(await basket(2), [{ client_id: 2 }]);
	assert.equal((await rows("SELECT count(*)::integer AS n FROM clients"))[0].n, 3);
});

await db.exec(sql("../migrations/000127_client_merge_selection.down.sql"));
assert.equal((await rows("SELECT prosrc FROM pg_proc WHERE oid = 'public.clients_merge(integer,integer[])'::regprocedure"))[0].prosrc, originalMerge);
assert.deepEqual(await rows("SELECT f FROM views WHERE id = '10063'"), [{ f: "get_list" }]);
assert.equal((await rows("SELECT to_regclass('public.client_merge_selections') AS selection_table, to_regclass('public.client_merge_list') AS merge_view"))[0].selection_table, null);
await db.query("SELECT public.clients_merge($1::integer, $2::integer[])", [1, [1, 2]]);
await db.exec(sql("../migrations/000127_client_merge_selection.up.sql"));
assert.deepEqual(await rows("SELECT f FROM views WHERE id = '10063'"), [{ f: "get_merge_list" }]);
await db.exec(sql("../migrations/000127_client_merge_selection.down.sql"));
await db.exec(sql("../migrations/000126_clients_merge.down.sql"));
console.log(`Passed ${checks} selection scenarios plus migration rollback/reapply checks.`);
await db.close();
