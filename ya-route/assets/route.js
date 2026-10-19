"use strict";
var RouteYandex;
(function (RouteYandex) {
	RouteYandex.isRecord = (value) => typeof value === "object" && value !== null && !Array.isArray(value);
	RouteYandex.numberValue = (value) => {
		if (typeof value !== "number" && typeof value !== "string") {
			return null;
		}
		if (typeof value === "string" && !/^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$/.test(value.trim())) {
			return null;
		}
		const number = Number(value);
		return Number.isFinite(number) ? number : null;
	};
	RouteYandex.coordinates = (lon, lat) => {
		const x = RouteYandex.numberValue(lon);
		const y = RouteYandex.numberValue(lat);
		return x !== null && y !== null && Math.abs(x) <= 180 && Math.abs(y) <= 90 ? [x, y] : null;
	};
	RouteYandex.parsePosition = (value) => {
		if (!RouteYandex.isRecord(value)) {
			return null;
		}
		const point = RouteYandex.coordinates(value.lon, value.lat);
		return point ? { coordinates: point, period: typeof value.period === "string" ? value.period : null } : null;
	};
	/** The existing protocol uses "lon lat,lon lat" (NOT Leaflet's lat/lon order). */
	RouteYandex.parseRoute = (value) => {
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
		const result = [];
		for (const pair of text.split(",")) {
			const parts = pair.trim().split(/\s+/);
			const point = parts.length === 2 ? RouteYandex.coordinates(parts[0], parts[1]) : null;
			if (!point) {
				// Never skip a bad vertex and invent a straight segment across the gap.
				return null;
			}
			result.push(point);
		}
		return result;
	};
	RouteYandex.formatDistance = (value) => {
		const distance = RouteYandex.numberValue(value);
		if (distance === null || distance < 0) {
			return "—";
		}
		return distance < 1000 ? `${Math.floor(distance)} м` :
			`${new Intl.NumberFormat("ru-RU", { maximumFractionDigits: 1 }).format(distance / 1000)} км`;
	};
	/** Keep the source time: do not reinterpret an unzoned SQL timestamp as UTC. */
	RouteYandex.formatPeriod = (value) => {
		if (!value) {
			return "—";
		}
		const match = /^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}:\d{2}(?::\d{2})?)/.exec(value);
		return match ? `${match[4]} · ${match[3]}.${match[2]}` : "—";
	};
})(RouteYandex || (RouteYandex = {}));
var RouteYandex;
(function (RouteYandex) {
	const RADIUS = 6378137;
	const WORLD = 2 * Math.PI * RADIUS;
	const MAX_LATITUDE = 85.0511287798066;
	/** Only rendering uses Mercator. Incoming GPS/route data remains [longitude, latitude]. */
	RouteYandex.project = (point) => {
		const latitude = Math.max(-MAX_LATITUDE, Math.min(MAX_LATITUDE, point[1]));
		return [RADIUS * point[0] * Math.PI / 180, RADIUS * Math.log(Math.tan(Math.PI / 4 + latitude * Math.PI / 360))];
	};
	RouteYandex.unproject = (point) => [
		point[0] / RADIUS * 180 / Math.PI,
		(2 * Math.atan(Math.exp(point[1] / RADIUS)) - Math.PI / 2) * 180 / Math.PI,
	];
	/** Fit the complete geometry with room for labels, controls and native copyrights. */
	RouteYandex.fitLocation = (points, width, height, maxZoom) => {
		if (!points.length) {
			return null;
		}
		let minX = Infinity;
		let minY = Infinity;
		let maxX = -Infinity;
		let maxY = -Infinity;
		for (const point of points) {
			const [x, y] = RouteYandex.project(point);
			minX = Math.min(minX, x);
			minY = Math.min(minY, y);
			maxX = Math.max(maxX, x);
			maxY = Math.max(maxY, y);
		}
		const usableWidth = Math.max(64, width - 128);
		const usableHeight = Math.max(64, height - 150);
		const scaleX = usableWidth * WORLD / (256 * Math.max(0.01, maxX - minX));
		const scaleY = usableHeight * WORLD / (256 * Math.max(0.01, maxY - minY));
		return {
			center: RouteYandex.unproject([(minX + maxX) / 2, (minY + maxY) / 2]),
			zoom: Math.max(1, Math.min(maxZoom, Math.log2(Math.min(scaleX, scaleY)))),
		};
	};
	/** Validate every ring; never render a partial polygon after a malformed vertex. */
	RouteYandex.parseZone = (value) => {
		if (value === null || value === undefined) {
			return [];
		}
		if (!RouteYandex.isRecord(value) || !Array.isArray(value.coordinates)) {
			return null;
		}
		const polygons = value.type === "Polygon" ? [value.coordinates] : value.type === "MultiPolygon" ? value.coordinates : [];
		if (!["Polygon", "MultiPolygon"].includes(String(value.type))) {
			return null;
		}
		const result = [];
		for (const polygon of polygons) {
			if (!Array.isArray(polygon) || !polygon.length) {
				return null;
			}
			const rings = [];
			for (const ring of polygon) {
				if (!Array.isArray(ring) || ring.length < 3) {
					return null;
				}
				const parsed = [];
				for (const vertex of ring) {
					if (!Array.isArray(vertex) || vertex.length < 2) {
						return null;
					}
					const point = RouteYandex.coordinates(vertex[0], vertex[1]);
					if (!point) {
						return null;
					}
					parsed.push(point);
				}
				const first = parsed[0];
				const last = parsed[parsed.length - 1];
				if (first[0] !== last[0] || first[1] !== last[1]) {
					parsed.push([...first]);
				}
				if (parsed.length < 4) {
					return null;
				}
				rings.push(parsed);
			}
			result.push(rings);
		}
		return result;
	};
	/** A scanline interior point, including holes; used only when no route endpoint exists. */
	RouteYandex.zoneInterior = (polygon) => {
		if (!polygon[0]?.length) {
			return null;
		}
		let minY = Infinity;
		let maxY = -Infinity;
		for (const point of polygon[0]) {
			minY = Math.min(minY, point[1]);
			maxY = Math.max(maxY, point[1]);
		}
		let best = null;
		let bestWidth = 0;
		for (let step = 1; step < 20; step++) {
			const y = minY + (maxY - minY) * step / 20;
			const intersections = [];
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
				if (width > bestWidth) {
					bestWidth = width;
					best = [(intersections[i + 1] + intersections[i]) / 2, y];
				}
			}
		}
		return best;
	};
})(RouteYandex || (RouteYandex = {}));
var RouteYandex;
(function (RouteYandex) {
	/** Compare SQL/ISO times without assigning the customer's timezone to unzoned data. */
	RouteYandex.positionTime = (period) => {
		if (!period) {
			return null;
		}
		const match = /^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}):(\d{2})(?::(\d{2})(?:\.(\d{1,9}))?)?(Z|[+-]\d{2}(?::?\d{2})?)?$/i.exec(period.trim());
		if (!match) {
			return null;
		}
		const [year, month, day, hours, minutes, seconds] = [match[1], match[2], match[3], match[4], match[5], match[6] ?? "0"].map(Number);
		const date = new Date(0);
		date.setUTCFullYear(year, month - 1, day);
		date.setUTCHours(hours, minutes, seconds, 0);
		if (date.getUTCFullYear() !== year || date.getUTCMonth() !== month - 1 || date.getUTCDate() !== day ||
			date.getUTCHours() !== hours || date.getUTCMinutes() !== minutes || date.getUTCSeconds() !== seconds) {
			return null;
		}
		const zone = match[8];
		let offset = 0;
		if (zone && zone.toUpperCase() !== "Z") {
			const digits = zone.slice(1).replace(":", "");
			const zoneHours = Number(digits.slice(0, 2));
			const zoneMinutes = Number(digits.slice(2) || "0");
			if (zoneHours > 23 || zoneMinutes > 59) {
				return null;
			}
			offset = (zoneHours * 60 + zoneMinutes) * (zone[0] === "+" ? 1 : -1);
		}
		return { value: date.getTime() + Number(`0.${match[7] ?? "0"}`) * 1000 - offset * 60000, kind: zone ? "offset" : "local" };
	};
	/** Unknown/unzoned and offset-qualified clocks are never guessed to be comparable. */
	RouteYandex.createPositionOrder = (initial) => {
		const latest = {};
		const accept = (period) => {
			const time = RouteYandex.positionTime(period);
			if (!time) {
				return true;
			}
			const previous = latest[time.kind];
			if (previous !== undefined && time.value < previous) {
				return false;
			}
			latest[time.kind] = time.value;
			return true;
		};
		accept(initial);
		return accept;
	};
	RouteYandex.movementOptions = (input) => {
		const value = (number, fallback, min, max) => {
			const parsed = RouteYandex.numberValue(number);
			return parsed === null ? fallback : Math.min(max, Math.max(min, parsed));
		};
		return {
			durationMs: value(input?.durationMs, 1200, 0, 5000),
			maxGapMs: value(input?.maxGapMs, 30000, 1000, 300000),
			maxDistanceM: value(input?.maxDistanceM, 1000, 1, 10000),
		};
	};
	/** Ground distance, not Web Mercator metres (which vary with latitude). */
	const distanceMeters = (from, to) => {
		const radians = Math.PI / 180;
		const lat = (to[1] - from[1]) * radians;
		const lon = (to[0] - from[0]) * radians;
		const a = Math.sin(lat / 2) ** 2 + Math.cos(from[1] * radians) * Math.cos(to[1] * radians) * Math.sin(lon / 2) ** 2;
		return 12742017.6 * Math.asin(Math.sqrt(Math.min(1, Math.max(0, a))));
	};
	/** A finite, local rendering loop. It never fetches data or predicts beyond a GPS fix. */
	RouteYandex.createVehicleMovement = (options, draw, clock = {
		now: () => performance.now(),
		request: (callback) => window.requestAnimationFrame(callback),
		cancel: (id) => window.cancelAnimationFrame(id),
	}) => {
		let displayed = null;
		let target = null;
		let origin = null;
		let lastPosition = null;
		let lastArrival = null;
		let frame = null;
		let startedAt = 0;
		let lastFrameAt = 0;
		let paused = false;
		let reducedMotion = false;
		let snapNext = false;
		let disposed = false;
		const cancel = () => {
			if (frame !== null) {
				clock.cancel(frame);
				frame = null;
			}
			origin = null;
		};
		const render = (point, animated) => {
			displayed = [...point];
			draw([...point], animated);
		};
		const finish = () => {
			cancel();
			if (target) {
				render(target, false);
			}
		};
		const tick = (now) => {
			frame = null;
			if (disposed || paused || !origin || !target) {
				return;
			}
			// A suspended/busy browser must not replay an old journey when frames resume.
			if (now - lastFrameAt > options.maxGapMs) {
				finish();
				return;
			}
			lastFrameAt = now;
			const progress = Math.min(1, Math.max(0, (now - startedAt) / options.durationMs));
			render(progress === 1 ? target : [
				origin[0] + (target[0] - origin[0]) * progress,
				origin[1] + (target[1] - origin[1]) * progress,
			], true);
			if (progress < 1) {
				frame = clock.request(tick);
			}
			else {
				origin = null;
			}
		};
		return {
			update: (position, projected) => {
				if (disposed || projected.length !== 2 || !projected.every(Number.isFinite)) {
					return;
				}
				const now = clock.now();
				const previousTime = RouteYandex.positionTime(lastPosition?.period ?? null);
				const nextTime = RouteYandex.positionTime(position.period);
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
				if (unchanged) {
					return;
				}
				if (displayed[0] === target[0] && displayed[1] === target[1]) {
					finish();
					return;
				}
				cancel();
				origin = [...displayed];
				startedAt = now;
				lastFrameAt = now;
				frame = clock.request(tick);
			},
			pause: () => { if (!disposed) {
				paused = true;
				finish();
			} },
			resume: () => { if (!disposed && paused) {
				paused = false;
				snapNext = true;
			} },
			setReducedMotion: (enabled) => {
				if (disposed || reducedMotion === enabled) {
					return;
				}
				reducedMotion = enabled;
				if (enabled) {
					finish();
				}
			},
			isAnimating: () => frame !== null,
			dispose: () => { disposed = true; cancel(); },
		};
	};
})(RouteYandex || (RouteYandex = {}));
var RouteYandex;
(function (RouteYandex) {
	/** Event-triggered queue. No interval, scheduled refresh, or polling fallback. */
	class RouteUpdates {
		constructor(callbacks) {
			this.callbacks = callbacks;
			this.revision = 0;
			this.controller = null;
			this.pending = false;
			this.disposed = false;
			this.inline = (points) => {
				if (this.disposed) {
					return;
				}
				this.revision++;
				this.pending = false;
				this.controller?.abort();
				this.callbacks.route(points);
			};
			this.request = () => {
				if (this.disposed) {
					return;
				}
				this.revision++;
				if (this.controller) {
					this.pending = true;
					return;
				}
				this.start();
			};
			this.dispose = () => {
				this.disposed = true;
				this.pending = false;
				this.controller?.abort();
			};
			this.start = () => {
				const revision = this.revision;
				const controller = new AbortController();
				this.controller = controller;
				void Promise.resolve().then(() => this.callbacks.fetchRoute(controller.signal)).then((points) => {
					if (!this.disposed && !controller.signal.aborted && revision === this.revision) {
						this.callbacks.route(points);
					}
				}).catch((error) => {
					if (!this.disposed && !controller.signal.aborted && revision === this.revision) {
						this.callbacks.error(error);
					}
				}).finally(() => {
					if (this.controller === controller) {
						this.controller = null;
						if (this.pending && !this.disposed) {
							this.pending = false;
							this.start();
						}
					}
				});
			};
		}
	}
	RouteYandex.RouteUpdates = RouteUpdates;
	RouteYandex.subscribe = (Constructor, config, callbacks) => {
		const positionId = `Vehicle.position.${config.trackerId}`;
		const redrawId = `Vehicle.route_redraw.${config.trackerId}`;
		const endId = `Vehicle.route_end.${config.trackerId}`;
		const updates = new RouteUpdates(callbacks);
		const acceptPosition = RouteYandex.createPositionOrder(RouteYandex.parsePosition(config.position)?.period ?? null);
		let stopped = false;
		const stop = () => { stopped = true; updates.dispose(); };
		const reload = () => {
			if (!stopped) {
				stop();
				callbacks.reload();
			}
		};
		const onEvent = (event) => {
			if (stopped || !RouteYandex.isRecord(event) || typeof event.eventId !== "string") {
				return;
			}
			if (event.eventId === endId || event.eventId === "User.logout") {
				reload();
				return;
			}
			if (event.eventId !== positionId && event.eventId !== redrawId) {
				return;
			}
			if (!RouteYandex.isRecord(event.params)) {
				return;
			}
			const params = event.params;
			const position = event.eventId === positionId ? RouteYandex.parsePosition(params) : null;
			// An older GPS packet must not regress the marker, its time, distance, or bundled route.
			if (position && !acceptPosition(position.period)) {
				return;
			}
			callbacks.received();
			if (event.eventId === positionId) {
				if (position) {
					callbacks.position(position);
				}
			}
			if (Object.prototype.hasOwnProperty.call(params, "route_rest_len")) {
				const distance = RouteYandex.numberValue(params.route_rest_len);
				if (params.route_rest_len === null || (distance !== null && distance >= 0)) {
					callbacks.distance(distance);
				}
			}
			if (params.long_route_rest === true) {
				updates.request();
			}
			else if (Object.prototype.hasOwnProperty.call(params, "route_rest")) {
				const points = RouteYandex.parseRoute(params.route_rest);
				if (points === null) {
					callbacks.error(new Error("Получена некорректная линия маршрута. Сохраняем предыдущую."));
				}
				else {
					updates.inline(points);
				}
			}
		};
		const client = new Constructor(config.appSrv);
		try {
			// Deliberately the same order and public API as the supplied route.js.
			client.connect();
			client.subscribe({
				events: [{ id: positionId }, { id: redrawId }, { id: endId }, { id: "User.logout" }],
				onEvent,
				onWakeup: reload,
			});
		}
		catch (error) {
			stop();
			throw error;
		}
		// Socket reconnect/heartbeat behavior belongs to AppSrv, not this adapter.
		return stop;
	};
})(RouteYandex || (RouteYandex = {}));
var RouteYandex;
(function (RouteYandex) {
	class HttpError extends Error {
		constructor(message, status) {
			super(message);
			this.status = status;
			this.name = "HttpError";
		}
	}
	RouteYandex.HttpError = HttpError;
	RouteYandex.requestJson = async (url, token, timeoutMs, options = {}) => {
		const controller = new AbortController();
		let timedOut = false;
		const abort = () => controller.abort();
		if (options.signal?.aborted) {
			throw new DOMException("Request cancelled", "AbortError");
		}
		options.signal?.addEventListener("abort", abort, { once: true });
		// This is a single in-flight request deadline, NOT a refresh/retry timer.
		const timeout = setTimeout(() => {
			timedOut = true;
			controller.abort();
		}, timeoutMs);
		try {
			const headers = { Accept: "application/json", "X-Route-Token": token };
			if (options.body !== undefined) {
				headers["Content-Type"] = "application/json";
			}
			const response = await fetch(url, {
				method: options.body === undefined ? "GET" : "POST",
				headers,
				body: options.body === undefined ? undefined : JSON.stringify(options.body),
				credentials: "same-origin",
				cache: "no-store",
				signal: controller.signal,
			});
			let data;
			try {
				data = await response.json();
			}
			catch {
				throw new HttpError("Сервер вернул некорректный ответ. Попробуйте обновить страницу.", response.status);
			}
			if (!response.ok) {
				throw new HttpError(RouteYandex.isRecord(data) && typeof data.error === "string" ? data.error : "Не удалось выполнить запрос.", response.status);
			}
			return data;
		}
		catch (error) {
			if (timedOut) {
				throw new Error("Сервер не ответил вовремя. Ожидаем следующее обновление или обновите страницу.");
			}
			throw error;
		}
		finally {
			clearTimeout(timeout);
			options.signal?.removeEventListener("abort", abort);
		}
	};
	RouteYandex.loadRoute = async (config, signal) => {
		const data = await RouteYandex.requestJson(config.routeUrl, config.readToken, config.requestTimeoutMs, { signal });
		if (!RouteYandex.isRecord(data) || !Object.prototype.hasOwnProperty.call(data, "route")) {
			throw new Error("В ответе сервера отсутствует маршрут.");
		}
		const points = RouteYandex.parseRoute(data.route);
		if (points === null) {
			throw new Error("Сервер вернул некорректную линию маршрута.");
		}
		return points;
	};
})(RouteYandex || (RouteYandex = {}));
var RouteYandex;
(function (RouteYandex) {
	RouteYandex.createMap = (sdk, config, callbacks, initial) => {
		const container = document.getElementById("map");
		if (!container) {
			throw new Error("Не найден контейнер карты.");
		}
		const maxZoom = config.yandex.maxZoom;
		const zoom = Math.min(maxZoom, Math.max(1, config.initialZoom ?? RouteYandex.numberValue(window.TRACK_CONSTANTS?.INI_ZOOM) ?? 14));
		const map = new sdk.YMap(container, {
			location: { center: config.center, zoom },
			mode: config.yandex.mode,
			zoomRange: { min: 1, max: maxZoom },
			behaviors: ["drag", "scrollZoom", "dblClick", "pinchZoom", "oneFingerZoom"],
			showScaleInCopyrights: true,
		}, [new sdk.YMapDefaultSchemeLayer({}), new sdk.YMapDefaultFeaturesLayer({})]);
		// Native Yandex logo, attribution and "Open in Maps" controls are left intact.
		let line = null;
		let vehicle = null;
		let destination = null;
		let points = [];
		let vehicleCoordinates = null;
		let latestVehicleCoordinates = null;
		let destinationCoordinates = null;
		let following = config.followVehicle;
		let cameraTransition = null;
		let pageSuspended = false;
		let disposed = false;
		const motion = RouteYandex.movementOptions(config.movement);
		const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
		const activePage = () => !document.hidden && !pageSuspended;
		const mapCenter = () => [map.center[0], map.center[1]];
		const cancelCamera = () => { map.setLocation({ center: mapCenter(), zoom: map.zoom, duration: 0 }); };
		const vehicleElement = document.createElement("div");
		vehicleElement.className = "vehicle-marker";
		vehicleElement.title = config.vehiclePlate;
		const plate = document.createElement("span");
		plate.className = "vehicle-marker-label";
		plate.textContent = config.vehiclePlate || "Миксер";
		const icon = document.createElement("img");
		icon.src = config.iconUrl;
		icon.width = 38;
		icon.height = 38;
		icon.alt = "Автомобиль";
		icon.draggable = false;
		vehicleElement.append(plate, icon);
		const destinationElement = document.createElement("div");
		destinationElement.className = "destination-marker";
		const destinationLabel = document.createElement("span");
		destinationLabel.textContent = "Объект";
		destinationElement.append(destinationLabel);
		const movement = RouteYandex.createVehicleMovement(motion, (point, animated) => {
			const previous = vehicleCoordinates;
			vehicleCoordinates = [point[0], point[1]];
			const coordinates = RouteYandex.unproject(point);
			if (vehicle) {
				vehicle.update({ coordinates });
			}
			else {
				vehicle = new sdk.YMapMarker({ id: "shipment-vehicle", coordinates, draggable: false, disableRoundCoordinates: true, zIndex: 1000 }, vehicleElement);
				map.addChild(vehicle);
			}
			if (!following || !activePage()) {
				cameraTransition = null;
				return;
			}
			const arrived = latestVehicleCoordinates?.[0] === point[0] && latestVehicleCoordinates[1] === point[1];
			if (!animated || arrived) {
				cameraTransition = null;
				map.setLocation({ center: coordinates, duration: 0 });
				return;
			}
			// Retain the offset when following is enabled mid-movement, then ease it away.
			if (!cameraTransition && previous) {
				const current = RouteYandex.project(mapCenter());
				if (Math.hypot(current[0] - previous[0], current[1] - previous[1]) > 0.01) {
					cameraTransition = { offset: [current[0] - previous[0], current[1] - previous[1]], startedAt: performance.now() };
				}
			}
			let cameraPoint = point;
			if (cameraTransition) {
				const progress = Math.min(1, (performance.now() - cameraTransition.startedAt) / Math.max(1, Math.min(300, motion.durationMs)));
				const remaining = (1 - progress) ** 2;
				cameraPoint = [point[0] + cameraTransition.offset[0] * remaining, point[1] + cameraTransition.offset[1] * remaining];
				if (progress === 1) {
					cameraTransition = null;
				}
			}
			map.setLocation({ center: RouteYandex.unproject(cameraPoint), duration: 0 });
		});
		movement.setReducedMotion(reducedMotion.matches);
		if (!activePage()) {
			movement.pause();
		}
		const zone = RouteYandex.parseZone(config.destinationZone);
		if (zone === null) {
			callbacks.error(new Error("Не удалось отобразить зону объекта. Маршрут и положение машины остаются доступны."));
		}
		const zoneDestination = zone?.length ? RouteYandex.zoneInterior(zone[0]) : null;
		for (const [index, polygon] of (zone ?? []).entries()) {
			if (config.showZone) {
				map.addChild(new sdk.YMapFeature({
					id: `destination-zone-${index}`,
					geometry: { type: "Polygon", coordinates: polygon },
					style: { fill: "rgba(33, 142, 90, 0.09)", stroke: [{ color: "#369a69", width: 1.5 }], zIndex: 0 },
				}));
			}
		}
		const visiblePoints = () => {
			const result = [...points];
			if (vehicleCoordinates) {
				result.push(RouteYandex.unproject(vehicleCoordinates));
			}
			if (latestVehicleCoordinates) {
				result.push(RouteYandex.unproject(latestVehicleCoordinates));
			}
			if (destinationCoordinates) {
				result.push(destinationCoordinates);
			}
			if (!result.length) {
				for (const polygon of zone ?? []) {
					result.push(...polygon[0]);
				}
			}
			return result;
		};
		const availability = () => callbacks.availability(vehicle !== null, visiblePoints().length > 0);
		const follow = (enabled) => {
			following = enabled;
			cameraTransition = null;
			callbacks.follow(enabled);
		};
		const fit = (duration = 250) => {
			const location = RouteYandex.fitLocation(visiblePoints(), container.clientWidth, container.clientHeight, Math.min(config.fitMaxZoom, maxZoom));
			if (location) {
				map.setLocation({ ...location, duration: reducedMotion.matches ? 0 : duration });
			}
		};
		const center = () => {
			if (!vehicleCoordinates || !activePage()) {
				return;
			}
			cameraTransition = null;
			cancelCamera();
			if (!movement.isAnimating()) {
				map.setLocation({ center: RouteYandex.unproject(vehicleCoordinates), duration: reducedMotion.matches ? 0 : 300 });
			}
		};
		const stopFollow = () => { if (!disposed) {
			follow(false);
		} };
		const listener = new sdk.YMapListener({
			onActionStart: ({ type }) => {
				if (["drag", "scrollZoom", "dblClick", "pinchZoom", "oneFingerZoom"].includes(type)) {
					stopFollow();
				}
			},
		});
		map.addChild(listener);
		const keydown = (event) => {
			if (event.target !== container || !["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight", "+", "=", "-"].includes(event.key)) {
				return;
			}
			event.preventDefault();
			stopFollow();
			if (["+", "=", "-"].includes(event.key)) {
				api.zoom(event.key === "-" ? -1 : 1);
				return;
			}
			const point = RouteYandex.project(mapCenter());
			const offset = 40075016.68557849 / (256 * 2 ** map.zoom) * 80;
			if (event.key === "ArrowUp") {
				point[1] += offset;
			}
			if (event.key === "ArrowDown") {
				point[1] -= offset;
			}
			if (event.key === "ArrowLeft") {
				point[0] -= offset;
			}
			if (event.key === "ArrowRight") {
				point[0] += offset;
			}
			map.setLocation({ center: RouteYandex.unproject(point), duration: 0 });
		};
		const visibility = () => {
			if (disposed) {
				return;
			}
			if (activePage()) {
				movement.resume();
				if (following && vehicleCoordinates) {
					map.setLocation({ center: RouteYandex.unproject(vehicleCoordinates), duration: 0 });
				}
			}
			else {
				movement.pause();
				cameraTransition = null;
				cancelCamera();
			}
		};
		const motionPreference = () => {
			movement.setReducedMotion(reducedMotion.matches);
			if (reducedMotion.matches && !disposed) {
				cancelCamera();
			}
		};
		const pagehide = (event) => {
			pageSuspended = true;
			visibility();
			if (!event.persisted) {
				dispose();
			}
		};
		const pageshow = () => { if (pageSuspended) {
			pageSuspended = false;
			visibility();
		} };
		const dispose = () => {
			if (disposed) {
				return;
			}
			disposed = true;
			movement.dispose();
			container.removeEventListener("keydown", keydown);
			document.removeEventListener("visibilitychange", visibility);
			reducedMotion.removeEventListener("change", motionPreference);
			window.removeEventListener("pagehide", pagehide);
			window.removeEventListener("pageshow", pageshow);
			map.destroy();
		};
		container.addEventListener("keydown", keydown);
		document.addEventListener("visibilitychange", visibility);
		reducedMotion.addEventListener("change", motionPreference);
		window.addEventListener("pagehide", pagehide);
		window.addEventListener("pageshow", pageshow);
		callbacks.follow(following);
		const api = {
			position: (position) => {
				if (disposed) {
					return;
				}
				latestVehicleCoordinates = RouteYandex.project(position.coordinates);
				vehicleElement.title = `${config.vehiclePlate} · ${RouteYandex.formatPeriod(position.period)}`;
				movement.update(position, latestVehicleCoordinates);
				availability();
			},
			route: (nextPoints) => {
				if (disposed) {
					return;
				}
				points = nextPoints.map((point) => [...point]);
				if (points.length > 1) {
					const geometry = { type: "LineString", coordinates: points };
					if (line) {
						line.update({ geometry });
					}
					else {
						line = new sdk.YMapFeature({ id: "remaining-route", geometry,
							style: { stroke: [{ color: "#ffffff", width: 8 }, { color: "#176bd1", width: 4 }], zIndex: 10 },
						});
						map.addChild(line);
					}
				}
				else if (line) {
					map.removeChild(line);
					line = null;
				}
				destinationCoordinates = points.length ? points[points.length - 1] : zoneDestination;
				if (destinationCoordinates) {
					if (destination) {
						destination.update({ coordinates: destinationCoordinates });
					}
					else {
						destination = new sdk.YMapMarker({ id: "shipment-destination", coordinates: destinationCoordinates, zIndex: 500 }, destinationElement);
						map.addChild(destination);
					}
				}
				else if (destination) {
					map.removeChild(destination);
					destination = null;
				}
				availability();
			},
			fit: () => { if (!disposed) {
				follow(false);
				fit();
			} },
			find: () => {
				if (disposed || !vehicleCoordinates) {
					return;
				}
				follow(true);
				map.setLocation({ zoom: Math.max(map.zoom, zoom), duration: 0 });
				center();
			},
			toggleFollow: () => { if (!disposed) {
				follow(!following);
				if (following) {
					center();
				}
			} },
			zoom: (delta) => {
				if (disposed) {
					return;
				}
				follow(false);
				map.setLocation({ zoom: Math.min(maxZoom, Math.max(1, map.zoom + delta)), duration: reducedMotion.matches ? 0 : 200 });
			},
			dispose,
		};
		if (initial.position) {
			api.position(initial.position);
		}
		api.route(initial.route);
		fit(0);
		return api;
	};
})(RouteYandex || (RouteYandex = {}));
var RouteYandex;
(function (RouteYandex) {
	let yandexLoading = null;
	/** Load one official SDK, wait for its asynchronous modules, and fail visibly. No polling. */
	RouteYandex.loadYandex = (config) => {
		if (yandexLoading) {
			return yandexLoading;
		}
		if (!config.apiKey.trim()) {
			return Promise.reject(new Error("Не задан ключ Яндекс Карт. Добавьте ROUTE_YANDEX_API_KEY в общий Config.php."));
		}
		yandexLoading = new Promise((resolve, reject) => {
			let settled = false;
			let script = null;
			const finish = (api, error) => {
				if (settled) {
					return;
				}
				settled = true;
				window.clearTimeout(timer);
				if (script) {
					script.onload = null;
					script.onerror = null;
				}
				if (api) {
					resolve(api);
				}
				else {
					reject(error);
				}
			};
			const timer = window.setTimeout(() => finish(null, new Error("Яндекс Карты не загрузились вовремя. Проверьте ключ API, разрешённый домен и подключение, затем обновите страницу.")), config.loadTimeoutMs);
			const ready = () => {
				const api = window.ymaps3;
				if (!api?.ready) {
					finish(null, new Error("Не удалось инициализировать API Яндекс Карт v3."));
					return;
				}
				void Promise.resolve(api.ready).then(() => {
					if (!api.YMap || !api.YMapMarker || !api.YMapFeature || !api.YMapListener || !api.YMapDefaultSchemeLayer || !api.YMapDefaultFeaturesLayer) {
						finish(null, new Error("Компоненты API Яндекс Карт v3 недоступны."));
						return;
					}
					finish(api);
				}).catch(() => finish(null, new Error("Яндекс Карты отклонили загрузку. Проверьте API-ключ, лицензию и ограничение по домену.")));
			};
			if (window.ymaps3) {
				ready();
				return;
			}
			const url = new URL("https://api-maps.yandex.ru/v3/");
			url.searchParams.set("apikey", config.apiKey);
			url.searchParams.set("lang", config.lang);
			script = document.createElement("script");
			script.id = "yandex-maps-api";
			script.src = url.href;
			script.async = true;
			script.referrerPolicy = "origin";
			script.onload = ready;
			script.onerror = () => finish(null, new Error("Не удалось загрузить Яндекс Карты. Проверьте подключение и разрешения браузера."));
			document.head.appendChild(script);
		});
		return yandexLoading;
	};
})(RouteYandex || (RouteYandex = {}));
var RouteYandex;
(function (RouteYandex) {
	const element = (id) => {
		const node = document.getElementById(id);
		if (!node) {
			throw new Error(`Missing page element: ${id}`);
		}
		return node;
	};
	const boot = async () => {
		element("reload-page").addEventListener("click", () => window.location.reload());
		const notice = element("notice");
		const showNotice = (message, kind = "warning", scope = "route") => {
			notice.textContent = message;
			notice.dataset.kind = kind;
			notice.dataset.scope = scope;
			notice.hidden = false;
		};
		const status = (message, kind) => {
			const node = element("live-status");
			node.textContent = message;
			node.dataset.kind = kind;
		};
		const showError = (error, scope = "route") => {
			if (error instanceof RouteYandex.HttpError && [403, 404, 410].includes(error.status)) {
				window.location.reload();
				return;
			}
			showNotice(error instanceof Error ? error.message : "Не удалось обновить данные.", "error", scope);
		};
		try {
			const config = JSON.parse(element("route-config").textContent ?? "null");
			if (!config || !Number.isInteger(config.id) || !config.trackerId) {
				throw new Error("Некорректные данные страницы.");
			}
			const findButton = element("find-vehicle");
			const fitButton = element("fit-route");
			const followButton = element("follow-vehicle");
			let map = null;
			let disposed = false;
			let latestPosition = RouteYandex.parsePosition(config.position);
			const parsedInitialRoute = RouteYandex.parseRoute(config.route);
			let latestRoute = parsedInitialRoute ?? [];
			if (parsedInitialRoute === null) {
				showNotice("Начальная линия маршрута некорректна. Ожидаем обновление.");
			}
			const cleanup = () => { disposed = true; map?.dispose(); };
			window.addEventListener("pagehide", (event) => { if (!event.persisted) {
				cleanup();
			} });
			const showPosition = (position) => {
				const node = element("position-time");
				node.textContent = RouteYandex.formatPeriod(position.period);
				node.title = position.period ? `Время из системы трекинга: ${position.period}` : "Время позиции не получено";
			};
			if (latestPosition) {
				showPosition(latestPosition);
			}
			element("distance").textContent = RouteYandex.formatDistance(config.distance);
			findButton.addEventListener("click", () => map?.find());
			fitButton.addEventListener("click", () => map?.fit());
			followButton.addEventListener("click", () => map?.toggleFollow());
			const AppSrv = window.AppSrv;
			if (!AppSrv) {
				status("AppSrv не загружен", "error");
				showNotice("Показаны начальные данные. Не загружен ../js20/core/AppSrv.js или одна из его зависимостей. Автоматические обновления недоступны.", "error", "appsrv");
			}
			else if (!config.appSrv.host || !config.appSrv.port || !config.appSrv.appId) {
				status("AppSrv не настроен", "error");
				showNotice("Проверьте APP_SERVER_HOST, APP_SERVER_PORT, APP_SERVER_PORT_SECURED и APP_NAME в Config.php.", "error", "appsrv");
			}
			else {
				try {
					const stop = RouteYandex.subscribe(AppSrv, config, {
						position: (position) => { latestPosition = position; map?.position(position); showPosition(position); },
						distance: (distance) => { element("distance").textContent = RouteYandex.formatDistance(distance); },
						route: (points) => {
							latestRoute = points;
							map?.route(points);
							if (["route", "location-waiting"].includes(notice.dataset.scope ?? "")) {
								notice.hidden = true;
							}
						},
						fetchRoute: (signal) => RouteYandex.loadRoute(config, signal),
						received: () => status(`Обновление в ${new Date().toLocaleTimeString("ru-RU")}`, "received"),
						error: showError,
						reload: () => window.location.reload(),
					});
					window.addEventListener("pagehide", (event) => { if (!event.persisted) {
						stop();
					} });
				}
				catch (error) {
					status("Не удалось подключить AppSrv", "error");
					showNotice("Показаны начальные данные. Проверьте загрузку зависимостей AppSrv и настройки WebSocket.", "error", "appsrv");
					console.error("AppSrv initialization failed", error);
				}
			}
			window.addEventListener("offline", () => status("Нет подключения к интернету", "error"));
			window.addEventListener("online", () => status("Ожидание обновлений", "waiting"));
			if (!navigator.onLine) {
				status("Нет подключения к интернету", "error");
			}
			const locationButton = document.getElementById("share-location");
			if (locationButton && config.locationEnabled && config.locationToken) {
				locationButton.disabled = false;
				locationButton.addEventListener("click", () => {
					if (!window.isSecureContext || !navigator.geolocation) {
						showNotice("Для передачи местоположения откройте страницу по HTTPS и разрешите доступ к геолокации.", "error", "location");
						return;
					}
					if (!window.confirm("Вы сейчас на месте разгрузки? Ваше текущее местоположение будет передано для построения маршрута водителю.")) {
						return;
					}
					locationButton.disabled = true;
					locationButton.textContent = "Определяем…";
					const reset = () => { locationButton.disabled = false; locationButton.textContent = "Я на объекте"; };
					navigator.geolocation.getCurrentPosition((position) => {
						locationButton.textContent = "Отправляем…";
						void RouteYandex.requestJson(config.locationUrl, config.locationToken, config.requestTimeoutMs, {
							body: { lon: position.coords.longitude, lat: position.coords.latitude },
						}).then((data) => {
							if (!RouteYandex.isRecord(data) || data.ok !== true) {
								throw new Error("Не удалось подтвердить передачу местоположения.");
							}
							element("location-panel").hidden = true;
							showNotice("Место разгрузки передано. Ожидаем новый маршрут от диспетчерской системы.", "warning", "location-waiting");
							// Vehicle.rebuild_route -> AppSrv event. Deliberately no HTTP refresh here.
						}).catch((error) => showError(error, "location")).finally(reset);
					}, (error) => {
						showNotice(error.code === 1 ? "Доступ к местоположению запрещён в браузере." :
							error.code === 3 ? "Не удалось определить местоположение вовремя. Попробуйте ещё раз." : "Местоположение сейчас недоступно.", "error", "location");
						reset();
					}, { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 });
				});
			}
			// Subscribe before waiting for the SDK. Events arriving during load are retained,
			// and the newest fix is displayed immediately rather than replaying a backlog.
			const sdk = await RouteYandex.loadYandex(config.yandex);
			if (disposed) {
				return;
			}
			map = RouteYandex.createMap(sdk, config, {
				follow: (enabled) => followButton.setAttribute("aria-pressed", String(enabled)),
				availability: (vehicle, geometry) => {
					findButton.disabled = !vehicle;
					followButton.disabled = !vehicle;
					fitButton.disabled = !geometry;
				},
				error: showError,
			}, { position: latestPosition, route: latestRoute });
			element("zoom-in").addEventListener("click", () => map?.zoom(1));
			element("zoom-out").addEventListener("click", () => map?.zoom(-1));
			element("map-controls").hidden = false;
			element("map-message").hidden = true;
		}
		catch (error) {
			const message = error instanceof Error ? error.message : "Не удалось открыть карту.";
			element("map-message").textContent = message;
			status("Карта недоступна", "error");
			console.error("Shipment map initialization failed", error);
		}
	};
	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", () => { void boot(); }, { once: true });
	}
	else {
		void boot();
	}
})(RouteYandex || (RouteYandex = {}));
