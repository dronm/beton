/** TEST DOUBLE ONLY. No real Yandex renderer, API key, WebSocket or geolocation. */
namespace BrowserYandexFixture {
	type Point = [number, number];
	let subscription: { onEvent: (event: unknown) => void; events: { id: string }[] } | null = null;
	const calls: string[] = [];
	const requests: { url: string; method: string; body?: BodyInit | null; headers?: HeadersInit }[] = [];
	let map: MockMap | null = null;
	let vehicleCreations = 0;
	class Generic {
		constructor(public props: Record<string, unknown> = {}) {}
		update = (props: Record<string, unknown>): void => { Object.assign(this.props, props); };
	}
	class MockFeature extends Generic {}
	class MockListener extends Generic {}
	class MockMarker extends Generic {
		wrapper = document.createElement("div");
		constructor(props: Record<string, unknown>, public element: HTMLElement) {
			super(props);
			if (props.id === "shipment-vehicle") { vehicleCreations++; }
			this.wrapper.style.cssText = "position:absolute;pointer-events:none;";
			this.wrapper.append(element);
		}
		update = (props: Record<string, unknown>): void => { Object.assign(this.props, props); map?.paint(); };
	}
	const project = (p: Point): Point => [p[0] / 360, -Math.log(Math.tan(Math.PI / 4 + p[1] * Math.PI / 360)) / (2 * Math.PI)];
	class MockMap {
		children: Generic[] = [];
		center: [number, number, number];
		zoom: number;
		destroyed = false;
		locations: unknown[] = [];
		constructor(public container: HTMLElement, public props: { location: { center: Point; zoom: number }; [key: string]: unknown }, children: Generic[] = []) {
			map = this;
			this.center = [...props.location.center, 0];
			this.zoom = props.location.zoom;
			container.style.background = "repeating-linear-gradient(0deg, transparent, transparent 59px, #dce4e9 60px),repeating-linear-gradient(90deg,#edf2f4,#edf2f4 59px,#dce4e9 60px)";
			const label = document.createElement("div");
			label.textContent = "TEST PLACEHOLDER — Yandex map is not loaded";
			label.style.cssText = "position:absolute;top:45%;left:10%;right:10%;text-align:center;color:#687888;font:14px sans-serif";
			container.append(label);
			const credits = document.createElement("div");
			credits.textContent = "Native map attribution area (test placeholder)";
			credits.style.cssText = "position:absolute;bottom:8px;right:8px;color:#687888;font:11px sans-serif";
			container.append(credits);
			children.forEach((child) => this.addChild(child));
		}
		addChild = (child: Generic): MockMap => {
			this.children.push(child);
			if (child instanceof MockMarker) { this.container.append(child.wrapper); }
			this.paint();
			return this;
		};
		removeChild = (child: Generic): MockMap => {
			this.children = this.children.filter((item) => item !== child);
			if (child instanceof MockMarker) { child.wrapper.remove(); }
			return this;
		};
		setLocation = (location: { center?: Point; zoom?: number; duration?: number }): void => {
			this.locations.push(location);
			if (location.center) { this.center = [...location.center, 0]; }
			if (location.zoom !== undefined) { this.zoom = location.zoom; }
			this.paint();
		};
		paint = (): void => {
			const center = project([this.center[0], this.center[1]]);
			for (const child of this.children) {
				if (!(child instanceof MockMarker)) { continue; }
				const point = project(child.props.coordinates as Point);
				child.wrapper.style.left = `${this.container.clientWidth / 2 + (point[0] - center[0]) * 256 * 2 ** this.zoom}px`;
				child.wrapper.style.top = `${this.container.clientHeight / 2 + (point[1] - center[1]) * 256 * 2 ** this.zoom}px`;
			}
		};
		destroy = (): void => { this.destroyed = true; };
	}
	const sdk = { ready: Promise.resolve(), YMap: MockMap, YMapMarker: MockMarker, YMapFeature: MockFeature,
		YMapListener: MockListener, YMapDefaultSchemeLayer: Generic, YMapDefaultFeaturesLayer: Generic };
	const global = window as unknown as Record<string, unknown>;
	global.ymaps3 = sdk;
	class AppSrv {
		constructor(public options: unknown) { calls.push("construct"); }
		connect = (): void => { calls.push("connect"); };
		subscribe = (value: typeof subscription): void => { calls.push("subscribe"); subscription = value; };
	}
	global.AppSrv = AppSrv;
	global.fetch = async (url: string, options: RequestInit = {}): Promise<Response> => {
		requests.push({ url, method: options.method ?? "GET", body: options.body, headers: options.headers });
		return new Response(JSON.stringify(url.includes("location.php") ? { ok: true } : { route: "60.60 56.832,60.62 56.837" }), { status: 200, headers: { "Content-Type": "application/json" } });
	};
	Object.defineProperty(window, "isSecureContext", { value: true, configurable: true });
	Object.defineProperty(navigator, "geolocation", { value: {
		getCurrentPosition: (success: (position: unknown) => void): void => success({ coords: { longitude: 60.62, latitude: 56.837 } }),
	}, configurable: true });
	window.confirm = () => true;
	let clock = 0;
	let frameId = 0;
	const frames = new Map<number, FrameRequestCallback>();
	const motionHandlers: (() => void)[] = [];
	const motion = { matches: false, media: "(prefers-reduced-motion: reduce)",
		addEventListener: (_name: string, handler: () => void): void => { motionHandlers.push(handler); },
		removeEventListener: (_name: string, handler: () => void): void => { const index = motionHandlers.indexOf(handler); if (index >= 0) { motionHandlers.splice(index, 1); } },
	};
	global.matchMedia = () => motion;
	Object.defineProperty(performance, "now", { value: () => clock, configurable: true });
	window.requestAnimationFrame = (callback) => { const id = ++frameId; frames.set(id, callback); return id; };
	window.cancelAnimationFrame = (id) => { frames.delete(id); };
	let resolveReady: () => void = () => {};
	let rejectReady: (error: Error) => void = () => {};
	const entity = (id: string): Generic | undefined => map?.children.find((child) => child.props.id === id);
	global.routeFixture = {
		sdk, calls, requests,
		deferReady: (): void => { sdk.ready = new Promise<void>((resolve, reject) => { resolveReady = resolve; rejectReady = reject; }); },
		resolveReady: (): void => resolveReady(),
		rejectReady: (): void => rejectReady(new Error("fixture SDK rejection")),
		tick: (ms: number): void => { clock += ms; const callbacks = [...frames.values()]; frames.clear(); callbacks.forEach((callback) => callback(clock)); },
		frames: (): number => frames.size,
		emit: (event: unknown): void => subscription?.onEvent(event),
		events: () => subscription?.events,
		vehicle: () => entity("shipment-vehicle")?.props.coordinates ?? null,
		marker: () => entity("shipment-vehicle")?.props ?? null,
		destination: () => entity("shipment-destination")?.props.coordinates ?? null,
		route: () => entity("remaining-route")?.props.geometry ?? null,
		zones: () => map?.children.filter((child) => String(child.props.id).startsWith("destination-zone")).map((child) => child.props.geometry),
		camera: () => map?.center,
		zoom: () => map?.zoom,
		options: () => map?.props,
		vehicleCreations: () => vehicleCreations,
		destroyed: () => map?.destroyed,
		action: (type: string): void => {
			for (const child of map?.children ?? []) {
				if (child instanceof MockListener) { (child.props.onActionStart as (e: unknown) => void)({ type, location: {}, camera: {} }); }
			}
		},
		hidden: (value: boolean): void => { Object.defineProperty(document, "hidden", { value, configurable: true }); document.dispatchEvent(new Event("visibilitychange")); },
		reduced: (value: boolean): void => { motion.matches = value; motionHandlers.forEach((handler) => handler()); },
	};
}
