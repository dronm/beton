namespace RouteOsm {
	export interface ShipmentMap {
		position: (position: Position) => void;
		route: (points: LonLat[]) => void;
		fit: () => void;
		find: () => void;
		toggleFollow: () => void;
		dispose: () => void;
	}

	export const createMap = (config: Config, callbacks: {
		follow: (enabled: boolean) => void;
		availability: (hasVehicle: boolean, hasGeometry: boolean) => void;
		tiles: (failed: boolean) => void;
		error: (error: unknown) => void;
	}): ShipmentMap => {
		const routeFeature = new ol.Feature();
		const vehicleFeature = new ol.Feature();
		const destinationFeature = new ol.Feature();
		const zoneFeature = new ol.Feature();
		let zoneDestination: number[] | undefined;
		let zoneGeometry: RouteOl.Geometry | undefined;
		let vehicleCoordinates: number[] | null = null;
		let following = config.followVehicle;
		let vehicleGeometry: RouteOl.Point | null = null;
		let latestVehicleCoordinates: number[] | null = null;
		let cameraTransition: { offset: number[]; startedAt: number } | null = null;
		let pageSuspended = false;
		let disposed = false;
		const motion = movementOptions(config.movement);
		const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
		const activePage = (): boolean => !document.hidden && !pageSuspended;
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
		const legacyZoom = numberValue(window.TRACK_CONSTANTS?.INI_ZOOM);
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
		const movement = createVehicleMovement(motion, (point, animated) => {
			const previous = vehicleCoordinates;
			vehicleCoordinates = point;
			if (vehicleGeometry) {
				vehicleGeometry.setCoordinates(point);
			} else {
				vehicleGeometry = new ol.geom.Point(point);
				vehicleFeature.setGeometry(vehicleGeometry);
			}
			if (!following || !activePage()) { cameraTransition = null; return; }
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
				if (progress === 1) { cameraTransition = null; }
			} else {
				view.setCenter(point);
			}
		});
		movement.setReducedMotion(reducedMotion.matches);
		if (!activePage()) { movement.pause(); }
		if (isRecord(config.destinationZone) && ["Polygon", "MultiPolygon"].includes(String(config.destinationZone.type))) {
			try {
				zoneGeometry = new ol.format.GeoJSON().readGeometry(config.destinationZone, { dataProjection: "EPSG:4326", featureProjection: "EPSG:3857" });
				const polygon = zoneGeometry instanceof ol.geom.Polygon ? zoneGeometry :
					zoneGeometry instanceof ol.geom.MultiPolygon ? zoneGeometry.getPolygons()[0] : undefined;
				const interior = polygon?.getInteriorPoint().getCoordinates().slice(0, 2);
				if (interior?.length === 2 && interior.every(Number.isFinite)) { zoneDestination = interior; }
				if (config.showZone && zoneGeometry.getExtent().every(Number.isFinite)) { zoneFeature.setGeometry(zoneGeometry); }
			} catch (error: unknown) {
				callbacks.error(new Error("Не удалось отобразить зону объекта. Маршрут и положение машины остаются доступны."));
			}
		}
		const extent = (): number[] => {
			const result = ol.extent.createEmpty();
			for (const feature of [routeFeature, vehicleFeature, destinationFeature]) {
				const bounds = feature.getGeometry()?.getExtent();
				if (bounds?.every(Number.isFinite)) { ol.extent.extend(result, bounds); }
			}
			if (ol.extent.isEmpty(result) && zoneGeometry?.getExtent().every(Number.isFinite)) {
				ol.extent.extend(result, zoneGeometry.getExtent());
			}
			return result;
		};
		const availability = (): void => callbacks.availability(vehicleCoordinates !== null, !ol.extent.isEmpty(extent()));
		const follow = (enabled: boolean): void => {
			following = enabled;
			cameraTransition = null;
			map.getView().cancelAnimations();
			callbacks.follow(enabled);
		};
		const fit = (): void => {
			map.updateSize();
			const bounds = extent();
			if (!ol.extent.isEmpty(bounds)) {
				map.getView().cancelAnimations();
				map.getView().fit(bounds, { padding: [55, 55, 65, 55], maxZoom: Math.min(config.fitMaxZoom, config.tiles.maxZoom), duration: reducedMotion.matches ? 0 : 250 });
			}
		};
		const center = (): void => {
			if (vehicleCoordinates && activePage()) {
				map.getView().cancelAnimations();
				cameraTransition = null;
				// A moving marker takes the camera along on the next frame.
				if (!movement.isAnimating()) {
					map.getView().animate({ center: vehicleCoordinates, duration: reducedMotion.matches ? 0 : 300 });
				}
			}
		};
		const stopFollow = (): void => follow(false);
		const keydown = (event: KeyboardEvent): void => {
			if (["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight"].includes(event.key)) { stopFollow(); }
		};
		const visibility = (): void => {
			if (activePage()) {
				movement.resume();
				if (following && vehicleCoordinates) { map.getView().setCenter(vehicleCoordinates); }
			} else {
				movement.pause();
				cameraTransition = null;
				map.getView().cancelAnimations();
			}
		};
		const motionPreference = (): void => {
			movement.setReducedMotion(reducedMotion.matches);
			if (reducedMotion.matches) { map.getView().cancelAnimations(); }
		};
		const pagehide = (event: PageTransitionEvent): void => {
			pageSuspended = true;
			visibility();
			if (!event.persisted) { dispose(); }
		};
		const pageshow = (): void => { if (pageSuspended) { pageSuspended = false; visibility(); } };
		const mapElement = document.getElementById("map");
		const dispose = (): void => {
			if (disposed) { return; }
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
		const api: ShipmentMap = {
			position: (position) => {
				if (disposed) { return; }
				latestVehicleCoordinates = ol.proj.fromLonLat(position.coordinates);
				movement.update(position, latestVehicleCoordinates);
				availability();
			},
			route: (points) => {
				if (disposed) { return; }
				const projected = points.map((point) => ol.proj.fromLonLat(point));
				routeFeature.setGeometry(projected.length > 1 ? new ol.geom.LineString(projected) : undefined);
				const destination = projected.length > 0 ? projected[projected.length - 1] : zoneDestination;
				destinationFeature.setGeometry(destination ? new ol.geom.Point(destination) : undefined);
				availability();
			},
			fit: () => { if (!disposed) { follow(false); fit(); } },
			find: () => {
				if (disposed || !vehicleCoordinates) { return; }
				follow(true);
				map.getView().setZoom(Math.max(map.getView().getZoom() ?? zoom, zoom));
				center();
			},
			toggleFollow: () => { if (!disposed) { follow(!following); if (following) { center(); } } },
			dispose,
		};
		const initialPosition = parsePosition(config.position);
		if (initialPosition) { api.position(initialPosition); }
		const initialRoute = parseRoute(config.route);
		api.route(initialRoute ?? []);
		if (initialRoute === null) { callbacks.error(new Error("Начальная линия маршрута некорректна. Ожидаем обновление.")); }
		fit();
		return api;
	};
}
