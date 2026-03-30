const SW_VERSION = '2026-03-30-2';
const CACHE_NAME = 'static-cache-v1.4';

/*
	* add this query to cache
	*http://localhost/beton_new/?c=Shipment_Controller&f=get_list_for_order&v=ViewXML&cond_fields=order_id&cond_sgns=e&cond_vals=134812&cond_ic=0&field_sep=@@
	*/

const LOG_LEVELS = {
	ERROR: 0,
	WARN: 1,
	INFO: 2,
	DEBUG: 3,
};
const LOG_LEVEL = LOG_LEVELS.INFO;//DEBUG

const STATIC_ASSETS = [
	'/',
	'img/dot_blue.png',
	'img/dot_green.png',
	'img/dot_red.png',
	'img/favicon.ico',
	'img/loading.gif',
	'img/marker.png',
	'img/marker-blue.png',
	'img/marker-gold.png',
	'img/marker-green.png',
	'img/mixer.png',
	'img/pointer_blue.png',
	'img/pointer_green.png',
	'img/pointer_red.png',
	'img/tm.png',
	'img/wait-lg.gif',
	'img/wait-sm.gif',
	'js20/assets/css/bootstrap.css',
	'js20/assets/css/core.min.css',
	'js20/assets/css/components.min.css',
	'js20/assets/css/colors.min.css',
	'js20/assets/css/icons/fontawesome/styles.min.css',
	'js20/ext/bootstrap-datepicker/bootstrap-datepicker.standalone.min.css',
	'js20/ext/chart.js-2.8.0/Chart.min.css',
	'js20/custom-css/style.css',
	'js20/custom-css/print.css',
	'js20/assets/css/icons/icomoon/styles.css',
	'js20/assets/js/core/libraries/jquery.min.js',
	'js20/assets/js/core/libraries/bootstrap.min.js',
	'js20/assets/js/plugins/loaders/blockui.min.js',
	'js20/assets/js/core/app.js',
	'js20/assets/js/plugins/forms/styling/switchery.min.js',
	'js20/assets/js/plugins/forms/styling/uniform.min.js',
	'js20/ext/bootstrap-datepicker/bootstrap-datepicker.min.js',
	'js20/ext/bootstrap-datepicker/bootstrap-datepicker.ru.min.js',
	'js20/ext/OpenLayers/OpenLayers.js',
	'js20/ext/chart.js-2.8.0/Chart.min.js',
	'js20/jquery.maskedinput.js',
	'js20/ext/cleave/cleave.min.js',
	'js20/ext/cleave/cleave-phone.ru.js',
	'js20/ext/mustache/mustache.min.js',
	'js20/ext/jshash-2.2/md5-min.js',
	'js20/ext/jshash-2.2/md5-min.js',
	'js20/lib.js',
];

let isOriginUnavailable = false;
const SW_SCOPE = (self.registration && self.registration.scope) ? self.registration.scope : '/';

self.addEventListener('install', event => {
	swLog(LOG_LEVELS.INFO, 'loaded version:', SW_VERSION);

	self.skipWaiting();

	event.waitUntil(
		(async () => {
			const cache = await caches.open(CACHE_NAME);

			await Promise.all(
				STATIC_ASSETS.map(url =>
					cache.add(url).catch(err => {
						swLog(LOG_LEVELS.WARN, 'Failed to cache:', url, err);
					})
				)
			);
		})()
	);
});

self.addEventListener('activate', event => {
	swLog(LOG_LEVELS.INFO, 'activate version:', SW_VERSION);

	event.waitUntil(
		(async () => {
			await deleteOldCaches();
			await deleteOutdatedDateRequests();
			await self.clients.claim();
			swLog(LOG_LEVELS.DEBUG, 'activate done version:', SW_VERSION);
		})()
	);
});

self.addEventListener('fetch', event => {
	const request = event.request;
	const url = new URL(request.url);

	swLog(LOG_LEVELS.DEBUG, 'fetch event:', request.method, request.url);

	if (url.pathname === '/healthz.txt') {
		event.respondWith(handleHealthCheckRequest(request));
		return;
	}

	if (request.method !== 'GET') {
		swLog(LOG_LEVELS.DEBUG, 'skip non-GET:', request.url);
		return;
	}

	const policy = getRequestPolicy(request);

	swLog(LOG_LEVELS.DEBUG, 'policy:', {
		url: request.url,
		isCacheable: policy.isCacheable,
		isStaticAsset: policy.isStaticAsset,
		isRoot: policy.isRoot,
		isOrderMakeFormHTTPQuery: policy.isOrderMakeFormHTTPQuery,
		isOrderMakeFormWSQuery: policy.isOrderMakeFormWSQuery,
		cacheKey: policy.cacheKey
	});

	if (!policy.isCacheable) {
		swLog(LOG_LEVELS.DEBUG, 'request is not cacheable:', request.url);
		return;
	}

	swLog(LOG_LEVELS.DEBUG, 'request is cacheable:', request.url);
	event.respondWith(handleCacheableRequest(request, policy));
});

async function deleteOldCaches() {
	const cacheNames = await caches.keys();

	await Promise.all(
		cacheNames
			.filter(name => name !== CACHE_NAME)
			.map(name => caches.delete(name))
	);
}

async function deleteOutdatedDateRequests() {
	const cache = await caches.open(CACHE_NAME);
	const requests = await cache.keys();
	const curDate = new Date().toISOString().split('T')[0];

	await Promise.all(
		requests.map(request => {
			const url = new URL(request.url);
			const dateParam = url.searchParams.get('date');

			if (dateParam && dateParam !== curDate) {
				swLog(LOG_LEVELS.WARN, 'Deleting outdated cache:',request.url);
				return cache.delete(request);
			}

			return Promise.resolve();
		})
	);
}

async function notifyClients(message) {
	const clients = await self.clients.matchAll({ type: 'window' });

	clients.forEach(client => client.postMessage(message));

	swLog(LOG_LEVELS.WARN, 'notifyClients message:',message);
}

function getRequestPolicy(request) {
	const url = new URL(request.url);

	let isStaticAsset = isStaticAssetRequest(request, url);

	if (url.pathname.endsWith('/sw.js')) {
		isStaticAsset = false;
	}

	const isRoot = isRootRequest(request);
	let isCacheable = isRoot || isStaticAsset;

	let paramC = null;
	let paramF = null;
	let paramT = null;

	let isOrderMakeFormHTTPQuery = false;
	let isOrderMakeFormWSQuery = false;

	if (!isRoot) {
		paramC = url.searchParams.get('c');
		paramF = url.searchParams.get('f');
		paramT = url.searchParams.get('t');

		isOrderMakeFormHTTPQuery = (
			paramC === 'Order_Controller' &&
			paramF === 'get_make_orders_form'
		);

		isOrderMakeFormWSQuery = (
			(paramC === 'Order_Controller' && paramF === 'get_make_orders_form_ord') ||
			(paramC === 'Order_Controller' && paramF === 'get_make_orders_form_mat') ||
			(paramC === 'Order_Controller' && paramF === 'get_make_orders_form_veh')
		);

		if (isOrderMakeFormHTTPQuery || isOrderMakeFormWSQuery) {
			isCacheable = shouldCacheOrderMakeForm(url);
		} else if (isAlwaysCacheableQuery(url, paramC, paramF, paramT)) {
			isCacheable = true;
		}
	}

	const cacheKey = getCacheKey(
		request,
		paramC,
		paramF,
		paramT,
		isOrderMakeFormHTTPQuery,
		isOrderMakeFormWSQuery
	);

	return {
		url: url,
		isStaticAsset: isStaticAsset,
		isRoot: isRoot,
		isCacheable: isCacheable,
		paramC: paramC,
		paramF: paramF,
		paramT: paramT,
		isOrderMakeFormHTTPQuery: isOrderMakeFormHTTPQuery,
		isOrderMakeFormWSQuery: isOrderMakeFormWSQuery,
		cacheKey: cacheKey,
	};
}

function isStaticAssetRequest(request, url) {
	return (
		['script', 'style', 'image', 'font'].includes(request.destination) ||
		/\.(js|css|png|jpe?g|gif|svg|ico|woff2?|ttf|eot)$/.test(url.pathname)
	);
}

function isRootRequest(request) {
	//return request.mode === 'navigate';
	return (
		request.url.indexOf('c=') === -1 &&
		request.url === SW_SCOPE
	);
}

function shouldCacheOrderMakeForm(url) {
	const paramD = url.searchParams.get('date');

	if (!paramD) {
		return true;
	}

	let curDate = new Date();
	const hour = curDate.getHours();

	if (hour >= 0 && hour < 6) {
		curDate.setDate(curDate.getDate() - 1);
	}

	const curDateStr = curDate.toISOString().split('T')[0];

	return (paramD === curDateStr);
}

function isAlwaysCacheableQuery(url, paramC, paramF, paramT) {
	return (
		(paramC === 'Constant_Controller' && paramF === 'get_values') ||
		(paramC === 'SessionVar_Controller' && paramF === 'get_values') ||
		(paramC === 'ConnectElkonCheck_Controller' && paramF === 'connected') ||
		(paramC === 'Connect1cCheck_Controller' && paramF === 'connected') ||
		(paramC === 'Vehicle_Controller' && paramF === 'get_vehicle_statistics') ||
		(paramC === 'ProductionSite_Controller' && paramF === 'get_list') ||
		(paramC === 'Weather_Controller') ||
		(paramC === 'UserChat_Controller' && paramF === 'get_history') ||
		(paramC === 'UserChat_Controller' && paramF === 'get_user_list') ||
		(paramC === 'ChatStatus_Controller' && paramF === 'get_list') ||
		(paramC === 'Shipment_Controller' && paramF === 'get_operator_list') ||
		(paramC === 'Shipment_Controller' && paramF === 'get_assigned_vehicle_list') ||
		(paramT === 'ShipmentForOrderList')
	);
}

function getCacheKey(request, paramC, paramF, paramT, isOrderMakeFormHTTPQuery, isOrderMakeFormWSQuery) {
	if ((isOrderMakeFormWSQuery || isOrderMakeFormHTTPQuery) && paramC && paramF) {
		return paramC + '&' + paramF + (paramT ? '&' + paramT : '');
	}

	return request;
}

async function handleCacheableRequest(request, policy) {
	if (shouldUseOfflineFallback(policy)) {
		swLog(LOG_LEVELS.DEBUG, 'offline fallback without network:', request.url);
		return await getFallbackResponse(request, policy);
	}

	try {
		swLog(LOG_LEVELS.DEBUG, 'network try:', request.url);

		const networkResponse = await fetch(request);

		swLog(LOG_LEVELS.DEBUG, 'network response:', request.url, networkResponse.status);

		const canCacheResponse = await shouldCacheResponse(networkResponse, policy);

		swLog(LOG_LEVELS.DEBUG, 'cache decision:', {
			url: request.url,
			ok: networkResponse && networkResponse.ok,
			canCacheResponse: canCacheResponse
		});

		if (canCacheResponse) {
			const cacheableResponse = networkResponse.clone();
			await saveResponseToCache(policy.cacheKey, cacheableResponse);
			swLog(LOG_LEVELS.DEBUG, 'cached under key:', policy.cacheKey);

			if (isOriginUnavailable && !policy.isStaticAsset) {
				isOriginUnavailable = false;
				await notifyClients({ type: 'ONLINE' });
			}

			return await withDebugHeader(networkResponse, 'network');
		}

		swLog(LOG_LEVELS.WARN, 'response was NOT cached:', request.url);
		return await withDebugHeader(networkResponse, 'network-not-cached');

	} catch (error) {
		swLog(LOG_LEVELS.ERROR, 'handleCacheableRequest failed:', request.url, error);

		if (!policy.isStaticAsset) {
			isOriginUnavailable = true;
			await notifyClients({ type: 'OFFLINE' });
		}

		return await getFallbackResponse(request, policy);
	}
}

async function saveResponseToCache(cacheKey, response) {
	const cache = await caches.open(CACHE_NAME);
	await cache.put(cacheKey, response.clone());
}

async function getFallbackResponse(request, policy) {
	const cache = await caches.open(CACHE_NAME);

	const cacheKeyForLog = (policy.cacheKey instanceof Request)
		? policy.cacheKey.url
		: policy.cacheKey;

	swLog(LOG_LEVELS.DEBUG, 'CACHE LOOKUP KEY:', cacheKeyForLog);

	let cachedResponse = await cache.match(
		policy.cacheKey,
		policy.isStaticAsset ? { ignoreSearch: true } : {}
	);

	swLog(LOG_LEVELS.DEBUG, 'DIRECT CACHE HIT:', !!cachedResponse);

	if (!cachedResponse && (policy.isOrderMakeFormHTTPQuery || policy.isOrderMakeFormWSQuery)) {
		const keys = await cache.keys();

		swLog(
			LOG_LEVELS.DEBUG,
			'AVAILABLE ORDER CACHE KEYS:',
			keys
				.map(function(requestItem) { return requestItem.url; })
				.filter(function(url) { return url.indexOf('Order_Controller') !== -1; })
		);

		swLog(LOG_LEVELS.DEBUG, 'TRY BUILD ORDER FORM FROM PARTS');
		cachedResponse = await buildOrderFormResponse(cache);
		swLog(LOG_LEVELS.DEBUG, 'BUILT ORDER FORM:', !!cachedResponse);
	}

	if (cachedResponse) {
		return await withDebugHeader(cachedResponse, 'cache');
	}

	swLog(LOG_LEVELS.WARN, 'NO CACHED RESPONSE FOUND FOR:', cacheKeyForLog);

	return new Response('Resource unavailable', {
		status: 503,
		statusText: 'Service Unavailable',
	});
}

function withDebugHeader(response, value) {
	if (response.type === 'opaque') {
		return Promise.resolve(response);
	}
	const headers = new Headers(response.headers);
	headers.set('X-SW-Source', value);

	return response.blob().then(function(body) {
		return new Response(body, {
			status: response.status,
			statusText: response.statusText,
			headers: headers
		});
	});
}

function swLog(level, ...args) {
	if (level > LOG_LEVEL) {
		return;
	}

	const prefix = '[SW]';

	switch (level) {
		case LOG_LEVELS.ERROR:
			console.error(prefix, ...args);
			break;

		case LOG_LEVELS.WARN:
			console.warn(prefix, ...args);
			break;

		case LOG_LEVELS.INFO:
			console.info(prefix, ...args);
			break;

		case LOG_LEVELS.DEBUG:
		default:
			console.log(prefix, ...args);
			break;
	}
}

function shouldUseOfflineFallback(policy) {
	if (!policy.isCacheable) {
		return false;
	}

	if (!self.navigator || self.navigator.onLine !== false) {
		return false;
	}

	return true;
}

async function shouldCacheResponse(response, policy) {
	if (!response) {
		return false;
	}

	if (response.type === 'opaque') {
		return policy.isStaticAsset;
	}

	if (!response.ok) {
		return false;
	}

	if (!(policy.isOrderMakeFormHTTPQuery || policy.isOrderMakeFormWSQuery)) {
		return true;
	}

	const text = await response.clone().text();

	swLog(LOG_LEVELS.DEBUG, 'order form response sample:', text.slice(0, 300));

	if (!text) {
		return false;
	}

	if (/Connection failed/i.test(text)) {
		return false;
	}

	const resultMatch = text.match(
		/<model\b[^>]*id=["']ModelServResponse["'][\s\S]*?<result>\s*(-?\d+)\s*<\/result>/i
	);

	if (resultMatch) {
		return resultMatch[1] === '0';
	}

	return true;
}

async function isSuccessfulXmlResponse(response) {
	try {
		const text = await response.clone().text();
		const parser = new DOMParser();
		const xml = parser.parseFromString(text, 'application/xml');

		const resultNode = xml.getElementsByTagName('result')[0];

		if (!resultNode) {
			return true;
		}

		return String(resultNode.textContent || '').trim() === '0';

	} catch (error) {
		return false;
	}
}

async function handleHealthCheckRequest(request) {
	try {
		const response = await fetch(request, { cache: 'no-store' });

		if (response && response.ok) {
			if (isOriginUnavailable) {
				isOriginUnavailable = false;
				await notifyClients({ type: 'ONLINE' });
			}

			return response;
		}

		return response;

	} catch (error) {
		if (!isOriginUnavailable) {
			isOriginUnavailable = true;
			await notifyClients({ type: 'OFFLINE' });
		}

		return new Response('Health check failed', {
			status: 503,
			statusText: 'Service Unavailable'
		});
	}
}

async function extractModelBlocks(cache, cacheKey) {
	const response = await cache.match(cacheKey);

	if (!response) {
		return [];
	}

	const text = await response.text();

	const matches = text.match(/<model\b[\s\S]*?<\/model>/gi);

	return matches ? matches : [];
}

async function buildOrderFormResponse(cache) {
	const keyOrder = 'Order_Controller&get_make_orders_form_ord';
	const keyMat = 'Order_Controller&get_make_orders_form_mat';
	const keyVeh = 'Order_Controller&get_make_orders_form_veh';

	const ordModels = await extractModelBlocks(cache, keyOrder);
	const matModels = await extractModelBlocks(cache, keyMat);
	const vehModels = await extractModelBlocks(cache, keyVeh);

	const allModels = []
		.concat(ordModels)
		.concat(matModels)
		.concat(vehModels);

	if (!allModels.length) {
		return null;
	}

	const xmlString =
		'<?xml version="1.0" encoding="UTF-8"?>' +
		'<document>' +
		allModels.join('') +
		'</document>';

	const result = new Response(xmlString, {
		headers: {
			'Content-Type': 'application/xml',
		},
	});

	if (ordModels.length && matModels.length && vehModels.length) {
		await cache.put('Order_Controller&get_make_orders_form', result.clone());
	}

	return result;
}
