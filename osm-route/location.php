<?php
/** Optional, explicitly confirmed customer unloading location. */
require_once __DIR__.'/lib/backend.php';
$db = null;
$transaction = false;
try {
	route_method('POST');
	$id = route_id($_GET['id'] ?? null);
	$contentType = strtolower(trim(explode(';', $_SERVER['CONTENT_TYPE'] ?? '')[0]));
	if ($contentType !== 'application/json') {
		throw new RouteOsmError('Ожидается запрос JSON.', 415);
	}
	$body = file_get_contents('php://input', false, null, 0, 4097);
	if ($body === false || strlen($body) > 4096) {
		throw new RouteOsmError('Слишком большой запрос.', 413);
	}
	$data = json_decode($body, true);
	$coords = is_array($data) ? route_coordinates($data['lon'] ?? null, $data['lat'] ?? null) : null;
	if ($coords === null) {
		throw new RouteOsmError('Некорректные координаты.', 400);
	}
	$db = route_database();
	if (!route_bool(route_option('ROUTE_OSM_ENABLE_LOCATION', true))) {
		throw new RouteOsmError('Передача местоположения отключена.', 403);
	}
	$shipment = route_authorize($db, $id, 'location');
	$lon = sprintf('%.8F', $coords[0]);
	$lat = sprintf('%.8F', $coords[1]);
	if (route_bool(route_option('ROUTE_OSM_REQUIRE_LOCATION_IN_ZONE', false))) {
		$row = $db->query_first(sprintf(
			"SELECT ST_Covers(dest.zone, CASE WHEN ST_SRID(dest.zone) = 0
				THEN ST_SetSRID(ST_MakePoint(%s, %s), 0)
				ELSE ST_Transform(ST_SetSRID(ST_MakePoint(%s, %s), 4326), ST_SRID(dest.zone)) END) AS inside
			FROM destinations AS dest WHERE dest.id = %d", $lon, $lat, $lon, $lat, (int) $shipment['destination_id']
		));
		if (!is_array($row) || !route_bool($row['inside'] ?? false)) {
			throw new RouteOsmError('Вы находитесь вне зоны объекта. Передайте местоположение, когда прибудете на объект.', 422);
		}
	}
	route_query($db, 'BEGIN');
	$transaction = true;
	route_query($db, sprintf(
		"INSERT INTO client_destinations (client_id, destination_id, lon, lat) VALUES (%d, %d, %s, %s)
		ON CONFLICT (client_id, destination_id) DO UPDATE SET lon = EXCLUDED.lon, lat = EXCLUDED.lat",
		(int) $shipment['client_id'], (int) $shipment['destination_id'], $lon, $lat
	));
	route_query($db, sprintf(
		"UPDATE vehicle_route_cashe SET route = NULL, route_line = NULL, update_dt = now(), update_cnt = update_cnt + 1
		WHERE shipment_id = %d AND vehicle_state = 'left_for_dest'", $id
	));
	$notification = route_json(array('params' => array(
		'tracker_id' => (string) $shipment['tracker_id'], 'shipment_id' => $id, 'vehicle_state' => 'left_for_dest'
	)));
	route_query($db, "SELECT pg_notify('Vehicle.rebuild_route', ".route_sql($db, $notification).')');
	route_query($db, 'COMMIT');
	$transaction = false;
	route_reply(array('ok' => true));
} catch (Throwable $error) {
	if ($transaction && $db !== null) {
		try {
			route_query($db, 'ROLLBACK');
		} catch (Throwable $rollbackError) {
			error_log('[route-osm] Rollback: '.$rollbackError->getMessage());
		}
	}
	route_error($error, true);
}
