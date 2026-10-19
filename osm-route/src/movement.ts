namespace RouteOsm {
	export interface MovementOptions {
		durationMs: number;
		maxGapMs: number;
		maxDistanceM: number;
	}

	interface PositionTime {
		value: number;
		kind: "local" | "offset";
	}

	/** Compare SQL/ISO times without assigning the customer's timezone to unzoned data. */
	export const positionTime = (period: string | null): PositionTime | null => {
		if (!period) { return null; }
		const match = /^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})(?::(\d{2})(?:\.(\d{1,9}))?)?(Z|[+-]\d{2}(?::?\d{2})?)?$/i.exec(period.trim());
		if (!match) { return null; }
		const [year, month, day, hours, minutes, seconds] = [match[1], match[2], match[3], match[4], match[5], match[6] ?? "0"].map(Number);
		const date = new Date(0);
		date.setUTCFullYear(year, month - 1, day);
		date.setUTCHours(hours, minutes, seconds, 0);
		if (date.getUTCFullYear() !== year || date.getUTCMonth() !== month - 1 || date.getUTCDate() !== day ||
			date.getUTCHours() !== hours || date.getUTCMinutes() !== minutes || date.getUTCSeconds() !== seconds) { return null; }
		const zone = match[8];
		let offset = 0;
		if (zone && zone.toUpperCase() !== "Z") {
			const digits = zone.slice(1).replace(":", "");
			const zoneHours = Number(digits.slice(0, 2));
			const zoneMinutes = Number(digits.slice(2) || "0");
			if (zoneHours > 23 || zoneMinutes > 59) { return null; }
			offset = (zoneHours * 60 + zoneMinutes) * (zone[0] === "+" ? 1 : -1);
		}
		return { value: date.getTime() + Number(`0.${match[7] ?? "0"}`) * 1000 - offset * 60000, kind: zone ? "offset" : "local" };
	};

	/** Unknown/unzoned and offset-qualified clocks are never guessed to be comparable. */
	export const createPositionOrder = (initial: string | null): ((period: string | null) => boolean) => {
		const latest: Partial<Record<PositionTime["kind"], number>> = {};
		const accept = (period: string | null): boolean => {
			const time = positionTime(period);
			if (!time) { return true; }
			const previous = latest[time.kind];
			if (previous !== undefined && time.value < previous) { return false; }
			latest[time.kind] = time.value;
			return true;
		};
		accept(initial);
		return accept;
	};

	export const movementOptions = (input?: Partial<MovementOptions>): MovementOptions => {
		const value = (number: unknown, fallback: number, min: number, max: number): number => {
			const parsed = numberValue(number);
			return parsed === null ? fallback : Math.min(max, Math.max(min, parsed));
		};
		return {
			durationMs: value(input?.durationMs, 1200, 0, 5000),
			maxGapMs: value(input?.maxGapMs, 30000, 1000, 300000),
			maxDistanceM: value(input?.maxDistanceM, 1000, 1, 10000),
		};
	};

	/** Ground distance, not Web Mercator metres (which vary with latitude). */
	const distanceMeters = (from: LonLat, to: LonLat): number => {
		const radians = Math.PI / 180;
		const lat = (to[1] - from[1]) * radians;
		const lon = (to[0] - from[0]) * radians;
		const a = Math.sin(lat / 2) ** 2 + Math.cos(from[1] * radians) * Math.cos(to[1] * radians) * Math.sin(lon / 2) ** 2;
		return 12742017.6 * Math.asin(Math.sqrt(Math.min(1, Math.max(0, a))));
	};

	export interface AnimationClock {
		now: () => number;
		request: (callback: FrameRequestCallback) => number;
		cancel: (id: number) => void;
	}

	export interface VehicleMovement {
		update: (position: Position, projected: number[]) => void;
		pause: () => void;
		resume: () => void;
		setReducedMotion: (enabled: boolean) => void;
		isAnimating: () => boolean;
		dispose: () => void;
	}

	/** A finite, local rendering loop. It never fetches data or predicts beyond a GPS fix. */
	export const createVehicleMovement = (
		options: MovementOptions,
		draw: (point: number[], animated: boolean) => void,
		clock: AnimationClock = {
			now: () => performance.now(),
			request: (callback) => window.requestAnimationFrame(callback),
			cancel: (id) => window.cancelAnimationFrame(id),
		},
	): VehicleMovement => {
		let displayed: number[] | null = null;
		let target: number[] | null = null;
		let origin: number[] | null = null;
		let lastPosition: Position | null = null;
		let lastArrival: number | null = null;
		let frame: number | null = null;
		let startedAt = 0;
		let lastFrameAt = 0;
		let paused = false;
		let reducedMotion = false;
		let snapNext = false;
		let disposed = false;
		const cancel = (): void => {
			if (frame !== null) { clock.cancel(frame); frame = null; }
			origin = null;
		};
		const render = (point: number[], animated: boolean): void => {
			displayed = [...point];
			draw([...point], animated);
		};
		const finish = (): void => {
			cancel();
			if (target) { render(target, false); }
		};
		const tick = (now: number): void => {
			frame = null;
			if (disposed || paused || !origin || !target) { return; }
			// A suspended/busy browser must not replay an old journey when frames resume.
			if (now - lastFrameAt > options.maxGapMs) { finish(); return; }
			lastFrameAt = now;
			const progress = Math.min(1, Math.max(0, (now - startedAt) / options.durationMs));
			render(progress === 1 ? target : [
				origin[0] + (target[0] - origin[0]) * progress,
				origin[1] + (target[1] - origin[1]) * progress,
			], true);
			if (progress < 1) { frame = clock.request(tick); } else { origin = null; }
		};
		return {
			update: (position, projected) => {
				if (disposed || projected.length !== 2 || !projected.every(Number.isFinite)) { return; }
				const now = clock.now();
				const previousTime = positionTime(lastPosition?.period ?? null);
				const nextTime = positionTime(position.period);
				const timeGap = previousTime && nextTime && previousTime.kind === nextTime.kind ? nextTime.value - previousTime.value : 0;
				const longGap = (lastArrival !== null && now - lastArrival > options.maxGapMs) || timeGap > options.maxGapMs;
				const longJump = lastPosition !== null && distanceMeters(lastPosition.coordinates, position.coordinates) > options.maxDistanceM;
				// Avoid sweeping around the whole projected world across the antimeridian.
				const worldJump = displayed !== null && Math.abs(projected[0] - displayed[0]) > 20037508.342789244;
				const unchanged = target !== null && target[0] === projected[0] && target[1] === projected[1];
				lastPosition = { coordinates: [...position.coordinates], period: position.period };
				lastArrival = now;
				target = [...projected];
				if (!displayed || paused || reducedMotion || snapNext || options.durationMs === 0 || longGap || longJump || worldJump) {
					snapNext = false;
					finish();
					return;
				}
				// Repeated stationary fixes must not restart an in-progress transition.
				if (unchanged) { return; }
				if (displayed[0] === target[0] && displayed[1] === target[1]) { finish(); return; }
				cancel();
				origin = [...displayed];
				startedAt = now;
				lastFrameAt = now;
				frame = clock.request(tick);
			},
			pause: () => { if (!disposed) { paused = true; finish(); } },
			resume: () => { if (!disposed && paused) { paused = false; snapNext = true; } },
			setReducedMotion: (enabled) => {
				if (disposed || reducedMotion === enabled) { return; }
				reducedMotion = enabled;
				if (enabled) { finish(); }
			},
			isAnimating: () => frame !== null,
			dispose: () => { disposed = true; cancel(); },
		};
	};
}
