/** Test doubles only: this is NOT OpenLayers or a WebSocket implementation. */
namespace BrowserRouteFixture {
	let subscription: { onEvent: (event: unknown) => void; onWakeup: () => void; events: { id: string }[] } | null = null;
	const calls: string[] = [];
	const features: Feature[] = [];
	const finiteExtent = (points: number[][]): number[] => points.length === 0 ? [Infinity, Infinity, -Infinity, -Infinity] :
		[Math.min(...points.map((p) => p[0])), Math.min(...points.map((p) => p[1])), Math.max(...points.map((p) => p[0])), Math.max(...points.map((p) => p[1]))];
	class Point {
		constructor(private point: number[]) {}
		getCoordinates = (): number[] => this.point;
		setCoordinates = (point: number[]): void => { this.point = [...point]; };
		getExtent = (): number[] => finiteExtent([this.point]);
	}
	class LineString {
		constructor(private points: number[][]) {}
		getExtent = (): number[] => finiteExtent(this.points);
	}
	class Polygon extends LineString {
		getInteriorPoint = (): Point => { const e = this.getExtent(); return new Point([(e[0] + e[2]) / 2, (e[1] + e[3]) / 2]); };
	}
	class MultiPolygon extends Polygon { getPolygons = (): Polygon[] => [this]; }
	class Feature {
		constructor(private geometry?: Point | LineString) { features.push(this); }
		getGeometry = (): Point | LineString | undefined => this.geometry;
		setGeometry = (geometry: Point | LineString | undefined): void => { this.geometry = geometry; };
		setStyle = (_style: unknown): void => {};
	}
	class Generic {
		constructor(public options: Record<string, unknown> = {}) {}
		on = (_event: string, _callback: () => void): void => {};
	}
	class View extends Generic {
		private zoom = 14;
		private center: number[] = [0, 0];
		getCenter = (): number[] => [...this.center];
		setCenter = (point: number[]): void => { this.center = [...point]; };
		getZoom = (): number => this.zoom;
		setZoom = (value: number): void => { this.zoom = value; };
		cancelAnimations = (): void => {};
		animate = (options: { center?: number[] }): void => { if (options.center) { this.setCenter(options.center); } };
		fit = (extent: number[]): void => {
			if (extent.some((value) => !Number.isFinite(value))) { throw new Error("Non-finite map extent"); }
		};
	}
	let lastMap: Map;
	class Map extends Generic {
		private handlers: Record<string, (() => void)[]> = {};
		constructor(options: Record<string, unknown>) {
			super(options);
			lastMap = this;
			const map = document.getElementById("map");
			if (map) {
				const label = document.createElement("div");
				label.textContent = "Map renderer is mocked for this test";
				label.style.cssText = "position:absolute;top:50%;left:0;width:100%;text-align:center;color:#7f939f;font:12px sans-serif";
				map.append(label);
				const attribution = document.createElement("div");
				attribution.className = "ol-attribution ol-control";
				attribution.textContent = "© OpenStreetMap contributors (test placeholder)";
				attribution.style.position = "absolute";
				map.append(attribution);
			}
		}
		on = (event: string, callback: () => void): void => { (this.handlers[event] ??= []).push(callback); };
		un = (event: string, callback: () => void): void => { this.handlers[event] = (this.handlers[event] ?? []).filter((handler) => handler !== callback); };
		setTarget = (_target: unknown): void => {};
		trigger = (event: string): void => { this.handlers[event]?.forEach((callback) => callback()); };
		getView = (): View => this.options.view as View;
		updateSize = (): void => {};
	}
	class GeoJSON {
		readGeometry = (geometry: { type: string; coordinates: number[][][] }): Polygon => new Polygon(geometry.coordinates[0]);
	}
	const global = window as unknown as Record<string, unknown>;
	global.ol = {
		Map, View, Feature, geom: { Point, LineString, Polygon, MultiPolygon }, format: { GeoJSON },
		source: { Vector: Generic, OSM: Generic }, layer: { Vector: Generic, Tile: Generic },
		style: { Style: Generic, Stroke: Generic, Fill: Generic, Circle: Generic, Icon: Generic, Text: Generic },
		control: { Zoom: Generic, Attribution: Generic, ScaleLine: Generic },
		proj: { fromLonLat: (point: number[]) => [...point] },
		extent: {
			createEmpty: () => [Infinity, Infinity, -Infinity, -Infinity],
			extend: (e: number[], other: number[]) => { e[0] = Math.min(e[0], other[0]); e[1] = Math.min(e[1], other[1]); e[2] = Math.max(e[2], other[2]); e[3] = Math.max(e[3], other[3]); return e; },
			isEmpty: (e: number[]) => e[0] > e[2] || e[1] > e[3],
		},
	};
	class AppSrv {
		constructor(_options: unknown) { calls.push("construct"); }
		connect = (): void => { calls.push("connect"); };
		subscribe = (value: typeof subscription): void => { calls.push("subscribe"); subscription = value; };
	}
	const requests: { url: string; method: string; body?: BodyInit | null }[] = [];
	global.AppSrv = AppSrv;
	global.fetch = async (url: string, init: RequestInit = {}): Promise<Response> => {
		requests.push({ url, method: init.method ?? "GET", body: init.body });
		return new Response(JSON.stringify(url.startsWith("location.php") ? { ok: true } : { route: "60.60 56.832,60.62 56.837" }), { status: 200, headers: { "Content-Type": "application/json" } });
	};
	// Explicit browser capability test doubles; no device location is read.
	Object.defineProperty(window, "isSecureContext", { value: true, configurable: true });
	Object.defineProperty(navigator, "geolocation", { value: {
		getCurrentPosition: (callback: (position: { coords: { longitude: number; latitude: number } }) => void) => callback({ coords: { longitude: 60.62, latitude: 56.837 } }),
	}, configurable: true });
	// Optional deterministic clock for integration checks of the actual compiled map adapter.
	let frameTime = 0;
	let frameId = 0;
	const frames = new globalThis.Map<number, FrameRequestCallback>();
	let savedGeometry: Point | LineString | undefined;
	global.routeFixture = {
		requests,
		manualFrames: () => {
			Object.defineProperty(performance, "now", { value: () => frameTime, configurable: true });
			window.requestAnimationFrame = (callback) => { const id = frameId++; frames.set(id, callback); return id; };
			window.cancelAnimationFrame = (id) => { frames.delete(id); };
		},
		tick: (milliseconds: number) => {
			frameTime += milliseconds;
			const callbacks = [...frames.values()];
			frames.clear();
			callbacks.forEach((callback) => callback(frameTime));
		},
		pendingFrames: () => frames.size,
		hidden: (value: boolean) => {
			Object.defineProperty(document, "hidden", { value, configurable: true });
			document.dispatchEvent(new Event("visibilitychange"));
		},
		captureGeometry: () => { savedGeometry = features[1].getGeometry(); },
		sameGeometry: () => savedGeometry === features[1].getGeometry(),
		AppSrv,
		emit: (event: unknown) => subscription?.onEvent(event),
		wake: () => subscription?.onWakeup(),
		drag: () => lastMap.trigger("pointerdrag"),
		calls,
		vehicle: () => (features[1].getGeometry() as Point | undefined)?.getCoordinates(),
		vehicleGeometry: () => features[1].getGeometry(),
		camera: () => lastMap.getView().getCenter(),
		featureExtents: () => features.map((feature) => feature.getGeometry()?.getExtent() ?? null),
	};
}
