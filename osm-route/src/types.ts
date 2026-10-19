namespace RouteOsm {
	export type LonLat = [number, number];
	export interface Position {
		coordinates: LonLat;
		period: string | null;
	}
	export interface AppSrvOptions {
		host: string;
		port: string | number | null;
		appId: string;
		token: string;
		tokenExpires: null;
	}
	export interface AppSrvSubscription {
		events: { id: string }[];
		onEvent: (event: unknown) => void;
		onWakeup: () => void;
	}
	export interface AppSrvClient {
		connect: () => void;
		subscribe: (subscription: AppSrvSubscription) => void;
	}
	export type AppSrvConstructor = new (options: AppSrvOptions) => AppSrvClient;
	export interface Config {
		id: number;
		trackerId: string;
		vehiclePlate: string;
		position: unknown;
		route: unknown;
		distance: unknown;
		destinationZone: unknown;
		center: LonLat;
		initialZoom: number | null;
		fitMaxZoom: number;
		followVehicle: boolean;
		movement?: Partial<MovementOptions>;
		showZone: boolean;
		tiles: { url: string; attribution: string; maxZoom: number };
		appSrv: AppSrvOptions;
		routeUrl: string;
		locationUrl: string;
		readToken: string;
		locationToken: string | null;
		locationEnabled: boolean;
		iconUrl: string;
		requestTimeoutMs: number;
	}
}
