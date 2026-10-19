<?php
/** Called ONLY when AppSrv sends long_route_rest: true. Not a polling endpoint. */
require_once __DIR__.'/lib/backend.php';
try {
	route_method('GET');
	$id = route_id($_GET['id'] ?? null);
	$db = route_database();
	$shipment = route_authorize($db, $id);
	$row = $db->query_first('SELECT route_rest FROM route_rests WHERE tracker_id = '.route_sql($db, $shipment['tracker_id']));
	if (!is_array($row) || !array_key_exists('route_rest', $row) || $row['route_rest'] === null) {
		throw new RouteOsmError('Маршрут ещё перестраивается. Ожидаем следующее обновление.', 409);
	}
	route_reply(array('route' => (string) $row['route_rest']));
} catch (Throwable $error) {
	route_error($error, true);
}
