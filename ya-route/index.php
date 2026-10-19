<?php
require_once __DIR__.'/lib/backend.php';
try {
	route_method('GET');
	$request = route_request($_GET);
	$db = route_database();
	list($shipment, $tokens) = route_open_page($db, $request['id']);
	$distance = null;
	$route = '';
	$routeWarning = null;
	try {
		$route = VehicleRoute::getRoute((int) $shipment['vehicle_id'], $db, $distance);
	} catch (Throwable $error) {
		error_log('[yandex-route] Initial route: '.$error->getMessage());
		$routeWarning = 'Линия маршрута пока недоступна. Положение автомобиля будет обновляться.';
	}
	$page = route_settings($request['id'], $request['isClient'], $shipment, $tokens, $route, $distance);
	$title = 'Маршрут миксера '.($page['vehiclePlate'] !== '' ? $page['vehiclePlate'] : '№ '.$request['id']);
	$version = (string) route_option('VERSION', '1');
	if (route_bool(route_option('DEBUG', false))) {
		$version .= '-'.time();
	}
	$scripts = route_option('ROUTE_YANDEX_APPSRV_SCRIPTS', array(
		'../js20/core/extend.js',
		'../js20/core/CommonHelper.js',
		'../js20/core/EventHelper.js',
		'../js20/core/AppSrv.js',
		'../js20/custom_controls/TrackConstants.js'
	));
	if (!is_array($scripts)) {
		throw new RuntimeException('ROUTE_YANDEX_APPSRV_SCRIPTS must be an array of script URLs.');
	}
	$appVersion = $version.'-'.(string) filemtime(__DIR__.'/assets/route.js');
	route_headers();
	header('Content-Type: text/html; charset=UTF-8');
	require __DIR__.'/templates/page.php';
} catch (Throwable $error) {
	route_error($error);
}
