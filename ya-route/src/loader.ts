namespace RouteYandex {
	let yandexLoading: Promise<RouteYmaps.Api> | null = null;

	/** Load one official SDK, wait for its asynchronous modules, and fail visibly. No polling. */
	export const loadYandex = (config: Config["yandex"]): Promise<RouteYmaps.Api> => {
		if (yandexLoading) { return yandexLoading; }
		if (!config.apiKey.trim()) {
			return Promise.reject(new Error("Не задан ключ Яндекс Карт. Добавьте ROUTE_YANDEX_API_KEY в общий Config.php."));
		}
		yandexLoading = new Promise<RouteYmaps.Api>((resolve, reject) => {
			let settled = false;
			let script: HTMLScriptElement | null = null;
			const finish = (api: RouteYmaps.Api | null, error?: Error): void => {
				if (settled) { return; }
				settled = true;
				window.clearTimeout(timer);
				if (script) { script.onload = null; script.onerror = null; }
				if (api) { resolve(api); } else { reject(error); }
			};
			const timer = window.setTimeout(() => finish(null, new Error(
				"Яндекс Карты не загрузились вовремя. Проверьте ключ API, разрешённый домен и подключение, затем обновите страницу."
			)), config.loadTimeoutMs);
			const ready = (): void => {
				const api = window.ymaps3;
				if (!api?.ready) { finish(null, new Error("Не удалось инициализировать API Яндекс Карт v3.")); return; }
				void Promise.resolve(api.ready).then(() => {
					if (!api.YMap || !api.YMapMarker || !api.YMapFeature || !api.YMapListener || !api.YMapDefaultSchemeLayer || !api.YMapDefaultFeaturesLayer) {
						finish(null, new Error("Компоненты API Яндекс Карт v3 недоступны.")); return;
					}
					finish(api);
				}).catch(() => finish(null, new Error("Яндекс Карты отклонили загрузку. Проверьте API-ключ, лицензию и ограничение по домену.")));
			};
			if (window.ymaps3) { ready(); return; }
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
}
