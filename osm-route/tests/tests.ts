declare const process: { exitCode?: number };
namespace RouteOsmTests {
	let checks = 0;
	const assert = (condition: unknown, message: string): void => {
		checks++;
		if (!condition) { throw new Error(message); }
	};
	const equal = (actual: unknown, expected: unknown, message: string): void =>
		assert(JSON.stringify(actual) === JSON.stringify(expected), `${message}: ${JSON.stringify(actual)} != ${JSON.stringify(expected)}`);
	const tick = async (): Promise<void> => { for (let i = 0; i < 12; i++) { await Promise.resolve(); } };
	const deferred = <T>(): { promise: Promise<T>; resolve: (value: T) => void; reject: (reason: unknown) => void } => {
		let resolve!: (value: T) => void;
		let reject!: (reason: unknown) => void;
		const promise = new Promise<T>((done, fail) => { resolve = done; reject = fail; });
		return { promise, resolve, reject };
	};
	const config = {
		id: 101, trackerId: "tracker-7",
		appSrv: { host: "app.example.test", port: 443, appId: "test", token: "101:original-md5", tokenExpires: null },
		routeUrl: "long_route_rest.php?id=101", readToken: "secret", requestTimeoutMs: 1000,
	} as RouteOsm.Config;

	const harness = () => {
		const calls: string[] = [];
		let subscription!: RouteOsm.AppSrvSubscription;
		let options!: RouteOsm.AppSrvOptions;
		const positions: RouteOsm.Position[] = [];
		const distances: (number | null)[] = [];
		const routes: RouteOsm.LonLat[][] = [];
		const requests: ReturnType<typeof deferred<RouteOsm.LonLat[]>>[] = [];
		const signals: AbortSignal[] = [];
		const errors: unknown[] = [];
		let reloads = 0;
		let received = 0;
		class FakeAppSrv implements RouteOsm.AppSrvClient {
			constructor(value: RouteOsm.AppSrvOptions) { options = value; calls.push("construct"); }
			connect = (): void => { calls.push("connect"); };
			subscribe = (value: RouteOsm.AppSrvSubscription): void => { calls.push("subscribe"); subscription = value; };
		}
		const stop = RouteOsm.subscribe(FakeAppSrv, config, {
			position: (position) => positions.push(position),
			distance: (distance) => distances.push(distance),
			route: (points) => routes.push(points),
			fetchRoute: (signal) => { signals.push(signal); const request = deferred<RouteOsm.LonLat[]>(); requests.push(request); return request.promise; },
			error: (error) => errors.push(error),
			reload: () => { reloads++; },
			received: () => { received++; },
		});
		return {
			calls, options, subscription, positions, distances, routes, requests, signals, errors, stop,
			reloads: () => reloads, received: () => received,
			emit: (params: unknown, eventId = "Vehicle.position.tracker-7") => subscription.onEvent({ eventId, params }),
		};
	};

	const run = async (): Promise<void> => {
		for (const invalid of [null, undefined, true, false, "", " ", "0xFF", "1x", NaN, Infinity, {}, []]) {
			equal(RouteOsm.numberValue(invalid), null, `invalid number ${String(invalid)}`);
		}
		for (const [input, expected] of [[0, 0], [" 12.5 ", 12.5], ["-1e2", -100], [".5", 0.5]]) {
			equal(RouteOsm.numberValue(input), expected, "numeric input");
		}
		equal(RouteOsm.coordinates("60.5", "56.2"), [60.5, 56.2], "longitude comes first");
		equal(RouteOsm.coordinates(0, 0), [0, 0], "zero coordinate");
		equal(RouteOsm.coordinates(181, 30), null, "invalid longitude");
		equal(RouteOsm.coordinates(30, 91), null, "invalid latitude");
		equal(RouteOsm.parsePosition(null), null, "missing GPS");
		equal(RouteOsm.parsePosition({ lon: 60, lat: 56 }), { coordinates: [60, 56], period: null }, "missing timestamp");
		equal(RouteOsm.parseRoute("60 56, 61 57"), [[60, 56], [61, 57]], "legacy coordinate string");
		equal(RouteOsm.parseRoute("60\t56,\n61 57"), [[60, 56], [61, 57]], "whitespace");
		equal(RouteOsm.parseRoute("LINESTRING (60 56,61 57)"), [[60, 56], [61, 57]], "WKT");
		equal(RouteOsm.parseRoute("0 0"), [[0, 0]], "one-point route");
		for (const empty of [null, "", "  ", "LINESTRING EMPTY"]) { equal(RouteOsm.parseRoute(empty), [], "empty route"); }
		for (const invalid of [true, {}, [], undefined, "60 56,,61 57", "60 56,broken,61 57", "181 0", "60 56 5", "1x 2", "60 56,"]) {
			equal(RouteOsm.parseRoute(invalid), null, "reject whole malformed line");
		}
		equal(RouteOsm.formatDistance(0), "0 м", "zero remaining distance");
		equal(RouteOsm.formatDistance(950.9), "950 м", "metres");
		equal(RouteOsm.formatDistance(1500), "1,5 км", "kilometres");
		equal(RouteOsm.formatDistance(null), "—", "unknown distance");
		equal(RouteOsm.formatDistance(-1), "—", "negative distance");
		equal(RouteOsm.formatPeriod("2026-09-21T08:09:10+05:00"), "08:09:10 · 21.09", "source timezone preserved");
		equal(RouteOsm.formatPeriod(null), "—", "missing period");

		const h = harness();
		equal(h.calls, ["construct", "connect", "subscribe"], "original AppSrv call order");
		equal(h.options, config.appSrv, "original AppSrv options");
		equal(h.subscription.events, [
			{ id: "Vehicle.position.tracker-7" }, { id: "Vehicle.route_redraw.tracker-7" },
			{ id: "Vehicle.route_end.tracker-7" }, { id: "User.logout" },
		], "exact event subscriptions");
		await tick();
		equal(h.requests.length, 0, "no startup fetch");
		h.subscription.onEvent(null);
		h.subscription.onEvent({});
		h.emit(null);
		h.emit({ lon: 10, lat: 10, route_rest: "1 1" }, "Vehicle.position.other");
		equal(h.received(), 0, "ignore malformed/unrelated messages");
		equal(h.routes.length, 0, "ignore other tracker route");
		h.emit({ lon: "60.1", lat: "56.2", period: "2026-09-21T09:00:00", route_rest_len: 0, route_rest: "60.1 56.2, 60.2 56.3" });
		equal(h.positions[0].coordinates, [60.1, 56.2], "position callback");
		equal(h.distances, [0], "distance zero from event");
		equal(h.routes[0], [[60.1, 56.2], [60.2, 56.3]], "route from position event");
		h.emit({ route_rest: "" }, "Vehicle.route_redraw.tracker-7");
		equal(h.routes[1], [], "explicit empty redraw clears route");
		h.emit({ route_rest: null });
		equal(h.routes[2], [], "explicit null route clears route");
		h.emit({ route_rest: "broken" });
		equal(h.errors.length, 1, "invalid route reported");
		equal(h.routes.length, 3, "invalid route preserves last geometry");
		h.emit({ route_rest_len: "bad" });
		equal(h.distances, [0], "invalid distance ignored");
		h.emit({ route_rest_len: null });
		equal(h.distances, [0, null], "unknown distance clears old value");
		h.emit({ long_route_rest: "true" });
		await tick();
		equal(h.requests.length, 0, "only boolean true starts fetch");
		h.emit({ long_route_rest: true });
		await tick();
		equal(h.requests.length, 1, "long route fetched on demand");
		h.requests[0].resolve([[10, 20]]);
		await tick();
		equal(h.routes[3], [[10, 20]], "HTTP route applied");
		equal(h.requests.length, 1, "no fetch after response");

		const ordered = harness();
		ordered.emit({ lon: 60, lat: 56, period: "2026-09-21T09:00:10+05:00", route_rest_len: 120, route_rest: "60 56,60.01 56" });
		ordered.emit({ lon: 59, lat: 56, period: "2026-09-21T09:00:09+05:00", route_rest_len: 999, long_route_rest: true });
		await tick();
		equal(ordered.positions.length, 1, "older GPS event does not reach map");
		equal(ordered.distances, [120], "older GPS packet cannot regress distance");
		equal(ordered.routes.length, 1, "older GPS packet cannot regress route");
		equal(ordered.requests.length, 0, "older GPS packet cannot fetch obsolete route");
		ordered.emit({ lon: 60.001, lat: 56, period: "2026-09-21T04:00:10Z" });
		equal(ordered.positions.length, 2, "equal timestamp correction accepted");
		ordered.emit({ lon: 60.002, lat: 56 });
		equal(ordered.positions.length, 3, "fix without period remains compatible");
		ordered.emit({ route_rest: "60 56" }, "Vehicle.route_redraw.tracker-7");
		equal(ordered.routes.length, 2, "independent route redraw unaffected by position ordering");

		const race = harness();
		race.emit({ long_route_rest: true });
		await tick();
		race.emit({ route_rest: "30 40" });
		assert(race.signals[0].aborted, "new inline geometry aborts pending request");
		race.requests[0].resolve([[10, 20]]);
		await tick();
		equal(race.routes, [[[30, 40]]], "late response cannot overwrite inline event");

		const burst = harness();
		burst.emit({ long_route_rest: true });
		await tick();
		for (let i = 0; i < 10; i++) { burst.emit({ long_route_rest: true }); }
		equal(burst.requests.length, 1, "burst does not start concurrent requests");
		burst.requests[0].resolve([[1, 2]]);
		await tick();
		equal(burst.routes, [], "obsolete response discarded");
		equal(burst.requests.length, 2, "one coalesced follow-up for newer events");
		burst.requests[1].resolve([[3, 4]]);
		await tick();
		equal(burst.routes, [[[3, 4]]], "latest route applied");
		equal(burst.requests.length, 2, "no polling after queue drained");

		const failure = harness();
		failure.emit({ long_route_rest: true });
		await tick();
		failure.requests[0].reject(new Error("network down"));
		await tick();
		equal(failure.errors.length, 1, "HTTP error reported");
		equal(failure.requests.length, 1, "no automatic retries");

		for (const event of ["Vehicle.route_end.tracker-7", "User.logout"]) {
			const ending = harness();
			ending.emit({}, event);
			ending.emit({}, event);
			ending.emit({ lon: 0, lat: 0 });
			equal(ending.reloads(), 1, `${event}: reload once`);
			equal(ending.positions.length, 0, `${event}: ignore messages after stop`);
		}
		const wake = harness();
		wake.subscription.onWakeup();
		wake.subscription.onWakeup();
		equal(wake.reloads(), 1, "onWakeup reload once");
		const stopped = harness();
		stopped.stop();
		stopped.subscription.onWakeup();
		stopped.emit({ long_route_rest: true });
		await tick();
		equal(stopped.requests.length, 0, "stopped subscriber does no work");
		equal(stopped.reloads(), 0, "stopped subscriber does not reload");

		const originalFetch = globalThis.fetch;
		const requests: { url: string; init?: RequestInit }[] = [];
		globalThis.fetch = async (url, init) => {
			requests.push({ url: String(url), init });
			return new Response(JSON.stringify({ route: "60 56" }), { status: 200, headers: { "Content-Type": "application/json" } });
		};
		try {
			equal(await RouteOsm.loadRoute(config, new AbortController().signal), [[60, 56]], "HTTP response parsed");
			equal(requests[0].url, config.routeUrl, "shipment-scoped endpoint");
			equal(requests[0].init?.method, "GET", "read method");
			equal((requests[0].init?.headers as Record<string, string>)["X-Route-Token"], "secret", "read token header");
			equal(requests[0].init?.cache, "no-store", "route API avoids stale response");
			await RouteOsm.requestJson("location.php?id=101", "write-token", 1000, { body: { lon: 60, lat: 56 } });
			equal(requests[1].init?.method, "POST", "location write method");
			equal(requests[1].init?.body, '{"lon":60,"lat":56}', "location JSON");
			const aborted = new AbortController();
			aborted.abort();
			try { await RouteOsm.loadRoute(config, aborted.signal); assert(false, "aborted call must throw"); }
			catch (error) { assert(error instanceof DOMException && error.name === "AbortError", "caller abort respected"); }
			equal(requests.length, 2, "already-aborted request never reaches fetch");
			globalThis.fetch = async () => new Response('{"error":"Expired"}', { status: 403 });
			try { await RouteOsm.loadRoute(config, new AbortController().signal); assert(false, "403 must throw"); }
			catch (error) { assert(error instanceof RouteOsm.HttpError && error.status === 403, "HTTP status preserved"); }
			globalThis.fetch = async () => new Response("<html>error</html>", { status: 500 });
			try { await RouteOsm.loadRoute(config, new AbortController().signal); assert(false, "HTML response must throw"); }
			catch (error) { assert(error instanceof RouteOsm.HttpError && error.status === 500, "invalid response handled"); }
			globalThis.fetch = async () => new Response('{"route":"broken"}', { status: 200 });
			try { await RouteOsm.loadRoute(config, new AbortController().signal); assert(false, "bad geometry must throw"); }
			catch (error) { assert(error instanceof Error, "bad HTTP geometry handled"); }
			globalThis.fetch = async (_url, init) => new Promise((_resolve, reject) => {
				init?.signal?.addEventListener("abort", () => reject(new DOMException("Aborted", "AbortError")), { once: true });
			});
			try { await RouteOsm.requestJson("test", "token", 5); assert(false, "timeout must throw"); }
			catch (error) { assert(error instanceof Error && error.message.includes("вовремя"), "single request timeout reported"); }
		} finally { globalThis.fetch = originalFetch; }
		console.log(`Frontend checks passed: ${checks}`);
	};
	void run().catch((error: unknown) => { console.error(error); process.exitCode = 1; });
}
