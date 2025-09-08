
const CACHE_NAME = 'static-cache-v1.0';
const STATIC_ASSETS = [
// 	"img/Bell-sound-effect-ding.mp3",
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
//
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
//
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
//
	"js20/jquery.maskedinput.js",
	"js20/ext/cleave/cleave.min.js",
	"js20/ext/cleave/cleave-phone.ru.js",
	"js20/ext/mustache/mustache.min.js",
	"js20/ext/jshash-2.2/md5-min.js",
	"js20/ext/jshash-2.2/md5-min.js",
	'js20/lib.js',
];

let isOffline = false;
let isLogged = false;
const ROOT_PATH = "/beton_new/";

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
	console.log("SW activate fired");
	event.waitUntil(self.clients.claim()); // control all pages immediately
});

// Utility to notify all controlled clients
async function notifyClients(message) {
    const clients = await self.clients.matchAll({ type: 'window' });
    clients.forEach(client => client.postMessage(message));
}

self.addEventListener('fetch', event => {
    const url = new URL(event.request.url);

    const isRoot = (
		event.request.url.indexOf("c=") === -1
		&& url.pathname === ROOT_PATH
	);//default controller
    
		//;
    let isCachable = isRoot;
	if(!isRoot && event.request.method === 'GET'){
		const paramC = url.searchParams.get('c');
		const paramF = url.searchParams.get('f');

		//all cachable queries
		if(
			(paramC === "Order_Controller" && paramF === "get_make_orders_form")
			||(paramC === "Constant_Controller" && paramF === "get_values")
			||(paramC === "SessionVar_Controller" && paramF === "get_values")
			||(paramC === "ConnectElkonCheck_Controller" && paramF === "connected")
			||(paramC === "Connect1cCheck_Controller" && paramF === "connected")
			||(paramC === "Vehicle_Controller" && paramF === "get_vehicle_statistics")
			||(paramC === "ProductionSite_Controller" && paramF === "get_list")
			||(paramC === "Weather_Controller" )
			||(paramC === "UserChat_Controller" && paramF === "get_history")
			||(paramC === "UserChat_Controller" && paramF === "get_user_list")
			||(paramC === "ChatStatus_Controller" && paramF === "get_list")
			||(paramC === "Shipment_Controller" && paramF === "get_operator_list")
		){
			isCachable = true;
		}
	}

    // Handle root page with stale-while-revalidate
	if(isCachable || isRoot){
		console.log("isCachable:"+isCachable,"isRoot:"+isRoot, "offline:"+isOffline, "url:"+event.request.url, "pathname:"+url.pathname)
	}
    if (isCachable) {
        event.respondWith(
            (async () => {
                try {
                    const networkResponse = await fetch(event.request);

                    // Cache only if response is OK
                    if (networkResponse && networkResponse.ok) {
                        const cache = await caches.open(CACHE_NAME);
                        cache.put(event.request, networkResponse.clone());

						if (isOffline) {
							console.log("setting isOffline to FALSE")
							isOffline = false;
							notifyClients({ type: 'ONLINE' });
						}

						console.log("request is cached")
                    }

                    return networkResponse;
                } catch (error) {
					// if (!isOffline) {
						isOffline = true;
						// console.log("error fetching resource, setting isOffline to TRUE")
						notifyClients({ type: 'OFFLINE' });
					// }

                    // Network failed, try cache
                    const cache = await caches.open(CACHE_NAME);
                    const cachedResponse = await cache.match(event.request);

                    if (cachedResponse) {
						console.log("returning cached data")
                        return cachedResponse;

                    } else {
						console.log("returning error, no cache")
                        return new Response('Resource unavailable', {
                            status: 503,
                            statusText: 'Service Unavailable'
                        });
                    }
                }
            })()
        );
    }
	/*
	if(!isCachable){
		return;
	}
    // Handle specific query
	event.respondWith((async () => {
		try {
			if(isCachable ){
				console.log("fetching cachable resource:"+event.request.url)
			}
			const networkResponse = await fetch(event.request);

			if (networkResponse && networkResponse.ok) {
				if(isCachable ){
					console.log("response is OK")
				}
				if(isRoot){
					const responseClone = networkResponse.clone();
					const text = await responseClone.text();
					const match = text.match(/"role_id":`([^`]*)`/);
					isLogged = (match && match[1] !== "");

					console.log("Root is logged:"+isLogged)
				}

				if( isCachable && (!isRoot || isLogged) ){
					const cache = await caches.open(CACHE_NAME);
					cache.put(isRoot? ROOT_PATH : event.request, networkResponse.clone());
					console.log("response is cached for request",event.request)
				}

				if (isOffline) {
					console.log("setting isOffline to FALSE")
					isOffline = false;
					notifyClients({ type: 'ONLINE' });
				}
			}

			return networkResponse;

		} catch (error) {
			if (!isOffline) {
				isOffline = true;
				console.log("error fetching resource, setting isOffline to TRUE")
				notifyClients({ type: 'OFFLINE' });
			}

			if(isCachable && (!isRoot || isLogged)){
				const cache = await caches.open(CACHE_NAME);
				const cachedResponse = await cache.match(isRoot? ROOT_PATH : event.request);
				if(isRoot){
					console.log("retrieving from cache for "+ROOT_PATH)
				}else{
					console.log("retrieving from cache for requst", event.request)
				}

				if (cachedResponse) {
					console.log("returning cached data")
					return cachedResponse;
				} else {
					console.log("no data cached returning error: resource is unavailable")
					return new Response('Resource unavailable', {
						status: 503,
						statusText: 'Service Unavailable'
					});
				}
			}
		}
	})());
	*/
});


