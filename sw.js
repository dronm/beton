const CACHE_NAME = 'static-cache-v1.1';
const STATIC_ASSETS = [
	"/",
	"img/dot_blue.png",
	"img/dot_green.png",
	"img/dot_red.png",
	"img/favicon.ico",
	"img/loading.gif",
	"img/marker.png",
	"img/marker-blue.png",
	"img/marker-gold.png",
	"img/marker-green.png",
	"img/mixer.png",
	"img/pointer_blue.png",
	"img/pointer_green.png",
	"img/pointer_red.png",
	"img/tm.png",
	"img/wait-lg.gif",
	"img/wait-sm.gif",
	"js20/assets/css/bootstrap.css",
	"js20/assets/css/core.min.css",
	"js20/assets/css/components.min.css",
	"js20/assets/css/colors.min.css",
	"js20/assets/css/icons/fontawesome/styles.min.css",
	"js20/ext/bootstrap-datepicker/bootstrap-datepicker.standalone.min.css",
	"js20/ext/chart.js-2.8.0/Chart.min.css",
	"js20/custom-css/style.css",
	"js20/custom-css/print.css",
	"js20/assets/css/icons/icomoon/styles.css",
	"js20/assets/js/core/libraries/jquery.min.js",
	"js20/assets/js/core/libraries/bootstrap.min.js",
	"js20/assets/js/plugins/loaders/blockui.min.js",
	"js20/assets/js/core/app.js",
	"js20/assets/js/plugins/forms/styling/switchery.min.js",
	"js20/assets/js/plugins/forms/styling/uniform.min.js",
	"js20/ext/bootstrap-datepicker/bootstrap-datepicker.min.js",
	"js20/ext/bootstrap-datepicker/bootstrap-datepicker.ru.min.js",
	"js20/ext/OpenLayers/OpenLayers.js",
	"js20/ext/chart.js-2.8.0/Chart.min.js",
	"js20/jquery.maskedinput.js",
	"js20/ext/cleave/cleave.min.js",
	"js20/ext/cleave/cleave-phone.ru.js",
	"js20/ext/mustache/mustache.min.js",
	"js20/ext/jshash-2.2/md5-min.js",
	"js20/ext/jshash-2.2/md5-min.js",
	"js20/lib.js",
];

let isOffline = false;
const SW_SCOPE = (self.registration && self.registration.scope) ? self.registration.scope : '/';

self.addEventListener("install", event => {
	console.log("SW install fired");
	event.waitUntil(
		caches.open(CACHE_NAME).then(cache => {
			return Promise.all(
				STATIC_ASSETS.map(url =>
					cache.add(url).catch(err => console.warn("Failed to cache:", url, err))
				)
			);
		})
	);
});

self.addEventListener("activate", event => {
	event.waitUntil(
		(async () => {
			// Delete old cache versions
			const cacheNames = await caches.keys();
			await Promise.all(
				cacheNames
					.filter(name => name !== CACHE_NAME)
					.map(name => caches.delete(name))
			);

			// Delete outdated date requests inside current cache
			const cache = await caches.open(CACHE_NAME);
			const requests = await cache.keys();
			const curDate = new Date().toISOString().split('T')[0];

			await Promise.all(
				requests.map(request => {
					const url = new URL(request.url);
					const dateParam = url.searchParams.get("date");
					if (dateParam && dateParam !== curDate) {
						console.log("Deleting outdated cache:", request.url);
						return cache.delete(request);
					}
					// ensure Promise.all gets something to wait on for every item:
					return Promise.resolve();
				})
			);

			// Take control of all clients
			await self.clients.claim();
		})()
	);
});

// Utility to notify all controlled clients
async function notifyClients(message) {
	const clients = await self.clients.matchAll({ type: 'window' });
	clients.forEach(client => client.postMessage(message));
}

/*
self.addEventListener('fetch', event => {
	const url = new URL(event.request.url);

	let isStaticAsset =
		['script', 'style', 'image', 'font'].includes(event.request.destination) ||
		/\.(js|css|png|jpe?g|gif|svg|ico|woff2?|ttf|eot)$/.test(url.pathname);

	if (url.pathname.endsWith('/sw.js')) {
		isStaticAsset = false; //no cache for sw itself
	}

	const isRoot = (
		event.request.url.indexOf("c=") === -1
		&& event.request.url === SW_SCOPE
	);

	let isCachable = isRoot || isStaticAsset;

	let paramC = null;
	let paramF = null;
	let paramT = null;
	let isOrderMakeFormHTTPQuery = false;
	let isOrderMakeFormWSQuery = false;

	if (!isRoot && event.request.method === 'GET') {
		paramC = url.searchParams.get('c');
		paramF = url.searchParams.get('f');
		paramT = url.searchParams.get('t');
		isOrderMakeFormHTTPQuery = (paramC === "Order_Controller" && paramF === "get_make_orders_form");
		isOrderMakeFormWSQuery = (
			(paramC === "Order_Controller" && paramF === "get_make_orders_form_ord")
			|| (paramC === "Order_Controller" && paramF === "get_make_orders_form_mat")
			|| (paramC === "Order_Controller" && paramF === "get_make_orders_form_veh")
		);

		//all cachable queries
		if (isOrderMakeFormHTTPQuery || isOrderMakeFormWSQuery) {
			const paramD = url.searchParams.get('date');
			if (!paramD) {
				isCachable = true; // no date → cache it
			} else {
				// date param exists → cache only if it is current date (or previous date if current time is between 00 - 06 hours)
				let curDate = new Date();
				const hour = curDate.getHours();
				// if hour between 0 and 5 (inclusive), allow previous date
				if (hour >= 0 && hour < 6) {
					// keep curDate as now (so previous date logic is applied below)
					curDate.setDate(curDate.getDate() - 1);
				}
				const curDateStr = curDate.toISOString().split('T')[0];
				isCachable = (paramD === curDateStr);
			}
			// console.log("get_make_orders_form query isCachable:" + isCachable);

		} else if (
			(paramC === "Constant_Controller" && paramF === "get_values")
			|| (paramC === "SessionVar_Controller" && paramF === "get_values")
			|| (paramC === "ConnectElkonCheck_Controller" && paramF === "connected")
			|| (paramC === "Connect1cCheck_Controller" && paramF === "connected")
			|| (paramC === "Vehicle_Controller" && paramF === "get_vehicle_statistics")
			|| (paramC === "ProductionSite_Controller" && paramF === "get_list")
			|| (paramC === "Weather_Controller")
			|| (paramC === "UserChat_Controller" && paramF === "get_history")
			|| (paramC === "UserChat_Controller" && paramF === "get_user_list")
			|| (paramC === "ChatStatus_Controller" && paramF === "get_list")
			|| (paramC === "Shipment_Controller" && paramF === "get_operator_list")
			|| (paramC === "Shipment_Controller" && paramF === "get_assigned_vehicle_list")
			|| (url.searchParams.get('t') === "ShipmentForOrderList")
		) {
			isCachable = true;
		}
	}

	// console.log("URL:" + url.href + ", isCachable:" + isCachable + ", isRoot:" + isRoot + ", offline:" + isOffline + ", isStaticAsset:" + isStaticAsset);

	if (isCachable) {
		event.respondWith(
			(async () => {
				const cacheKey = (isOrderMakeFormWSQuery || isOrderMakeFormHTTPQuery) && paramC && paramF
					? (paramC + "&" + paramF + (paramT? "&"+paramT : "") )
					: event.request;

				try {
					const networkResponse = await fetch(event.request);

					// Cache only if response is OK
					if (networkResponse && networkResponse.ok) {
						const cache = await caches.open(CACHE_NAME);
						await cache.put(cacheKey, networkResponse.clone());

						if (isOffline && !isStaticAsset) {
							// console.log("setting isOffline to FALSE");
							isOffline = false;
							notifyClients({ type: 'ONLINE' });
						}

						// if(isOrderMakeFormWSQuery || isOrderMakeFormHTTPQuery){
							// console.log("request is cached isOrderMakeFormHTTPQuery="+isOrderMakeFormHTTPQuery+" isOrderMakeFormWSQuery="+isOrderMakeFormWSQuery+", cacheKey:",cacheKey);
						// }
					}

					return networkResponse;

				} catch (error) {
					if (!isStaticAsset) {
						isOffline = true;
						// console.log("error fetching resource, setting isOffline to TRUE");
						notifyClients({ type: 'OFFLINE' });
					}

					// Network failed, try cache
					const cache = await caches.open(CACHE_NAME);
					let cachedResponse = await cache.match(
						cacheKey,
						isStaticAsset ? { ignoreSearch: true } : {}
					);

					if (!cachedResponse && (isOrderMakeFormHTTPQuery || isOrderMakeFormWSQuery)) {
						// combine specific models
						console.log("calling buildOrderFormResponse");
						cachedResponse = await buildOrderFormResponse(cache, event.request, cacheKey);
					}

					if (cachedResponse) {
						console.log("returning cached data");
						return cachedResponse;
					} else {
						return new Response('Resource unavailable', {
							status: 503,
							statusText: 'Service Unavailable'
						});
					}
				}
			})()
		);
	}
});
*/

// Make this async function (correct syntax), and use DOMParser (available in workers)
async function importModels(cache, cacheKey, doc, root) {
	const response = await cache.match(cacheKey);
	if (!response) return false;

	const text = await response.text();
	const parser = new DOMParser();
	const xml = parser.parseFromString(text, 'application/xml');

	// Extract the <model> element(s)
	let importCount = 0;
	const models = xml.getElementsByTagName('model');

	for (const model of Array.from(models)) {
		const imported = doc.importNode(model, true);
		root.appendChild(imported);
		importCount++;
	}

	return (importCount > 0);
}

// returns combined Response object.
async function buildOrderFormResponse(cache, request, cacheKey) {
	// Create root <document> using DOMParser (document.* not available in workers)
	const parser = new DOMParser();
	const doc = parser.parseFromString('<document></document>', 'application/xml');
	const root = doc.documentElement;
	const serializer = new XMLSerializer();

	// retrieve these queries from cache
	const keyOrder = "Order_Controller" + "&" + "get_make_orders_form_ord";
	const keyMat = "Order_Controller" + "&" + "get_make_orders_form_mat";
	const keyVeh = "Order_Controller" + "&" + "get_make_orders_form_veh";

	const ordExists = await importModels(cache, keyOrder, doc, root);
	const matExists = await importModels(cache, keyMat, doc, root);
	const vehExists = await importModels(cache, keyVeh, doc, root);

	const xmlString = serializer.serializeToString(doc);
	const result = new Response(xmlString, {
		headers: { 'Content-Type': 'application/xml' }
	});

	if (ordExists && matExists && vehExists) {
		// put for future use
		// console.log("putting to cache new combined response");
		await cache.put("Order_Controller&get_make_orders_form", result.clone());
	}

	return result;
}

