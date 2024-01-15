<?php
require_once(dirname(__FILE__).'/../Config.php');
require(dirname(__FILE__).'/DOMRuIntegration.php');
require_once(FRAME_WORK_PATH.'db/db_pgsql.php');

//178.46.157.185:7777/beton_new/domru/?cmd=contact&crm_token=badf2c5af1041feec8729a920842c891

/**
 * Интеграция с облачной АТС Дом.ру
 * URL скрипта прописан в ЛК Дом.ру
 *
 * Предполагается наличие  константы DOMRU_CRM_TOKEN
 *
 * history (POST)
 * event(POST)
 * contact (POST) 
 */
 
function print_response($statusCode, $okContent=""){
	static $status_codes = null;

	$content = "";
	if ($status_codes === null) {
		$status_codes = array (
		    200 => 'OK',
		    400 => 'Bad Request',
		    401 => 'Unauthorized',
		    402 => 'Payment Required',
		    403 => 'Forbidden',
		    404 => 'Not Found',
		    405 => 'Method Not Allowed',
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

	if($statusCode == 400){
		$content = '{"error": "Invalid parameters"}';
	
	}else if($statusCode == 401){
		$content = '{"error": "Invalid token"}';
		
	}else{
		$content = $okContent;
	}
	$status_string = $statusCode . ' ' . $status_codes[$statusCode];
	header($_SERVER['SERVER_PROTOCOL'] . ' ' . $status_string, true, $statusCode);
	
	header('Content-Type: application/json; charset=utf-8');
	
	echo $content;
} 

function get_db_link(){
	$dbLink = new DB_Sql();
	$dbLink->appname = APP_NAME;
	$dbLink->technicalemail = TECH_EMAIL;
	$dbLink->detailedError = defined('DETAILED_ERROR')? DETAILED_ERROR:DEBUG;

	/*conneсtion*/
	$dbLink->server		= DB_SERVER_MASTER;
	$dbLink->user		= DB_USER;
	$dbLink->password	= DB_PASSWORD;
	$dbLink->database	= DB_NAME;
	$dbLink->connect(DB_SERVER_MASTER, DB_USER, DB_PASSWORD);
	
	return $dbLink;
}

if(!isset($_REQUEST['cmd']) || !isset($_REQUEST['crm_token'])){
	print_response(400);
	
}else if(isset($_REQUEST['crm_token']) && $_REQUEST['crm_token']!=DOMRU_CRM_TOKEN){
	print_response(401);

/**
 * history 
 *
 * Входящий звонок клиента и ссылка на запись разговора записывается в CRM
 * Исходящий звонок клиента и ссылка на запись разговора записывается в CRM
 *
 * cmd required тип операции, в данном случае history
 * type required тип звонка in/out (входящий/исходящий) 
 * user required идентификатор пользователя облачной АТС (необхо-дим для сопоставления на стороне CRM)
 * ext NotRequired внутренний номер пользователя облачной АТС, если есть
 * groupRealName NotRequired название отдела, если входящий звонок прошел через отдел
 * telnum NotRequired прямой  телефонный  номер пользователя  облачной АТС, если есть
 * phone Required номер телефона клиента, с которого или на который произошел звонок 
 * diversion NotRequired ваш номер телефона, через который пришел входя-щий вызов 
 * start required время начала звонка формате YYYYmmddTHHMMSSZ
 * duration required общая длительность звонка в секундах 
 * callid уникальный id звонка 
 * link ссылка на запись звонка, если она включена в Облач-ной АТС
 * crm_token ключ (token) от CRM,  установленный в веб-кабинете
 * status required
 * 	статус входящего звонка:
 *		Success-успешный входящий звонок
 *		missed –пропущенный входящий звонок
 *	статус исходящего звонка:
 *		Success-успешный исходящий звонок
 *		Busy-мы получили ответ Занято
 *		NotAvailable-мы  получили    ответ Абонент  недо-ступен
 *		NotAllowed-мы  получили  ответ Звонки  на  это направление запрещены
 *		callAerror–вызов менеджера при выполнении ко-манды makecall завершился ошибкой 
 */
}else if(isset($_REQUEST['cmd']) && $_REQUEST['cmd'] == 'history'){
	$db_link = get_db_link();
	print_response(DOMRuIntegration::onHistory($_REQUEST, $db_link));
}

/**
 * event 
 * cmd required тип операции, в данном случае event
 * type required это тип события, связанного со звонком
 *	INCOMING -пришел входящий звонок (в это время у менеджера должен начать звонить телефон).
 *	ACCEPTED -звонок успешно принят (менеджер снял трубку). В этот момент можно убрать всплывающую карточку контакта в CRM.
 *	COMPLETED -звонок успешно завершен (менеджер или клиент положили трубку после разговора).
 *	CANCELLED -звонок сброшен (клиент не дождался пока менеджер снимет трубку. Либо, если это был звонок сразу на группу менеджеров,
 *		на звонок мог ответить кто-то еще).
 *	OUTGOING-менеджер совершает исходящийзвонок  (в  это  время облачная  АТС  пытается  дозво-ниться до клиента)
 * phone required номер телефона клиента
 * diversion required ваш номер телефона, через который пришел входя-щий вызов
 * user required идентификатор пользователя облачной АТС (необхо-дим для сопоставления на стороне CRM)
 * groupRealName NotRequired название отдела, если входящий звонок прошел через отдел
 * ext NotRequired внутренний номер пользователя облачной АТС, если есть
 * telnum NotRequired прямой  телефонный  номер пользователя  облачной АТС, если есть
 * callid уникальный id звонка 
 * crm_token ключ (token) от CRM,  установленный в веб-кабинете
 */
else if(isset($_REQUEST['cmd']) && $_REQUEST['cmd'] == 'event'){
	$db_link = get_db_link();
	print_response(DOMRuIntegration::onEvent($_REQUEST, $db_link));
}

/**
 * contact
 * Команда для получения информации о названии клиента и ответственном за него сотруднике по номеру его телефона. Команда вызывается при
 *	поступлении нового входящего звонка.
 * Команда используется для отображения на экране IP-телефона или в коммуникаторе на ПК сотрудника названия клиента
 *
 * phone номер телефона клиента
 * callid уникальный id звонка 
 * crm_token ключ (token) от CRM,  установленный в веб-кабинете 
 
 http://178.46.157.185:7777/beton_new/domru/?cmd=contact&crm_token=badf2c5af1041feec8729a920842c891&phone=79222695251
 
 */
else if(isset($_REQUEST['cmd']) && $_REQUEST['cmd'] == 'contact'){
	$db_link = get_db_link();
	$content = "";
	$res = DOMRuIntegration::onContact($_REQUEST, $db_link, $content);
	print_response($res, $content);
}
 
 
?>
