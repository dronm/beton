/** Production plant commands. Hand-maintained ES JavaScript; no build step required. */
"use strict";

function ProductionSiteManager_View(id, options) {
	options = options || {};
	this.requests = new Map();
	this.httpRequests = new Map();
	this.logEntries = [];
	this.commandButtons = [];
	this.requestSequence = 0;
	this.disposed = false;
	this.responseTimeout = options.responseTimeout || 60000;
	var self = this;
	ProductionSiteManager_View.superclass.constructor.call(this, id, options);
	this.addElement(new ProductionSiteEdit(id + ":production_site", {
		labelCaption: "Завод:",
		addNotSelected: true,
		cashable: false,
		onSelect: function() {
			self.updateConnectionState();
		}
	}));
}
extend(ProductionSiteManager_View, View);

ProductionSiteManager_View.prototype.GET_PARAMETERS = [
	"production_site_id", "production_site_descr", "last_production", "unclosed_productions",
	"websocket_url", "mssql_conn_str", "query_interval_s", "empty_debounce_s",
	"query_production_count", "log_level"
];

ProductionSiteManager_View.prototype.SET_PARAMETERS = [
	"websocket_url", "mssql_conn_str", "query_interval_s", "empty_debounce_s", "shutdown_s",
	"query_production_count", "log_level", "log_file", "last_production"
];

ProductionSiteManager_View.prototype.NUMERIC_PARAMETERS = {
	query_interval_s: 1,
	empty_debounce_s: 0,
	shutdown_s: 0,
	query_production_count: 1,
	last_production: 0
};

ProductionSiteManager_View.prototype.createNode = function(tag, className, text) {
	var node = document.createElement(tag);
	if (className) {
		node.className = className;
	}
	if (text !== undefined) {
		node.textContent = text;
	}
	return node;
};

ProductionSiteManager_View.prototype.createButton = function(caption, onClick, parent, command) {
	var button = this.createNode("button", "btn btn-" + (command ? "primary" : "default"), caption);
	button.type = "button";
	button.addEventListener("click", onClick);
	parent.appendChild(button);
	if (command) {
		this.commandButtons.push(button);
	}
	return button;
};

ProductionSiteManager_View.prototype.createSelect = function(name, values) {
	var select = this.createNode("select", "form-control");
	select.id = this.getId() + ":" + name;
	values.forEach(function(value) {
		var option = document.createElement("option");
		option.value = value;
		option.textContent = value;
		select.appendChild(option);
	});
	return select;
};

ProductionSiteManager_View.prototype.createField = function(caption, input, parent) {
	var group = this.createNode("div", "form-group");
	var label = this.createNode("label", "control-label", caption);
	label.htmlFor = input.id;
	group.appendChild(label);
	group.appendChild(input);
	parent.appendChild(group);
	return group;
};

ProductionSiteManager_View.prototype.createPanel = function(title, parent) {
	var column = this.createNode("div", "production-site-manager-command");
	var panel = this.createNode("div", "panel panel-default");
	var heading = this.createNode("div", "panel-heading");
	heading.appendChild(this.createNode("h3", "panel-title", title));
	panel.appendChild(heading);
	var body = this.createNode("div", "panel-body");
	panel.appendChild(body);
	column.appendChild(panel);
	parent.appendChild(column);
	return body;
};

ProductionSiteManager_View.prototype.toDOM = function(parent) {
	this.disposed = false;
	ProductionSiteManager_View.superclass.toDOM.call(this, parent);
	if (this.panel) {
		return;
	}
	var self = this;
	this.panel = this.createNode("div", "production-site-manager");
	this.getNode().appendChild(this.panel);
	var toolbar = this.createNode("div", "form-group");
	this.connectionNode = this.createNode("span", "label label-default");
	this.connectionNode.setAttribute("role", "status");
	this.connectionNode.style.marginRight = "12px";
	toolbar.appendChild(this.connectionNode);
	this.createButton("Обновить список заводов", function() {
		self.getElement("production_site").onRefresh();
	}, toolbar, false);
	this.panel.appendChild(toolbar);
	this.errorNode = this.createNode("div", "alert alert-danger");
	this.errorNode.setAttribute("role", "alert");
	this.errorNode.hidden = true;
	this.panel.appendChild(this.errorNode);
	var styles = [
		".production-site-manager-commands { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); grid-auto-rows: 1fr; gap: 20px; margin-bottom: 20px; }",
		".production-site-manager-command { display: flex; min-width: 0; }",
		".production-site-manager-command > .panel { display: flex; flex-direction: column; flex: 1; min-width: 0; margin-bottom: 0; }",
		".production-site-manager-command .panel-body { display: flex; flex-direction: column; flex: 1; }",
		".production-site-manager-command .panel-body::before, .production-site-manager-command .panel-body::after { display: none; }",
		".production-site-manager-command [hidden] { display: none !important; }",
		".production-site-manager-command .btn-primary { align-self: flex-start; margin-top: auto; max-width: 100%; white-space: normal; }",
		"@media (max-width: 1024px) { .production-site-manager-commands { grid-template-columns: minmax(0, 1fr); } }"
	];
	this.panel.appendChild(this.createNode("style", null, styles.join("\n")));
	var row = this.createNode("div", "production-site-manager-commands");
	this.panel.appendChild(row);

	var fetchPanel = this.createPanel("Загрузить производство", row);
	this.productionId = this.createNode("input", "form-control");
	this.productionId.id = this.getId() + ":production_id";
	this.productionId.type = "number";
	this.productionId.min = "1";
	this.productionId.step = "1";
	this.createField("№ производства Elkon", this.productionId, fetchPanel);
	fetchPanel.appendChild(this.createNode("p", "help-block", "Программа завода поставит производство в очередь загрузки."));
	this.createButton("Загрузить производство", function() {
		self.runFetchProduction();
	}, fetchPanel, true);


	var getPanel = this.createPanel("Прочитать параметр", row);
	this.getParameter = this.createSelect("get_parameter", this.GET_PARAMETERS);
	this.createField("Параметр", this.getParameter, getPanel);
	getPanel.appendChild(this.createNode("p", "help-block", "Значение придёт от программы завода через WebSocket."));
	this.createButton("Прочитать параметр", function() {
		self.runGet();
	}, getPanel, true);

	var setPanel = this.createPanel("Изменить параметр", row);
	this.setParameter = this.createSelect("set_parameter", this.SET_PARAMETERS);
	this.createField("Параметр", this.setParameter, setPanel);
	this.valueInput = this.createNode("textarea", "form-control");
	this.valueInput.id = this.getId() + ":set_value";
	this.valueInput.rows = 3;
	this.valueInput.spellcheck = false;
	this.valueInputGroup = this.createField("Новое значение", this.valueInput, setPanel);
	this.numberValue = this.createNode("input", "form-control");
	this.numberValue.id = this.getId() + ":number_value";
	this.numberValue.type = "number";
	this.numberValue.step = "1";
	this.numberValueGroup = this.createField("Новое значение", this.numberValue, setPanel);
	this.logLevel = this.createSelect("log_level", ["trace", "debug", "info", "warn", "error", "fatal", "panic"]);
	this.logLevel.value = "info";
	this.logLevelGroup = this.createField("Уровень журнала", this.logLevel, setPanel);
	this.setHelp = this.createNode("p", "help-block");
	setPanel.appendChild(this.setHelp);
	this.setParameter.addEventListener("change", function() {
		self.updateValueInput();
	});
	this.createButton("Изменить параметр", function() {
		self.runSet();
	}, setPanel, true);


	var results = this.createNode("div", "panel panel-default");
	var resultsBody = this.createNode("div", "panel-body");
	resultsBody.appendChild(this.createNode("h3", "panel-title", "Результаты команд"));
	this.pendingNode = this.createNode("p", "help-block");
	this.pendingNode.setAttribute("role", "status");
	resultsBody.appendChild(this.pendingNode);
	this.resultNode = this.createNode("textarea", "form-control");
	this.resultNode.id = this.getId() + ":results";
	this.resultNode.setAttribute("aria-label", "Результаты команд HTTP и WebSocket");
	this.resultNode.rows = 18;
	this.resultNode.readOnly = true;
	this.resultNode.spellcheck = false;
	this.resultNode.style.fontFamily = "monospace";
	resultsBody.appendChild(this.resultNode);
	var resultActions = this.createNode("div", "form-group");
	resultActions.style.marginTop = "12px";
	this.createButton("Очистить результаты", function() {
		self.logEntries = [];
		self.renderLog();
	}, resultActions, false);
	resultsBody.appendChild(resultActions);
	results.appendChild(resultsBody);
	this.panel.appendChild(results);
	this.updateValueInput();
	this.updateConnectionState();
	this.updatePending();
	this.renderLog();
	this.connectionTimer = window.setInterval(function() {
		self.updateConnectionState();
	}, 1000);
};

ProductionSiteManager_View.prototype.updateValueInput = function() {
	var parameter = this.setParameter.value;
	var numeric = Object.prototype.hasOwnProperty.call(this.NUMERIC_PARAMETERS, parameter);
	this.valueInputGroup.hidden = numeric || parameter === "log_level";
	this.numberValueGroup.hidden = !numeric;
	this.logLevelGroup.hidden = parameter !== "log_level";
	this.numberValue.value = "";
	this.valueInput.value = "";
	this.numberValue.min = numeric ? String(this.NUMERIC_PARAMETERS[parameter]) : "0";
	this.setHelp.textContent = parameter === "log_file" ?
		"Имя файла журнала. Пустое значение допустимо." :
		(numeric ? "Целое число, не меньше " + this.NUMERIC_PARAMETERS[parameter] + "." : "Введите значение без JSON-кавычек.");
};

ProductionSiteManager_View.prototype.getPlant = function() {
	var ref = this.getElement("production_site").getValue();
	var id = ref && ref.getKeys && Number(ref.getKeys().id);
	if (!Number.isSafeInteger(id) || id <= 0) {
		throw new Error("Выберите завод.");
	}
	return {id: id, name: ref.getDescr()};
};

ProductionSiteManager_View.prototype.updateConnectionState = function() {
	if (!this.connectionNode || this.disposed) {
		return;
	}
	var srv = window.getApp().getAppSrv();
	var connected = !!(srv && srv.connActive());
	this.connectionNode.textContent = connected ? "WebSocket подключён" : "Нет соединения WebSocket";
	this.connectionNode.className = "label label-" + (connected ? "success" : "danger");
	var selected = false;
	try {
		selected = !!this.getPlant();
	}
	catch (error) {
		selected = false;
	}
	this.commandButtons.forEach(function(button) {
		button.disabled = !connected || !selected;
	});
};

ProductionSiteManager_View.prototype.showError = function(error) {
	if (this.disposed || !this.errorNode) {
		return;
	}
	this.errorNode.textContent = error.message || String(error);
	this.errorNode.hidden = false;
};

ProductionSiteManager_View.prototype.parseInteger = function(value, minimum) {
	if (!/^\d+$/.test(String(value)) || !Number.isSafeInteger(Number(value)) || Number(value) < minimum) {
		throw new Error("Введите целое число, не меньше " + minimum + ".");
	}
	return Number(value);
};

ProductionSiteManager_View.prototype.runGet = function() {
	var parameter = this.getParameter.value;
	if (this.GET_PARAMETERS.indexOf(parameter) < 0) {
		return Promise.resolve();
	}
	return this.runCommand("get", {param: parameter}, "get " + parameter, {reply: true});
};

ProductionSiteManager_View.prototype.runSet = function() {
	try {
		var parameter = this.setParameter.value;
		if (this.SET_PARAMETERS.indexOf(parameter) < 0) {
			throw new Error("Неизвестный параметр set.");
		}
		var value = this.valueInput.value;
		if (Object.prototype.hasOwnProperty.call(this.NUMERIC_PARAMETERS, parameter)) {
			value = this.parseInteger(this.numberValue.value, this.NUMERIC_PARAMETERS[parameter]);
		}
		else if (parameter === "log_level") {
			value = this.logLevel.value;
		}
		else if (parameter !== "log_file" && !value.trim()) {
			throw new Error("Введите новое значение параметра.");
		}
		if (parameter === "websocket_url") {
			var url = new URL(value);
			if (url.protocol !== "ws:" && url.protocol !== "wss:") {
				throw new Error("Адрес WebSocket должен начинаться с ws:// или wss://.");
			}
		}
		var params = {};
		params[parameter] = value;
		return this.runCommand("set-config-params", {params: params}, "set " + parameter, {
			verify: {parameter: parameter, value: value}
		});
	}
	catch (error) {
		this.showError(error);
		return Promise.resolve();
	}
};

ProductionSiteManager_View.prototype.runFetchProduction = function() {
	try {
		var productionId = this.parseInteger(this.productionId.value, 1);
		return this.runCommand("fetch-production", {production_id: productionId}, "fetch_production " + productionId, {});
	}
	catch (error) {
		this.showError(error);
		return Promise.resolve();
	}
};

ProductionSiteManager_View.prototype.newQueryId = function() {
	this.requestSequence++;
	return "plant_" + (window.crypto && window.crypto.randomUUID ? window.crypto.randomUUID() :
		Date.now().toString(36) + "_" + CommonHelper.uniqid() + "_" + this.requestSequence);
};

ProductionSiteManager_View.prototype.appendLog = function(request, label, value) {
	if (this.disposed) {
		return;
	}
	var text = typeof value === "string" ? value : JSON.stringify(value, null, 2);
	this.logEntries.push("[" + new Date().toLocaleString() + "] " + label +
		" | " + request.plant.name + " (#" + request.plant.id + ") | " + request.caption +
		" | " + request.id + "\n" + (text === undefined ? "" : text));
	// Bound retained output, including unusually large remote responses.
	while (this.logEntries.length > 1 && (this.logEntries.length > 200 || this.logEntries.join("\n").length > 500000)) {
		this.logEntries.shift();
	}
	if (this.logEntries[0] && this.logEntries[0].length > 500000) {
		this.logEntries[0] = this.logEntries[0].slice(0, 500000) + "\n[Вывод сокращён]";
	}
	this.renderLog();
};

ProductionSiteManager_View.prototype.renderLog = function() {
	if (this.resultNode) {
		this.resultNode.value = this.logEntries.join("\n\n");
		this.resultNode.scrollTop = this.resultNode.scrollHeight;
	}
};

ProductionSiteManager_View.prototype.updatePending = function() {
	if (this.pendingNode) {
		var count = 0;
		this.requests.forEach(function(request) {
			if (!request.settled && !request.observing) {
				count++;
			}
		});
		this.pendingNode.textContent = count ? "Ожидается ответов: " + count : "Нет ожидающих команд.";
	}
};

ProductionSiteManager_View.prototype.finishRequest = function(request) {
	request.settled = true;
	window.clearTimeout(request.timer);
	if (request.srv) {
		request.srv.unsubscribeFromQuery(request.id);
	}
	this.requests.delete(request.id);
	this.updatePending();
};

ProductionSiteManager_View.prototype.onCommandResponse = function(request, response) {
	if (this.disposed || request.settled) {
		return;
	}
	var isError = !!response.error || response.event_id === "ElkonProduction.Error";
	this.appendLog(request, isError ? "Ошибка WebSocket" : "Ответ WebSocket: " + response.event_id, response.error || response.payload);
	if (isError) {
		request.failed = true;
		this.showError(new Error((response.error && response.error.message) || String(response.payload || "Ошибка программы завода.")));
	}
	else if (request.verify) {
		var config = response.payload || {};
		var parameter = request.verify.parameter;
		var source = parameter === "last_production" || parameter === "query_production_count" ? config.production || {} : config;
		var actual = source[parameter === "log_file" ? "log_file_name" : parameter];
		if (actual === request.verify.value) {
			this.appendLog(request, "Изменение подтверждено", {parameter: parameter, value: actual});
		}
		else {
			this.showError(new Error("Программа завода вернула другое значение параметра " + parameter + "."));
			this.appendLog(request, "Изменение не подтверждено", {expected: request.verify.value, actual: actual});
		}
	}
	this.finishRequest(request);
};

ProductionSiteManager_View.prototype.runCommand = async function(command, parameters, caption, options) {
	options = options || {};
	var request;
	try {
		var plant = options.plant || this.getPlant();
		var app = window.getApp();
		var srv = app.getAppSrv();
		if (!srv || !srv.connActive()) {
			throw new Error("Нет соединения с сервером WebSocket.");
		}
		if (typeof srv.subscribeToQuery !== "function") {
			throw new Error("Обновите библиотеку AppSrv и перезагрузите страницу.");
		}
		if (this.requests.size >= 20) {
			throw new Error("Дождитесь завершения предыдущих команд.");
		}
		this.errorNode.hidden = true;
		request = {
			id: this.newQueryId(), plant: plant, caption: caption, srv: srv,
			controller: new AbortController(), verify: options.readback, settled: false, httpReceived: false
		};
		this.requests.set(request.id, request);
		var self = this;
		srv.subscribeToQuery(request.id, {
			onResponse: function(response) {
				self.onCommandResponse(request, response);
			},
			onClose: function() {
				if (!request.settled) {
					self.appendLog(request, "Соединение прервано", "Команда не будет отправлена повторно. Результат можно проверить после восстановления связи.");
					request.failed = true;
					request.controller.abort();
					self.finishRequest(request);
				}
				self.updateConnectionState();
			}
		});
		request.timer = window.setTimeout(function() {
			if (!request.settled) {
				if (options.reply || !request.httpReceived) {
					var message = request.httpReceived ? "Ответ не получен. Проверьте соединение программы завода." : "Сервер не ответил на HTTP-запрос.";
					self.appendLog(request, "Истекло время ожидания", message);
					self.showError(new Error(message));
				}
				request.controller.abort();
				self.finishRequest(request);
			}
		}, this.responseTimeout);
		// The reflection API binds values by property order: plant ID MUST be first.
		var body = {production_site_id: plant.id};
		Object.keys(parameters).forEach(function(key) {
			body[key] = parameters[key];
		});
		this.appendLog(request, "Запрос HTTP", body);
		this.updatePending();
		// A socket reply may arrive before HTTP completes; retain its abort handle.
		this.httpRequests.set(request.id, request.controller);
		var httpTimer = window.setTimeout(function() {
			request.controller.abort();
		}, this.responseTimeout);
		var response;
		try {
			response = await app.sendCommandToElkon(command, request.id, body, {signal: request.controller.signal});
		}
		finally {
			window.clearTimeout(httpTimer);
			this.httpRequests.delete(request.id);
		}
		if (this.disposed) {
			return;
		}
		request.httpReceived = true;
		this.appendLog(request, "Ответ HTTP " + response.status, response.body);
		if (request.failed || request.settled) {
			return;
		}
		if (!options.reply) {
			// Keep this listener for delayed client errors; no success reply is expected.
			request.observing = true;
			this.updatePending();
		}
		if (options.verify) {
			// The client sends no success reply for set. Read its configuration back.
			this.appendLog(request, "Команда отправлена", "Проверяем значение параметра.");
			await this.runCommand("fetch-config", {}, "Проверка " + options.verify.parameter, {
				reply: true, plant: plant, readback: options.verify
			});
		}
		else if (!options.reply) {
			this.appendLog(request, "Команда отправлена", "Запрос на загрузку отправлен программе завода. Отдельного подтверждения завершения загрузки нет.");
		}
	}
	catch (error) {
		if (!this.disposed && !(request && request.settled && error.name === "AbortError")) {
			this.showError(error);
			if (request) {
				this.appendLog(request, "Ошибка HTTP", error.message || String(error));
			}
		}
		if (request && !request.settled) {
			this.finishRequest(request);
		}
	}
};

ProductionSiteManager_View.prototype.delDOM = function() {
	this.disposed = true;
	window.clearInterval(this.connectionTimer);
	this.httpRequests.forEach(function(controller) {
		controller.abort();
	});
	this.httpRequests.clear();
	var self = this;
	Array.from(this.requests.values()).forEach(function(request) {
		request.controller.abort();
		self.finishRequest(request);
	});
	ProductionSiteManager_View.superclass.delDOM.call(this);
	this.panel = null;
	this.connectionNode = null;
	this.commandButtons = [];
};
