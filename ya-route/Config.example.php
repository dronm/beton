<?php
/**
 * Copy the settings you need into ../Config.php. This file is not loaded automatically.
 * A suitable Yandex commercial license/trial is required for real-time vehicle tracking.
 * Set the API key's HTTP Referer restriction to eurobeton.katren.org (without a path).
 */
define('ROUTE_YANDEX_API_KEY', 'YOUR_YANDEX_JAVASCRIPT_API_KEY');

// Initial map zoom: omit to use TRACK_CONSTANTS.INI_ZOOM, then 14 as fallback.
define('ROUTE_YANDEX_INITIAL_ZOOM', 14);
define('ROUTE_YANDEX_FIT_MAX_ZOOM', 16);
define('ROUTE_YANDEX_MAX_ZOOM', 19);
define('ROUTE_YANDEX_MAP_MODE', 'auto'); // auto, raster, vector.
define('ROUTE_YANDEX_FOLLOW_VEHICLE', true);
define('ROUTE_YANDEX_SHOW_ZONE', true);

// Local marker animation, not polling or position prediction. Duration 0 disables it.
define('ROUTE_YANDEX_ANIMATION_DURATION_MS', 1200);
define('ROUTE_YANDEX_ANIMATION_MAX_GAP_MS', 30000);
define('ROUTE_YANDEX_ANIMATION_MAX_DISTANCE_M', 1000);

// Location is sent only after the customer clicks and confirms "Я на объекте".
define('ROUTE_YANDEX_ENABLE_LOCATION', true);
// false preserves the original 2GIS location.php behavior (zone check was commented out).
define('ROUTE_YANDEX_REQUIRE_LOCATION_IN_ZONE', false);

// Timeouts, NOT polling/retry intervals.
define('ROUTE_YANDEX_REQUEST_TIMEOUT_MS', 15000);
define('ROUTE_YANDEX_LOAD_TIMEOUT_MS', 20000);

// These are already the defaults. No additional original application scripts are imported.
/*
define('ROUTE_YANDEX_APPSRV_SCRIPTS', array(
	'../js20/core/extend.js',
	'../js20/core/CommonHelper.js',
	'../js20/core/EventHelper.js',
	'../js20/core/AppSrv.js',
	'../js20/custom_controls/TrackConstants.js'
));
*/

// Usually unnecessary: existing APP_SERVER_* and APP_NAME constants are reused.
/*
define('ROUTE_YANDEX_APPSRV_HOST', APP_SERVER_HOST);
define('ROUTE_YANDEX_APPSRV_PORT', APP_SERVER_PORT_SECURED);
*/
