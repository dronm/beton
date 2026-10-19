namespace RouteYandex {
	export class HttpError extends Error {
		constructor(message: string, public readonly status: number) {
			super(message);
			this.name = "HttpError";
		}
	}

	export const requestJson = async (
		url: string,
		token: string,
		timeoutMs: number,
		options: { body?: unknown; signal?: AbortSignal } = {},
	): Promise<unknown> => {
		const controller = new AbortController();
		let timedOut = false;
		const abort = (): void => controller.abort();
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
			const headers: Record<string, string> = { Accept: "application/json", "X-Route-Token": token };
			if (options.body !== undefined) { headers["Content-Type"] = "application/json"; }
			const response = await fetch(url, {
				method: options.body === undefined ? "GET" : "POST",
				headers,
				body: options.body === undefined ? undefined : JSON.stringify(options.body),
				credentials: "same-origin",
				cache: "no-store",
				signal: controller.signal,
			});
			let data: unknown;
			try {
				data = await response.json();
			} catch {
				throw new HttpError("Сервер вернул некорректный ответ. Попробуйте обновить страницу.", response.status);
			}
			if (!response.ok) {
				throw new HttpError(isRecord(data) && typeof data.error === "string" ? data.error : "Не удалось выполнить запрос.", response.status);
			}
			return data;
		} catch (error: unknown) {
			if (timedOut) { throw new Error("Сервер не ответил вовремя. Ожидаем следующее обновление или обновите страницу."); }
			throw error;
		} finally {
			clearTimeout(timeout);
			options.signal?.removeEventListener("abort", abort);
		}
	};

	export const loadRoute = async (config: Config, signal: AbortSignal): Promise<LonLat[]> => {
		const data = await requestJson(config.routeUrl, config.readToken, config.requestTimeoutMs, { signal });
		if (!isRecord(data) || !Object.prototype.hasOwnProperty.call(data, "route")) {
			throw new Error("В ответе сервера отсутствует маршрут.");
		}
		const points = parseRoute(data.route);
		if (points === null) { throw new Error("Сервер вернул некорректную линию маршрута."); }
		return points;
	};
}
