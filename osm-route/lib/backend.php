<?php
require_once __DIR__.'/common.php';

function route_database()
{
	$root = dirname(__DIR__, 2);
	if (is_file($root.'/version.php')) {
		require_once $root.'/version.php';
	}
	require_once $root.'/Config.php';
	require_once FRAME_WORK_PATH.'db/SessManager.php';
	require_once FRAME_WORK_PATH.'basic_classes/FieldSQLString.php';
	require_once FRAME_WORK_PATH.'basic_classes/FieldExtString.php';
	require_once $root.'/functions/db_con_f.php';
	require_once $root.'/functions/VehicleRoute.php';
	return db_con();
}

function route_sql($db, $value): string
{
	return "'".$db->escape_string((string) $value)."'";
}

function route_query($db, string $sql): void
{
	if ($db->query($sql) === false) {
		throw new RuntimeException('Route database operation failed.');
	}
}

function route_login($db, int $id): ?array
{
	$row = $db->query_first(sprintf(
		"SELECT trim(l.session_id) AS session_id,
			(l.date_time_out IS NULL) AS active,
			now() - l.date_time_out > interval '10 minutes' AS expired
		FROM logins AS l WHERE l.pub_key = '%d'
		ORDER BY l.date_time_in DESC NULLS LAST LIMIT 1", $id
	));
	if (!is_array($row) || empty($row['session_id'])) {
		return null;
	}
	if (!route_bool($row['active'] ?? false)) {
		throw new RouteOsmError(route_bool($row['expired'] ?? false) ? 'Неверная ссылка.' : 'Маршрут завершён.', 404);
	}
	return $row;
}

/** Uses the same shipment eligibility and schema as the supplied 2GIS page. */
function route_shipment($db, int $id): array
{
	$row = $db->query_first(sprintf(
		"SELECT const_map_default_lon_val() AS map_def_lon,
			const_map_default_lat_val() AS map_def_lat,
			sch.vehicle_id,
			(SELECT sch_st.state FROM vehicle_schedule_states AS sch_st
				WHERE sch_st.schedule_id = sch.id ORDER BY sch_st.date_time DESC LIMIT 1) AS shipment_state,
			ST_AsGeoJSON(CASE
				WHEN ST_SRID(d.zone) = 0 THEN ST_SetSRID(d.zone, 4326)
				WHEN ST_SRID(d.zone) = 4326 THEN d.zone
				ELSE ST_Transform(d.zone, 4326) END) AS dest_zone,
			vh.tracker_id, vh.plate AS vehicle_plate,
			(SELECT v_pos.pos_data FROM vehicles_last_pos AS v_pos WHERE v_pos.id = sch.vehicle_id) AS pos_data,
			(SELECT users.id FROM users WHERE name = 'Маршруты' LIMIT 1) AS user_id,
			r_csh.client_route_done, o.destination_id, o.client_id,
			(cl_d.lon IS NOT NULL AND cl_d.lat IS NOT NULL) AS client_location_exists
		FROM shipments AS sh
		LEFT JOIN vehicle_schedules AS sch ON sch.id = sh.vehicle_schedule_id
		LEFT JOIN vehicles AS vh ON vh.id = sch.vehicle_id
		LEFT JOIN orders AS o ON o.id = sh.order_id
		LEFT JOIN destinations AS d ON d.id = o.destination_id
		LEFT JOIN vehicle_route_cashe AS r_csh ON r_csh.shipment_id = sh.id AND r_csh.vehicle_state = 'left_for_dest'
		LEFT JOIN client_destinations AS cl_d ON cl_d.client_id = o.client_id AND cl_d.destination_id = o.destination_id
		WHERE sh.id = %d AND d.zone IS NOT NULL", $id
	));
	if (is_array($row) && route_bool($row['client_route_done'] ?? false)) {
		throw new RouteOsmError('Маршрут завершён.', 404);
	}
	if (!is_array($row) || !in_array($row['shipment_state'] ?? '', array('busy', 'at_dest'), true) ||
		!isset($row['tracker_id']) || (string) $row['tracker_id'] === '' || empty($row['vehicle_id'])) {
		throw new RouteOsmError('Неверная ссылка.', 404);
	}
	return $row;
}

/** Preserve the existing shared shipment session, needed by the AppSrv protocol. */
function route_session($db, int $id, ?array $login): void
{
	if (session_status() === PHP_SESSION_ACTIVE) {
		throw new RuntimeException('A session was started before the route application. Disable session.auto_start for this page.');
	}
	if ($login !== null) {
		session_id($login['session_id']);
	}
	$session = new SessManager();
	$session->detailedError = route_option('DEBUG', false);
	$session->productionError = route_option('ERR_SESSION', 'Ошибка сессии.');
	$session->start('_r'.$id, $db, $db, false,
		(int) route_option('SESSION_LIVE_SEC', 0), (string) route_option('SESSION_KEY', ''));
	if (session_status() !== PHP_SESSION_ACTIVE || session_id() === '') {
		throw new RuntimeException('SessManager did not start a route session.');
	}
}

function route_register_login($db, int $id, array $shipment): void
{
	if (empty($shipment['user_id'])) {
		throw new RuntimeException('The application user named Маршруты was not found.');
	}
	$ip = $_SERVER['REMOTE_ADDR'] ?? '';
	if (!filter_var($ip, FILTER_VALIDATE_IP)) {
		$ip = '0.0.0.0';
	}
	// Keep credentials/cookies out of the login audit JSON. No device-detector dependency.
	$headers = array('User-Agent' => substr((string) ($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 2048));
	route_query($db, sprintf(
		"INSERT INTO logins (date_time_in, ip, session_id, pub_key, user_id, headers_j, user_agent)
		VALUES (now(), %s, %s, '%d', %d, %s, NULL)",
		route_sql($db, $ip), route_sql($db, session_id()), $id, (int) $shipment['user_id'], route_sql($db, route_json($headers))
	));
}

function route_open_page($db, int $id): array
{
	$login = route_login($db, $id);
	$shipment = route_shipment($db, $id);
	route_session($db, $id, $login);
	if ($login === null) {
		route_register_login($db, $id, $shipment);
	}
	// Refresh these on every page load, including sessions created by the old page.
	$_SESSION['shipment_id'] = $id;
	$_SESSION['destination_id'] = (int) $shipment['destination_id'];
	$_SESSION['client_id'] = (int) $shipment['client_id'];
	$_SESSION['tracker_id'] = (string) $shipment['tracker_id'];
	foreach (array('route_osm_read_token', 'route_osm_location_token') as $key) {
		if (!isset($_SESSION[$key]) || !is_string($_SESSION[$key]) || strlen($_SESSION[$key]) !== 64) {
			$_SESSION[$key] = bin2hex(random_bytes(32));
		}
	}
	$tokens = array('read' => $_SESSION['route_osm_read_token'], 'location' => $_SESSION['route_osm_location_token']);
	session_write_close();
	return array($shipment, $tokens);
}

/** Never accept a caller-supplied tracker/client/destination ID on an endpoint. */
function route_authorize($db, int $id, string $scope = 'read'): array
{
	$token = $_SERVER['HTTP_X_ROUTE_TOKEN'] ?? '';
	if (!is_string($token) || !preg_match('/^[a-f0-9]{64}$/D', $token)) {
		throw new RouteOsmError('Доступ закрыт. Обновите страницу маршрута.', 403);
	}
	$login = route_login($db, $id);
	if ($login === null) {
		throw new RouteOsmError('Доступ закрыт. Обновите страницу маршрута.', 403);
	}
	route_session($db, $id, $login);
	$expected = $_SESSION[$scope === 'location' ? 'route_osm_location_token' : 'route_osm_read_token'] ?? '';
	$allowed = is_string($expected) && hash_equals($expected, $token) && (int) ($_SESSION['shipment_id'] ?? 0) === $id;
	session_write_close();
	if (!$allowed) {
		throw new RouteOsmError('Доступ закрыт. Обновите страницу маршрута.', 403);
	}
	return route_shipment($db, $id);
}

function route_settings(int $id, bool $isClient, array $shipment, array $tokens, $route, $distance): array
{
	$pos = route_decode($shipment['pos_data'] ?? null);
	$center = route_coordinates($shipment['map_def_lon'] ?? null, $shipment['map_def_lat'] ?? null);
	$zoom = route_option('ROUTE_OSM_INITIAL_ZOOM');
	$locationEnabled = $isClient && route_bool(route_option('ROUTE_OSM_ENABLE_LOCATION', true)) &&
		!route_bool($shipment['client_location_exists'] ?? false);
	return array(
		'id' => $id,
		'trackerId' => (string) $shipment['tracker_id'],
		'vehiclePlate' => (string) ($shipment['vehicle_plate'] ?? ''),
		'position' => is_array($pos) ? array('lon' => $pos['lon'] ?? null, 'lat' => $pos['lat'] ?? null, 'period' => $pos['period'] ?? null) : null,
		'route' => is_string($route) ? $route : '',
		'distance' => route_number($distance),
		'destinationZone' => route_decode($shipment['dest_zone'] ?? null),
		'center' => $center ?? array(0, 0),
		'initialZoom' => $zoom === null ? null : max(1, min(19, (float) $zoom)),
		'fitMaxZoom' => max(1, min(19, (float) route_option('ROUTE_OSM_FIT_MAX_ZOOM', 16))),
		'followVehicle' => route_bool(route_option('ROUTE_OSM_FOLLOW_VEHICLE', true)),
		'movement' => array(
			'durationMs' => max(0, min(5000, route_number(route_option('ROUTE_OSM_ANIMATION_DURATION_MS')) ?? 1200)),
			'maxGapMs' => max(1000, min(300000, route_number(route_option('ROUTE_OSM_ANIMATION_MAX_GAP_MS')) ?? 30000)),
			'maxDistanceM' => max(1, min(10000, route_number(route_option('ROUTE_OSM_ANIMATION_MAX_DISTANCE_M')) ?? 1000))
		),
		'showZone' => route_bool(route_option('ROUTE_OSM_SHOW_ZONE', true)),
		'tiles' => array(
			'url' => (string) route_option('ROUTE_OSM_TILE_URL', 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
			'attribution' => (string) route_option('ROUTE_OSM_TILE_ATTRIBUTION', '© <a href="https://www.openstreetmap.org/copyright" target="_blank" rel="noopener">OpenStreetMap</a> contributors'),
			'maxZoom' => max(1, min(24, (int) route_option('ROUTE_OSM_TILE_MAX_ZOOM', 19)))
		),
		'appSrv' => array(
			'host' => (string) route_option('ROUTE_OSM_APPSRV_HOST', route_option('APP_SERVER_HOST', '')),
			'port' => route_option('ROUTE_OSM_APPSRV_PORT', route_https() ? route_option('APP_SERVER_PORT_SECURED', route_option('APP_SERVER_PORT')) : route_option('APP_SERVER_PORT')),
			'appId' => (string) route_option('APP_NAME', ''),
			// This is deliberately unchanged: the existing AppSrv server verifies this format.
			'token' => $id.':'.md5('route_'.$id),
			'tokenExpires' => null
		),
		'routeUrl' => 'long_route_rest.php?id='.$id,
		'locationUrl' => 'location.php?id='.$id,
		'readToken' => $tokens['read'],
		'locationToken' => $locationEnabled ? $tokens['location'] : null,
		'locationEnabled' => $locationEnabled,
		'iconUrl' => 'img/mixer.png',
		'requestTimeoutMs' => max(1000, min(60000, (int) route_option('ROUTE_OSM_REQUEST_TIMEOUT_MS', 15000)))
	);
}
