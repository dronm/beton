namespace RouteGeoTests {
	let count = 0;
	const check = (value: boolean, message: string): void => { count++; if (!value) { throw new Error(message); } };
	const near = (a: number, b: number): boolean => Math.abs(a - b) < 1e-8;
	for (const coordinate of [[0, 0], [60.58, 56.83], [-120, -50], [179.99, 80]] as RouteYandex.LonLat[]) {
		const back = RouteYandex.unproject(RouteYandex.project(coordinate));
		check(near(back[0], coordinate[0]) && near(back[1], coordinate[1]), "Mercator round trip");
	}
	check(RouteYandex.project([0, 90]).every(Number.isFinite), "Polar projection finite");
	check(RouteYandex.fitLocation([], 400, 300, 16) === null, "No fit for missing geometry");
	const single = RouteYandex.fitLocation([[60, 56]], 400, 300, 16)!;
	check(single.zoom === 16 && near(single.center[0], 60), "Single point capped zoom");
	const points: RouteYandex.LonLat[] = [[60, 56], [61, 57]];
	const small = RouteYandex.fitLocation(points, 320, 270, 16)!;
	const big = RouteYandex.fitLocation(points, 1440, 900, 16)!;
	check(big.zoom > small.zoom, "Responsive fit zoom");
	check(small.zoom > 1 && small.zoom < 16, "Nondegenerate route fit");
	check(RouteYandex.fitLocation(points, 0, 0, 16)!.zoom >= 1, "Zero-size container safely bounded");
	check(RouteYandex.parseZone(null)?.length === 0, "Missing zone");
	check(RouteYandex.parseZone({ type: "MultiPolygon", coordinates: [] })?.length === 0, "Empty multipolygon");
	for (const invalid of [{}, { type: "Point", coordinates: [1, 2] }, { type: "Polygon", coordinates: [[[]]] }, { type: "Polygon", coordinates: [[[181, 0], [1, 0], [1, 1]]] }]) {
		check(RouteYandex.parseZone(invalid) === null, "Invalid zone rejected");
	}
	const polygon: RouteYandex.ZonePolygon = [[[0, 0], [10, 0], [10, 10], [0, 10], [0, 0]], [[4, 2], [6, 2], [6, 8], [4, 8], [4, 2]]];
	const parsed = RouteYandex.parseZone({ type: "Polygon", coordinates: polygon });
	check(parsed?.length === 1 && parsed[0].length === 2, "Polygon holes preserved");
	const point = RouteYandex.zoneInterior(polygon)!;
	check(point !== null && point[0] > 0 && point[0] < 10 && point[1] > 0 && point[1] < 10, "Interior lies within outer polygon");
	check(!(point[0] > 4 && point[0] < 6 && point[1] > 2 && point[1] < 8), "Interior avoids hole");
	const concave: RouteYandex.ZonePolygon = [[[0, 0], [10, 0], [10, 2], [2, 2], [2, 10], [0, 10], [0, 0]]];
	const inside = RouteYandex.zoneInterior(concave)!;
	check(inside[0] < 2 || inside[1] < 2, "Concave interior avoids empty centre");
	const closed = RouteYandex.parseZone({ type: "Polygon", coordinates: [[[0, 0], [1, 0], [0, 1]]] });
	check(closed?.[0][0].length === 4, "Ring closure normalized");
	check(RouteYandex.parseZone({ type: "MultiPolygon", coordinates: [polygon, concave] })?.length === 2, "Multipolygon supported");
	console.log(`Geography checks passed: ${count}`);
}
