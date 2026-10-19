/**
 * Narrow declarations for the JS API v3 surface used by this standalone app.
 * No runtime library is bundled here. The loader obtains it from Yandex.
 * Reference: https://yandex.com/maps-api/docs/js-api/ref/index.html
 */
declare namespace RouteYmaps {
	type Coordinates = [number, number];
	interface Entity { update: (props: never) => void; }
	interface Location { center?: Coordinates; zoom?: number; duration?: number; }
	interface MapProps {
		location: Location;
		mode?: "auto" | "raster" | "vector";
		zoomRange?: { min: number; max: number };
		behaviors?: string[];
		showScaleInCopyrights?: boolean;
	}
	interface Map {
		readonly center: readonly [number, number, number?];
		readonly zoom: number;
		addChild: (entity: Entity) => Map;
		removeChild: (entity: Entity) => Map;
		setLocation: (location: Location) => void;
		destroy: () => void;
	}
	interface MarkerProps {
		id?: string;
		coordinates: Coordinates;
		draggable?: boolean;
		disableRoundCoordinates?: boolean;
		zIndex?: number;
	}
	interface Marker { update: (props: Partial<MarkerProps>) => void; }
	type Geometry = { type: "LineString"; coordinates: Coordinates[] } | { type: "Polygon"; coordinates: Coordinates[][] };
	interface FeatureProps {
		id?: string;
		geometry: Geometry;
		style?: { stroke?: { color: string; width: number }[]; fill?: string; zIndex?: number };
	}
	interface Feature { update: (props: Partial<FeatureProps>) => void; }
	interface ListenerProps {
		onActionStart?: (event: { type: string }) => void;
	}
	interface Api {
		ready: Promise<unknown>;
		YMap: new (container: HTMLElement, props: MapProps, children?: Entity[]) => Map;
		YMapMarker: new (props: MarkerProps, content: HTMLElement) => Marker;
		YMapFeature: new (props: FeatureProps) => Feature;
		YMapListener: new (props: ListenerProps) => Entity;
		YMapDefaultSchemeLayer: new (props: Record<string, never>) => Entity;
		YMapDefaultFeaturesLayer: new (props: Record<string, never>) => Entity;
	}
}
interface Window {
	ymaps3?: RouteYmaps.Api;
	AppSrv?: RouteYandex.AppSrvConstructor;
	TRACK_CONSTANTS?: { INI_ZOOM?: unknown };
}
