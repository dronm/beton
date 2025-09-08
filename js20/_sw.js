const CACHE_NAME = 'static-cache-v1.1';
const STATIC_ASSETS = [
	"img/Bell-sound-effect-ding.mp3",
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
	"img/pointer-blue.png",
	"img/pointer-green.png",
	"img/pointer-red.png",
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

	"js20/jquery.maskedinput.js",
	"js20/ext/cleave/cleave.min.js",
	"js20/ext/cleave/cleave-phone.ru.js",
	"js20/ext/mustache/mustache.min.js",
	"js20/ext/jshash-2.2/md5-min.js",
	'js20/lib.js',
];

self.addEventListener('install', event => {
	console.log("sw install")
	event.waitUntil(
		caches.open(CACHE_NAME).then(cache => cache.addAll(STATIC_ASSETS))
	);
});

self.addEventListener('fetch', event => {
	console.log("sw fetch")
	event.respondWith(
		caches.match(event.request).then(cachedResponse => {
			return cachedResponse || fetch(event.request);
		})
	);
});
