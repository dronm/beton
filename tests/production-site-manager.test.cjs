"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");
const vm = require("node:vm");
const projectRoot = process.env.BETON_PROJECT_ROOT || path.resolve(__dirname, "..");

// A small deterministic DOM/session fixture isolates transport and lifecycle tests.
// This is not a substitute for rendering in the deployed application's browser.
class Element {
	constructor(tag) {
		this.tagName = tag.toUpperCase();
		this.children = [];
		this.style = {};
		this.attributes = {};
		this.events = {};
		this.value = "";
		this.hidden = false;
		this.textContent = "";
	}
	appendChild(node) {
		this.children.push(node);
		node.parentNode = this;
		if (this.tagName === "SELECT" && this.children.length === 1) {
			this.value = node.value;
		}
		return node;
	}
	setAttribute(name, value) {
		this.attributes[name] = String(value);
	}
	addEventListener(name, callback) {
		this.events[name] = callback;
	}
	focus() {}
}

const read = (file) => fs.readFileSync(path.join(projectRoot, file), "utf8");
const sourceApp = read("js20/custom_controls/AppBeton.js");
const methodStart = sourceApp.indexOf("AppBeton.prototype.sendCommandToElkon = async function(");
const methodEnd = sourceApp.indexOf("\nAppBeton.prototype.initOSMLayer", methodStart);
assert(methodStart >= 0 && methodEnd > methodStart);

const fixture = () => {
	let nextTimer = 0;
	let nextQuery = 0;
	const timeouts = new Map();
	const intervals = new Map();
	const context = {
		Map, Set, Number, String, Object, Array, JSON, Promise, Error, URL, Date,
		AbortController,
		console: {log() {}},
		document: {createElement: (tag) => new Element(tag)},
		WebSocket: {OPEN: 1, CONNECTING: 0},
		CommonHelper: {unserialize: JSON.parse, uniqid: () => "fallback_" + (++nextQuery)},
		ServConnector: function() {},
		ResponseJSON: function(data) {
			this.modelExists = (id) => !!data.models[id];
			this.getModelData = (id) => data.models[id];
		},
		ModelServRespJSON: function(data) {
			Object.assign(this, data.rows[0]);
		},
		AppBeton: function() {},
		extend(child, parent) {
			child.prototype = Object.create(parent.prototype);
			child.prototype.constructor = child;
			child.superclass = parent.prototype;
		},
		View: function(id) {
			this.id = id;
			this.node = new Element("div");
			this.elements = {};
		},
		ProductionSiteEdit: function(id, options) {
			this.id = id;
			this.options = options;
			this.ref = null;
			this.getValue = () => this.ref;
			this.onRefresh = () => {};
		}
	};
	context.ServConnector.prototype = {ERR_AUTH_NOT_LOGGED: 1001, ERR_AUTH: 1002, ERR_AUTH_EXP: 1003, ERR_SQL_SERVER: 1004};
	context.View.prototype.addElement = function(element) {
		this.elements[element.id.split(":").pop()] = element;
	};
	context.View.prototype.getElement = function(id) {
		return this.elements[id];
	};
	context.View.prototype.getId = function() {
		return this.id;
	};
	context.View.prototype.getNode = function() {
		return this.node;
	};
	context.View.prototype.toDOM = function(parent) {
		parent.appendChild(this.node);
	};
	context.View.prototype.delDOM = function() {
		this.removed = true;
	};
	context.window = {
		location: {href: "https://beton.test/"},
		crypto: {randomUUID: () => "fixture_" + (++nextQuery)},
		setTimeout(callback, delay) {
			const id = ++nextTimer;
			timeouts.set(id, {callback, delay});
			return id;
		},
		clearTimeout(id) {
			timeouts.delete(id);
		},
		setInterval(callback, delay) {
			const id = ++nextTimer;
			intervals.set(id, {callback, delay});
			return id;
		},
		clearInterval(id) {
			intervals.delete(id);
		}
	};
	vm.createContext(context);
	vm.runInContext(read("js20/core/AppSrv.js"), context);
	vm.runInContext(read("js20/views/ProductionSiteManager_View.js"), context);
	vm.runInContext(sourceApp.slice(methodStart, methodEnd), context);
	const srv = Object.create(context.AppSrv.prototype);
	srv.m_connection = {readyState: 1, send() {}};
	srv.m_subscriptions = {};
	const calls = [];
	let sender = async () => ({status: 200, body: null, text: "null"});
	const app = {
		EVENT_MODEL_ID: "Event_Model",
		SERV_RESPONSE_MODEL_ID: "ModelServResponse",
		getAppSrv: () => srv,
		sendCommandToElkon(command, queryId, body, options) {
			assert(srv.m_querySubscriptions[queryId], "listener must exist before HTTP is sent");
			const call = {command, queryId, body, options};
			calls.push(call);
			return sender(call);
		}
	};
	context.window.getApp = () => app;
	const view = new context.ProductionSiteManager_View("manager", {responseTimeout: 100});
	view.toDOM(new Element("main"));
	const selectPlant = (id, name = "Plant " + id) => {
		view.getElement("production_site").ref = id == null ? null : {
			getKeys: () => ({id}),
			getDescr: () => name
		};
		view.updateConnectionState();
	};
	selectPlant(4);
	const reply = (queryId, payload, eventId = "ElkonProduction.Get", error = null) => {
		srv.onMessage({data: JSON.stringify({event_id: eventId, query_id: queryId, payload, error})});
	};
	return {
		context, srv, app, view, calls, timeouts, intervals, selectPlant, reply,
		setSender(callback) { sender = callback; },
		fireTimeouts() {
			Array.from(timeouts.values()).forEach(({callback}) => callback());
		}
	};
};

const tests = [];
const test = (caption, callback) => tests.push({caption, callback});

test("form offers the exact get/set choices and disables commands without plant or socket", () => {
	const f = fixture();
	assert.deepEqual(Array.from(f.view.getParameter.children, (o) => o.value), [
		"production_site_id", "production_site_descr", "last_production", "unclosed_productions",
		"websocket_url", "mssql_conn_str", "query_interval_s", "empty_debounce_s", "query_production_count", "log_level"
	]);
	assert.deepEqual(Array.from(f.view.setParameter.children, (o) => o.value), [
		"websocket_url", "mssql_conn_str", "query_interval_s", "empty_debounce_s", "shutdown_s",
		"query_production_count", "log_level", "log_file", "last_production"
	]);
	assert(f.view.commandButtons.every((button) => !button.disabled));
	f.selectPlant(null);
	assert(f.view.commandButtons.every((button) => button.disabled));
	f.selectPlant(4);
	f.srv.m_connection.readyState = 3;
	f.view.updateConnectionState();
	assert(f.view.commandButtons.every((button) => button.disabled));
	assert.equal(f.view.resultNode.readOnly, true);
});

test("flat responses correlate query IDs; subscriptions can be removed; legacy events still dispatch", () => {
	const f = fixture();
	const received = [];
	f.srv.subscribeToQuery("first", {onResponse: (response) => received.push(response.payload)});
	f.reply("other", "wrong");
	f.reply("first", 0);
	assert.deepEqual(received, [0]);
	assert.throws(() => f.srv.subscribeToQuery("first", {onResponse() {}}), /already exists/);
	f.srv.unsubscribeFromQuery("first");
	f.reply("first", "late");
	assert.deepEqual(received, [0]);
	const events = [];
	f.srv.m_subscriptions["Legacy.update"] = {groups: {fixture: {onEvent: (event) => events.push(event)}}};
	f.srv.onMessage({data: JSON.stringify({models: {Event_Model: {rows: [{id: "Legacy.update", params: {id: 8}}]}}})});
	assert.equal(events.length, 1);
	assert.equal(events[0].params.id, 8);
	f.reply("", {id: 9}, "Legacy.update");
	assert.equal(events.length, 2);
	assert.equal(events[1].params.id, 9);
});

test("every get option is sent with site first and a listener before an early socket response", async () => {
	const f = fixture();
	const payloads = [4, "Plant 4", 0, {}, "wss://host/ws", "Server=sql;", 2, 0, 20, "info"];
	f.setSender(async (call) => {
		assert.deepEqual(Object.keys(call.body), ["production_site_id", "param"]);
		const index = Array.from(f.view.GET_PARAMETERS).indexOf(call.body.param);
		f.reply(call.queryId, payloads[index]);
		return {status: 200, body: null};
	});
	for (const parameter of f.view.GET_PARAMETERS) {
		f.view.getParameter.value = parameter;
		await f.view.runGet();
	}
	assert.equal(f.calls.length, 10);
	assert.equal(new Set(f.calls.map((call) => call.queryId)).size, 10);
	assert.equal(f.view.requests.size, 0);
	assert.equal(Object.keys(f.srv.m_querySubscriptions).length, 0);
	assert.equal(f.timeouts.size, 0);
	assert.match(f.view.resultNode.value, /Ответ WebSocket/);
	assert.match(f.view.resultNode.value, /Ответ HTTP 200/);
});

test("late results retain their original plant and are not assigned to another request", async () => {
	const f = fixture();
	f.view.getParameter.value = "last_production";
	await f.view.runGet();
	f.selectPlant(7, "Other plant");
	await f.view.runGet();
	assert.equal(f.view.requests.size, 2);
	f.reply(f.calls[1].queryId, 700);
	f.reply(f.calls[0].queryId, 400);
	assert.equal(f.view.requests.size, 0);
	assert.match(f.view.resultNode.value, /Plant 4 \(#4\).*get last_production[^\n]*\n400/);
	assert.match(f.view.resultNode.value, /Other plant \(#7\).*get last_production[^\n]*\n700/);
});

test("set sends exact typed values and reads configuration back including nested and renamed fields", async () => {
	const values = {
		websocket_url: "wss://plant.example/ws",
		mssql_conn_str: "Server=SQL;Password=example;",
		query_interval_s: 3,
		empty_debounce_s: 0,
		shutdown_s: 0,
		query_production_count: 10,
		log_level: "debug",
		log_file: "",
		last_production: 0
	};
	for (const [parameter, expected] of Object.entries(values)) {
		const f = fixture();
		f.view.setParameter.value = parameter;
		f.view.updateValueInput();
		f.view.valueInput.value = String(expected);
		f.view.numberValue.value = String(expected);
		f.view.logLevel.value = expected;
		f.setSender(async (call) => {
			if (call.command === "set-config-params") {
				assert.deepEqual(Object.keys(call.body), ["production_site_id", "params"]);
				assert.equal(call.body.params[parameter], expected);
			}
			else {
				assert.equal(call.command, "fetch-config");
				const payload = {production: {}};
				if (["last_production", "query_production_count"].includes(parameter)) {
					payload.production[parameter] = expected;
				}
				else {
					payload[parameter === "log_file" ? "log_file_name" : parameter] = expected;
				}
				f.reply(call.queryId, payload, "ElkonProduction.FetchConfig");
			}
			return {status: 200, body: null};
		});
		await f.view.runSet();
		assert.equal(f.calls.length, 2, parameter);
		assert.equal(f.view.errorNode.hidden, true, parameter);
		assert.match(f.view.resultNode.value, /Изменение подтверждено/);
		assert.match(f.view.pendingNode.textContent, /Нет ожидающих/);
		f.view.delDOM();
		assert.equal(f.timeouts.size, 0);
	}
});

test("invalid numbers, invalid WebSocket URL, and missing selection never send HTTP", async () => {
	const f = fixture();
	for (const value of ["", "-1", "1.1", "1e3", "9007199254740992"]) {
		f.view.productionId.value = value;
		await f.view.runFetchProduction();
	}
	f.view.setParameter.value = "query_interval_s";
	f.view.numberValue.value = "0";
	await f.view.runSet();
	f.view.setParameter.value = "websocket_url";
	f.view.valueInput.value = "https://invalid.example/";
	await f.view.runSet();
	f.selectPlant(null);
	await f.view.runGet();
	assert.equal(f.calls.length, 0);
	assert.equal(f.view.errorNode.hidden, false);
});

test("HTTP and asynchronous client errors are visible and release query listeners", async () => {
	const f = fixture();
	f.setSender(async () => { throw new Error("HTTP 403 forbidden"); });
	await f.view.runGet();
	assert.match(f.view.errorNode.textContent, /403/);
	assert.equal(f.view.requests.size, 0);
	f.setSender(async () => ({status: 200, body: null}));
	await f.view.runGet();
	const call = f.calls[1];
	f.reply(call.queryId, "plant SQL error", "ElkonProduction.Error");
	assert.match(f.view.errorNode.textContent, /plant SQL error/);
	assert.match(f.view.resultNode.value, /Ошибка WebSocket/);
	assert.equal(f.view.requests.size, 0);
	await f.view.runGet();
	f.reply(f.calls[2].queryId, null, "ElkonProduction.Get", {code: "500", message: "backend failed"});
	assert.match(f.view.errorNode.textContent, /backend failed/);
	assert.equal(f.view.requests.size, 0);
});

test("readback mismatch does not report a successful setting change", async () => {
	const f = fixture();
	f.view.setParameter.value = "last_production";
	f.view.numberValue.value = "80";
	f.setSender(async (call) => {
		if (call.command === "fetch-config") {
			f.reply(call.queryId, {production: {last_production: 79}}, "ElkonProduction.FetchConfig");
		}
		return {status: 200, body: null};
	});
	await f.view.runSet();
	assert.equal(f.view.errorNode.hidden, false);
	assert.match(f.view.resultNode.value, /Изменение не подтверждено/);
	assert.doesNotMatch(f.view.resultNode.value, /Изменение подтверждено/);
});

test("fetch production records dispatch without inventing upload completion or waiting for success", async () => {
	const f = fixture();
	f.view.productionId.value = "23274";
	await f.view.runFetchProduction();
	assert.equal(f.calls[0].command, "fetch-production");
	assert.deepEqual(Object.keys(f.calls[0].body), ["production_site_id", "production_id"]);
	assert.equal(f.calls[0].body.production_id, 23274);
	assert.match(f.view.resultNode.value, /Команда отправлена/);
	assert.doesNotMatch(f.view.resultNode.value, /Данные производства загружены/);
	assert.match(f.view.pendingNode.textContent, /Нет ожидающих/);
	// The listener remains briefly so a late validation error is still displayed.
	f.reply(f.calls[0].queryId, "production not found", "ElkonProduction.Error");
	assert.match(f.view.resultNode.value, /production not found/);
	assert.equal(f.view.requests.size, 0);
});

test("timeout, connection loss and disposal abort local waits without replaying commands", async () => {
	const f = fixture();
	await f.view.runGet();
	const firstCall = f.calls[0];
	f.fireTimeouts();
	assert(firstCall.options.signal.aborted);
	assert.match(f.view.resultNode.value, /Истекло время ожидания/);
	assert.equal(f.view.requests.size, 0);
	await f.view.runGet();
	f.srv.m_connection.readyState = 3;
	f.srv.notifyOnConnEvent("onClose", {code: 1006});
	assert.equal(f.view.requests.size, 0);
	assert(f.calls[1].options.signal.aborted);
	f.srv.m_connection.readyState = 1;
	f.srv.notifyOnConnEvent("onOpen");
	assert.equal(f.calls.length, 2);
	await f.view.runGet();
	const beforeDispose = f.view.resultNode.value;
	f.view.delDOM();
	assert.equal(f.view.requests.size, 0);
	assert.equal(f.timeouts.size, 0);
	assert.equal(f.intervals.size, 0);
	assert.equal(Object.keys(f.srv.m_querySubscriptions).length, 0);
	f.reply(f.calls[2].queryId, "too late");
	assert.equal(f.view.resultNode.value, beforeDispose);
});

test("disposing or timing out a still-running HTTP request aborts it and suppresses late UI writes", async () => {
	for (const action of ["dispose", "timeout"]) {
		const f = fixture();
		f.setSender((call) => new Promise((resolve, reject) => {
			call.options.signal.addEventListener("abort", () => {
				const error = new Error("aborted");
				error.name = "AbortError";
				reject(error);
			});
		}));
		const pending = f.view.runGet();
		assert.equal(f.view.requests.size, 1);
		if (action === "dispose") {
			f.view.delDOM();
		}
		else {
			f.fireTimeouts();
		}
		await pending;
		assert(f.calls[0].options.signal.aborted);
		assert.equal(f.view.requests.size, 0);
		assert.equal(f.timeouts.size, 0);
		assert.doesNotMatch(f.view.resultNode.value, /Ошибка HTTP.*aborted/);
	}
});

test("an early socket success keeps unresolved HTTP abortable until disposal", async () => {
	const f = fixture();
	f.setSender((call) => {
		f.reply(call.queryId, "info", "ElkonProduction.Get");
		return new Promise((resolve, reject) => {
			call.options.signal.addEventListener("abort", () => {
				const error = new Error("aborted after socket reply");
				error.name = "AbortError";
				reject(error);
			});
		});
	});
	const pending = f.view.runGet();
	assert.equal(f.view.requests.size, 0, "socket result has completed its query");
	assert.equal(f.view.httpRequests.size, 1, "HTTP still owns a tracked abort handle");
	assert.equal(f.timeouts.size, 1, "HTTP retains its own timeout after query completion");
	assert.match(f.view.resultNode.value, /Ответ WebSocket: ElkonProduction.Get/);
	const beforeDispose = f.view.resultNode.value;
	f.view.delDOM();
	await pending;
	assert(f.calls[0].options.signal.aborted);
	assert.equal(f.view.httpRequests.size, 0);
	assert.equal(f.timeouts.size, 0);
	assert.equal(f.view.resultNode.value, beforeDispose);
});

test("set error during readback never resurrects its completed request", async () => {
	const f = fixture();
	f.view.setParameter.value = "log_level";
	f.view.logLevel.value = "debug";
	f.setSender(async (call) => {
		if (call.command === "fetch-config") {
			f.reply(f.calls[0].queryId, "set failed", "ElkonProduction.Error");
			f.reply(call.queryId, {log_level: "info"}, "ElkonProduction.FetchConfig");
		}
		return {status: 200, body: null};
	});
	await f.view.runSet();
	assert.equal(f.view.requests.size, 0);
	assert.equal(f.timeouts.size, 0);
	assert.equal(Object.keys(f.srv.m_querySubscriptions).length, 0);
	assert.match(f.view.resultNode.value, /set failed/);
});

test("HTTP helper keeps absolute URLs valid, uses browser cookies, returns body and surfaces failures", async () => {
	const f = fixture();
	const calls = [];
	f.context.fetch = async (url, options) => {
		calls.push({url, options});
		return {ok: true, status: 200, text: async () => "null"};
	};
	const app = Object.create(f.context.AppBeton.prototype);
	app.m_servVars = {basePath: "https://beton.test/"};
	const result = await app.sendCommandToElkon("get", "query-1", {production_site_id: 4, param: "log_level"});
	assert.equal(result.body, null);
	assert.equal(calls[0].url, "https://beton.test/eurobeton/api-post/elkon-production-cmd/get");
	assert.equal(calls[0].options.credentials, "include");
	assert.equal(calls[0].options.headers["Query-Id"], "query-1");
	assert.equal(calls[0].options.headers.Cookie, undefined);
	assert.equal(JSON.parse(calls[0].options.body).production_site_id, 4);
	app.m_servVars.elkonCommandApiURL = "https://beton.test:59904/api-post/elkon-production-cmd";
	await app.sendCommandToElkon("fetch-production", "query-2", "{}");
	assert.equal(calls[1].url, "https://beton.test:59904/api-post/elkon-production-cmd/fetch-production");
	f.context.fetch = async () => ({ok: false, status: 403, text: async () => '{"error":{"message":"forbidden"}}'});
	await assert.rejects(app.sendCommandToElkon("get", "query-3", {}), /403.*forbidden/);
	f.context.fetch = async () => ({ok: true, status: 200, text: async () => '<html>login</html>'});
	await assert.rejects(app.sendCommandToElkon("get", "query-4", {}), /JSON/);
	f.context.fetch = async () => ({ok: true, status: 200, text: async () => '{"error":{"message":"denied"}}'});
	await assert.rejects(app.sendCommandToElkon("get", "query-5", {}), /denied/);
	await assert.rejects(app.sendCommandToElkon("stop", "query-6", {}), /Неизвестная/);
});

(async () => {
	for (const {caption, callback} of tests) {
		await callback();
		console.log("PASS " + caption);
	}
	console.log(tests.length + " plant manager tests passed.");
})().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
