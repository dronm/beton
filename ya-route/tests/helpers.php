<?php
require_once __DIR__.'/../lib/backend.php';
$count = 0;
function check($condition, string $message): void
{
	global $count;
	$count++;
	if (!$condition) { throw new RuntimeException($message); }
}
foreach (array(array('123' => ''), array('id' => '123')) as $query) {
	check(route_request($query) === array('id' => 123, 'isClient' => true), 'Customer ID parsing');
}
foreach (array(array('m123' => ''), array('id' => 'm123')) as $query) {
	check(route_request($query) === array('id' => 123, 'isClient' => false), 'Non-customer ID parsing');
}
foreach (array(array(), array('0' => ''), array('123abc' => ''), array('id' => array('1')), array('id' => '-1'), array('id' => '2147483648'), array('id' => '1', 'x' => '2'), array('id' => '1;DROP TABLE shipments'), array('m' => ''), array('1' => 'x')) as $query) {
	try { route_request($query); check(false, 'Invalid query accepted'); }
	catch (RouteYandexError $error) { check($error->status === 400, 'Bad query status'); }
}
check(route_id('2147483647') === 2147483647, 'Max int');
foreach (array(null, '', ' ', false, true, array(), 'oops', '1abc', INF, NAN) as $value) {
	check(route_number($value) === null, 'Invalid number');
}
check(route_coordinates('60.5', '56.2') === array(60.5, 56.2), 'Coordinate order');
check(route_coordinates(0, 0) === array(0.0, 0.0), 'Zero coordinates');
check(route_coordinates(181, 0) === null, 'Longitude bounds');
check(route_coordinates(0, -91) === null, 'Latitude bounds');
foreach (array('f', 'false', false, 0, null) as $value) { check(!route_bool($value), 'Postgres false'); }
foreach (array('t', 'true', true, 1) as $value) { check(route_bool($value), 'Postgres true'); }
$payload = array('plate' => '</script><script>alert("x")</script>');
$json = route_json($payload);
check(stripos($json, '</script') === false, 'Script-safe JSON');
check(json_decode($json, true) === $payload, 'JSON roundtrip');
check(route_escape('<"&') === '&lt;&quot;&amp;', 'HTML encoding');
foreach (array('off', '0', '') as $https) {
	$_SERVER = array('HTTPS' => $https, 'SERVER_PORT' => 80);
	check(!route_https(), 'HTTPS off handling');
}
$_SERVER = array('HTTPS' => 'on');
check(route_https(), 'HTTPS on');
$_SERVER = array('SERVER_PORT' => 443);
check(route_https(), 'HTTPS port');
check(route_asset('../AppSrv.js', '1 2') === '../AppSrv.js?v=1%202', 'Version URL');
check(route_asset('../AppSrv.js?a=1', '2') === '../AppSrv.js?a=1&v=2', 'Existing query');
$_SERVER = array();
$shipment = array('tracker_id' => 'abc', 'vehicle_plate' => 'А123', 'client_location_exists' => 'f', 'map_def_lon' => 60, 'map_def_lat' => 56, 'pos_data' => null, 'dest_zone' => null);
$page = route_settings(123, true, $shipment, array('read' => 'r', 'location' => 'l'), '', 0);
check($page['distance'] === 0.0, 'Zero distance preserved');
check($page['position'] === null, 'Missing GPS preserved');
check($page['appSrv']['token'] === '123:'.md5('route_123'), 'Legacy AppSrv token');
check($page['locationEnabled'] && $page['locationToken'] === 'l', 'Customer location enabled');
$page = route_settings(123, false, $shipment, array('read' => 'r', 'location' => 'l'), '', null);
check(!$page['locationEnabled'] && $page['locationToken'] === null, 'No write token for m view');
check($page['movement'] === array('durationMs' => 1200, 'maxGapMs' => 30000, 'maxDistanceM' => 1000), 'Animation defaults');
define('ROUTE_YANDEX_ANIMATION_DURATION_MS', 0);
define('ROUTE_YANDEX_ANIMATION_MAX_GAP_MS', 'invalid');
define('ROUTE_YANDEX_ANIMATION_MAX_DISTANCE_M', 20000);
$custom = route_settings(123, true, $shipment, array('read' => 'r', 'location' => 'l'), '', 0);
check($custom['movement']['durationMs'] === 0, 'Zero duration disables animation');
check($custom['movement']['maxGapMs'] === 30000, 'Invalid gap falls back to default');
check($custom['movement']['maxDistanceM'] === 10000, 'Distance safeguard upper bound');
echo 'PHP helper checks passed: '.$count."\n";
