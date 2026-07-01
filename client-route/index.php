<?php
//http://localhost/beton_new/client-route/?k=53563ec6-53b0-4fe5-87a3-4606c3ab43d4&lat=57.150114&lon=65.544012
require_once(dirname(__FILE__).'/../Config.php');
require_once(dirname(__FILE__).'/../functions/db_con_f.php');
require_once(dirname(__FILE__).'/../functions/http_headers.php');
require_once('common/OSRMV5.php');

if(!isset($_REQUEST) || !isset($_REQUEST['k']) || !isset($_REQUEST['lat']) || !isset($_REQUEST['lon'])){
	set_headers_status(400);
	exit;
	
}else if($_REQUEST['k'] != AUTH_CLIENT_ROUTE_KEY){
	set_headers_status(403);
	exit;
}

const ER_OSRM_ROUTE_QUERY = 'Ошибка получения данных с сервера OSRM';

header("Content-type: application/json; charset=utf-8");

try{

	$dbLink = db_con();
	//from utyashevo
	$ar = $dbLink->query_first("
		SELECT
			d.near_road_lon AS zone_near_road_lon
			,d.near_road_lat AS zone_near_road_lat
		FROM production_bases AS b
		LEFT JOIN destinations AS d ON d.id = b.destination_id
		WHERE b.id = 1"
	);

	$lon = floatval($_REQUEST['lon']);
	$lat = floatval($_REQUEST['lat']);

	$osrm = new OSRMV5(OSRM_PROTOCOLE,OSRM_HOST,OSRM_PORT);

	//routing
	$osrmRoute = $osrm->getRoute(
		array(
			$lon.','.$lat,
			$ar['zone_near_road_lon'].','.$ar['zone_near_road_lat']
		)
		,'json'
		,NULL
		,array("geometries=geojson")									
	);

	if (!$osrmRoute->routes || !count($osrmRoute->routes) || !$osrmRoute->routes[count($osrmRoute->routes)-1]->geometry){
		throw new Exception(ER_OSRM_ROUTE_QUERY);
	}
	$route = $osrmRoute->routes[count($osrmRoute->routes)-1];
//file_put_contents(OUTPUT_PATH.'route.txt', var_export($route, true));

	set_headers_status(200);
	echo json_encode(
		[
			'success' => true,
			'route' => [
				'type' => 'Feature',
				'geometry' => $route->geometry,
				'properties' => [
					'distance' => $route->distance ?? null,
					'duration' => $route->duration ?? null,
				],
			],
		],
		JSON_UNESCAPED_UNICODE
	);

}catch(Exception $e){
	syslog(LOG_ERR, $e->getMessage());
	set_headers_status(500);
	exit;	
}
