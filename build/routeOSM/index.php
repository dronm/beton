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

//User agent parser
require_once USER_MODELS_PATH.'Spyc.php';

require_once 'common/matomo/device-detector/autoload.php';
require_once 'common/matomo/device-detector/DeviceDetector.php';
require_once 'common/matomo/device-detector/Parser/AbstractParser.php';
require_once 'common/matomo/device-detector/Parser/AbstractBotParser.php';
require_once 'common/matomo/device-detector/Parser/Bot.php';
require_once 'common/matomo/device-detector/Parser/OperatingSystem.php';
require_once 'common/matomo/device-detector/Yaml/ParserInterface.php';
require_once 'common/matomo/device-detector/Yaml/Spyc.php';
require_once 'common/matomo/device-detector/Cache/CacheInterface.php';
require_once 'common/matomo/device-detector/Cache/StaticCache.php';

require_once 'common/matomo/device-detector/Parser/VendorFragment.php';
require_once 'common/matomo/device-detector/Parser/Client/AbstractClientParser.php';
require_once 'common/matomo/device-detector/Parser/Client/FeedReader.php';
require_once 'common/matomo/device-detector/Parser/Client/MobileApp.php';
require_once 'common/matomo/device-detector/Parser/Client/MediaPlayer.php';
require_once 'common/matomo/device-detector/Parser/Client/PIM.php';
require_once 'common/matomo/device-detector/Parser/Client/Browser.php';
require_once 'common/matomo/device-detector/Parser/Client/Browser/Engine/Version.php';
require_once 'common/matomo/device-detector/Parser/Client/Library.php';
require_once 'common/matomo/device-detector/Parser/Device/AbstractDeviceParser.php';
require_once 'common/matomo/device-detector/Parser/Device/HbbTv.php';
require_once 'common/matomo/device-detector/Parser/Device/Notebook.php';
require_once 'common/matomo/device-detector/Parser/Device/Console.php';
require_once 'common/matomo/device-detector/Parser/Device/CarBrowser.php';
require_once 'common/matomo/device-detector/Parser/Device/Camera.php';
require_once 'common/matomo/device-detector/Parser/Device/PortableMediaPlayer.php';
require_once 'common/matomo/device-detector/Parser/Device/Mobile.php';


use DeviceDetector\DeviceDetector;
use DeviceDetector\Parser\Device\AbstractDeviceParser;
AbstractDeviceParser::setVersionTruncation(AbstractDeviceParser::VERSION_TRUNCATION_NONE);

define('ER_ROUTE_DONE','Маршрут завершен.');
define('ER_NO_ROUTE','Неверная ссылка.');

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
	show_error(ER_NO_ROUTE,405);
	exit;
}
$id_ar = array_keys($_GET);
$shipment_id = intval($id_ar[0]);

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
}

$session->start(
	'_r'.$shipment_id,
	$dbLink,
	$dbLink,
	FALSE,
	(defined('SESSION_LIVE_SEC')? intval(SESSION_LIVE_SEC):0),
	(defined('SESSION_KEY')? SESSION_KEY:'')		
);	

//check for shipment	
$ar = $dbLink->query_first(sprintf(
	"SELECT
		const_map_default_lon_val() AS map_def_lon
		,const_map_default_lat_val() AS map_def_lat
	
		,sch.vehicle_id
		,(SELECT
			sch_st.state
		FROM vehicle_schedule_states AS sch_st		
		WHERE sch_st.schedule_id = sch.id
		ORDER BY sch_st.date_time DESC
		LIMIT 1
		) AS shipment_state
		
		,replace(replace(st_astext(d.zone), 'POLYGON(('::text, ''::text), '))'::text, ''::text) AS dest_zone
		
		,vh.tracker_id
		,vh.plate AS vehicle_plate
		,(SELECT
			json_build_object(
				'id',v_pos.id
				,'plate',v_pos.plate
				,'feature',v_pos.feature
				,'owner',v_pos.owner
				,'make',v_pos.make
				,'tracker_id',v_pos.tracker_id
				,'pos_data',v_pos.pos_data
			)	 
		FROM vehicles_last_pos AS v_pos
		WHERE v_pos.id=sch.vehicle_id
		) AS last_pos
		
		,(SELECT users.id FROM users WHERE name='Маршруты' LIMIT 1) AS user_id
		,r_csh.client_route_done
		,o.destination_id
		,o.client_id
		,(cl_d.lon IS NOT NULL AND cl_d.lat IS NOT NULL) AS client_location_exists
		
	FROM shipments AS sh
	LEFT JOIN vehicle_schedules AS sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles AS vh ON vh.id = sch.vehicle_id
	LEFT JOIN orders AS o ON o.id=sh.order_id
	LEFT JOIN destinations AS d ON d.id = o.destination_id
	LEFT JOIN vehicle_route_cashe AS r_csh ON r_csh.shipment_id = sh.id AND r_csh.vehicle_state='left_for_dest'
	LEFT JOIN client_destinations AS cl_d ON cl_d.client_id=o.client_id AND cl_d.destination_id = o.destination_id
	WHERE sh.id=%d AND d.zone IS NOT NULL"
	,$shipment_id
));

if(is_array($ar) && count($ar) && $ar['client_route_done']=='t'){
	show_error(ER_ROUTE_DONE,404);
	exit;
	
}else if(!is_array($ar) || !count($ar) || !isset($ar['shipment_state'])
 || !isset($ar['tracker_id'])
 || ($ar['shipment_state']!='busy' && $ar['shipment_state']!='at_dest')
){
	show_error(ER_NO_ROUTE,404);
	exit;
}

//throw new Exception('Cl='.$ar['client_id'].' Dest='.$ar['destination_id']);
if(!$sess_found){	
	//**** Login information
	$headers = '';			
	if (!function_exists('getallheaders')){
		function getallheaders(){
			$headers = [];
			foreach ($_SERVER as $name => $value){
				if (substr($name, 0, 5) == 'HTTP_'){
					$headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
				}
			}
			return $headers;
		}
	} 
	$headers = getallheaders();
	$headers_json = json_encode($headers);	
	if (isset($headers['User-Agent'])){
		$userAgent = $headers['User-Agent'];//$_SERVER['HTTP_USER_AGENT'];
		$dd = new DeviceDetector($userAgent);
		$dd->skipBotDetection();
		$dd->parse();
		$header_user_agent = json_encode(array(
			'clientInfo'	=> $dd->getClient()
			,'osInfo'	=> $dd->getOs()
			,'device'	=> $dd->getDeviceName()
			,'brand'	=> $dd->getBrandName()
			,'model'	=> $dd->getModel()
		));			
	}
	else{
		$header_user_agent = NULL;
	}	
	//********************************
	
	$dbLink->query(sprintf(
		"INSERT INTO logins
		(date_time_in,ip,session_id,pub_key,user_id,headers_j,user_agent)
		VALUES(now(),'%s','%s','%s',%d,'%s',%s)"
		,$_SERVER["REMOTE_ADDR"]
		,session_id()
		,$shipment_id
		,$ar['user_id']
		,$headers_json
		,is_null($header_user_agent)? 'NULL':"'".$header_user_agent."'"
	));								
	
	$_SESSION['destination_id'] = $ar['destination_id'];
	$_SESSION['tracker_id'] = $ar['tracker_id'];
	$_SESSION['client_id'] = $ar['client_id'];
	$_SESSION['shipment_id'] = $shipment_id;
}

$route_rest_len = NULL;
$route_rest = VehicleRoute::getRoute($ar['vehicle_id'], $dbLink, $route_rest_len);

//throw new Exception('route_rest='.$route_rest);
if(!file_exists($html = OUTPUT_PATH.'Route.html')){
	$htmp_cont = file_get_contents(USER_VIEWS_PATH.'Route.html');	
	$htmp_cont = str_replace('{{AUTHOR}}', 'Andrey Mikhalevich', $htmp_cont);
	$htmp_cont = str_replace('{{KEYWORD}}', 'Маршрут GPRS, трэкинг, traking', $htmp_cont);	
	
	file_put_contents($html,$htmp_cont);
}else{
	$htmp_cont = file_get_contents($html);
}

if(DEBUG){
	$script_ver = uniqid();
}else{
	$script_ver = VERSION;
}

$htmp_cont = str_replace('{{TITLE}}', 'Маршрут следования миксера '.$ar['vehicle_plate'], $htmp_cont);
$htmp_cont = str_replace('{{DESCRIPTION}}', 'Маршрут следования миксера '.$ar['vehicle_plate'], $htmp_cont);
$htmp_cont = str_replace('{{VERSION}}', $script_ver, $htmp_cont);	 	 
$htmp_cont = str_replace('{{ID}}', $shipment_id, $htmp_cont);
$htmp_cont = str_replace('{{lastPos}}', $ar['last_pos'], $htmp_cont);
$htmp_cont = str_replace('{{destZone}}', $ar['dest_zone'], $htmp_cont);
$htmp_cont = str_replace('{{routeRest}}', $route_rest, $htmp_cont);
$htmp_cont = str_replace('{{vehiclePlate}}', $ar['vehicle_plate'], $htmp_cont);
$htmp_cont = str_replace('{{token}}', $shipment_id.':'.md5('route_'.$shipment_id), $htmp_cont);

$htmp_cont = str_replace('{{appSrvHost}}', APP_SERVER_HOST, $htmp_cont);
$htmp_cont = str_replace('{{appSrvPort}}', APP_SERVER_PORT, $htmp_cont);
$htmp_cont = str_replace('{{appName}}', APP_NAME, $htmp_cont);
$htmp_cont = str_replace('{{locationExists}}', ($ar['client_location_exists']=='t')? 'true':'false', $htmp_cont);

$htmp_cont = str_replace('{{routeRestLen}}', $route_rest_len, $htmp_cont);
	 
echo $htmp_cont;
	 
?>
