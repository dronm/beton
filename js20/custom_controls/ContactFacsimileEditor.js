"use strict";
class ContactFacsimileEditor {
	constructor(options) {
		this.root = document.createElement("div");
		this.status = document.createElement("div");
		this.canvas = document.createElement("canvas");
		this.sourceCanvas = document.createElement("canvas");
		this.preview = document.createElement("img");
		this.previewMessage = document.createElement("p");
		this.image = new Image();
		this.zoom = document.createElement("input");
		this.zoomValue = document.createElement("span");
		this.background = document.createElement("input");
		this.backgroundColor = document.createElement("input");
		this.fuzz = document.createElement("input");
		this.inputs = {};
		this.controls = [];
		this.form = null;
		this.source = null;
		this.busy = false;
		this.saving = false;
		this.closed = false;
		this.rotation = 0;
		this.pickingBackground = false;
		this.sampleButton = null;
		this.pointerStart = null;
		this.pointerId = null;
		this.crop = { x: 0, y: 0, width: 1, height: 1 };
		this.cropLabel = document.createElement("p");
		this.open = () => {
			if (this.form || this.closed) {
				return;
			}
			this.form = new WindowFormModalBS("facsimile-editor-" + Date.now(), {
				contentHead: "Редактор факсимиле",
				dialogWidth: "min(1000px, 96vw)",
				cmdCancel: true,
				controlCancelCaption: "Отмена",
				onClickCancel: this.close,
				closeOnMouseClick: false,
			});
			this.form.open();
			this.build();
			this.form.getContentParent().append(this.root);
			$(this.form.getNode()).on("hide.bs.modal.facsimile", (event) => {
				if (this.saving) {
					event.preventDefault();
				}
			});
			$(this.form.getNode()).on("hidden.bs.modal.facsimile", () => {
				var _a;
				const node = (_a = this.form) === null || _a === void 0 ? void 0 : _a.getNode();
				this.dispose();
				if (node) {
					$(node).remove();
				}
				this.restoreParentModal();
			});
			this.setBusy(true, "Загрузка изображения…");
			this.request("get_facsimile", {}, (row) => {
				this.source = row;
				this.image.onload = () => {
					if (this.closed) {
						return;
					}
					this.renderSource();
					this.crop = { x: 0, y: 0, width: this.canvas.width, height: this.canvas.height };
					this.zoom.value = String(Math.min(100, Math.max(10, Math.floor(800 / this.canvas.width * 100))));
					this.updateZoom();
					this.syncCrop();
					this.setBusy(false);
				};
				this.image.onerror = () => this.showError("Не удалось открыть изображение.");
				this.image.src = "data:" + row.mime_type + ";base64," + row.data_base64;
			});
		};
		this.close = () => {
			if (this.saving || this.closed) {
				return;
			}
			const form = this.form;
			const node = form === null || form === void 0 ? void 0 : form.getNode();
			this.dispose();
			form === null || form === void 0 ? void 0 : form.close();
			if (node) {
				$(node).remove();
			}
			this.restoreParentModal();
		};
		this.dispose = () => {
			var _a, _b;
			if (this.closed) {
				return;
			}
			this.closed = true;
			if (this.form) {
				$(this.form.getNode()).off(".facsimile");
			}
			this.image.onload = null;
			this.image.onerror = null;
			this.root.remove();
			this.form = null;
			(_b = (_a = this.options).onClosed) === null || _b === void 0 ? void 0 : _b.call(_a);
		};
		this.restoreParentModal = () => {
			// Bootstrap removes this class when a nested modal closes.
			if ($(".modal.in").length) {
				$(document.body).addClass("modal-open");
			}
		};
		this.build = () => {
			this.root.className = "facsimile-editor";
			this.status.className = "facsimile-editor-status";
			this.status.setAttribute("role", "status");
			this.status.setAttribute("aria-live", "polite");
			const hint = document.createElement("p");
			hint.textContent = "Выделите подпись мышью или задайте границы в пикселях. Масштаб просмотра не меняет размер готового файла.";
			const saveHint = document.createElement("p");
			saveHint.className = "help-block";
			saveHint.textContent = "«Применить» сохраняет файл сразу. «Отмена» оставляет загруженное изображение без обработки.";
			this.root.append(hint, saveHint, this.status);
			const toolbar = document.createElement("div");
			toolbar.className = "facsimile-editor-toolbar";
			this.zoom.type = "range";
			this.zoom.min = "10";
			this.zoom.max = "400";
			this.zoom.step = "5";
			this.zoom.value = "100";
			this.zoom.addEventListener("input", this.updateZoom);
			this.controls.push(this.zoom);
			toolbar.append(this.label("Масштаб просмотра", this.zoom), this.zoomValue, this.button("Всё изображение", this.resetCrop), this.button("Повернуть на 90° ↻", this.rotateClockwise));
			const scroll = document.createElement("div");
			scroll.className = "facsimile-editor-source facsimile-editor-checkerboard";
			this.canvas.setAttribute("aria-label", "Исходное изображение. Выделите прямоугольник для обрезки.");
			this.canvas.addEventListener("pointerdown", this.startCrop);
			this.canvas.addEventListener("pointermove", this.moveCrop);
			this.canvas.addEventListener("pointerup", this.endCrop);
			this.canvas.addEventListener("pointercancel", this.endCrop);
			scroll.append(this.canvas);
			const fields = document.createElement("div");
			fields.className = "facsimile-editor-fields";
			for (const [key, caption] of [["x", "Слева"], ["y", "Сверху"], ["width", "Ширина выделения"], ["height", "Высота выделения"]]) {
				const input = this.numberInput(key, 0, 16000000);
				input.addEventListener("change", this.readCrop);
				fields.append(this.label(caption + ", px", input));
			}
			const outputFields = document.createElement("div");
			outputFields.className = "facsimile-editor-fields";
			for (const [key, caption] of [["output_width", "Ширина файла"], ["output_height", "Высота файла"]]) {
				const input = this.numberInput(key, 1, 4096);
				input.addEventListener("change", () => this.resizeOutput(key));
				outputFields.append(this.label(caption + ", px", input));
			}
			const ratioHint = document.createElement("span");
			ratioHint.textContent = "Пропорции сохраняются. Для увеличения задайте больший размер.";
			outputFields.append(ratioHint);
			const backgroundFields = document.createElement("div");
			backgroundFields.className = "facsimile-editor-toolbar";
			this.background.type = "checkbox";
			this.background.addEventListener("change", () => {
				if (!this.background.checked) {
					this.setPickingBackground(false);
				}
				this.invalidatePreview();
			});
			this.controls.push(this.background);
			this.backgroundColor.type = "color";
			this.backgroundColor.value = "#ffffff";
			this.backgroundColor.className = "form-control facsimile-editor-color";
			const updateBackgroundColor = () => {
				this.setPickingBackground(false);
				this.background.checked = true;
				this.invalidatePreview();
			};
			this.backgroundColor.addEventListener("input", updateBackgroundColor);
			this.backgroundColor.addEventListener("change", updateBackgroundColor);
			this.controls.push(this.backgroundColor);
			this.sampleButton = this.button("Выбрать цвет фона", () => this.setPickingBackground(!this.pickingBackground));
			this.fuzz.type = "number";
			this.fuzz.min = "0";
			this.fuzz.max = "30";
			this.fuzz.step = "1";
			this.fuzz.value = "10";
			this.fuzz.className = "form-control facsimile-editor-number";
			this.fuzz.addEventListener("change", this.invalidatePreview);
			this.controls.push(this.fuzz);
			backgroundFields.append(this.label("Убрать фон", this.background), this.label("Цвет фона", this.backgroundColor), this.sampleButton, this.label("Допуск цвета, %", this.fuzz));
			const backgroundHint = document.createElement("p");
			backgroundHint.className = "help-block";
			backgroundHint.textContent = "По умолчанию убирается белый фон. Для серого или желтоватого фона выберите его цвет на изображении. Если фон остаётся, попробуйте допуск 15, 20 или 30%. Высокий допуск может удалить слабые линии подписи.";
			this.preview.alt = "Предпросмотр результата обработки";
			this.preview.hidden = true;
			this.previewMessage.textContent = "Нажмите «Предпросмотр», чтобы проверить результат. Шахматный фон обозначает прозрачность.";
			const previewBox = document.createElement("div");
			previewBox.className = "facsimile-editor-preview facsimile-editor-checkerboard";
			previewBox.append(this.previewMessage, this.preview);
			const actions = document.createElement("div");
			actions.className = "facsimile-editor-actions";
			actions.append(this.button("Предпросмотр", () => this.process(false)), this.button("Применить", () => this.process(true), "btn-primary"));
			this.root.append(toolbar, scroll, this.cropLabel, fields, outputFields, backgroundFields, backgroundHint, previewBox, actions);
		};
		this.label = (caption, input) => {
			const label = document.createElement("label");
			const text = document.createElement("span");
			text.textContent = caption;
			label.append(text, input);
			return label;
		};
		this.numberInput = (key, min, max) => {
			const input = document.createElement("input");
			input.type = "number";
			input.min = String(min);
			input.max = String(max);
			input.step = "1";
			input.className = "form-control facsimile-editor-number";
			this.inputs[key] = input;
			this.controls.push(input);
			return input;
		};
		this.button = (caption, callback, className = "btn-default") => {
			const button = document.createElement("button");
			button.type = "button";
			button.className = "btn " + className;
			button.textContent = caption;
			button.addEventListener("click", callback);
			this.controls.push(button);
			return button;
		};
		this.updateZoom = () => {
			const scale = Number(this.zoom.value) / 100;
			this.canvas.style.width = this.canvas.width * scale + "px";
			this.canvas.style.height = this.canvas.height * scale + "px";
			this.zoomValue.textContent = this.zoom.value + "%";
			if (this.image.naturalWidth > 0) {
				this.draw();
			}
		};
		this.point = (event) => {
			const rect = this.canvas.getBoundingClientRect();
			return {
				x: Math.max(0, Math.min(this.canvas.width, Math.round((event.clientX - rect.left) * this.canvas.width / rect.width))),
				y: Math.max(0, Math.min(this.canvas.height, Math.round((event.clientY - rect.top) * this.canvas.height / rect.height))),
			};
		};
		this.startCrop = (event) => {
			if (this.busy || !this.source || event.button !== 0 || this.pointerId !== null) {
				return;
			}
			event.preventDefault();
			if (this.pickingBackground) {
				this.sampleBackground(event);
				return;
			}
			this.pointerStart = this.point(event);
			this.pointerId = event.pointerId;
			this.canvas.setPointerCapture(event.pointerId);
		};
		this.moveCrop = (event) => {
			if (!this.pointerStart || event.pointerId !== this.pointerId) {
				return;
			}
			const point = this.point(event);
			const x = Math.min(this.pointerStart.x, point.x, this.canvas.width - 1);
			const y = Math.min(this.pointerStart.y, point.y, this.canvas.height - 1);
			this.crop = {
				x,
				y,
				width: Math.max(1, Math.abs(point.x - this.pointerStart.x)),
				height: Math.max(1, Math.abs(point.y - this.pointerStart.y)),
			};
			this.syncCrop();
		};
		this.endCrop = (event) => {
			if (event.pointerId !== this.pointerId) {
				return;
			}
			this.moveCrop(event);
			this.pointerStart = null;
			this.pointerId = null;
			if (this.canvas.hasPointerCapture(event.pointerId)) {
				this.canvas.releasePointerCapture(event.pointerId);
			}
		};
		this.resetCrop = () => {
			this.crop = { x: 0, y: 0, width: this.canvas.width, height: this.canvas.height };
			this.syncCrop();
		};
		this.renderSource = () => {
			const quarterTurn = this.rotation === 90 || this.rotation === 270;
			this.sourceCanvas.width = quarterTurn ? this.image.naturalHeight : this.image.naturalWidth;
			this.sourceCanvas.height = quarterTurn ? this.image.naturalWidth : this.image.naturalHeight;
			this.canvas.width = this.sourceCanvas.width;
			this.canvas.height = this.sourceCanvas.height;
			const context = this.sourceCanvas.getContext("2d");
			if (!context) {
				return;
			}
			context.save();
			if (this.rotation === 90) {
				context.translate(this.sourceCanvas.width, 0);
			}
			else if (this.rotation === 180) {
				context.translate(this.sourceCanvas.width, this.sourceCanvas.height);
			}
			else if (this.rotation === 270) {
				context.translate(0, this.sourceCanvas.height);
			}
			context.rotate(this.rotation * Math.PI / 180);
			context.drawImage(this.image, 0, 0);
			context.restore();
		};
		this.rotateClockwise = () => {
			if (this.busy || !this.source || this.pointerId !== null) {
				return;
			}
			const oldHeight = this.canvas.height;
			const oldCrop = this.crop;
			const outputWidth = this.inputs.output_width.value;
			const outputHeight = this.inputs.output_height.value;
			this.rotation = (this.rotation + 90) % 360;
			this.setPickingBackground(false);
			this.renderSource();
			this.crop = {
				x: oldHeight - oldCrop.y - oldCrop.height,
				y: oldCrop.x,
				width: oldCrop.height,
				height: oldCrop.width,
			};
			this.syncCrop();
			this.inputs.output_width.value = outputHeight;
			this.inputs.output_height.value = outputWidth;
			this.updateZoom();
		};
		this.setPickingBackground = (picking) => {
			this.pickingBackground = picking;
			this.canvas.classList.toggle("facsimile-editor-picking", picking);
			if (this.sampleButton) {
				this.sampleButton.textContent = picking ? "Отменить выбор цвета" : "Выбрать цвет фона";
				this.sampleButton.setAttribute("aria-pressed", String(picking));
			}
			this.status.className = "facsimile-editor-status";
			this.status.textContent = picking ? "Нажмите на фон исходного изображения, чтобы выбрать его цвет." : "";
		};
		this.sampleBackground = (event) => {
			const context = this.sourceCanvas.getContext("2d");
			if (!context) {
				return;
			}
			const point = this.point(event);
			const x = Math.min(this.sourceCanvas.width - 1, point.x);
			const y = Math.min(this.sourceCanvas.height - 1, point.y);
			const pixel = context.getImageData(x, y, 1, 1).data;
			if (pixel[3] === 0) {
				this.status.textContent = "В выбранной точке фон уже прозрачный. Выберите непрозрачный участок фона.";
				return;
			}
			this.backgroundColor.value = "#" + Array.from(pixel.slice(0, 3)).map((value) => value.toString(16).padStart(2, "0")).join("");
			this.background.checked = true;
			this.setPickingBackground(false);
			this.invalidatePreview();
		};
		this.readCrop = () => {
			const value = (key) => Math.round(Number(this.inputs[key].value) || 0);
			const x = Math.max(0, Math.min(this.canvas.width - 1, value("x")));
			const y = Math.max(0, Math.min(this.canvas.height - 1, value("y")));
			this.crop = {
				x,
				y,
				width: Math.max(1, Math.min(this.canvas.width - x, value("width"))),
				height: Math.max(1, Math.min(this.canvas.height - y, value("height"))),
			};
			this.syncCrop();
		};
		this.syncCrop = () => {
			for (const [key, value] of Object.entries(this.crop)) {
				this.inputs[key].value = String(value);
			}
			this.inputs.output_width.value = String(this.crop.width);
			this.inputs.output_height.value = String(this.crop.height);
			if (this.crop.width > 4096 || this.crop.height > 4096 || this.crop.width * this.crop.height > 8000000) {
				const scale = Math.min(4096 / this.crop.width, 4096 / this.crop.height, Math.sqrt(8000000 / (this.crop.width * this.crop.height)));
				const widthIsPrimary = this.crop.width >= this.crop.height;
				const primarySource = widthIsPrimary ? this.crop.width : this.crop.height;
				const secondarySource = widthIsPrimary ? this.crop.height : this.crop.width;
				let primary = Math.max(1, Math.floor(primarySource * scale));
				let secondary = Math.max(1, Math.round(primary * secondarySource / primarySource));
				while (primary > 1 && (secondary > 4096 || primary * secondary > 8000000)) {
					primary--;
					secondary = Math.max(1, Math.round(primary * secondarySource / primarySource));
				}
				this.inputs.output_width.value = String(widthIsPrimary ? primary : secondary);
				this.inputs.output_height.value = String(widthIsPrimary ? secondary : primary);
			}
			this.cropLabel.textContent = "Выделено: " + this.crop.width + " × " + this.crop.height + " px; исходник: " + this.canvas.width + " × " + this.canvas.height + " px.";
			this.draw();
			this.invalidatePreview();
		};
		this.draw = () => {
			const context = this.canvas.getContext("2d");
			if (!context) {
				return;
			}
			context.clearRect(0, 0, this.canvas.width, this.canvas.height);
			context.drawImage(this.sourceCanvas, 0, 0);
			const { x, y, width, height } = this.crop;
			context.fillStyle = "rgba(0, 0, 0, 0.32)";
			context.fillRect(0, 0, this.canvas.width, y);
			context.fillRect(0, y + height, this.canvas.width, this.canvas.height - y - height);
			context.fillRect(0, y, x, height);
			context.fillRect(x + width, y, this.canvas.width - x - width, height);
			context.strokeStyle = "#1473e6";
			context.lineWidth = 2 / (Number(this.zoom.value) / 100);
			context.strokeRect(x, y, width, height);
		};
		this.resizeOutput = (key) => {
			const input = this.inputs[key];
			const value = Math.max(1, Math.min(4096, Math.round(Number(input.value) || 1)));
			if (key === "output_width") {
				input.value = String(value);
				this.inputs.output_height.value = String(Math.max(1, Math.round(value * this.crop.height / this.crop.width)));
			}
			else {
				input.value = String(value);
				this.inputs.output_width.value = String(Math.max(1, Math.round(value * this.crop.width / this.crop.height)));
			}
			this.invalidatePreview();
		};
		this.invalidatePreview = () => {
			this.preview.hidden = true;
			this.previewMessage.hidden = false;
			this.previewMessage.textContent = "Нажмите «Предпросмотр», чтобы проверить результат. Шахматный фон обозначает прозрачность.";
		};
		this.setBusy = (busy, message = "") => {
			this.busy = busy;
			if (busy) {
				this.setPickingBackground(false);
			}
			if (!busy) {
				this.saving = false;
			}
			for (const control of this.controls) {
				control.disabled = busy || !this.source;
			}
			this.root.setAttribute("aria-busy", String(busy));
			this.status.className = "facsimile-editor-status";
			this.status.textContent = message;
		};
		this.showError = (message) => {
			if (this.closed) {
				return;
			}
			this.setBusy(false);
			this.status.className = "alert alert-danger facsimile-editor-status";
			this.status.textContent = message;
		};
		this.process = (save) => {
			if (this.busy || !this.source || this.closed) {
				return;
			}
			const width = Number(this.inputs.output_width.value);
			const height = Number(this.inputs.output_height.value);
			const fuzz = Number(this.fuzz.value);
			if (![width, height, fuzz].every(Number.isInteger) || width < 1 || height < 1 || width > 4096 || height > 4096 || width * height > 8000000 || fuzz < 0 || fuzz > 30) {
				this.showError("Размер файла должен быть от 1 до 4096 px и до 8 млн пикселей. Допуск цвета: от 0 до 30%.");
				return;
			}
			this.saving = save;
			this.setBusy(true, save ? "Сохранение факсимиле…" : "Подготовка предпросмотра…");
			this.request("process_facsimile", Object.assign(Object.assign({ source_hash: this.source.source_hash }, this.crop), { output_width: width, output_height: height, remove_background: this.background.checked, background_color: this.backgroundColor.value, rotation: this.rotation, fuzz,
				save }), (row) => {
				this.setBusy(false);
				if (save) {
					this.options.onSaved(row);
					this.close();
					return;
				}
				this.preview.src = "data:" + row.mime_type + ";base64," + row.data_base64;
				this.preview.hidden = false;
				this.previewMessage.hidden = false;
				this.previewMessage.textContent = "Результат: " + row.width + " × " + row.height + " px, PNG. Шахматный фон обозначает прозрачность.";
			});
		};
		this.request = (method, values, callback) => {
			try {
				const pm = (new Contact_Controller()).getPublicMethod(method);
				pm.setFieldValue("id", this.options.contactId);
				pm.setFieldValue("content_id", this.options.contentId);
				for (const [key, value] of Object.entries(values)) {
					pm.setFieldValue(key, value);
				}
				pm.run({
					ok: (response) => {
						if (this.closed) {
							return;
						}
						try {
							const model = response.getModel("Facsimile_Model");
							if (!model || !model.getNextRow()) {
								throw new Error("Сервер не вернул изображение.");
							}
							const row = {
								data_base64: String(model.getFieldValue("data_base64") || ""),
								mime_type: String(model.getFieldValue("mime_type") || "image/png"),
								name: String(model.getFieldValue("name") || "facsimile.png"),
								width: Number(model.getFieldValue("width")),
								height: Number(model.getFieldValue("height")),
								size: Number(model.getFieldValue("size")),
								source_hash: String(model.getFieldValue("source_hash") || ""),
							};
							if (!row.data_base64 || !row.source_hash || row.width < 1 || row.height < 1) {
								throw new Error("Сервер вернул некорректное изображение.");
							}
							callback(row);
						}
						catch (error) {
							this.showError(error instanceof Error ? error.message : "Ошибка обработки изображения.");
						}
					},
					fail: (_response, _code, message) => this.showError(message || "Не удалось обработать изображение."),
				});
			}
			catch (error) {
				this.showError(error instanceof Error ? error.message : "Ошибка обработки изображения.");
			}
		};
		this.options = options;
	}
}
