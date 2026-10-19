import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { PGlite } from "@electric-sql/pglite";

const db = new PGlite();
await db.exec(`
	CREATE TABLE users (id integer PRIMARY KEY);
	CREATE TABLE clients (id integer PRIMARY KEY, name text, inn text, phone_cel text);
	CREATE TABLE orders (id integer PRIMARY KEY, client_id integer REFERENCES clients);
	CREATE TABLE order_garbage (id integer PRIMARY KEY, client_id integer REFERENCES clients);
`);
await db.exec(readFileSync(new URL("../build/sql/client_merge_selections.sql", import.meta.url), "utf8"));
await db.exec(readFileSync(new URL("../build/sql/client_merge_list.sql", import.meta.url), "utf8"));

const rows = async (sql, params = []) => (await db.query(sql, params)).rows;
const scope = (selected) => `${selected ? "" : "NOT "}EXISTS (
	SELECT 1 FROM public.client_merge_selections AS selection
	WHERE selection.user_id = $1 AND selection.client_id = client_merge_list.id
)`;
const ids = (result) => result.map((row) => row.id);
const list = async (userId, selected = false, tail = "ORDER BY id") => rows(`
	SELECT * FROM public.client_merge_list WHERE ${scope(selected)} ${tail}
`, [userId]);
const total = async (userId, selected = false, filter = "TRUE") => Number((await rows(`
	SELECT count(*) AS total_count FROM public.client_merge_list
	WHERE (${filter}) AND ${scope(selected)}
`, [userId]))[0].total_count);
let checks = 0;
const reset = async () => {
	await db.exec(`
		TRUNCATE client_merge_selections, orders, order_garbage, clients, users;
		INSERT INTO users VALUES (10), (20);
		INSERT INTO clients VALUES
			(1, 'Alpha', '111', '100'), (2, 'Bravo', '222', '200'),
			(3, 'Charlie', '333', '300'), (4, 'Delta', '444', '400'),
			(5, 'Echo', '555', NULL), (6, 'Foxtrot', NULL, '600');
		INSERT INTO orders VALUES (1, 1), (2, 1), (3, 1), (4, 3), (5, 3), (6, 4);
		INSERT INTO order_garbage VALUES (1, 2), (2, 2), (3, 2), (4, 2);
	`);
};
const test = async (name, run) => {
	await reset();
	await run();
	checks++;
	console.log(`PASS ${name}`);
};

await test("dedicated merge view counts orders, including zero, independently from garbage orders", async () => {
	const result = await list(10);
	assert.deepEqual(result.map((row) => [row.id, Number(row.orders_count)]), [
		[1, 3], [2, 0], [3, 2], [4, 1], [5, 0], [6, 0],
	]);
	assert.deepEqual(result[0], {
		id: 1, name: "Alpha", inn: "111", phone_cel: "100", orders_count: 3,
	});
	assert.equal((await rows("SELECT pg_typeof(orders_count)::text AS data_type FROM client_merge_list LIMIT 1"))[0].data_type, "bigint");
});

await test("selecting a client excludes it only from that user's available collection", async () => {
	await db.exec("INSERT INTO client_merge_selections (user_id, client_id) VALUES (10, 1), (10, 3), (20, 2)");
	assert.deepEqual(ids(await list(10)), [2, 4, 5, 6]);
	assert.deepEqual(ids(await list(20)), [1, 3, 4, 5, 6]);
	assert.deepEqual(ids(await list(10, true)), [1, 3]);
	assert.deepEqual(ids(await list(20, true)), [2]);
	assert.equal(await total(10), 4);
	assert.equal(await total(20), 5);
	assert.equal(await total(10, true), 2);
});

await test("selected rows return their current order counts for choosing a main client", async () => {
	await db.exec("INSERT INTO client_merge_selections (user_id, client_id) VALUES (10, 1), (10, 3)");
	assert.deepEqual((await list(10, true)).map((row) => [row.id, Number(row.orders_count)]), [[1, 3], [3, 2]]);
	await db.exec("INSERT INTO orders VALUES (7, 3), (8, 3)");
	assert.deepEqual((await list(10, true, "ORDER BY orders_count DESC, id")).map((row) => [row.id, Number(row.orders_count)]), [[3, 4], [1, 3]]);
});

await test("filtering, sorting and pagination apply after exclusion with a matching total count", async () => {
	await db.exec("INSERT INTO client_merge_selections (user_id, client_id) VALUES (10, 1), (10, 5)");
	const filter = "orders_count >= 0 AND name <> 'Bravo'";
	const result = await rows(`
		SELECT id, orders_count FROM client_merge_list
		WHERE (${filter}) AND ${scope(false)}
		ORDER BY orders_count DESC, id LIMIT 1 OFFSET 1
	`, [10]);
	assert.deepEqual(ids(result), [4]);
	assert.equal(await total(10, false, filter), 3);
	assert.deepEqual(ids(await list(10, false, "ORDER BY id LIMIT 2 OFFSET 2")), [4, 6]);
});

await test("grouped alternative client filters cannot expose selected clients or another user's selection", async () => {
	await db.exec("INSERT INTO client_merge_selections (user_id, client_id) VALUES (10, 1), (20, 2)");
	const filter = "id = 1 OR id = 2";
	assert.deepEqual(ids(await rows(`SELECT id FROM client_merge_list WHERE (${filter}) AND ${scope(false)} ORDER BY id`, [10])), [2]);
	assert.deepEqual(ids(await rows(`SELECT id FROM client_merge_list WHERE (${filter}) AND ${scope(true)} ORDER BY id`, [10])), [1]);
	assert.equal(await total(10, false, filter), 1);
	assert.equal(await total(10, true, filter), 1);
});

await test("removing a selection returns the client to the collection without affecting another user", async () => {
	await db.exec("INSERT INTO client_merge_selections (user_id, client_id) VALUES (10, 1), (20, 1)");
	await db.query("DELETE FROM client_merge_selections WHERE user_id = $1 AND client_id = $2", [10, 1]);
	assert.deepEqual(ids(await list(10)), [1, 2, 3, 4, 5, 6]);
	assert.deepEqual(ids(await list(10, true)), []);
	assert.deepEqual(ids(await list(20, true)), [1]);
	assert.deepEqual(ids(await list(20)), [2, 3, 4, 5, 6]);
});

await test("selection persists across independent collection reads and filter changes", async () => {
	await db.exec("INSERT INTO client_merge_selections (user_id, client_id) VALUES (10, 4)");
	assert.deepEqual(ids(await list(10, true)), [4]);
	assert.deepEqual(ids(await rows(`SELECT id FROM client_merge_list WHERE name LIKE 'A%' AND ${scope(false)}`, [10])), [1]);
	assert.deepEqual(ids(await list(10, true)), [4]);
	assert.deepEqual(ids(await list(10)), [1, 2, 3, 5, 6]);
	assert.equal(await total(10, true), 1);
});

await test("an empty available page retains the correct selected and available totals", async () => {
	await db.exec("INSERT INTO client_merge_selections (user_id, client_id) SELECT 10, id FROM clients");
	assert.deepEqual(await list(10), []);
	assert.equal(await total(10), 0);
	assert.equal(await total(10, true), 6);
	assert.equal(await total(20), 6);
});

await db.close();
console.log(`${checks} client merge list scenarios passed.`);
