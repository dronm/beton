/** Run with Node 24+: node --experimental-strip-types tests/contact-facsimile-ui.test.ts. */
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";
import { createRequire } from "node:module";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const { JSDOM } = require(process.env.JSDOM_MODULE || "jsdom");
const root = process.env.BETON_PROJECT_ROOT || path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const read = (name: string): string => fs.readFileSync(path.join(root, name), "utf8");

type Values = Record<string, string | number | boolean>;
interface Request {
	method: string;
	values: Values;
	options: { ok: (response: unknown) => void; fail: (response: unknown, code: number, message: string) => void; };
}

const fixture = async (defer = false) => {
	const dom = new JSDOM("<!doctype html><html><body></body></html>", {
		url: "https://beton.test/",
		runScripts: "outside-only",
		pretendToBeVisual: true,
	});
	const w = dom.window;
	const requests: Request[] = [];
	const saved: Array<Record<string, unknown>> = [];
	const canvasContexts = new Map();
	const sampledPixels: Array<{ canvas: HTMLCanvasElement; x: number; y: number; shaded: boolean; }> = [];
	let sampleColor = [230, 232, 235, 255];
	let closed = 0;
	const source = {
		data_base64: "fixture-image",
		mime_type: "image/png",
		name: "signature.png",
		width: 400,
		height: 200,
		size: 100,
		source_hash: "a".repeat(64),
	};
	const response = (row: Record<string, unknown>) => ({
		getModel: (name: string) => name === "Facsimile_Model" ? {
			getNextRow: () => true,
			getFieldValue: (key: string) => row[key],
		} : null,
	});
	const complete = (request: Request, overrides: Record<string, unknown> = {}) => {
		request.options.ok(response({
			...source,
			width: request.values.output_width || source.width,
			height: request.values.output_height || source.height,
			source_hash: request.values.save ? "b".repeat(64) : source.source_hash,
			...overrides,
		}));
	};
	w.getApp = () => ({ getTemplate: () => undefined, getAppSrv: () => null });
	w.eval(read("js20/assets/js/core/libraries/jquery.min.js"));
	w.eval(read("js20/assets/js/core/libraries/bootstrap.min.js"));
	w.jQuery.support.transition = false;
	for (const name of [
		"core/extend.js", "core/CommonHelper.js", "core/DOMHelper.js", "core/EventHelper.js",
		"controls/Control.js", "controls/ControlContainer.js", "controls/Button.js", "controls/ButtonCmd.js",
		"controls/WindowFormModalBS.js",
	]) {
		w.eval(read("js20/" + name));
	}
	w.Contact_Controller = class {
		getPublicMethod = (method: string) => {
			const values: Values = {};
			return {
				setFieldValue: (name: string, value: string | number | boolean) => { values[name] = value; },
				run: (options: Request["options"]) => {
					const request = { method, values, options };
					requests.push(request);
					if (!defer) {
						complete(request);
					}
				},
			};
		};
	};
	w.Image = class {
		naturalWidth = 400;
		naturalHeight = 200;
		onload: (() => void) | null = null;
		onerror: (() => void) | null = null;
		set src(_value: string) { queueMicrotask(() => this.onload?.()); }
	};
	w.HTMLCanvasElement.prototype.getContext = function() {
		if (!canvasContexts.has(this)) {
			const context = {
				canvas: this,
				shaded: false,
				operations: [] as Array<[string, ...number[]]>,
				clearRect() { this.shaded = false; },
				drawImage() { this.shaded = false; },
				fillRect() { this.shaded = true; },
				strokeRect() {},
				save() {},
				restore() {},
				translate(x: number, y: number) { this.operations.push(["translate", x, y]); },
				rotate(angle: number) { this.operations.push(["rotate", angle]); },
				getImageData(x: number, y: number) {
					sampledPixels.push({ canvas: this.canvas, x, y, shaded: this.shaded });
					return { data: Uint8ClampedArray.from(this.shaded ? [100, 100, 100, 255] : sampleColor) };
				},
			};
			canvasContexts.set(this, context);
		}
		return canvasContexts.get(this);
	};
	w.HTMLCanvasElement.prototype.setPointerCapture = () => {};
	w.HTMLCanvasElement.prototype.hasPointerCapture = () => true;
	w.HTMLCanvasElement.prototype.releasePointerCapture = () => {};
	w.eval(read("js20/custom_controls/ContactFacsimileEditor.js") + "\nwindow.ContactFacsimileEditor = ContactFacsimileEditor;");
	const editor = new w.ContactFacsimileEditor({
		contactId: 42,
		contentId: "sig-1",
		onSaved: (row: Record<string, unknown>) => saved.push(row),
		onClosed: () => { closed++; },
	});
	const tick = async () => { await new Promise((resolve) => setTimeout(resolve, 0)); };
	const open = async () => { editor.open(); await tick(); };
	const change = (input: HTMLInputElement, value: string) => {
		input.value = value;
		input.dispatchEvent(new w.Event("change", { bubbles: true }));
	};
	const button = (caption: string) => Array.from(w.document.querySelectorAll("button")).find((node) => node.textContent === caption);
	return {
		dom, w, editor, requests, saved, source, complete, tick, open, change, button, canvasContexts, sampledPixels,
		setSampleColor: (color: number[]) => { sampleColor = color; },
		closed: () => closed,
	};
};

{
	const f = await fixture();
	await f.open();
	f.editor.open();
	assert.equal(f.w.document.querySelectorAll(".facsimile-editor").length, 1, "one instance cannot open duplicate modals");
	assert.deepEqual(f.requests[0].values, { id: 42, content_id: "sig-1" });
	assert.equal(f.editor.canvas.width, 400);
	assert.equal(f.editor.canvas.height, 200);
	f.editor.zoom.value = "200";
	f.editor.zoom.dispatchEvent(new f.w.Event("input"));
	assert.equal(f.editor.canvas.style.width, "800px");
	f.editor.canvas.getBoundingClientRect = () => ({ left: 10, top: 20, width: 800, height: 400 });
	const pointer = (type: string, x: number, y: number) => {
		const event = new f.w.Event(type, { bubbles: true, cancelable: true });
		Object.assign(event, { pointerId: 1, button: 0, clientX: x, clientY: y });
		f.editor.canvas.dispatchEvent(event);
	};
	pointer("pointerdown", 110, 70);
	pointer("pointermove", 610, 270);
	pointer("pointerup", 610, 270);
	assert.equal(JSON.stringify(f.editor.crop), JSON.stringify({ x: 50, y: 25, width: 250, height: 100 }), "crop coordinates map back from zoomed display to original pixels");
	f.change(f.editor.inputs.output_width, "500");
	assert.equal(f.editor.inputs.output_height.value, "200", "enlargement preserves crop aspect ratio");
	f.editor.background.checked = true;
	f.change(f.editor.fuzz, "15");
	f.button("Предпросмотр").click();
	assert.deepEqual(f.requests.at(-1).values, {
		id: 42, content_id: "sig-1", source_hash: "a".repeat(64), x: 50, y: 25, width: 250, height: 100,
		output_width: 500, output_height: 200, remove_background: true, background_color: "#ffffff", rotation: 0, fuzz: 15, save: false,
	});
	assert.equal(f.saved.length, 0, "preview does not save");
	assert.equal(f.editor.preview.hidden, false);
	f.change(f.editor.fuzz, "12");
	assert.equal(f.editor.preview.hidden, true, "changing processing settings invalidates stale preview");
	const beforeInvalid = f.requests.length;
	f.editor.inputs.output_width.value = "4097";
	f.button("Предпросмотр").click();
	assert.equal(f.requests.length, beforeInvalid, "invalid output dimensions never reach the server");
	f.change(f.editor.inputs.output_width, "500");
	f.button("Применить").click();
	assert.equal(f.requests.at(-1).values.save, true);
	assert.equal(f.saved.length, 1);
	assert.equal(f.saved[0].source_hash, "b".repeat(64));
	assert.equal(f.closed(), 1);
	assert.equal(f.w.document.querySelectorAll(".facsimile-editor").length, 0);
	f.dom.window.close();
}

{
	const f = await fixture();
	await f.open();
	Object.assign(f.editor.crop, { x: 50, y: 25, width: 250, height: 100 });
	f.editor.syncCrop();
	f.change(f.editor.inputs.output_width, "500");
	const states = [
		{ rotation: 90, canvas: [200, 400], crop: { x: 75, y: 50, width: 100, height: 250 }, output: [200, 500] },
		{ rotation: 180, canvas: [400, 200], crop: { x: 100, y: 75, width: 250, height: 100 }, output: [500, 200] },
		{ rotation: 270, canvas: [200, 400], crop: { x: 25, y: 100, width: 100, height: 250 }, output: [200, 500] },
		{ rotation: 0, canvas: [400, 200], crop: { x: 50, y: 25, width: 250, height: 100 }, output: [500, 200] },
	];
	for (const state of states) {
		f.button("Повернуть на 90° ↻").click();
		assert.equal(f.editor.rotation, state.rotation);
		assert.deepEqual([f.editor.canvas.width, f.editor.canvas.height], state.canvas, "quarter turns swap displayed image dimensions");
		assert.equal(JSON.stringify(f.editor.crop), JSON.stringify(state.crop), "clockwise rotation preserves selected signature pixels");
		assert.deepEqual([Number(f.editor.inputs.output_width.value), Number(f.editor.inputs.output_height.value)], state.output, "rotation preserves enlargement and swaps output dimensions");
		assert.equal(f.editor.preview.hidden, true, "rotation invalidates any previous preview");
		const sourceContext = f.canvasContexts.get(f.editor.sourceCanvas);
		assert.deepEqual(sourceContext.operations.at(-1), ["rotate", state.rotation * Math.PI / 180], "source pixels rotate clockwise for the requested angle");
		f.button("Предпросмотр").click();
		const values = f.requests.at(-1).values;
		assert.equal(values.rotation, state.rotation);
		assert.equal(values.background_color, "#ffffff");
		for (const [key, value] of Object.entries(state.crop)) {
			assert.equal(values[key], value, "backend receives crop in rotated coordinates");
		}
		assert.deepEqual([values.output_width, values.output_height], state.output);
	}
	f.button("Повернуть на 90° ↻").click();
	f.button("Всё изображение").click();
	assert.equal(f.editor.rotation, 90, "full-image selection retains orientation");
	assert.equal(JSON.stringify(f.editor.crop), JSON.stringify({ x: 0, y: 0, width: 200, height: 400 }));
	f.editor.close();
	f.dom.window.close();
}

{
	const f = await fixture();
	await f.open();
	Object.assign(f.editor.crop, { x: 50, y: 25, width: 250, height: 100 });
	f.editor.syncCrop();
	f.editor.zoom.value = "200";
	f.editor.zoom.dispatchEvent(new f.w.Event("input"));
	f.editor.canvas.getBoundingClientRect = () => ({ left: 10, top: 20, width: 800, height: 400 });
	f.button("Предпросмотр").click();
	const cropBefore = JSON.stringify(f.editor.crop);
	const point = (type: string, x: number, y: number) => {
		const event = new f.w.Event(type, { bubbles: true, cancelable: true });
		Object.assign(event, { pointerId: 2, button: 0, clientX: x, clientY: y });
		f.editor.canvas.dispatchEvent(event);
	};
	f.button("Выбрать цвет фона").click();
	assert.equal(f.editor.pickingBackground, true);
	assert.equal(f.editor.canvas.classList.contains("facsimile-editor-picking"), true);
	point("pointerdown", 20, 30);
	point("pointermove", 30, 40);
	point("pointerup", 30, 40);
	assert.equal(JSON.stringify(f.editor.crop), cropBefore, "sampling background cannot start a crop drag");
	assert.equal(f.editor.backgroundColor.value, "#e6e8eb", "sample captures the original background rather than the darkened selection margin");
	assert.equal(f.sampledPixels.at(-1).canvas, f.editor.sourceCanvas);
	assert.deepEqual([f.sampledPixels.at(-1).x, f.sampledPixels.at(-1).y], [5, 5], "sampling maps zoomed pointer coordinates to source pixels");
	assert.equal(f.sampledPixels.at(-1).shaded, false);
	assert.equal(f.editor.background.checked, true, "sampling enables background removal");
	assert.equal(f.editor.pickingBackground, false);
	assert.equal(f.editor.preview.hidden, true, "sampling invalidates previous preview");
	f.button("Предпросмотр").click();
	assert.equal(f.requests.at(-1).values.background_color, "#e6e8eb");
	assert.equal(f.requests.at(-1).values.remove_background, true);
	f.editor.background.checked = false;
	f.editor.backgroundColor.value = "#ddddcc";
	f.editor.backgroundColor.dispatchEvent(new f.w.Event("input", { bubbles: true }));
	assert.equal(f.editor.background.checked, true, "manual background colour enables removal");
	assert.equal(f.editor.preview.hidden, true);
	f.setSampleColor([0, 0, 0, 0]);
	f.button("Выбрать цвет фона").click();
	point("pointerdown", 20, 30);
	assert.equal(f.editor.backgroundColor.value, "#ddddcc", "already-transparent pixels do not replace the chosen background colour");
	assert.equal(f.editor.pickingBackground, true, "transparent sample leaves picker ready for another point");
	assert.match(f.editor.status.textContent, /прозрачный/);
	assert.equal(JSON.stringify(f.editor.crop), cropBefore);
	f.button("Отменить выбор цвета").click();
	assert.equal(f.editor.pickingBackground, false);
	f.button("Повернуть на 90° ↻").click();
	const rotatedCrop = JSON.stringify(f.editor.crop);
	f.editor.canvas.getBoundingClientRect = () => ({ left: 10, top: 20, width: 400, height: 800 });
	f.setSampleColor([190, 191, 192, 255]);
	f.button("Выбрать цвет фона").click();
	point("pointerdown", 20, 30);
	assert.equal(f.editor.backgroundColor.value, "#bebfc0", "sampling also uses the rotated source image");
	assert.equal(JSON.stringify(f.editor.crop), rotatedCrop);
	assert.deepEqual([f.sampledPixels.at(-1).x, f.sampledPixels.at(-1).y], [5, 5]);
	f.button("Предпросмотр").click();
	assert.equal(f.requests.at(-1).values.rotation, 90);
	assert.equal(f.requests.at(-1).values.background_color, "#bebfc0");
	f.button("Выбрать цвет фона").click();
	f.editor.backgroundColor.value = "#aabbcc";
	f.editor.backgroundColor.dispatchEvent(new f.w.Event("change", { bubbles: true }));
	assert.equal(f.editor.pickingBackground, false, "changing colour directly exits point sampling");
	assert.equal(f.editor.preview.hidden, true);
	f.editor.close();
	f.dom.window.close();
}

{
	const f = await fixture(true);
	await f.open();
	f.complete(f.requests[0]);
	await f.tick();
	f.button("Предпросмотр").click();
	f.requests.at(-1).options.fail(null, 1, "Processing failed");
	assert.equal(f.editor.status.textContent, "Processing failed");
	assert.equal(f.button("Применить").disabled, false, "failed preview restores controls");
	f.button("Предпросмотр").click();
	f.complete(f.requests.at(-1));
	assert.equal(f.editor.preview.hidden, false, "preview can be retried after failure");
	f.button("Предпросмотр").click();
	const pending = f.requests.at(-1);
	f.editor.close();
	f.complete(pending);
	assert.equal(f.saved.length, 0);
	assert.equal(f.closed(), 1, "cancel plus late response disposes once");
	assert.equal(f.w.document.querySelectorAll(".facsimile-editor").length, 0);
	f.dom.window.close();
}

{
	const f = await fixture(true);
	await f.open();
	f.complete(f.requests[0]);
	await f.tick();
	f.button("Применить").click();
	const request = f.requests.at(-1);
	f.editor.process(true);
	assert.equal(f.requests.at(-1), request, "repeated Apply cannot submit a second active save");
	f.editor.close();
	assert.equal(f.closed(), 0, "cancel is blocked while saving");
	const event = f.w.jQuery.Event("hide.bs.modal");
	f.w.jQuery(f.editor.form.getNode()).trigger(event);
	assert.equal(event.isDefaultPrevented(), true, "Bootstrap Escape/backdrop close cannot discard an active save");
	f.complete(request);
	assert.equal(f.saved.length, 1);
	assert.equal(f.closed(), 1);
	f.dom.window.close();
}

{
	const f = await fixture(true);
	await f.open();
	f.editor.close();
	f.complete(f.requests[0]);
	await f.tick();
	assert.equal(f.closed(), 1, "source loading can be cancelled");
	assert.equal(f.saved.length, 0);
	assert.equal(f.w.document.querySelectorAll(".facsimile-editor").length, 0, "late source response cannot reopen cancelled editor");
	f.dom.window.close();
}

{
	const f = await fixture(true);
	await f.open();
	f.requests[0].options.fail(null, 1, "Forbidden");
	assert.equal(f.editor.status.textContent, "Forbidden");
	assert.equal(f.button("Применить").disabled, true);
	f.editor.close();
	assert.equal(f.closed(), 1, "load failure remains closable");
	assert.equal(f.requests.length, 1, "load failure cannot send a save");
	f.dom.window.close();
}

{
	const f = await fixture();
	const parent = new f.w.WindowFormModalBS("contact-parent", { contentHead: "Contact", cmdCancel: true });
	parent.open();
	await f.open();
	f.editor.close();
	assert.equal(f.w.document.querySelectorAll(".modal.in").length, 1, "closing editor preserves the contact modal");
	assert.equal(f.w.document.body.classList.contains("modal-open"), true, "nested-modal close preserves parent scroll lock");
	parent.close();
	f.dom.window.close();
}

{
	const f = await fixture();
	f.w.Mustache = require(process.env.MUSTACHE_MODULE || "mustache");
	const templates: Record<string, string> = {
		EditFile: read("js20/tmpl/EditFile.html"),
		EditFileInf: read("js20/tmpl/EditFileInf.html"),
	};
	f.w.getApp = () => ({ getTemplate: (name: string) => templates[name], getAppSrv: () => null });
	f.w.getBsCol = () => "lg";
	f.w.getWidthType = () => "lg";
	f.w.showError = (message: string) => { throw new Error(message); };
	f.w.eval(read("js20/controls/ButtonCtrl.js"));
	f.w.eval(read("js20/custom_controls/EditFile.js"));
	f.w.ViewObjectAjx = function() {};
	f.w.eval(read("js20/views/ContactDialog_View.js") + "\nwindow.ContactDialog_View = ContactDialog_View;");
	const attachment = new f.w.EditFile("contact:attachments_list", { showHref: true, multipleFiles: false });
	attachment.toDOM(f.w.document.body);
	attachment.setValue([{ id: "sig-stored", name: "stored.jpg", size: 101 }]);
	assert.equal(attachment.getFiles().length, 0, "fixture reproduces legacy stored-file behavior");
	assert.equal(attachment.getFileControls().length, 1);
	const view = {
		m_facsimileEditor: null,
		getElement: (name: string) => name === "id" ? { getValue: () => 42 } : attachment,
	};
	f.w.ContactDialog_View.prototype.openFacsimile.call(view);
	await f.tick();
	assert.deepEqual(f.requests[0].values, { id: 42, content_id: "sig-stored" }, "stored signature opens using rendered file metadata");
	view.m_facsimileEditor.process(true);
	assert.equal(view.m_facsimileEditor, null, "save closes editor and clears view guard");
	assert.equal(f.w.document.getElementById("sig-stored-href").getAttribute("file_uploaded"), "true");
	f.w.ContactDialog_View.prototype.openFacsimile.call(view);
	await f.tick();
	assert.equal(f.requests.at(-1).method, "get_facsimile", "saved signature can be reopened without reloading contact");
	assert.equal(f.requests.at(-1).values.content_id, "sig-stored");
	view.m_facsimileEditor.close();
	f.dom.window.close();
}

console.log("Facsimile UI regression tests passed (real Bootstrap/legacy modal, deterministic image/canvas fixture).");
