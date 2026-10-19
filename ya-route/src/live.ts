namespace RouteYandex {
	export interface LiveCallbacks {
		position: (position: Position) => void;
		distance: (distance: number | null) => void;
		route: (points: LonLat[]) => void;
		fetchRoute: (signal: AbortSignal) => Promise<LonLat[]>;
		received: () => void;
		error: (error: unknown) => void;
		reload: () => void;
	}

	/** Event-triggered queue. No interval, scheduled refresh, or polling fallback. */
	export class RouteUpdates {
		private revision = 0;
		private controller: AbortController | null = null;
		private pending = false;
		private disposed = false;

		constructor(private readonly callbacks: Pick<LiveCallbacks, "fetchRoute" | "route" | "error">) {}

		inline = (points: LonLat[]): void => {
			if (this.disposed) { return; }
			this.revision++;
			this.pending = false;
			this.controller?.abort();
			this.callbacks.route(points);
		};

		request = (): void => {
			if (this.disposed) { return; }
			this.revision++;
			if (this.controller) {
				this.pending = true;
				return;
			}
			this.start();
		};

		dispose = (): void => {
			this.disposed = true;
			this.pending = false;
			this.controller?.abort();
		};

		private start = (): void => {
			const revision = this.revision;
			const controller = new AbortController();
			this.controller = controller;
			void Promise.resolve().then(() => this.callbacks.fetchRoute(controller.signal)).then((points) => {
				if (!this.disposed && !controller.signal.aborted && revision === this.revision) {
					this.callbacks.route(points);
				}
			}).catch((error: unknown) => {
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

	export const subscribe = (Constructor: AppSrvConstructor, config: Config, callbacks: LiveCallbacks): (() => void) => {
		const positionId = `Vehicle.position.${config.trackerId}`;
		const redrawId = `Vehicle.route_redraw.${config.trackerId}`;
		const endId = `Vehicle.route_end.${config.trackerId}`;
		const updates = new RouteUpdates(callbacks);
		const acceptPosition = createPositionOrder(parsePosition(config.position)?.period ?? null);
		let stopped = false;
		const stop = (): void => { stopped = true; updates.dispose(); };
		const reload = (): void => {
			if (!stopped) { stop(); callbacks.reload(); }
		};
		const onEvent = (event: unknown): void => {
			if (stopped || !isRecord(event) || typeof event.eventId !== "string") { return; }
			if (event.eventId === endId || event.eventId === "User.logout") {
				reload();
				return;
			}
			if (event.eventId !== positionId && event.eventId !== redrawId) { return; }
			if (!isRecord(event.params)) { return; }
			const params = event.params;
			const position = event.eventId === positionId ? parsePosition(params) : null;
			// An older GPS packet must not regress the marker, its time, distance, or bundled route.
			if (position && !acceptPosition(position.period)) { return; }
			callbacks.received();
			if (event.eventId === positionId) {
				if (position) { callbacks.position(position); }
			}
			if (Object.prototype.hasOwnProperty.call(params, "route_rest_len")) {
				const distance = numberValue(params.route_rest_len);
				if (params.route_rest_len === null || (distance !== null && distance >= 0)) {
					callbacks.distance(distance);
				}
			}
			if (params.long_route_rest === true) {
				updates.request();
			} else if (Object.prototype.hasOwnProperty.call(params, "route_rest")) {
				const points = parseRoute(params.route_rest);
				if (points === null) {
					callbacks.error(new Error("Получена некорректная линия маршрута. Сохраняем предыдущую."));
				} else {
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
		} catch (error: unknown) {
			stop();
			throw error;
		}
		// Socket reconnect/heartbeat behavior belongs to AppSrv, not this adapter.
		return stop;
	};
}
