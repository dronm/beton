<?php
/**
 * Клиентская программа для отображения маршрутов
 * приходит 1 параметр - int ID отгрузки (shipment)
 * разу проверяем: если маршрут завершет или нет такого - ошибка
 */
 
require_once(dirname(__FILE__).'/../version.php');
require_once(dirname(__FILE__).'/../Config.php');  

require_once(FRAME_WORK_PATH.'db/SessManager.php');
require_once(dirname(__FILE__).'/../functions/db_con.php');
require_once(dirname(__FILE__).'/../functions/VehicleRoute.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');

define('ER_BAD_QUERY','Неверный запрос.');

function set_headers_status($statusCode) {
	static $status_codes = null;

	if ($status_codes === null) {
		$status_codes = array (
		    100 => 'Continue',
		    101 => 'Switching Protocols',
		    102 => 'Processing',
		    200 => 'OK',
		    201 => 'Created',
		    202 => 'Accepted',
		    203 => 'Non-Authoritative Information',
		    204 => 'No Content',
		    205 => 'Reset Content',
		    206 => 'Partial Content',
		    207 => 'Multi-Status',
		    300 => 'Multiple Choices',
		    301 => 'Moved Permanently',
		    302 => 'Found',
		    303 => 'See Other',
		    304 => 'Not Modified',
		    305 => 'Use Proxy',
		    307 => 'Temporary Redirect',
		    400 => 'Bad Request',
		    401 => 'Unauthorized',
		    402 => 'Payment Required',
		    403 => 'Forbidden',
		    404 => 'Not Found',
		    405 => 'Method Not Allowed',
		    406 => 'Not Acceptable',
		    407 => 'Proxy Authentication Required',
		    408 => 'Request Timeout',
		    409 => 'Conflict',
		    410 => 'Gone',
		    411 => 'Length Required',
		    412 => 'Precondition Failed',
		    413 => 'Request Entity Too Large',
		    414 => 'Request-URI Too Long',
		    415 => 'Unsupported Media Type',
		    416 => 'Requested Range Not Satisfiable',
		    417 => 'Expectation Failed',
		    422 => 'Unprocessable Entity',
		    423 => 'Locked',
		    424 => 'Failed Dependency',
		    426 => 'Upgrade Required',
		    500 => 'Internal Server Error',
		    501 => 'Not Implemented',
		    502 => 'Bad Gateway',
		    503 => 'Service Unavailable',
		    504 => 'Gateway Timeout',
		    505 => 'HTTP Version Not Supported',
		    506 => 'Variant Also Negotiates',
		    507 => 'Insufficient Storage',
		    509 => 'Bandwidth Limit Exceeded',
		    510 => 'Not Extended'
		);
	}

	if ($status_codes[$statusCode] !== null) {
		$status_string = $statusCode . ' ' . $status_codes[$statusCode];
		header($_SERVER['SERVER_PROTOCOL'] . ' ' . $status_string, true, $statusCode);
	}
}

function show_error($errStr, $htmlStatus){
	set_headers_status($htmlStatus);
	$htmp_cont = file_get_contents(USER_VIEWS_PATH.'RouteEr.html');	
	$htmp_cont = str_replace('{{ERROR}}',$errStr, $htmp_cont);
	echo $htmp_cont;
}

if(!count($_GET)){
	show_error(ER_BAD_QUERY,405);
	exit;
}

if(!isset($_GET['id']) || !isset($_GET['lon']) ||!isset($_GET['lat'])){
	show_error(ER_BAD_QUERY,405);
	exit;
}

$shipment_id = intval($_GET['id']);
$lat = floatval($_GET['lat']);
$lon = floatval($_GET['lon']);
/**
 * Используем всегда один идентификатор сессии по номеру отгрузки
 */
$session = new SessManager();
$session->detailedError = DEBUG;
$session->productionError = ERR_SESSION;

$session_ar = $dbLink->query_first(
	sprintf("SELECT
			trim(l.session_id) AS session_id
			,(l.date_time_out IS NULL) AS active
			,now()-l.date_time_out > '00:10:00'::interval AS err_no_ship
		FROM logins l
		WHERE l.pub_key='%d'
		LIMIT 1",
		$shipment_id
	)
);

$sess_found = FALSE;		
if(is_array($session_ar) && isset($session_ar['session_id'])){
	
	if($session_ar['active']=='f'){
		//over
		show_error( ($session_ar['err_no_ship']=='t')? ER_NO_ROUTE:ER_ROUTE_DONE,404);
		exit;
	}

	session_id($session_ar['session_id']);	
	$sess_found = TRUE;		
	
}else{
	show_error(ER_BAD_QUERY,405);
	exit;
}

$session->start(
	'_r'.$shipment_id,
	$dbLink,
	$dbLink,
	FALSE,
	(defined('SESSION_LIVE_SEC')? intval(SESSION_LIVE_SEC):0),
	(defined('SESSION_KEY')? SESSION_KEY:'')		
);	

if(!isset($_SESSION['destination_id']) || !isset($_SESSION['client_id'])
||!isset($_SESSION['tracker_id']) ||!isset($_SESSION['shipment_id']) ){
	show_error(ER_BAD_QUERY,405);
	exit;
}

//Если координаты находятся в зоне маршрута - обновить, маршрут перестроить
$ar = $dbLink->query_first(sprintf(
	"SELECT
		St_Contains(dest.zone, ST_GeomFromText('POINT('||%f::text||' '||%f::text||')', 0)) AS loc_inside_zone
	FROM destinations AS dest
	WHERE dest.id=%d"	
	,$lon
	,$lat
	,$_SESSION['destination_id']
));

//if(is_array($ar) && count($ar) && $ar['loc_inside_zone']=='t'){
	$dbLink->query('BEGIN');
	$dbLink->query(sprintf(
		"INSERT INTO client_destinations
		(client_id,destination_id,lon,lat)
		VALUES (%d, %d, %f, %f)
		ON CONFLICT (client_id,destination_id) DO UPDATE
		SET
			lon = %f, lat = %f"
		,$_SESSION['client_id'],$_SESSION['destination_id']
		,$lon
		,$lat
		,$lon
		,$lat
	));
	
	$dbLink->query(sprintf(
		"UPDATE vehicle_route_cashe
		SET
			route = NULL
			,route_line = NULL
			,update_dt = now()
			,update_cnt = update_cnt + 1			
		WHERE shipment_id=%d AND vehicle_state='left_for_dest'"
		,$_SESSION['shipment_id']
	));
	$dbLink->query(sprintf(
		"SELECT pg_notify(
			'Vehicle.rebuild_route'
			,json_build_object(
				'params',json_build_object(								
					'tracker_id','%s'
					,'shipment_id',%d
					,'vehicle_state','left_for_dest'
				)
			)::text
		)"
		,$_SESSION['tracker_id']
		,$_SESSION['shipment_id']
	));
	$dbLink->query('COMMIT');
//}

?>
