const { JSDOM } = require("jsdom");
const path = require("path");
const fs = require("fs");
const assert = require("assert/strict");
const projectRoot = process.env.BETON_PROJECT_ROOT || path.resolve(__dirname, "..");
const dom = new JSDOM('<div id="host"></div>', { url: "http://localhost/", runScripts: "outside-only" });
const w = dom.window;
for (const file of ["js20/assets/js/core/libraries/jquery.min.js", "js20/lib.js", "js20/tmpl/App.templates.js"]) {
	w.eval(fs.readFileSync(path.join(projectRoot, file), "utf8"));
}
w.Mustache = require("mustache");
const app = new w.App("test", { servVars: { role_id: "owner", tokenExpires: "2099-01-01 00:00:00" } });
w.getApp = () => app;
w.getWidthType = () => "lg";
w.getBsCol = () => 3;
app.getAppSrv = () => null;
app.getColorClass = () => "primary";
app.formatError = (code, message) => `${code}: ${message}`;
app.getConstantManager().m_values = {
	doc_per_page_count: new w.FieldInt("doc_per_page_count", { value: 2 }),
	grid_refresh_interval: new w.FieldInt("grid_refresh_interval", { value: 0 })
};
const alerts = [];
w.alert = (message) => alerts.push(message);
let confirmed = true;
w.confirm = () => confirmed;

const escapeXml = (value) => String(value).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");
const modelXml = (id, rows, totalCount = rows.length, from = 0) => `<model id="${id}" xmlns="http://www.w3.org/1999/xhtml" totalCount="${totalCount}" rowsPerPage="2" listFrom="${from}">${rows.map((row) => `<row>${Object.keys(row).map((key) => `<${key}>${escapeXml(row[key])}</${key}>`).join("")}</row>`).join("")}</model>`;
const makeModel = (id, data) => new w.ModelXML(id, {
	fields: {
		id: new w.FieldInt("id", { primaryKey: true }),
		name: new w.FieldString("name", { alias: "Наименование" }),
		inn: new w.FieldString("inn", { alias: "ИНН" }),
		phone_cel: new w.FieldString("phone_cel", { alias: "Телефон" }),
		orders_count: new w.FieldInt("orders_count", { alias: "Количество заказов" })
	},
	data
});
w.ClientMergeList_Model = function(options) {
	return makeModel("ClientMergeList_Model", options && options.data);
};
// Only the metadata-generated wrapper is substituted; the real framework handles
// model parsing, controls, paging, sorting, search filters and lifecycle events.
w.eval(`
function Client_Controller(options) {
	options = options || {};
	options.listModelClass = ClientMergeList_Model;
	Client_Controller.superclass.constructor.call(this, options);
	this.METH_GET_LIST = "get_merge_list";
	this.addGetList();
	this.addMethod("get_merge_selected");
	this.addMethod("merge_select", "post").addField(new FieldInt("client_id"));
	this.addMethod("merge_unselect", "post").addField(new FieldInt("client_id"));
	this.addMethod("merge_clear_selection", "post");
	var merge = this.addMethod("merge_selected", "post");
	merge.addField(new FieldInt("main_client_id"));
	merge.addField(new FieldString("client_ids"));
}
extend(Client_Controller, ControllerObjServer);
Client_Controller.prototype.run = function(methodId, options) {
	return window.mockMergeServer(this.getPublicMethod(methodId), options);
};
`);

const clients = new Map([
	[1, { id: 1, name: "Alpha", inn: "111", phone_cel: "1111111111", orders_count: 3 }],
	[2, { id: 2, name: "Bravo", inn: "222", phone_cel: "2222222222", orders_count: 12 }],
	[3, { id: 3, name: "Charlie", inn: "333", phone_cel: "3333333333", orders_count: 0 }],
	[4, { id: 4, name: "Delta <safe>", inn: "444", phone_cel: "4444444444", orders_count: 7 }]
]);
const selectedByUser = new Map([[7, new Set()], [8, new Set([3])]]);
const selected = selectedByUser.get(7);
const calls = [];
let failNext = null;
let holdNext = null;
let releaseHeld = null;
const matchingRows = (values) => {
	let rows = [...clients.values()].filter((row) => !selected.has(row.id));
	const fields = String(values.cond_fields || "").split("@@");
	const signs = String(values.cond_sgns || "").split("@@");
	const matches = String(values.cond_vals || "").split("@@");
	fields.forEach((field, index) => {
		if (!field) {
			return;
		}
		rows = rows.filter((row) => {
			if (signs[index] === "ge") {
				return row[field] >= Number(matches[index]);
			}
			return String(row[field]).toLowerCase().includes(matches[index].replaceAll("%", "").toLowerCase());
		});
	});
	const orderField = values.ord_fields || "name";
	const direction = values.ord_directs === "desc" ? -1 : 1;
	return rows.sort((a, b) => (a[orderField] > b[orderField] ? 1 : a[orderField] < b[orderField] ? -1 : 0) * direction);
};
w.mockMergeServer = (method, options) => {
	const methodId = method.getId();
	const values = {};
	for (const [fieldId, field] of Object.entries(method.getFields())) {
		if (!["c", "f", "v"].includes(fieldId) && field.isSet()) {
			values[fieldId] = field.getValue();
		}
	}
	calls.push({ method: methodId, values, requestType: options.requestType || method.getRequestType() || "get" });
	const answer = () => {
		if (failNext === methodId) {
			failNext = null;
			options.fail(null, 500, "Expected request failure");
			if (options.all) {
				options.all(null, 500, "Expected request failure");
			}
			return;
		}
		let response = {};
		if (methodId === "get_merge_selected") {
			const rows = [...selected].map((id) => clients.get(id)).sort((a, b) => b.orders_count - a.orders_count);
			const xml = modelXml("ClientMergeSelectedList_Model", rows);
			response = { getModel: () => makeModel("ClientMergeSelectedList_Model", xml) };
		}
		else if (methodId === "get_merge_list") {
			const allRows = matchingRows(values);
			const from = Number(values.from || 0);
			const rows = allRows.slice(from, from + Number(values.count || 2));
			response = { getModelData: () => modelXml("ClientMergeList_Model", rows, allRows.length, from) };
		}
		else if (methodId === "merge_select") {
			selected.add(Number(values.client_id));
		}
		else if (methodId === "merge_unselect") {
			selected.delete(Number(values.client_id));
		}
		else if (methodId === "merge_clear_selection") {
			selected.clear();
		}
		else if (methodId === "merge_selected") {
			const mainId = Number(values.main_client_id);
			let orders = 0;
			for (const id of selected) {
				orders += clients.get(id).orders_count;
				if (id !== mainId) {
					clients.delete(id);
				}
			}
			clients.get(mainId).orders_count = orders;
			selected.clear();
		}
		else {
			throw new Error(`Unexpected method ${methodId}`);
		}
		if (options.ok) {
			options.ok(response);
		}
		if (options.all) {
			options.all(response, 0, "");
		}
	};
	if (holdNext === methodId) {
		holdNext = null;
		releaseHeld = answer;
	}
	else {
		setTimeout(answer, 2);
	}
};

const MergeView = w.eval(fs.readFileSync(path.resolve(__dirname, "../js20/views/ClientMerge_View.js"), "utf8") + "\nClientMerge_View;");
let view;
const mount = () => {
	view = new MergeView("merge", {
		models: { ClientMergeList_Model: new w.ClientMergeList_Model({ data: modelXml("ClientMergeList_Model", [...clients.values()].slice(0, 2), clients.size) }) },
		template: '<div id="{{id}}"><h1>Merge</h1></div>'
	});
	view.toDOM(w.document.getElementById("host"));
	return view;
};
const settle = async () => {
	for (let i = 0; i < 100; i++) {
		await new Promise((resolve) => setTimeout(resolve, 5));
		if (!view.busy) {
			return;
		}
	}
	throw new Error("Timed out waiting for UI requests");
};
const grid = () => view.getElement("grid");
const rows = () => [...grid().getNode().querySelectorAll("tr[modelIndex]")];
const rowByName = (name) => rows().find((row) => row.textContent.includes(name));
const dblclick = (name) => rowByName(name).querySelector("td").dispatchEvent(new w.MouseEvent("dblclick", { bubbles: true }));
const radios = () => [...view.list.querySelectorAll('input[type="radio"]')];
const refreshGrid = () => new Promise((resolve, reject) => grid().onRefresh(resolve, reject));
const mutationCalls = () => calls.filter((call) => !call.method.startsWith("get_"));

(async () => {
	mount();
	await settle();
	assert.equal(view instanceof w.ViewAjxList, true);
	assert.equal(grid().getReadPublicMethod().getId(), "get_merge_list");
	assert.deepEqual(rows().map((row) => row.cells[3].textContent), ["3", "12"]);
	assert.equal(view.mergeButton.disabled, true);
	rowByName("Alpha").querySelector("td").click();
	await settle();
	assert.equal(selected.size, 0, "Single click only highlights a row");
	assert.equal(mutationCalls().length, 0);

	dblclick("Alpha");
	assert.equal(view.busy, true);
	dblclick("Bravo");
	await settle();
	assert.equal(selected.size, 1, "Busy state blocks a second selection request");
	assert.equal(rowByName("Alpha"), undefined, "Server selection excludes selected rows");
	assert.equal(view.list.querySelector("tbody tr").cells[1].textContent, "Alpha");
	assert.equal(view.list.querySelector("tbody tr").cells[5].textContent, "3");
	assert.equal(radios().length, 1);
	assert.deepEqual(mutationCalls()[0], { method: "merge_select", values: { client_id: 1 }, requestType: "post" });

	dblclick("Bravo");
	await settle();
	assert.equal(view.selected.get(2).ordersCount, "12");
	assert.equal(view.selected.get(1).ordersCount, "3");
	assert.equal(view.mergeButton.disabled, false);
	radios().find((radio) => radio.value === "2").click();
	assert.equal(view.mainId, 2);
	await view.reload();
	assert.equal(view.mainId, 2, "Explicit main choice survives reload");
	assert.equal(selectedByUser.get(8).has(3), true, "Other user's basket is isolated");

	view.delDOM();
	assert.equal(w.document.getElementById("merge"), null);
	mount();
	await settle();
	assert.equal(radios().length, 2, "Selection is restored on a new page instance");
	assert.equal(view.mainId, 2, "Default main favors most orders from server ordering");
	const removeAlpha = [...view.list.querySelectorAll("button")].find((button) => button.getAttribute("aria-label") === "Убрать Alpha");
	removeAlpha.click();
	await settle();
	assert.equal(selected.has(1), false);
	assert.ok(rowByName("Alpha"), "Removed selection returns to the available collection");
	assert.equal(view.mainId, 2);

	failNext = "merge_select";
	dblclick("Alpha");
	await settle();
	assert.equal(selected.has(1), false);
	assert.equal(view.busy, false);
	assert.equal(view.selectionReady, true, "Failed request reloads authoritative server state");
	assert.match(view.errorNode.textContent, /Expected request failure/);
	dblclick("Alpha");
	await settle();
	assert.equal(selected.has(1), true);
	assert.equal(view.errorNode.hidden, true);

	// Header sorting and numeric search filters use the real GridAjx method fields.
	const countHeader = grid().getNode().querySelector("th[id$=\"orders_count\"]");
	countHeader.click();
	await new Promise((resolve) => setTimeout(resolve, 8));
	countHeader.click();
	await new Promise((resolve) => setTimeout(resolve, 8));
	assert.equal(calls.at(-1).values.ord_fields, "orders_count");
	assert.equal(calls.at(-1).values.ord_directs, "desc");
	assert.equal(rows()[0].cells[3].textContent, "7");
	grid().setFilter({ field: "orders_count", sign: "ge", val: 5 });
	await refreshGrid();
	assert.equal(rows().length, 1);
	assert.ok(rowByName("Delta <safe>"));
	assert.equal(rowByName("Delta <safe>").querySelector("safe"), null, "Names are rendered as text");
	assert.equal(calls.at(-1).values.cond_fields, "orders_count");
	grid().setFilters({});
	grid().getPagination().setFrom(2);
	await view.reload();
	assert.equal(grid().getPagination().getFrom(), 2, "Manual reload preserves current page");
	grid().getPagination().setFrom(0);
	await refreshGrid();
	dblclick("Charlie");
	await settle();
	assert.equal(grid().getPagination().getFrom(), 0, "Selection changes reset available paging");

	grid().getNode().querySelector("th[id$=\"name\"]").click();
	await new Promise((resolve) => setTimeout(resolve, 8));
	view.clearButton.click();
	await settle();
	assert.equal(selected.size, 0);
	assert.equal(radios().length, 0);
	assert.ok(rowByName("Alpha"));
	dblclick("Alpha");
	await settle();
	dblclick("Bravo");
	await settle();
	radios().find((radio) => radio.value === "2").click();
	confirmed = false;
	const beforeCancelled = mutationCalls().length;
	view.mergeButton.click();
	assert.equal(mutationCalls().length, beforeCancelled, "Cancelled confirmation sends no request");
	confirmed = true;
	const expectedSnapshot = [...view.selected.keys()].join(",");
	view.mergeButton.click();
	await settle();
	assert.deepEqual(mutationCalls().at(-1), { method: "merge_selected", values: { main_client_id: 2, client_ids: expectedSnapshot }, requestType: "post" });
	assert.equal(selected.size, 0);
	assert.equal(clients.has(1), false);
	assert.equal(clients.get(2).orders_count, 15);
	assert.equal(radios().length, 0);
	assert.equal(rowByName("Bravo").cells[3].textContent, "15");
	assert.deepEqual(alerts, ["Клиенты объединены."]);

	// Unmounting while an async read is outstanding must not mutate detached UI.
	holdNext = "get_merge_selected";
	view.reload();
	assert.equal(view.busy, true);
	const detached = view.gridNode;
	view.delDOM();
	releaseHeld();
	await new Promise((resolve) => setTimeout(resolve, 5));
	assert.equal(view.panel, null);
	assert.equal(view.busy, false);
	detached.dispatchEvent(new w.MouseEvent("dblclick", { bubbles: true }));
	console.log("UI integration PASS: dedicated list/model, order counts, double click, persistent user selection, removal/clear, main choice, paging/search, POST confirmation snapshot, busy/error recovery, merge and lifecycle cleanup.");
	dom.window.close();
})().catch((error) => {
	console.error(error);
	dom.window.close();
	process.exitCode = 1;
});
