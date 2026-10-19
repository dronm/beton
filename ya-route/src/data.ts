namespace RouteYandex {
	export const isRecord = (value: unknown): value is Record<string, unknown> =>
		typeof value === "object" && value !== null && !Array.isArray(value);

	export const numberValue = (value: unknown): number | null => {
		if (typeof value !== "number" && typeof value !== "string") {
			return null;
		}
		if (typeof value === "string" && !/^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$/.test(value.trim())) {
			return null;
		}
		const number = Number(value);
		return Number.isFinite(number) ? number : null;
	};

	export const coordinates = (lon: unknown, lat: unknown): LonLat | null => {
		const x = numberValue(lon);
		const y = numberValue(lat);
		return x !== null && y !== null && Math.abs(x) <= 180 && Math.abs(y) <= 90 ? [x, y] : null;
	};

	export const parsePosition = (value: unknown): Position | null => {
		if (!isRecord(value)) {
			return null;
		}
		const point = coordinates(value.lon, value.lat);
		return point ? { coordinates: point, period: typeof value.period === "string" ? value.period : null } : null;
	};

	/** The existing protocol uses "lon lat,lon lat" (NOT Leaflet's lat/lon order). */
	export const parseRoute = (value: unknown): LonLat[] | null => {
		if (value === null || value === "") {
			return [];
		}
		if (typeof value !== "string") {
			return null;
		}
		let text = value.trim();
		if (text === "" || /^LINESTRING\s+EMPTY$/i.test(text)) {
			return [];
		}
		const wkt = /^LINESTRING\s*\((.*)\)$/is.exec(text);
		if (wkt) {
			text = wkt[1];
		}
		const result: LonLat[] = [];
		for (const pair of text.split(",")) {
			const parts = pair.trim().split(/\s+/);
			const point = parts.length === 2 ? coordinates(parts[0], parts[1]) : null;
			if (!point) {
				// Never skip a bad vertex and invent a straight segment across the gap.
				return null;
			}
			result.push(point);
		}
		return result;
	};

	export const formatDistance = (value: unknown): string => {
		const distance = numberValue(value);
		if (distance === null || distance < 0) {
			return "—";
		}
		return distance < 1000 ? `${Math.floor(distance)} м` :
			`${new Intl.NumberFormat("ru-RU", { maximumFractionDigits: 1 }).format(distance / 1000)} км`;
	};

	/** Keep the source time: do not reinterpret an unzoned SQL timestamp as UTC. */
	export const formatPeriod = (value: string | null): string => {
		if (!value) {
			return "—";
		}
		const match = /^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}:\d{2}(?::\d{2})?)/.exec(value);
		return match ? `${match[4]} · ${match[3]}.${match[2]}` : "—";
	};
}
