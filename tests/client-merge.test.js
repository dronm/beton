import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { PGlite } from "@electric-sql/pglite";

const db = new PGlite();
const tables = [
	"orders", "order_garbage", "offer", "ast_calls", "client_tels", "specialist_requests",
	"client_valid_duplicates", "vehicle_owners", "vehicle_owner_clients", "vehicle_owner_concrete_prices",
	"client_destinations", "client_specifications", "quality_passports", "client_contracts_1c", "client_debts",
];
const basicTables = tables.filter((table) => ![
	"client_tels", "client_valid_duplicates", "vehicle_owner_clients", "vehicle_owner_concrete_prices",
	"client_destinations", "client_specifications", "client_contracts_1c", "client_debts",
].includes(table));

await db.exec(`
	CREATE TABLE clients (id integer PRIMARY KEY, name text, inn text);
	CREATE TABLE views (id text PRIMARY KEY, c text, f text, t text, section text, descr text, limited boolean);
	${basicTables.map((table) => `CREATE TABLE ${table} (id integer PRIMARY KEY, client_id integer REFERENCES clients);`).join("\n")}
	CREATE TABLE client_tels (id integer PRIMARY KEY, client_id integer REFERENCES clients, tel text, name text, UNIQUE(client_id, tel));
	CREATE TABLE client_valid_duplicates (client_id integer REFERENCES clients, tel text, PRIMARY KEY(client_id, tel));
	CREATE TABLE vehicle_owner_clients (vehicle_owner_id integer, client_id integer UNIQUE REFERENCES clients, PRIMARY KEY(vehicle_owner_id, client_id));
	CREATE TABLE vehicle_owner_concrete_prices (vehicle_owner_id integer, client_id integer REFERENCES clients, date date, price integer, PRIMARY KEY(vehicle_owner_id, client_id, date));
	CREATE TABLE client_destinations (client_id integer REFERENCES clients, destination_id integer, lon numeric, lat numeric, PRIMARY KEY(client_id, destination_id));
	CREATE TABLE client_contracts_1c (id integer PRIMARY KEY, client_id integer REFERENCES clients, ref_1c jsonb);
	CREATE TABLE client_specifications (id integer PRIMARY KEY, client_id integer REFERENCES clients, client_contract_1c_ref text, contract text);
	CREATE TABLE client_debts (id integer PRIMARY KEY, firm_id integer, client_id integer REFERENCES clients, client_contract_id integer, debt_total numeric, UNIQUE(firm_id, client_id, client_contract_id));
	CREATE TABLE entity_contacts (id integer PRIMARY KEY, entity_type text, entity_id integer, contact_id integer, mod_date_time timestamptz DEFAULT now(), UNIQUE(entity_type, entity_id, contact_id));
	CREATE TABLE unexpected_links (client_id integer REFERENCES clients ON DELETE CASCADE);
	CREATE FUNCTION specification_contract() RETURNS trigger LANGUAGE plpgsql AS $$
	BEGIN
		SELECT ref_1c->>'descr' INTO NEW.contract FROM client_contracts_1c
		WHERE client_id = NEW.client_id AND ref_1c->>'ref_1c' = NEW.client_contract_1c_ref;
		RETURN NEW;
	END; $$;
	CREATE TRIGGER contract_lookup BEFORE UPDATE ON client_specifications FOR EACH ROW EXECUTE FUNCTION specification_contract();
`);
await db.exec(readFileSync(new URL("../migrations/000126_clients_merge.up.sql", import.meta.url), "utf8"));
const reset = async () => {
	await db.exec(`TRUNCATE clients, ${tables.join(", ")}, entity_contacts, unexpected_links;
		INSERT INTO clients VALUES (1, 'Main', '111'), (2, 'Source', '222'), (3, 'Source 2', '333'), (4, 'Untouched', '444');`);
};
const merge = async (main = 1, ids = [1, 2, 3]) => {
	await db.query("SELECT public.clients_merge($1::integer, $2::integer[])", [main, ids]);
};
const rows = async (query) => (await db.query(query)).rows;
let checks = 0;
const test = async (name, run) => {
	await reset();
	await run();
	checks++;
	console.log(`PASS ${name}`);
};

await test("moves all 15 client_id tables and contacts; deletes only sources; retains main fields", async () => {
	for (const table of basicTables) {
		await db.exec(`INSERT INTO ${table} VALUES (1, 2), (2, 3), (3, 4);`);
	}
	await db.exec(`
		INSERT INTO client_tels VALUES (1, 2, '222', 'Person'), (2, 3, '333', 'Other');
		INSERT INTO client_valid_duplicates VALUES (2, '222'), (3, '333');
		INSERT INTO vehicle_owner_clients VALUES (10, 2);
		INSERT INTO vehicle_owner_concrete_prices VALUES (10, 2, '2026-01-01', 100);
		INSERT INTO client_destinations VALUES (2, 10, 1.5, 2.5);
		INSERT INTO client_contracts_1c VALUES (5, 2, '{"ref_1c":"contract-a","descr":"Retained contract"}');
		INSERT INTO client_specifications VALUES (5, 2, 'contract-a', 'Old title');
		INSERT INTO client_debts VALUES (1, 10, 2, 5, 125.50);
		INSERT INTO entity_contacts (id, entity_type, entity_id, contact_id) VALUES
			(1, 'clients', 1, 10), (2, 'clients', 2, 10), (3, 'clients', 2, 20),
			(4, 'clients', 3, 20), (5, 'clients', 3, 30), (6, 'suppliers', 2, 40);
	`);
	await merge();
	assert.deepEqual(await rows("SELECT * FROM clients ORDER BY id"), [
		{ id: 1, name: "Main", inn: "111" }, { id: 4, name: "Untouched", inn: "444" },
	]);
	for (const table of tables) {
		assert.equal((await rows(`SELECT * FROM ${table} WHERE client_id IN (2,3)`)).length, 0, table);
		assert.ok((await rows(`SELECT * FROM ${table} WHERE client_id = 1`)).length, table);
	}
	assert.equal((await rows("SELECT * FROM orders WHERE client_id = 4")).length, 1);
	assert.equal((await rows("SELECT * FROM entity_contacts WHERE entity_type = 'clients' AND entity_id = 1")).length, 3);
	assert.equal((await rows("SELECT * FROM entity_contacts WHERE entity_type = 'suppliers' AND entity_id = 2")).length, 1);
	assert.equal((await rows("SELECT contract FROM client_specifications"))[0].contract, "Retained contract");
	assert.equal(Number((await rows("SELECT debt_total FROM client_debts"))[0].debt_total), 125.5);
});

await test("deduplicates pure membership links from main and multiple sources", async () => {
	await db.exec(`INSERT INTO client_valid_duplicates VALUES (1,'100'),(2,'100'),(3,'100'),(2,'200'),(3,'200');
		INSERT INTO vehicle_owner_clients VALUES (10,1),(10,2),(10,3);`);
	await merge();
	assert.equal((await rows("SELECT * FROM client_valid_duplicates")).length, 2);
	assert.deepEqual(await rows("SELECT * FROM vehicle_owner_clients"), [{ vehicle_owner_id: 10, client_id: 1 }]);
});

const conflicts = [
	["client_tels", "INSERT INTO client_tels VALUES (1,1,'100','Main person'),(2,2,'100','Other person');"],
	["vehicle_owner_clients", "INSERT INTO vehicle_owner_clients VALUES (10,1),(20,2);"],
	["vehicle_owner_concrete_prices", "INSERT INTO vehicle_owner_concrete_prices VALUES (10,1,'2026-01-01',100),(10,2,'2026-01-01',200);"],
	["client_destinations", "INSERT INTO client_destinations VALUES (1,10,1,2),(2,10,3,4);"],
	["client_debts", "INSERT INTO client_debts VALUES (1,10,1,5,100),(2,10,2,5,200);"],
];
for (const [table, seed] of conflicts) {
	await test(`conflict in ${table} rolls back earlier updates and source deletion`, async () => {
		await db.exec(`INSERT INTO orders VALUES (1,2); INSERT INTO client_valid_duplicates VALUES (1,'100'),(2,'100'); ${seed}`);
		await assert.rejects(() => merge(), new RegExp(table));
		assert.deepEqual(await rows("SELECT client_id FROM orders"), [{ client_id: 2 }]);
		assert.equal((await rows("SELECT * FROM clients")).length, 4);
		assert.equal((await rows("SELECT * FROM client_valid_duplicates")).length, 2);
	});
}
await test("blocks unknown CASCADE references before any data is lost", async () => {
	await db.exec("INSERT INTO orders VALUES (1,2); INSERT INTO unexpected_links VALUES (2);");
	await assert.rejects(() => merge(), /unexpected_links/);
	assert.equal((await rows("SELECT * FROM clients")).length, 4);
	assert.deepEqual(await rows("SELECT client_id FROM orders"), [{ client_id: 2 }]);
	assert.equal((await rows("SELECT * FROM unexpected_links")).length, 1);
});
for (const [name, main, ids] of [
	["one distinct client", 1, [1, 1]], ["main absent", 1, [2, 3]],
	["stale source", 1, [1, 99]], ["stale main", 99, [99, 2]],
	["zero id", 1, [1, 0]], ["negative id", 1, [1, -1]],
	["null id", 1, [1, null]], ["empty array", 1, []],
	["too many ids", 1, Array.from({ length: 101 }, (_, index) => index + 1)],
]) {
	await test(`rejects ${name}`, async () => {
		await assert.rejects(() => merge(main, [...ids]));
		assert.equal((await rows("SELECT * FROM clients")).length, 4);
	});
}
await test("duplicate ids are normalized and arbitrary main selection works", async () => {
	await merge(3, [1, 2, 3, 2]);
	assert.deepEqual(await rows("SELECT id FROM clients ORDER BY id"), [{ id: 3 }, { id: 4 }]);
});
await db.exec(readFileSync(new URL("../migrations/000126_clients_merge.down.sql", import.meta.url), "utf8"));
assert.equal((await rows("SELECT * FROM views WHERE t = 'ClientMerge'")).length, 0);
await assert.rejects(() => merge(), /does not exist/);
console.log(`Passed ${checks} merge scenarios and down-migration checks.`);
await db.close();
