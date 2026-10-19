namespace RouteYandex {
	const RADIUS = 6378137;
	const WORLD = 2 * Math.PI * RADIUS;
	const MAX_LATITUDE = 85.0511287798066;

	/** Only rendering uses Mercator. Incoming GPS/route data remains [longitude, latitude]. */
	export const project = (point: LonLat): LonLat => {
		const latitude = Math.max(-MAX_LATITUDE, Math.min(MAX_LATITUDE, point[1]));
		return [RADIUS * point[0] * Math.PI / 180, RADIUS * Math.log(Math.tan(Math.PI / 4 + latitude * Math.PI / 360))];
	};
	export const unproject = (point: number[]): LonLat => [
		point[0] / RADIUS * 180 / Math.PI,
		(2 * Math.atan(Math.exp(point[1] / RADIUS)) - Math.PI / 2) * 180 / Math.PI,
	];

	/** Fit the complete geometry with room for labels, controls and native copyrights. */
	export const fitLocation = (points: LonLat[], width: number, height: number, maxZoom: number): { center: LonLat; zoom: number } | null => {
		if (!points.length) { return null; }
		let minX = Infinity;
		let minY = Infinity;
		let maxX = -Infinity;
		let maxY = -Infinity;
		for (const point of points) {
			const [x, y] = project(point);
			minX = Math.min(minX, x); minY = Math.min(minY, y);
			maxX = Math.max(maxX, x); maxY = Math.max(maxY, y);
		}
		const usableWidth = Math.max(64, width - 128);
		const usableHeight = Math.max(64, height - 150);
		const scaleX = usableWidth * WORLD / (256 * Math.max(0.01, maxX - minX));
		const scaleY = usableHeight * WORLD / (256 * Math.max(0.01, maxY - minY));
		return {
			center: unproject([(minX + maxX) / 2, (minY + maxY) / 2]),
			zoom: Math.max(1, Math.min(maxZoom, Math.log2(Math.min(scaleX, scaleY)))),
		};
	};

	export type ZonePolygon = LonLat[][];
	/** Validate every ring; never render a partial polygon after a malformed vertex. */
	export const parseZone = (value: unknown): ZonePolygon[] | null => {
		if (value === null || value === undefined) { return []; }
		if (!isRecord(value) || !Array.isArray(value.coordinates)) { return null; }
		const polygons: unknown[] = value.type === "Polygon" ? [value.coordinates] : value.type === "MultiPolygon" ? value.coordinates : [];
		if (!["Polygon", "MultiPolygon"].includes(String(value.type))) { return null; }
		const result: ZonePolygon[] = [];
		for (const polygon of polygons) {
			if (!Array.isArray(polygon) || !polygon.length) { return null; }
			const rings: ZonePolygon = [];
			for (const ring of polygon) {
				if (!Array.isArray(ring) || ring.length < 3) { return null; }
				const parsed: LonLat[] = [];
				for (const vertex of ring) {
					if (!Array.isArray(vertex) || vertex.length < 2) { return null; }
					const point = coordinates(vertex[0], vertex[1]);
					if (!point) { return null; }
					parsed.push(point);
				}
				const first = parsed[0];
				const last = parsed[parsed.length - 1];
				if (first[0] !== last[0] || first[1] !== last[1]) { parsed.push([...first]); }
				if (parsed.length < 4) { return null; }
				rings.push(parsed);
			}
			result.push(rings);
		}
		return result;
	};

	/** A scanline interior point, including holes; used only when no route endpoint exists. */
	export const zoneInterior = (polygon: ZonePolygon): LonLat | null => {
		if (!polygon[0]?.length) { return null; }
		let minY = Infinity;
		let maxY = -Infinity;
		for (const point of polygon[0]) { minY = Math.min(minY, point[1]); maxY = Math.max(maxY, point[1]); }
		let best: LonLat | null = null;
		let bestWidth = 0;
		for (let step = 1; step < 20; step++) {
			const y = minY + (maxY - minY) * step / 20;
			const intersections: number[] = [];
			for (const ring of polygon) {
				for (let i = 1; i < ring.length; i++) {
					const a = ring[i - 1];
					const b = ring[i];
					if ((a[1] <= y && b[1] > y) || (b[1] <= y && a[1] > y)) {
						intersections.push(a[0] + (y - a[1]) * (b[0] - a[0]) / (b[1] - a[1]));
					}
				}
			}
			intersections.sort((a, b) => a - b);
			for (let i = 0; i + 1 < intersections.length; i += 2) {
				const width = intersections[i + 1] - intersections[i];
				if (width > bestWidth) { bestWidth = width; best = [(intersections[i + 1] + intersections[i]) / 2, y]; }
			}
		}
		return best;
	};
}
