<?php
/**
 * Optional settings for ../Config.php.
 * This example is NOT loaded automatically. Copy only the settings you need.
 * Existing APP_NAME, APP_SERVER_HOST, APP_SERVER_PORT and
 * APP_SERVER_PORT_SECURED are reused without redefining them here.
 */

// Default OpenStreetMap raster tiles; replace BOTH URL and attribution for another provider.
define('ROUTE_OSM_TILE_URL', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png');
define('ROUTE_OSM_TILE_ATTRIBUTION', '© <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener">OpenStreetMap</a> contributors');
define('ROUTE_OSM_TILE_MAX_ZOOM', 19);

// Omit INITIAL_ZOOM to reuse TRACK_CONSTANTS.INI_ZOOM (or 14 if unavailable).
define('ROUTE_OSM_INITIAL_ZOOM', 14);
define('ROUTE_OSM_FIT_MAX_ZOOM', 16);
define('ROUTE_OSM_FOLLOW_VEHICLE', true);
define('ROUTE_OSM_SHOW_ZONE', true);

// Vehicle transitions: local animation only, no polling or position prediction.
// Duration range 0..5000 ms; 0 disables movement animation.
define('ROUTE_OSM_ANIMATION_DURATION_MS', 1200);
// Snap to the latest fix after a receipt/GPS-time gap longer than this (1000..300000 ms).
define('ROUTE_OSM_ANIMATION_MAX_GAP_MS', 30000);
// Snap instead of animating a large GPS correction (ground metres, range 1..10000).
define('ROUTE_OSM_ANIMATION_MAX_DISTANCE_M', 1000);

// Location is requested only after the customer clicks and confirms "Я на объекте".
define('ROUTE_OSM_ENABLE_LOCATION', true);
// false preserves the supplied location.php behavior: its zone check was commented out.
// true accepts only points inside/on the boundary of the destination zone.
define('ROUTE_OSM_REQUIRE_LOCATION_IN_ZONE', false);

// A single HTTP request timeout, NOT a polling/retry interval.
define('ROUTE_OSM_REQUEST_TIMEOUT_MS', 15000);

// Already the defaults, copied from your original HTML template in the same order.
// The page appends VERSION as a cache-busting query parameter.
/*
define('ROUTE_OSM_APPSRV_SCRIPTS', array(
	'../js20/core/extend.js',
	'../js20/core/CommonHelper.js',
	'../js20/core/EventHelper.js',
	'../js20/core/AppSrv.js',
	'../js20/custom_controls/TrackConstants.js'
));
*/

// Optional reverse-proxy/WebSocket overrides. Usually not needed.
/*
define('ROUTE_OSM_APPSRV_HOST', APP_SERVER_HOST);
define('ROUTE_OSM_APPSRV_PORT', APP_SERVER_PORT_SECURED);
*/

// The page automatically uses vendor/ol/ when both files exist.
// Otherwise it uses the pinned 10.10.0 jsDelivr URLs. Explicit overrides are optional.
/*
define('ROUTE_OSM_OL_JS', 'vendor/ol/ol.js');
define('ROUTE_OSM_OL_CSS', 'vendor/ol/ol.css');
*/
