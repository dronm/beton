"use strict";
var RouteOsm;
(function (RouteOsm) {
	RouteOsm.isRecord = (value) => typeof value === "object" && value !== null && !Array.isArray(value);
	RouteOsm.numberValue = (value) => {
		if (typeof value !== "number" && typeof value !== "string") {
			return null;
		}
		if (typeof value === "string" && !/^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$/.test(value.trim())) {
			return null;
		}
		const number = Number(value);
		return Number.isFinite(number) ? number : null;
	};
	RouteOsm.coordinates = (lon, lat) => {
		const x = RouteOsm.numberValue(lon);
		const y = RouteOsm.numberValue(lat);
		return x !== null && y !== null && Math.abs(x) <= 180 && Math.abs(y) <= 90 ? [x, y] : null;
	};
	RouteOsm.parsePosition = (value) => {
		if (!RouteOsm.isRecord(value)) {
			return null;
		}
		const point = RouteOsm.coordinates(value.lon, value.lat);
		return point ? { coordinates: point, period: typeof value.period === "string" ? value.period : null } : null;
	};
	/** The existing protocol uses "lon lat,lon lat" (NOT Leaflet's lat/lon order). */
	RouteOsm.parseRoute = (value) => {
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
			const point = parts.length === 2 ? RouteOsm.coordinates(parts[0], parts[1]) : null;
			if (!point) {
				// Never skip a bad vertex and invent a straight segment across the gap.
				return null;
			}
			result.push(point);
		}
		return result;
	};
	RouteOsm.formatDistance = (value) => {
		const distance = RouteOsm.numberValue(value);
		if (distance === null || distance < 0) {
			return "—";
		}
		return distance < 1000 ? `${Math.floor(distance)} м` :
			`${new Intl.NumberFormat("ru-RU", { maximumFractionDigits: 1 }).format(distance / 1000)} км`;
	};
	/** Keep the source time: do not reinterpret an unzoned SQL timestamp as UTC. */
	RouteOsm.formatPeriod = (value) => {
		if (!value) {
			return "—";
		}
		const match = /^(\d{4})-(\d{2})-(\d{2})[T ](\d{2}:\d{2}(?::\d{2})?)/.exec(value);
		return match ? `${match[4]} · ${match[3]}.${match[2]}` : "—";
	};
})(RouteOsm || (RouteOsm = {}));
var RouteOsm;
(function (RouteOsm) {
	/** Compare SQL/ISO times without assigning the customer's timezone to unzoned data. */
	RouteOsm.positionTime = (period) => {
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
	RouteOsm.createPositionOrder = (initial) => {
		const latest = {};
		const accept = (period) => {
			const time = RouteOsm.positionTime(period);
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
	RouteOsm.movementOptions = (input) => {
		const value = (number, fallback, min, max) => {
			const parsed = RouteOsm.numberValue(number);
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
	RouteOsm.createVehicleMovement = (options, draw, clock = {
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
				const previousTime = RouteOsm.positionTime(lastPosition?.period ?? null);
				const nextTime = RouteOsm.positionTime(position.period);
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
})(RouteOsm || (RouteOsm = {}));
var RouteOsm;
(function (RouteOsm) {
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
	RouteOsm.RouteUpdates = RouteUpdates;
	RouteOsm.subscribe = (Constructor, config, callbacks) => {
		const positionId = `Vehicle.position.${config.trackerId}`;
		const redrawId = `Vehicle.route_redraw.${config.trackerId}`;
		const endId = `Vehicle.route_end.${config.trackerId}`;
		const updates = new RouteUpdates(callbacks);
		const acceptPosition = RouteOsm.createPositionOrder(RouteOsm.parsePosition(config.position)?.period ?? null);
		let stopped = false;
		const stop = () => { stopped = true; updates.dispose(); };
		const reload = () => {
			if (!stopped) {
				stop();
				callbacks.reload();
			}
		};
		const onEvent = (event) => {
			if (stopped || !RouteOsm.isRecord(event) || typeof event.eventId !== "string") {
				return;
			}
			if (event.eventId === endId || event.eventId === "User.logout") {
				reload();
				return;
			}
			if (event.eventId !== positionId && event.eventId !== redrawId) {
				return;
			}
			if (!RouteOsm.isRecord(event.params)) {
				return;
			}
			const params = event.params;
			const position = event.eventId === positionId ? RouteOsm.parsePosition(params) : null;
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
				const distance = RouteOsm.numberValue(params.route_rest_len);
				if (params.route_rest_len === null || (distance !== null && distance >= 0)) {
					callbacks.distance(distance);
				}
			}
			if (params.long_route_rest === true) {
				updates.request();
			}
			else if (Object.prototype.hasOwnProperty.call(params, "route_rest")) {
				const points = RouteOsm.parseRoute(params.route_rest);
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
})(RouteOsm || (RouteOsm = {}));
var RouteOsm;
(function (RouteOsm) {
	class HttpError extends Error {
		constructor(message, status) {
			super(message);
			this.status = status;
			this.name = "HttpError";
		}
	}
	RouteOsm.HttpError = HttpError;
	RouteOsm.requestJson = async (url, token, timeoutMs, options = {}) => {
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
				throw new HttpError(RouteOsm.isRecord(data) && typeof data.error === "string" ? data.error : "Не удалось выполнить запрос.", response.status);
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
	RouteOsm.loadRoute = async (config, signal) => {
		const data = await RouteOsm.requestJson(config.routeUrl, config.readToken, config.requestTimeoutMs, { signal });
		if (!RouteOsm.isRecord(data) || !Object.prototype.hasOwnProperty.call(data, "route")) {
			throw new Error("В ответе сервера отсутствует маршрут.");
		}
		const points = RouteOsm.parseRoute(data.route);
		if (points === null) {
			throw new Error("Сервер вернул некорректную линию маршрута.");
		}
		return points;
	};
})(RouteOsm || (RouteOsm = {}));
var RouteOsm;
(function (RouteOsm) {
	RouteOsm.createMap = (config, callbacks) => {
		const routeFeature = new ol.Feature();
		const vehicleFeature = new ol.Feature();
		const destinationFeature = new ol.Feature();
		const zoneFeature = new ol.Feature();
		let zoneDestination;
		let zoneGeometry;
		let vehicleCoordinates = null;
		let following = config.followVehicle;
		let vehicleGeometry = null;
		let latestVehicleCoordinates = null;
		let cameraTransition = null;
		let pageSuspended = false;
		let disposed = false;
		const motion = RouteOsm.movementOptions(config.movement);
		const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
		const activePage = () => !document.hidden && !pageSuspended;
		const source = new ol.source.Vector({ features: [zoneFeature, routeFeature, destinationFeature, vehicleFeature], wrapX: false });
		const tileSource = new ol.source.OSM({
			url: config.tiles.url,
			attributions: config.tiles.attribution,
			maxZoom: config.tiles.maxZoom,
			crossOrigin: "anonymous",
			referrerPolicy: "origin",
		});
		tileSource.on("tileloaderror", () => callbacks.tiles(true));
		tileSource.on("tileloadend", () => callbacks.tiles(false));
		const legacyZoom = RouteOsm.numberValue(window.TRACK_CONSTANTS?.INI_ZOOM);
		const zoom = Math.min(config.tiles.maxZoom, Math.max(1, config.initialZoom ?? legacyZoom ?? 14));
		const map = new ol.Map({
			target: "map",
			layers: [new ol.layer.Tile({ source: tileSource, preload: 0 }), new ol.layer.Vector({ source })],
			view: new ol.View({ center: ol.proj.fromLonLat(config.center), zoom, maxZoom: config.tiles.maxZoom, enableRotation: false }),
			controls: [
				new ol.control.Zoom({ zoomInTipLabel: "Приблизить", zoomOutTipLabel: "Отдалить" }),
				new ol.control.Attribution({ collapsible: false }),
				new ol.control.ScaleLine({ units: "metric" }),
			],
		});
		routeFeature.setStyle([
			new ol.style.Style({ stroke: new ol.style.Stroke({ color: "#ffffff", width: 8 }), zIndex: 1 }),
			new ol.style.Style({ stroke: new ol.style.Stroke({ color: "#176bd1", width: 4 }), zIndex: 2 }),
		]);
		destinationFeature.setStyle(new ol.style.Style({
			image: new ol.style.Circle({ radius: 8, fill: new ol.style.Fill({ color: "#188753" }), stroke: new ol.style.Stroke({ color: "#ffffff", width: 3 }) }),
			text: new ol.style.Text({ text: "Объект", offsetY: 23, font: "600 12px sans-serif", fill: new ol.style.Fill({ color: "#184e35" }), stroke: new ol.style.Stroke({ color: "#ffffff", width: 4 }) }),
			zIndex: 4,
		}));
		zoneFeature.setStyle(new ol.style.Style({
			fill: new ol.style.Fill({ color: "rgba(33, 142, 90, 0.09)" }),
			stroke: new ol.style.Stroke({ color: "#369a69", width: 1.5, lineDash: [6, 5] }),
			zIndex: 0,
		}));
		// Geometry and styles are created once; frames only change point coordinates.
		vehicleFeature.setStyle([
			new ol.style.Style({ image: new ol.style.Circle({ radius: 24, fill: new ol.style.Fill({ color: "#ffffff" }), stroke: new ol.style.Stroke({ color: "#1766b3", width: 2 }) }), zIndex: 5 }),
			new ol.style.Style({ image: new ol.style.Icon({ src: config.iconUrl, width: 38, height: 38, anchor: [0.5, 0.5] }),
				text: new ol.style.Text({ text: config.vehiclePlate, offsetY: -37, font: "600 12px sans-serif", fill: new ol.style.Fill({ color: "#172f44" }), stroke: new ol.style.Stroke({ color: "#ffffff", width: 4 }) }), zIndex: 6 }),
		]);
		const movement = RouteOsm.createVehicleMovement(motion, (point, animated) => {
			const previous = vehicleCoordinates;
			vehicleCoordinates = point;
			if (vehicleGeometry) {
				vehicleGeometry.setCoordinates(point);
			}
			else {
				vehicleGeometry = new ol.geom.Point(point);
				vehicleFeature.setGeometry(vehicleGeometry);
			}
			if (!following || !activePage()) {
				cameraTransition = null;
				return;
			}
			const view = map.getView();
			const arrived = latestVehicleCoordinates?.[0] === point[0] && latestVehicleCoordinates[1] === point[1];
			if (!animated || arrived) {
				cameraTransition = null;
				view.cancelAnimations();
				view.setCenter(point);
				return;
			}
			// If the user just enabled follow (or the initial route was fitted), ease
			// away the camera offset using this same rendering loop, not View.animate().
			if (!cameraTransition && previous) {
				view.cancelAnimations();
				const current = view.getCenter();
				if (current && Math.hypot(current[0] - previous[0], current[1] - previous[1]) > 0.01) {
					cameraTransition = { offset: [current[0] - previous[0], current[1] - previous[1]], startedAt: performance.now() };
				}
			}
			if (cameraTransition) {
				const progress = Math.min(1, (performance.now() - cameraTransition.startedAt) / Math.min(300, motion.durationMs));
				const remaining = (1 - progress) ** 2;
				view.setCenter([point[0] + cameraTransition.offset[0] * remaining, point[1] + cameraTransition.offset[1] * remaining]);
				if (progress === 1) {
					cameraTransition = null;
				}
			}
			else {
				view.setCenter(point);
			}
		});
		movement.setReducedMotion(reducedMotion.matches);
		if (!activePage()) {
			movement.pause();
		}
		if (RouteOsm.isRecord(config.destinationZone) && ["Polygon", "MultiPolygon"].includes(String(config.destinationZone.type))) {
			try {
				zoneGeometry = new ol.format.GeoJSON().readGeometry(config.destinationZone, { dataProjection: "EPSG:4326", featureProjection: "EPSG:3857" });
				const polygon = zoneGeometry instanceof ol.geom.Polygon ? zoneGeometry :
					zoneGeometry instanceof ol.geom.MultiPolygon ? zoneGeometry.getPolygons()[0] : undefined;
				const interior = polygon?.getInteriorPoint().getCoordinates().slice(0, 2);
				if (interior?.length === 2 && interior.every(Number.isFinite)) {
					zoneDestination = interior;
				}
				if (config.showZone && zoneGeometry.getExtent().every(Number.isFinite)) {
					zoneFeature.setGeometry(zoneGeometry);
				}
			}
			catch (error) {
				callbacks.error(new Error("Не удалось отобразить зону объекта. Маршрут и положение машины остаются доступны."));
			}
		}
		const extent = () => {
			const result = ol.extent.createEmpty();
			for (const feature of [routeFeature, vehicleFeature, destinationFeature]) {
				const bounds = feature.getGeometry()?.getExtent();
				if (bounds?.every(Number.isFinite)) {
					ol.extent.extend(result, bounds);
				}
			}
			if (ol.extent.isEmpty(result) && zoneGeometry?.getExtent().every(Number.isFinite)) {
				ol.extent.extend(result, zoneGeometry.getExtent());
			}
			return result;
		};
		const availability = () => callbacks.availability(vehicleCoordinates !== null, !ol.extent.isEmpty(extent()));
		const follow = (enabled) => {
			following = enabled;
			cameraTransition = null;
			map.getView().cancelAnimations();
			callbacks.follow(enabled);
		};
		const fit = () => {
			map.updateSize();
			const bounds = extent();
			if (!ol.extent.isEmpty(bounds)) {
				map.getView().cancelAnimations();
				map.getView().fit(bounds, { padding: [55, 55, 65, 55], maxZoom: Math.min(config.fitMaxZoom, config.tiles.maxZoom), duration: reducedMotion.matches ? 0 : 250 });
			}
		};
		const center = () => {
			if (vehicleCoordinates && activePage()) {
				map.getView().cancelAnimations();
				cameraTransition = null;
				// A moving marker takes the camera along on the next frame.
				if (!movement.isAnimating()) {
					map.getView().animate({ center: vehicleCoordinates, duration: reducedMotion.matches ? 0 : 300 });
				}
			}
		};
		const stopFollow = () => follow(false);
		const keydown = (event) => {
			if (["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(event.key)) {
				stopFollow();
			}
		};
		const visibility = () => {
			if (activePage()) {
				movement.resume();
				if (following && vehicleCoordinates) {
					map.getView().setCenter(vehicleCoordinates);
				}
			}
			else {
				movement.pause();
				cameraTransition = null;
				map.getView().cancelAnimations();
			}
		};
		const motionPreference = () => {
			movement.setReducedMotion(reducedMotion.matches);
			if (reducedMotion.matches) {
				map.getView().cancelAnimations();
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
		const mapElement = document.getElementById("map");
		const dispose = () => {
			if (disposed) {
				return;
			}
			disposed = true;
			movement.dispose();
			map.getView().cancelAnimations();
			map.un("pointerdrag", stopFollow);
			mapElement?.removeEventListener("wheel", stopFollow);
			mapElement?.removeEventListener("keydown", keydown);
			document.removeEventListener("visibilitychange", visibility);
			reducedMotion.removeEventListener("change", motionPreference);
			window.removeEventListener("pagehide", pagehide);
			window.removeEventListener("pageshow", pageshow);
			map.setTarget(undefined);
		};
		map.on("pointerdrag", stopFollow);
		mapElement?.addEventListener("wheel", stopFollow, { passive: true });
		mapElement?.addEventListener("keydown", keydown);
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
				latestVehicleCoordinates = ol.proj.fromLonLat(position.coordinates);
				movement.update(position, latestVehicleCoordinates);
				availability();
			},
			route: (points) => {
				if (disposed) {
					return;
				}
				const projected = points.map((point) => ol.proj.fromLonLat(point));
				routeFeature.setGeometry(projected.length > 1 ? new ol.geom.LineString(projected) : undefined);
				const destination = projected.length > 0 ? projected[projected.length - 1] : zoneDestination;
				destinationFeature.setGeometry(destination ? new ol.geom.Point(destination) : undefined);
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
				map.getView().setZoom(Math.max(map.getView().getZoom() ?? zoom, zoom));
				center();
			},
			toggleFollow: () => { if (!disposed) {
				follow(!following);
				if (following) {
					center();
				}
			} },
			dispose,
		};
		const initialPosition = RouteOsm.parsePosition(config.position);
		if (initialPosition) {
			api.position(initialPosition);
		}
		const initialRoute = RouteOsm.parseRoute(config.route);
		api.route(initialRoute ?? []);
		if (initialRoute === null) {
			callbacks.error(new Error("Начальная линия маршрута некорректна. Ожидаем обновление."));
		}
		fit();
		return api;
	};
})(RouteOsm || (RouteOsm = {}));
var RouteOsm;
(function (RouteOsm) {
	const element = (id) => {
		const node = document.getElementById(id);
		if (!node) {
			throw new Error(`Missing page element: ${id}`);
		}
		return node;
	};
	const boot = () => {
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
			if (error instanceof RouteOsm.HttpError && [403, 404, 410].includes(error.status)) {
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
			if (typeof ol === "undefined") {
				throw new Error("Не удалось загрузить OpenLayers. Проверьте соединение или разместите библиотеку локально в vendor/ol/.");
			}
			const findButton = element("find-vehicle");
			const fitButton = element("fit-route");
			const followButton = element("follow-vehicle");
			const map = RouteOsm.createMap(config, {
				follow: (enabled) => followButton.setAttribute("aria-pressed", String(enabled)),
				availability: (vehicle, geometry) => { findButton.disabled = !vehicle; followButton.disabled = !vehicle; fitButton.disabled = !geometry; },
				tiles: (failed) => { element("tiles-notice").hidden = !failed; },
				error: showError,
			});
			element("map-message").hidden = true;
			const showPosition = (position) => {
				const node = element("position-time");
				node.textContent = RouteOsm.formatPeriod(position.period);
				node.title = position.period ? `Время из системы трекинга: ${position.period}` : "Время позиции не получено";
			};
			const initial = RouteOsm.parsePosition(config.position);
			if (initial) {
				showPosition(initial);
			}
			element("distance").textContent = RouteOsm.formatDistance(config.distance);
			findButton.addEventListener("click", map.find);
			fitButton.addEventListener("click", map.fit);
			followButton.addEventListener("click", map.toggleFollow);
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
					const stop = RouteOsm.subscribe(AppSrv, config, {
						position: (position) => { map.position(position); showPosition(position); },
						distance: (distance) => { element("distance").textContent = RouteOsm.formatDistance(distance); },
						route: (points) => {
							map.route(points);
							if (["route", "location-waiting"].includes(notice.dataset.scope ?? "")) {
								notice.hidden = true;
							}
						},
						fetchRoute: (signal) => RouteOsm.loadRoute(config, signal),
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
						void RouteOsm.requestJson(config.locationUrl, config.locationToken, config.requestTimeoutMs, {
							body: { lon: position.coords.longitude, lat: position.coords.latitude },
						}).then((data) => {
							if (!RouteOsm.isRecord(data) || data.ok !== true) {
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
		}
		catch (error) {
			const message = error instanceof Error ? error.message : "Не удалось открыть карту.";
			element("map-message").textContent = message;
			status("Карта недоступна", "error");
			console.error("Shipment map initialization failed", error);
		}
	};
	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", boot, { once: true });
	}
	else {
		boot();
	}
})(RouteOsm || (RouteOsm = {}));
