namespace RouteYandex {
	const element = <T extends HTMLElement>(id: string): T => {
		const node = document.getElementById(id);
		if (!node) { throw new Error(`Missing page element: ${id}`); }
		return node as T;
	};

	const boot = async (): Promise<void> => {
		element<HTMLButtonElement>("reload-page").addEventListener("click", () => window.location.reload());
		const notice = element("notice");
		const showNotice = (message: string, kind = "warning", scope = "route"): void => {
			notice.textContent = message;
			notice.dataset.kind = kind;
			notice.dataset.scope = scope;
			notice.hidden = false;
		};
		const status = (message: string, kind: "waiting" | "received" | "error"): void => {
			const node = element("live-status");
			node.textContent = message;
			node.dataset.kind = kind;
		};
		const showError = (error: unknown, scope = "route"): void => {
			if (error instanceof HttpError && [403, 404, 410].includes(error.status)) {
				window.location.reload();
				return;
			}
			showNotice(error instanceof Error ? error.message : "Не удалось обновить данные.", "error", scope);
		};
		try {
			const config = JSON.parse(element("route-config").textContent ?? "null") as Config | null;
			if (!config || !Number.isInteger(config.id) || !config.trackerId) { throw new Error("Некорректные данные страницы."); }
			const findButton = element<HTMLButtonElement>("find-vehicle");
			const fitButton = element<HTMLButtonElement>("fit-route");
			const followButton = element<HTMLButtonElement>("follow-vehicle");
			let map: ShipmentMap | null = null;
			let disposed = false;
			let latestPosition = parsePosition(config.position);
			const parsedInitialRoute = parseRoute(config.route);
			let latestRoute = parsedInitialRoute ?? [];
			if (parsedInitialRoute === null) { showNotice("Начальная линия маршрута некорректна. Ожидаем обновление."); }
			const cleanup = (): void => { disposed = true; map?.dispose(); };
			window.addEventListener("pagehide", (event) => { if (!event.persisted) { cleanup(); } });
			const showPosition = (position: Position): void => {
				const node = element("position-time");
				node.textContent = formatPeriod(position.period);
				node.title = position.period ? `Время из системы трекинга: ${position.period}` : "Время позиции не получено";
			};
			if (latestPosition) { showPosition(latestPosition); }
			element("distance").textContent = formatDistance(config.distance);
			findButton.addEventListener("click", () => map?.find());
			fitButton.addEventListener("click", () => map?.fit());
			followButton.addEventListener("click", () => map?.toggleFollow());
			const AppSrv = window.AppSrv;
			if (!AppSrv) {
				status("AppSrv не загружен", "error");
				showNotice("Показаны начальные данные. Не загружен ../js20/core/AppSrv.js или одна из его зависимостей. Автоматические обновления недоступны.", "error", "appsrv");
			} else if (!config.appSrv.host || !config.appSrv.port || !config.appSrv.appId) {
				status("AppSrv не настроен", "error");
				showNotice("Проверьте APP_SERVER_HOST, APP_SERVER_PORT, APP_SERVER_PORT_SECURED и APP_NAME в Config.php.", "error", "appsrv");
			} else {
				try {
					const stop = subscribe(AppSrv, config, {
						position: (position) => { latestPosition = position; map?.position(position); showPosition(position); },
						distance: (distance) => { element("distance").textContent = formatDistance(distance); },
						route: (points) => {
							latestRoute = points;
							map?.route(points);
							if (["route", "location-waiting"].includes(notice.dataset.scope ?? "")) { notice.hidden = true; }
						},
						fetchRoute: (signal) => loadRoute(config, signal),
						received: () => status(`Обновление в ${new Date().toLocaleTimeString("ru-RU")}`, "received"),
						error: showError,
						reload: () => window.location.reload(),
					});
					window.addEventListener("pagehide", (event) => { if (!event.persisted) { stop(); } });
				} catch (error: unknown) {
					status("Не удалось подключить AppSrv", "error");
					showNotice("Показаны начальные данные. Проверьте загрузку зависимостей AppSrv и настройки WebSocket.", "error", "appsrv");
					console.error("AppSrv initialization failed", error);
				}
			}
			window.addEventListener("offline", () => status("Нет подключения к интернету", "error"));
			window.addEventListener("online", () => status("Ожидание обновлений", "waiting"));
			if (!navigator.onLine) { status("Нет подключения к интернету", "error"); }
			const locationButton = document.getElementById("share-location") as HTMLButtonElement | null;
			if (locationButton && config.locationEnabled && config.locationToken) {
				locationButton.disabled = false;
				locationButton.addEventListener("click", () => {
					if (!window.isSecureContext || !navigator.geolocation) {
						showNotice("Для передачи местоположения откройте страницу по HTTPS и разрешите доступ к геолокации.", "error", "location");
						return;
					}
					if (!window.confirm("Вы сейчас на месте разгрузки? Ваше текущее местоположение будет передано для построения маршрута водителю.")) { return; }
					locationButton.disabled = true;
					locationButton.textContent = "Определяем…";
					const reset = (): void => { locationButton.disabled = false; locationButton.textContent = "Я на объекте"; };
					navigator.geolocation.getCurrentPosition((position) => {
						locationButton.textContent = "Отправляем…";
						void requestJson(config.locationUrl, config.locationToken as string, config.requestTimeoutMs, {
							body: { lon: position.coords.longitude, lat: position.coords.latitude },
						}).then((data) => {
							if (!isRecord(data) || data.ok !== true) { throw new Error("Не удалось подтвердить передачу местоположения."); }
							element("location-panel").hidden = true;
							showNotice("Место разгрузки передано. Ожидаем новый маршрут от диспетчерской системы.", "warning", "location-waiting");
							// Vehicle.rebuild_route -> AppSrv event. Deliberately no HTTP refresh here.
						}).catch((error: unknown) => showError(error, "location")).finally(reset);
					}, (error) => {
						showNotice(error.code === 1 ? "Доступ к местоположению запрещён в браузере." :
							error.code === 3 ? "Не удалось определить местоположение вовремя. Попробуйте ещё раз." : "Местоположение сейчас недоступно.", "error", "location");
						reset();
					}, { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 });
				});
			}
			// Subscribe before waiting for the SDK. Events arriving during load are retained,
			// and the newest fix is displayed immediately rather than replaying a backlog.
			const sdk = await loadYandex(config.yandex);
			if (disposed) { return; }
			map = createMap(sdk, config, {
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

		} catch (error: unknown) {
			const message = error instanceof Error ? error.message : "Не удалось открыть карту.";
			element("map-message").textContent = message;
			status("Карта недоступна", "error");
			console.error("Shipment map initialization failed", error);
		}
	};

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", () => { void boot(); }, { once: true });
	} else {
		void boot();
	}
}
