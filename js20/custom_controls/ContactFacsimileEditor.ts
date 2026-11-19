/** Signature crop and background editor. Compile with tsconfig.facsimile.json. */
interface FacsimileCrop {
	x: number;
	y: number;
	width: number;
	height: number;
}

type FacsimileDragMode = "new" | "move" | "n" | "s" | "w" | "e" | "nw" | "ne" | "sw" | "se";

interface FacsimileRow {
	data_base64: string;
	mime_type: string;
	name: string;
	width: number;
	height: number;
	size: number;
	source_hash: string;
}

interface FacsimileModel {
	getNextRow(): boolean;
	getFieldValue(name: string): unknown;
}

interface FacsimileResponse {
	getModel(name: string): FacsimileModel | null;
}

interface FacsimileMethod {
	setFieldValue(name: string, value: string | number | boolean): void;
	run(options: {
		ok: (response: FacsimileResponse) => void;
		fail: (response: unknown, code: unknown, message: string) => void;
	}): void;
}

declare class Contact_Controller {
	getPublicMethod(name: string): FacsimileMethod;
}

declare class WindowFormModalBS {
	constructor(id: string, options: Record<string, unknown>);
	open(): void;
	close(): void;
	getNode(): HTMLElement;
	getContentParent(): HTMLElement;
}

interface FacsimileJQuery {
	on(events: string, callback: (event: { preventDefault(): void; }) => void): FacsimileJQuery;
	off(events: string): FacsimileJQuery;
	addClass(name: string): FacsimileJQuery;
	remove(): FacsimileJQuery;
	length: number;
}

declare const $: (node: HTMLElement | string) => FacsimileJQuery;

interface ContactFacsimileOptions {
	contactId: number;
	contentId: string;
	onSaved: (row: FacsimileRow) => void;
	onClosed?: () => void;
}

class ContactFacsimileEditor {
	private readonly options: ContactFacsimileOptions;
	private readonly root = document.createElement("div");
	private readonly status = document.createElement("div");
	private readonly canvas = document.createElement("canvas");
	private readonly sourceCanvas = document.createElement("canvas");
	private readonly preview = document.createElement("img");
	private readonly previewMessage = document.createElement("p");
	private readonly image = new Image();
	private readonly zoom = document.createElement("input");
	private readonly zoomValue = document.createElement("span");
	private readonly background = document.createElement("input");
	private readonly backgroundColor = document.createElement("input");
	private readonly fuzz = document.createElement("input");
	private readonly inputs: Record<string, HTMLInputElement> = {};
	private readonly controls: Array<HTMLInputElement | HTMLButtonElement> = [];
	private form: WindowFormModalBS | null = null;
	private source: FacsimileRow | null = null;
	private busy = false;
	private saving = false;
	private closed = false;
	private rotation = 0;
	private pickingBackground = false;
	private sampleButton: HTMLButtonElement | null = null;
	private drag: {
		id: number;
		mode: FacsimileDragMode;
		start: { x: number; y: number; };
		crop: FacsimileCrop;
		selected: boolean;
	} | null = null;
	private hasSelection = false;
	private crop: FacsimileCrop = { x: 0, y: 0, width: 1, height: 1 };
	private previewRevision = 0;
	private previewPending = false;
	private previewQueued = false;
	private backgroundMode = "auto";
	private readonly cropLabel = document.createElement("p");

	constructor(options: ContactFacsimileOptions) {
		this.options = options;
	}

	public open = (): void => {
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
			const node = this.form?.getNode();
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

	public close = (): void => {
		if (this.saving || this.closed) {
			return;
		}
		const form = this.form;
		const node = form?.getNode();
		this.dispose();
		form?.close();
		if (node) {
			$(node).remove();
		}
		this.restoreParentModal();
	};

	private dispose = (): void => {
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
		this.options.onClosed?.();
	};

	private restoreParentModal = (): void => {
		// Bootstrap removes this class when a nested modal closes.
		if ($(".modal.in").length) {
			$(document.body).addClass("modal-open");
		}
	};

	private build = (): void => {
		this.root.className = "facsimile-editor";
		this.status.className = "facsimile-editor-status";
		this.status.setAttribute("role", "status");
		this.status.setAttribute("aria-live", "polite");
		const hint = document.createElement("p");
		hint.textContent = "Обведите подпись мышью. Потяните за край или угол, чтобы изменить размер, или за середину, чтобы переместить рамку. Правый щелчок снимает выделение.";
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
		toolbar.append(this.label("Масштаб просмотра", this.zoom), this.zoomValue, this.button("Всё изображение", () => {
			this.resetCrop();
			this.process(false);
		}), this.button("Повернуть на 90° ↻", this.rotateClockwise));
		const scroll = document.createElement("div");
		scroll.className = "facsimile-editor-source facsimile-editor-checkerboard";
		this.canvas.setAttribute("aria-label", "Исходное изображение. Выделите прямоугольник для обрезки.");
		this.canvas.addEventListener("pointerdown", this.startCrop);
		this.canvas.addEventListener("pointermove", this.moveCrop);
		this.canvas.addEventListener("pointerup", this.endCrop);
		this.canvas.addEventListener("pointercancel", this.cancelCrop);
		this.canvas.addEventListener("lostpointercapture", this.cancelCrop);
		this.canvas.addEventListener("contextmenu", (event) => {
			event.preventDefault();
			if (!this.busy && this.source) {
				this.resetCrop();
			}
		});
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
		this.background.checked = true;
		this.background.disabled = true;
		this.backgroundColor.type = "color";
		this.backgroundColor.value = "#ffffff";
		this.backgroundColor.className = "form-control facsimile-editor-color";
		const updateBackgroundColor = (): void => {
			this.setPickingBackground(false);
			this.backgroundMode = this.backgroundColor.value;
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
		const previewBox = document.createElement("div");
		previewBox.className = "facsimile-editor-preview facsimile-editor-checkerboard";
		previewBox.append(this.previewMessage, this.preview);
		const actions = document.createElement("div");
		actions.className = "facsimile-editor-actions";
		actions.append(this.button("Предпросмотр", () => this.process(false)), this.button("Применить", () => this.process(true), "btn-primary"));
		const settings = document.createElement("div");
		settings.hidden = true;
		settings.append(this.cropLabel, fields, outputFields, backgroundFields, backgroundHint);
		this.root.append(toolbar, scroll, settings, previewBox, actions);
	};

	private label = (caption: string, input: HTMLInputElement): HTMLLabelElement => {
		const label = document.createElement("label");
		const text = document.createElement("span");
		text.textContent = caption;
		label.append(text, input);
		return label;
	};

	private numberInput = (key: string, min: number, max: number): HTMLInputElement => {
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

	private button = (caption: string, callback: () => void, className = "btn-default"): HTMLButtonElement => {
		const button = document.createElement("button");
		button.type = "button";
		button.className = "btn " + className;
		button.textContent = caption;
		button.addEventListener("click", callback);
		this.controls.push(button);
		return button;
	};

	private updateZoom = (): void => {
		const scale = Number(this.zoom.value) / 100;
		this.canvas.style.width = this.canvas.width * scale + "px";
		this.canvas.style.height = this.canvas.height * scale + "px";
		this.zoomValue.textContent = this.zoom.value + "%";
		if (this.image.naturalWidth > 0) {
			this.draw();
		}
	};

	private point = (event: PointerEvent): { x: number; y: number; } => {
		const rect = this.canvas.getBoundingClientRect();
		return {
			x: Math.max(0, Math.min(this.canvas.width, Math.round((event.clientX - rect.left) * this.canvas.width / rect.width))),
			y: Math.max(0, Math.min(this.canvas.height, Math.round((event.clientY - rect.top) * this.canvas.height / rect.height))),
		};
	};

	private dragMode = (point: { x: number; y: number; }): FacsimileDragMode => {
		if (!this.hasSelection) {
			return "new";
		}
		const { x, y, width, height } = this.crop;
		const radius = 7 / (Number(this.zoom.value) / 100);
		const horizontal = Math.min(radius, width / 3);
		const vertical = Math.min(radius, height / 3);
		if (point.x < x - horizontal || point.x > x + width + horizontal || point.y < y - vertical || point.y > y + height + vertical) {
			return "new";
		}
		const side = Math.abs(point.x - x) <= horizontal ? "w" : Math.abs(point.x - x - width) <= horizontal ? "e" : "";
		if (Math.abs(point.y - y) <= vertical) {
			return side === "w" ? "nw" : side === "e" ? "ne" : "n";
		}
		if (Math.abs(point.y - y - height) <= vertical) {
			return side === "w" ? "sw" : side === "e" ? "se" : "s";
		}
		return side || "move";
	};

	private updateCursor = (mode: FacsimileDragMode): void => {
		this.canvas.style.cursor = mode === "new" ? "crosshair" : mode === "move" ? "move" : mode + "-resize";
	};

	private startCrop = (event: PointerEvent): void => {
		if (this.busy || !this.source || event.button !== 0 || this.drag) {
			return;
		}
		event.preventDefault();
		if (this.pickingBackground) {
			this.sampleBackground(event);
			return;
		}
		const start = this.point(event);
		const mode = this.dragMode(start);
		this.drag = { id: event.pointerId, mode, start, crop: { ...this.crop }, selected: this.hasSelection };
		this.updateCursor(mode);
		this.canvas.setPointerCapture(event.pointerId);
	};

	private moveCrop = (event: PointerEvent): void => {
		const drag = this.drag;
		const point = this.point(event);
		if (!drag) {
			if (!this.pickingBackground) {
				this.updateCursor(this.dragMode(point));
			}
			return;
		}
		if (event.pointerId !== drag.id) {
			return;
		}
		const { start, crop, mode } = drag;
		const dx = point.x - start.x;
		const dy = point.y - start.y;
		let { x, y, width, height } = crop;
		if (mode === "new") {
			if (dx === 0 && dy === 0) {
				return;
			}
			x = Math.min(start.x, point.x, this.canvas.width - 1);
			y = Math.min(start.y, point.y, this.canvas.height - 1);
			width = Math.max(1, Math.abs(dx));
			height = Math.max(1, Math.abs(dy));
		} else if (mode === "move") {
			x = Math.max(0, Math.min(this.canvas.width - width, x + dx));
			y = Math.max(0, Math.min(this.canvas.height - height, y + dy));
		} else {
			if (mode.includes("w")) {
				x = Math.max(0, Math.min(crop.x + width - 1, x + dx));
				width = crop.x + width - x;
			} else if (mode.includes("e")) {
				width = Math.max(1, Math.min(this.canvas.width - x, width + dx));
			}
			if (mode.includes("n")) {
				y = Math.max(0, Math.min(crop.y + height - 1, y + dy));
				height = crop.y + height - y;
			} else if (mode.includes("s")) {
				height = Math.max(1, Math.min(this.canvas.height - y, height + dy));
			}
		}
		if (this.hasSelection && x === this.crop.x && y === this.crop.y && width === this.crop.width && height === this.crop.height) {
			return;
		}
		this.hasSelection = true;
		this.crop = { x, y, width, height };
		this.syncCrop();
	};

	private releaseDrag = (): void => {
		const drag = this.drag;
		this.drag = null;
		if (drag && this.canvas.hasPointerCapture(drag.id)) {
			this.canvas.releasePointerCapture(drag.id);
		}
	};

	private endCrop = (event: PointerEvent): void => {
		if (!this.drag || event.pointerId !== this.drag.id) {
			return;
		}
		this.moveCrop(event);
		this.releaseDrag();
		if (this.hasSelection && this.preview.hidden) {
			this.process(false);
		}
	};

	private cancelCrop = (event: PointerEvent): void => {
		if (!this.drag || event.pointerId !== this.drag.id) {
			return;
		}
		this.crop = this.drag.crop;
		this.hasSelection = this.drag.selected;
		this.releaseDrag();
		this.syncCrop();
		if (this.hasSelection) {
			this.process(false);
		}
	};

	private resetCrop = (): void => {
		this.releaseDrag();
		this.hasSelection = false;
		this.updateCursor("new");
		this.crop = { x: 0, y: 0, width: this.canvas.width, height: this.canvas.height };
		this.syncCrop();
	};

	private renderSource = (): void => {
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
		} else if (this.rotation === 180) {
			context.translate(this.sourceCanvas.width, this.sourceCanvas.height);
		} else if (this.rotation === 270) {
			context.translate(0, this.sourceCanvas.height);
		}
		context.rotate(this.rotation * Math.PI / 180);
		context.drawImage(this.image, 0, 0);
		context.restore();
	};

	private rotateClockwise = (): void => {
		if (this.busy || !this.source || this.drag) {
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
		this.process(false);
	};

	private setPickingBackground = (picking: boolean): void => {
		this.pickingBackground = picking;
		this.canvas.classList.toggle("facsimile-editor-picking", picking);
		if (this.sampleButton) {
			this.sampleButton.textContent = picking ? "Отменить выбор цвета" : "Выбрать цвет фона";
			this.sampleButton.setAttribute("aria-pressed", String(picking));
		}
		this.status.className = "facsimile-editor-status";
		this.status.textContent = picking ? "Нажмите на фон исходного изображения, чтобы выбрать его цвет." : "";
	};

	private sampleBackground = (event: PointerEvent): void => {
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
		this.backgroundMode = this.backgroundColor.value;
		this.setPickingBackground(false);
		this.invalidatePreview();
	};

	private readCrop = (): void => {
		const value = (key: string): number => Math.round(Number(this.inputs[key].value) || 0);
		const x = Math.max(0, Math.min(this.canvas.width - 1, value("x")));
		const y = Math.max(0, Math.min(this.canvas.height - 1, value("y")));
		this.hasSelection = true;
		this.crop = {
			x,
			y,
			width: Math.max(1, Math.min(this.canvas.width - x, value("width"))),
			height: Math.max(1, Math.min(this.canvas.height - y, value("height"))),
		};
		this.syncCrop();
	};

	private syncCrop = (): void => {
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

	private draw = (): void => {
		const context = this.canvas.getContext("2d");
		if (!context) {
			return;
		}
		context.clearRect(0, 0, this.canvas.width, this.canvas.height);
		context.drawImage(this.sourceCanvas, 0, 0);
		if (!this.hasSelection) {
			return;
		}
		const { x, y, width, height } = this.crop;
		context.fillStyle = "rgba(0, 0, 0, 0.32)";
		context.fillRect(0, 0, this.canvas.width, y);
		context.fillRect(0, y + height, this.canvas.width, this.canvas.height - y - height);
		context.fillRect(0, y, x, height);
		context.fillRect(x + width, y, this.canvas.width - x - width, height);
		context.strokeStyle = "#1473e6";
		context.lineWidth = 2 / (Number(this.zoom.value) / 100);
		context.strokeRect(x, y, width, height);
		const size = Math.min(7 / (Number(this.zoom.value) / 100), width / 3, height / 3);
		context.fillStyle = "white";
		context.lineWidth /= 2;
		for (const hx of [0, 0.5, 1]) {
			for (const hy of [0, 0.5, 1]) {
				if (hx === 0.5 && hy === 0.5) {
					continue;
				}
				const left = x + width * hx - size / 2;
				const top = y + height * hy - size / 2;
				context.fillRect(left, top, size, size);
				context.strokeRect(left, top, size, size);
			}
		}
	};

	private resizeOutput = (key: string): void => {
		const input = this.inputs[key];
		const value = Math.max(1, Math.min(4096, Math.round(Number(input.value) || 1)));
		if (key === "output_width") {
			input.value = String(value);
			this.inputs.output_height.value = String(Math.max(1, Math.round(value * this.crop.height / this.crop.width)));
		} else {
			input.value = String(value);
			this.inputs.output_width.value = String(Math.max(1, Math.round(value * this.crop.width / this.crop.height)));
		}
		this.invalidatePreview();
	};

	private invalidatePreview = (): void => {
		this.previewRevision++;
		this.previewQueued = false;
		this.status.className = "facsimile-editor-status";
		this.status.textContent = "";
		this.preview.hidden = true;
		this.previewMessage.hidden = false;
		this.previewMessage.textContent = this.hasSelection ? "Фон выделенной области будет удалён автоматически." : "Выделите подпись для предпросмотра. Без выделения обрабатывается всё изображение.";
	};

	private setBusy = (busy: boolean, message = ""): void => {
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

	private showError = (message: string): void => {
		if (this.closed) {
			return;
		}
		this.setBusy(false);
		this.status.className = "alert alert-danger facsimile-editor-status";
		this.status.textContent = message;
	};

	private process = (save: boolean): void => {
		if (this.busy || !this.source || this.closed || this.drag) {
			return;
		}
		const width = Number(this.inputs.output_width.value);
		const height = Number(this.inputs.output_height.value);
		const fuzz = Number(this.fuzz.value);
		if (![width, height, fuzz].every(Number.isInteger) || width < 1 || height < 1 || width > 4096 || height > 4096 || width * height > 8000000 || fuzz < 0 || fuzz > 30) {
			this.showError("Размер файла должен быть от 1 до 4096 px и до 8 млн пикселей. Допуск цвета: от 0 до 30%.");
			return;
		}
		if (save) {
			this.invalidatePreview();
			this.saving = true;
			this.setBusy(true, "Сохранение факсимиле…");
		} else {
			if (this.previewPending) {
				this.previewQueued = true;
				return;
			}
			this.previewPending = true;
			this.status.className = "facsimile-editor-status";
			this.status.textContent = "Подготовка предпросмотра…";
		}
		const revision = this.previewRevision;
		const finishPreview = (): boolean => {
			this.previewPending = false;
			if (this.previewQueued) {
				this.previewQueued = false;
				this.process(false);
				return false;
			}
			return revision === this.previewRevision;
		};
		this.request("process_facsimile", {
			source_hash: this.source.source_hash,
			...this.crop,
			output_width: width,
			output_height: height,
			remove_background: true,
			background_color: this.backgroundMode,
			rotation: this.rotation,
			fuzz,
			save,
		}, (row) => {
			if (save) {
				this.setBusy(false);
				this.options.onSaved(row);
				this.close();
				return;
			}
			if (!finishPreview()) {
				return;
			}
			this.status.textContent = "";
			this.preview.src = "data:" + row.mime_type + ";base64," + row.data_base64;
			this.preview.hidden = false;
			this.previewMessage.hidden = false;
			this.previewMessage.textContent = "Результат: " + row.width + " × " + row.height + " px, PNG. Шахматный фон обозначает прозрачность.";
		}, (message) => {
			if (save || finishPreview()) {
				this.showError(message);
			}
		});
	};

	private request = (method: string, values: Record<string, string | number | boolean>, callback: (row: FacsimileRow) => void, onError = this.showError): void => {
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
						const row: FacsimileRow = {
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
					} catch (error) {
						onError(error instanceof Error ? error.message : "Ошибка обработки изображения.");
					}
				},
				fail: (_response, _code, message) => {
					if (!this.closed) {
						onError(message || "Не удалось обработать изображение.");
					}
				},
			});
		} catch (error) {
			onError(error instanceof Error ? error.message : "Ошибка обработки изображения.");
		}
	};
}
