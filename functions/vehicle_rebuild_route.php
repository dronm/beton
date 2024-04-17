<?php
/**
 * Предполагается следующая схема работы обновления маршрута:
 *	1) Следование маршруту контролируется в geo_zone_check.sql (триггер трэкера)
 *	2) При наступлении события Vehicle.rebuild_route срабатывает событие app_srv Vehicle_Controller
 *		оторый в свою очередь запускает этот скрипт, перестраивает маршрут и генерит событие Vehicle.route_redraw
 *		для браузера клиента, тот перечитывает маршрут заново 
 */
 
//require_once(dirname(__FILE__).'/../Config.php');
require_once(dirname(__FILE__).'/db_con.php');
require_once(dirname(__FILE__).'/VehicleRoute.php');

if (count($argv)<3){
	die("Arguments: tracker_id, shipment_id, vehicle_state");
}
$tracker_id = $argv[1];
$shipment_id = $argv[2];
$vehicle_state = $argv[3]; 
/*
file_put_contents(
	OUTPUT_PATH.'veh_reb_route.txt'
	,sprintf(
		date('d/m/y H:i:s').' tracker_id=%s, shipment_id=%d, vehicle_state=%s'.PHP_EOL
		,$tracker_id,$shipment_id,$vehicle_state
	)
	,FILE_APPEND
);
*/
$route_rest_len = NULL;
$route_rest = VehicleRoute::rebuildRoute($tracker_id,$shipment_id,$vehicle_state,$dbLink,$route_rest_len);

if(strlen($route_rest)>7500){
	$dbLink->query(sprintf(
		"INSERT INTO route_rests VALUES('%s','%s')
		ON CONFLICT (tracker_id) DO UPDATE SET
		route_rest = '%s'"
		,$tracker_id
		,$route_rest
		,$route_rest
	));
	$route_rest = 'NULL';
	$long_route_rest = 'true';
	
}else{
	$long_route_rest = 'false';
	$route_rest = "'". $route_rest ."'";
}

//event for browser redrawing
$dbLink->query(sprintf(
	"SELECT
		pg_notify('Vehicle.route_redraw.".$tracker_id."'
			,json_build_object(
				'params',json_build_object(								
					'tracker_id', '%s'
					,'shipment_id', %d
					,'vehicle_state', '%s'
					,'route_rest', %s
					,'long_route_rest', %s
					,'route_rest_len','".$route_rest_len."'
				)
			)::text
		
		)"
	,$tracker_id, $shipment_id, $vehicle_state, $long_route_rest, $route_rest
));


?>
