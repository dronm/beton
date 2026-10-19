/** Minimal declarations for the public OpenLayers global-build API used here. */
declare namespace RouteOl {
	class Geometry { getExtent(): number[]; }
	class Point extends Geometry {
		constructor(coordinates: number[]);
		getCoordinates(): number[];
		setCoordinates(coordinates: number[]): void;
	}
	class LineString extends Geometry {
		constructor(coordinates: number[][]);
		setCoordinates(coordinates: number[][]): void;
	}
	class Polygon extends Geometry { getInteriorPoint(): Point; }
	class MultiPolygon extends Geometry { getPolygons(): Polygon[]; }
	class Feature {
		constructor(geometry?: Geometry);
		getGeometry(): Geometry | undefined;
		setGeometry(geometry: Geometry | undefined): void;
		setStyle(style: Style | Style[]): void;
	}
	class Style { constructor(options: Record<string, unknown>); }
	class VectorSource {
		constructor(options?: Record<string, unknown>);
		addFeature(feature: Feature): void;
	}
	class TileSource {
		constructor(options?: Record<string, unknown>);
		on(type: string, callback: () => void): void;
	}
	class Layer { constructor(options: Record<string, unknown>); }
	class Control { constructor(options?: Record<string, unknown>); }
	class View {
		constructor(options: Record<string, unknown>);
		getZoom(): number | undefined;
		getCenter(): number[] | undefined;
		setCenter(center: number[]): void;
		setZoom(zoom: number): void;
		cancelAnimations(): void;
		animate(options: Record<string, unknown>): void;
		fit(extent: number[], options?: Record<string, unknown>): void;
	}
	class Map {
		constructor(options: Record<string, unknown>);
		on(type: string, callback: () => void): void;
		un(type: string, callback: () => void): void;
		setTarget(target: string | HTMLElement | undefined): void;
		getView(): View;
		updateSize(): void;
	}
	class GeoJSON {
		readGeometry(value: unknown, options: Record<string, unknown>): Geometry;
	}
}
declare const ol: {
	Map: typeof RouteOl.Map;
	View: typeof RouteOl.View;
	Feature: typeof RouteOl.Feature;
	geom: { Point: typeof RouteOl.Point; LineString: typeof RouteOl.LineString; Polygon: typeof RouteOl.Polygon; MultiPolygon: typeof RouteOl.MultiPolygon };
	format: { GeoJSON: typeof RouteOl.GeoJSON };
	source: { Vector: typeof RouteOl.VectorSource; OSM: typeof RouteOl.TileSource };
	layer: { Vector: typeof RouteOl.Layer; Tile: typeof RouteOl.Layer };
	style: { Style: typeof RouteOl.Style; Stroke: typeof RouteOl.Style; Fill: typeof RouteOl.Style; Circle: typeof RouteOl.Style; Icon: typeof RouteOl.Style; Text: typeof RouteOl.Style };
	control: { Zoom: typeof RouteOl.Control; Attribution: typeof RouteOl.Control; ScaleLine: typeof RouteOl.Control };
	proj: { fromLonLat: (coordinates: number[]) => number[] };
	extent: { createEmpty: () => number[]; extend: (extent: number[], other: number[]) => number[]; isEmpty: (extent: number[]) => boolean };
};
interface Window {
	AppSrv?: RouteOsm.AppSrvConstructor;
	TRACK_CONSTANTS?: { INI_ZOOM?: unknown };
}
