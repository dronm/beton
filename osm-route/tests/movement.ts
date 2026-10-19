/** Deterministic frame-clock tests: no browser, real time, network, or OpenLayers required. */
namespace RouteMovementTests {
	let checks = 0;
	const assert = (condition: unknown, message: string): void => {
		checks++;
		if (!condition) { throw new Error(message); }
	};
	const equal = (actual: unknown, expected: unknown, message: string): void =>
		assert(JSON.stringify(actual) === JSON.stringify(expected), `${message}: ${JSON.stringify(actual)} != ${JSON.stringify(expected)}`);
	const harness = (options: Partial<RouteOsm.MovementOptions> = {}) => {
		let now = 0;
		let sequence = 0;
		const frames = new Map<number, FrameRequestCallback>();
		const rendered: { point: number[]; animated: boolean }[] = [];
		const controller = RouteOsm.createVehicleMovement(RouteOsm.movementOptions(options), (point, animated) => {
			rendered.push({ point, animated });
		}, {
			now: () => now,
			request: (callback) => { const id = sequence++; frames.set(id, callback); return id; },
			cancel: (id) => { frames.delete(id); },
		});
		const update = (x: number, y = 0, period: string | null = null): void =>
			controller.update({ coordinates: [60 + x / 100000, 56 + y / 100000], period }, [x, y]);
		return {
			controller, update, rendered,
			point: () => rendered[rendered.length - 1]?.point,
			pending: () => frames.size,
			elapse: (ms: number) => { now += ms; },
			step: (ms: number) => {
				now += ms;
				const callbacks = [...frames.values()];
				frames.clear();
				callbacks.forEach((callback) => callback(now));
			},
		};
	};

	equal(RouteOsm.movementOptions(), { durationMs: 1200, maxGapMs: 30000, maxDistanceM: 1000 }, "default animation settings");
	equal(RouteOsm.movementOptions({ durationMs: -1, maxGapMs: Infinity, maxDistanceM: 20000 }), { durationMs: 0, maxGapMs: 30000, maxDistanceM: 10000 }, "settings are bounded");
	equal(RouteOsm.movementOptions({ durationMs: 9000, maxGapMs: 1, maxDistanceM: 0 }), { durationMs: 5000, maxGapMs: 1000, maxDistanceM: 1 }, "maximum duration and minimum safeguards");
	for (const invalid of [null, "", "yesterday", "2026-02-30 10:00:00", "2026-13-01 00:00:00", "2026-01-01 24:00:00", "2026-01-01 10:61:00", "2026-01-01 10:00:00+25:00", "2026-01-01 10:00:00+05:61"]) {
		equal(RouteOsm.positionTime(invalid), null, `invalid/unknown position time: ${invalid}`);
	}
	const offsetTime = RouteOsm.positionTime("2026-09-21 09:00:00.123456+05");
	assert(offsetTime?.kind === "offset", "PostgreSQL hour-only offset supported");
	equal(offsetTime, RouteOsm.positionTime("2026-09-21T04:00:00.123456Z"), "UTC and offset instants equivalent");
	equal(offsetTime, RouteOsm.positionTime("2026-09-21T09:00:00.123456+0500"), "compact offset supported");
	assert(RouteOsm.positionTime("2024-02-29 10:00")?.kind === "local", "leap date and SQL minute precision supported");
	const order = RouteOsm.createPositionOrder("2026-09-21 09:00:00+05:00");
	assert(!order("2026-09-21T03:59:59Z"), "older instant rejected against bootstrap");
	assert(order("2026-09-21T04:00:00Z"), "equal time accepted for corrections");
	assert(order(null) && order("unknown"), "missing/unknown time cannot prove staleness");
	assert(!order("2026-09-21 08:59:59+05"), "unknown times do not erase watermark");
	assert(order("2026-09-21 03:00:00"), "unzoned time not compared to offset time");
	assert(!order("2026-09-21 02:59:59"), "unzoned times comparable with each other");
	assert(order("2026-09-21T04:00:00.000002Z"), "submillisecond precision supported");
	assert(!order("2026-09-21T04:00:00.000001Z"), "microsecond timestamp regression rejected");

	const h = harness();
	h.update(0);
	equal(h.point(), [0, 0], "first fix shown immediately");
	equal(h.pending(), 0, "first fix schedules no frames");
	h.update(120, 60);
	equal(h.point(), [0, 0], "incoming fix does not teleport marker");
	equal(h.pending(), 1, "only one frame scheduled");
	h.step(300);
	equal(h.point(), [30, 15], "quarter progress uses elapsed time");
	h.step(300);
	equal(h.point(), [60, 30], "half progress uses elapsed time");
	h.update(180, 90);
	equal(h.point(), [60, 30], "retarget begins at actually displayed position");
	equal(h.pending(), 1, "retarget cancels old frame including ID zero");
	h.step(600);
	equal(h.point(), [120, 60], "interrupted transition follows new destination");
	h.step(600);
	equal(h.point(), [180, 90], "ends at exact latest coordinates");
	equal(h.pending(), 0, "no frames after transition completes");
	const count = h.rendered.length;
	h.step(60000);
	equal(h.rendered.length, count, "no extrapolation or idle rendering");

	const duplicate = harness();
	duplicate.update(0);
	duplicate.update(120);
	duplicate.step(300);
	duplicate.update(120);
	duplicate.step(900);
	equal(duplicate.point(), [120, 0], "duplicate fix does not restart transition");
	equal(duplicate.pending(), 0, "duplicates do not keep frame loop alive");
	duplicate.update(120);
	equal(duplicate.pending(), 0, "stationary repeated fix stays idle");

	const atDisplayed = harness();
	atDisplayed.update(0);
	atDisplayed.update(120);
	atDisplayed.step(600);
	atDisplayed.update(60);
	equal(atDisplayed.point(), [60, 0], "retarget at displayed point does not move marker");
	equal(atDisplayed.pending(), 0, "retarget at displayed point stops redundant animation");

	const receiptGap = harness();
	receiptGap.update(0);
	receiptGap.elapse(30001);
	receiptGap.update(120);
	equal(receiptGap.point(), [120, 0], "long receipt gap snaps instead of replaying travel");
	equal(receiptGap.pending(), 0, "receipt gap schedules no frames");
	const gpsGap = harness();
	gpsGap.update(0, 0, "2026-09-21 09:00:00+05:00");
	gpsGap.update(120, 0, "2026-09-21 09:01:00+05:00");
	equal(gpsGap.point(), [120, 0], "GPS time gap snaps even when events arrive together");
	const jump = harness();
	jump.update(0);
	jump.update(5000);
	equal(jump.point(), [5000, 0], "large ground-distance jump is not animated");
	const latitude = harness({ maxDistanceM: 100 });
	latitude.update(0);
	latitude.controller.update({ coordinates: [60.001, 56], period: null }, [199, 0]);
	assert(latitude.controller.isAnimating(), "ground distance at 56 degrees is not Web Mercator distance");
	const world = harness();
	world.controller.update({ coordinates: [179.999, 0], period: null }, [20037400, 0]);
	world.controller.update({ coordinates: [-179.999, 0], period: null }, [-20037400, 0]);
	equal(world.point(), [-20037400, 0], "antimeridian does not animate around the world");
	equal(world.pending(), 0, "antimeridian snap schedules no frames");
	const disabled = harness({ durationMs: 0 });
	disabled.update(0);
	disabled.update(120);
	equal(disabled.point(), [120, 0], "duration zero disables animation");
	equal(disabled.pending(), 0, "disabled animation has no frame loop");
	const stalled = harness();
	stalled.update(0);
	stalled.update(120);
	stalled.step(31000);
	equal(stalled.point(), [120, 0], "long frame suspension finishes latest fix immediately");
	equal(stalled.rendered[stalled.rendered.length - 1].animated, false, "suspension is a snap not stale playback");

	const hidden = harness();
	hidden.update(0);
	hidden.update(120);
	hidden.step(300);
	hidden.controller.pause();
	equal(hidden.point(), [120, 0], "hiding page settles latest known fix");
	equal(hidden.pending(), 0, "hiding page cancels scheduled frame");
	hidden.update(240);
	equal(hidden.point(), [240, 0], "hidden fixes applied immediately");
	equal(hidden.pending(), 0, "hidden updates cannot schedule frames");
	hidden.controller.resume();
	equal(hidden.pending(), 0, "showing page does not replay hidden fixes");
	hidden.update(360);
	equal(hidden.point(), [360, 0], "first update after resume snaps");
	hidden.update(480);
	assert(hidden.controller.isAnimating(), "subsequent visible fixes animate again");
	hidden.controller.setReducedMotion(true);
	equal(hidden.point(), [480, 0], "enabling reduced motion finishes active transition");
	equal(hidden.pending(), 0, "reduced motion cancels frame loop");
	hidden.update(600);
	equal(hidden.point(), [600, 0], "reduced-motion updates immediate");
	hidden.controller.setReducedMotion(false);
	hidden.update(720);
	assert(hidden.controller.isAnimating(), "motion preference can re-enable future transitions");
	hidden.controller.dispose();
	const disposedCount = hidden.rendered.length;
	equal(hidden.pending(), 0, "dispose cancels frame loop");
	hidden.update(840);
	hidden.controller.resume();
	hidden.controller.pause();
	hidden.controller.setReducedMotion(true);
	hidden.step(5000);
	equal(hidden.rendered.length, disposedCount, "disposed controller never mutates marker");
	const invalid = harness();
	invalid.update(0);
	invalid.controller.update({ coordinates: [60, 56], period: null }, [NaN, 1]);
	invalid.controller.update({ coordinates: [60, 56], period: null }, [1]);
	equal(invalid.point(), [0, 0], "invalid projected coordinates leave marker intact");
	equal(invalid.pending(), 0, "invalid projection does not schedule frame");

	console.log(`Movement checks passed: ${checks}`);
}
