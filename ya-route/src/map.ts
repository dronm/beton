namespace RouteYandex {
	export interface ShipmentMap {
		position: (position: Position) => void;
		route: (points: LonLat[]) => void;
		fit: () => void;
		find: () => void;
		toggleFollow: () => void;
		zoom: (delta: number) => void;
		dispose: () => void;
	}

	export const createMap = (sdk: RouteYmaps.Api, config: Config, callbacks: {
		follow: (enabled: boolean) => void;
		availability: (hasVehicle: boolean, hasGeometry: boolean) => void;
		error: (error: unknown) => void;
	}, initial: { position: Position | null; route: LonLat[] }): ShipmentMap => {
		const container = document.getElementById("map");
		if (!container) { throw new Error("Не найден контейнер карты."); }
		const maxZoom = config.yandex.maxZoom;
		const zoom = Math.min(maxZoom, Math.max(1, config.initialZoom ?? numberValue(window.TRACK_CONSTANTS?.INI_ZOOM) ?? 14));
		const map = new sdk.YMap(container, {
			location: { center: config.center, zoom },
			mode: config.yandex.mode,
			zoomRange: { min: 1, max: maxZoom },
			behaviors: ["drag", "scrollZoom", "dblClick", "pinchZoom", "oneFingerZoom"],
			showScaleInCopyrights: true,
		}, [new sdk.YMapDefaultSchemeLayer({}), new sdk.YMapDefaultFeaturesLayer({})]);
		// Native Yandex logo, attribution and "Open in Maps" controls are left intact.
		let line: RouteYmaps.Feature | null = null;
		let vehicle: RouteYmaps.Marker | null = null;
		let destination: RouteYmaps.Marker | null = null;
		let points: LonLat[] = [];
		let vehicleCoordinates: LonLat | null = null;
		let latestVehicleCoordinates: LonLat | null = null;
		let destinationCoordinates: LonLat | null = null;
		let following = config.followVehicle;
		let cameraTransition: { offset: LonLat; startedAt: number } | null = null;
		let pageSuspended = false;
		let disposed = false;
		const motion = movementOptions(config.movement);
		const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
		const activePage = (): boolean => !document.hidden && !pageSuspended;
		const mapCenter = (): LonLat => [map.center[0], map.center[1]];
		const cancelCamera = (): void => { map.setLocation({ center: mapCenter(), zoom: map.zoom, duration: 0 }); };

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

		const movement = createVehicleMovement(motion, (point, animated) => {
			const previous = vehicleCoordinates;
			vehicleCoordinates = [point[0], point[1]];
			const coordinates = unproject(point);
			if (vehicle) { vehicle.update({ coordinates }); } else {
				vehicle = new sdk.YMapMarker({ id: "shipment-vehicle", coordinates, draggable: false, disableRoundCoordinates: true, zIndex: 1000 }, vehicleElement);
				map.addChild(vehicle);
			}
			if (!following || !activePage()) { cameraTransition = null; return; }
			const arrived = latestVehicleCoordinates?.[0] === point[0] && latestVehicleCoordinates[1] === point[1];
			if (!animated || arrived) {
				cameraTransition = null;
				map.setLocation({ center: coordinates, duration: 0 });
				return;
			}
			// Retain the offset when following is enabled mid-movement, then ease it away.
			if (!cameraTransition && previous) {
				const current = project(mapCenter());
				if (Math.hypot(current[0] - previous[0], current[1] - previous[1]) > 0.01) {
					cameraTransition = { offset: [current[0] - previous[0], current[1] - previous[1]], startedAt: performance.now() };
				}
			}
			let cameraPoint = point;
			if (cameraTransition) {
				const progress = Math.min(1, (performance.now() - cameraTransition.startedAt) / Math.max(1, Math.min(300, motion.durationMs)));
				const remaining = (1 - progress) ** 2;
				cameraPoint = [point[0] + cameraTransition.offset[0] * remaining, point[1] + cameraTransition.offset[1] * remaining];
				if (progress === 1) { cameraTransition = null; }
			}
			map.setLocation({ center: unproject(cameraPoint), duration: 0 });
		});
		movement.setReducedMotion(reducedMotion.matches);
		if (!activePage()) { movement.pause(); }

		const zone = parseZone(config.destinationZone);
		if (zone === null) { callbacks.error(new Error("Не удалось отобразить зону объекта. Маршрут и положение машины остаются доступны.")); }
		const zoneDestination = zone?.length ? zoneInterior(zone[0]) : null;
		for (const [index, polygon] of (zone ?? []).entries()) {
			if (config.showZone) {
				map.addChild(new sdk.YMapFeature({
					id: `destination-zone-${index}`,
					geometry: { type: "Polygon", coordinates: polygon },
					style: { fill: "rgba(33, 142, 90, 0.09)", stroke: [{ color: "#369a69", width: 1.5 }], zIndex: 0 },
				}));
			}
		}
		const visiblePoints = (): LonLat[] => {
			const result = [...points];
			if (vehicleCoordinates) { result.push(unproject(vehicleCoordinates)); }
			if (latestVehicleCoordinates) { result.push(unproject(latestVehicleCoordinates)); }
			if (destinationCoordinates) { result.push(destinationCoordinates); }
			if (!result.length) { for (const polygon of zone ?? []) { result.push(...polygon[0]); } }
			return result;
		};
		const availability = (): void => callbacks.availability(vehicle !== null, visiblePoints().length > 0);
		const follow = (enabled: boolean): void => {
			following = enabled;
			cameraTransition = null;
			callbacks.follow(enabled);
		};
		const fit = (duration = 250): void => {
			const location = fitLocation(visiblePoints(), container.clientWidth, container.clientHeight, Math.min(config.fitMaxZoom, maxZoom));
			if (location) { map.setLocation({ ...location, duration: reducedMotion.matches ? 0 : duration }); }
		};
		const center = (): void => {
			if (!vehicleCoordinates || !activePage()) { return; }
			cameraTransition = null;
			cancelCamera();
			if (!movement.isAnimating()) { map.setLocation({ center: unproject(vehicleCoordinates), duration: reducedMotion.matches ? 0 : 300 }); }
		};
		const stopFollow = (): void => { if (!disposed) { follow(false); } };
		const listener = new sdk.YMapListener({
			onActionStart: ({ type }) => {
				if (["drag", "scrollZoom", "dblClick", "pinchZoom", "oneFingerZoom"].includes(type)) { stopFollow(); }
			},
		});
		map.addChild(listener);
		const keydown = (event: KeyboardEvent): void => {
			if (event.target !== container || !["ArrowUp", "ArrowDown", "ArrowLeft", "ArrowRight", "+", "=", "-"].includes(event.key)) { return; }
			event.preventDefault();
			stopFollow();
			if (["+", "=", "-"].includes(event.key)) { api.zoom(event.key === "-" ? -1 : 1); return; }
			const point = project(mapCenter());
			const offset = 40075016.68557849 / (256 * 2 ** map.zoom) * 80;
			if (event.key === "ArrowUp") { point[1] += offset; }
			if (event.key === "ArrowDown") { point[1] -= offset; }
			if (event.key === "ArrowLeft") { point[0] -= offset; }
			if (event.key === "ArrowRight") { point[0] += offset; }
			map.setLocation({ center: unproject(point), duration: 0 });
		};
		const visibility = (): void => {
			if (disposed) { return; }
			if (activePage()) {
				movement.resume();
				if (following && vehicleCoordinates) { map.setLocation({ center: unproject(vehicleCoordinates), duration: 0 }); }
			} else { movement.pause(); cameraTransition = null; cancelCamera(); }
		};
		const motionPreference = (): void => {
			movement.setReducedMotion(reducedMotion.matches);
			if (reducedMotion.matches && !disposed) { cancelCamera(); }
		};
		const pagehide = (event: PageTransitionEvent): void => {
			pageSuspended = true;
			visibility();
			if (!event.persisted) { dispose(); }
		};
		const pageshow = (): void => { if (pageSuspended) { pageSuspended = false; visibility(); } };
		const dispose = (): void => {
			if (disposed) { return; }
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

		const api: ShipmentMap = {
			position: (position) => {
				if (disposed) { return; }
				latestVehicleCoordinates = project(position.coordinates);
				vehicleElement.title = `${config.vehiclePlate} · ${formatPeriod(position.period)}`;
				movement.update(position, latestVehicleCoordinates);
				availability();
			},
			route: (nextPoints) => {
				if (disposed) { return; }
				points = nextPoints.map((point) => [...point]);
				if (points.length > 1) {
					const geometry: RouteYmaps.Geometry = { type: "LineString", coordinates: points };
					if (line) { line.update({ geometry }); } else {
						line = new sdk.YMapFeature({ id: "remaining-route", geometry,
							style: { stroke: [{ color: "#ffffff", width: 8 }, { color: "#176bd1", width: 4 }], zIndex: 10 },
						});
						map.addChild(line);
					}
				} else if (line) { map.removeChild(line); line = null; }
				destinationCoordinates = points.length ? points[points.length - 1] : zoneDestination;
				if (destinationCoordinates) {
					if (destination) { destination.update({ coordinates: destinationCoordinates }); } else {
						destination = new sdk.YMapMarker({ id: "shipment-destination", coordinates: destinationCoordinates, zIndex: 500 }, destinationElement);
						map.addChild(destination);
					}
				} else if (destination) { map.removeChild(destination); destination = null; }
				availability();
			},
			fit: () => { if (!disposed) { follow(false); fit(); } },
			find: () => {
				if (disposed || !vehicleCoordinates) { return; }
				follow(true);
				map.setLocation({ zoom: Math.max(map.zoom, zoom), duration: 0 });
				center();
			},
			toggleFollow: () => { if (!disposed) { follow(!following); if (following) { center(); } } },
			zoom: (delta) => {
				if (disposed) { return; }
				follow(false);
				map.setLocation({ zoom: Math.min(maxZoom, Math.max(1, map.zoom + delta)), duration: reducedMotion.matches ? 0 : 200 });
			},
			dispose,
		};
		if (initial.position) { api.position(initial.position); }
		api.route(initial.route);
		fit(0);
		return api;
	};
}
