<?php

/**
 * Генерит сообщение в родной базе при вызове колбака с параметрами:
 *	k=AUTH_KEY&
 *	id=MessageID(notifications.tm_in_messages||notifications.tm_out_messages)
 *	tp=in||out
  *	out_res=1||0
 *	out_error=TEXT
 *
 * Отправляет
 *	TmInMessage.insert(params:{"text":"", "sender":""})
 *	TmOutMessage.insert(params:{"text":"", "recipient":""})
 *
 * localhost/beton_new/functions/bot/?k=a32544fa-c680-11eb-b8bc-0242ac130003&id=125
 * eurobeton.katren.org/functions/bot/?k=a32544fa-c680-11eb-b8bc-0242ac130003&id=1
 */

require_once("../db_con_f.php");

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

//2 params:k, id
if(!isset($_REQUEST) || !isset($_REQUEST['k']) || !isset($_REQUEST['id']) ){
	set_headers_status(400);
	exit;
	
}else if($_REQUEST['k'] != TM_NOTIF_AUTH_KEY){
	set_headers_status(403);
	exit;
}
//file_put_contents(OUTPUT_PATH.'tm_log.txt','Got message ID='.$_REQUEST['id'].PHP_EOL,FILE_APPEND);
$dbLink = db_con();

if(isset($_REQUEST['tp']) && $_REQUEST['tp'] == 'out'){
	//outcoming message success or error
	$res = 'true';
	$err_text = '';
	if(!isset($_REQUEST['out_res']) || $_REQUEST['out_res'] != '1'){
		//error
		$out_err = isset($_REQUEST['out_error'])? trim($_REQUEST['out_error']) : 'No error text';
		$err_text = 'false';
	}
	$dbLink->query(sprintf(
		"WITH
		msg_d AS (
			SELECT
				m.id AS msg_id,
				notifications.message_text(m.message) AS text,
				notifications.message_media_type(m.message) AS media_type,
				json_build_object(
					'keys',json_build_object('id',m.ext_contact_id),
					'descr',''
				) AS ext_obj,
				m.ext_user AS sender
			FROM notifications.tm_out_messages AS m
			WHERE m.id = %d
		)
		SELECT
			pg_notify('TmOutMessage.sent',
				json_build_object(
					'params',json_build_object(
						'res', %s,
						'errText', '%s',
						'text',(SELECT text FROM msg_d),
						'ext_obj',(SELECT ext_obj FROM msg_d),
						'sender',(SELECT sender FROM msg_d),
						'media_type',(SELECT media_type FROM msg_d),
						'msg_id',(SELECT msg_id FROM msg_d)
					)
				)::text			
			)"
		,$_REQUEST['id']
		,$res
		,$err_text		
	));

}else{
	//incoming message
	$ar = $dbLink->query_first(sprintf(
		"WITH
		msg_d AS (
			SELECT
				m.id AS msg_id,
				notifications.message_text(m.message) AS text,
				notifications.message_media_type(m.message) AS media_type,				
				json_build_object(
					'keys',json_build_object('id',u.ext_contact_id),
					'descr', ct.descr
				) AS ext_obj,				
				m.message->'from'->>'first_name' AS sender,
				
				drivers.id AS driver_id
				
			FROM notifications.tm_in_messages AS m
			LEFT JOIN notifications.ext_users AS u ON (u.tm_user->>'id')::bigint = (m.message->'chat'->>'id')::bigint
				AND u.app_id = %d
			LEFT JOIN entity_contacts AS ent_dr ON ent_dr.contact_id = u.ext_contact_id AND ent_dr.entity_type='drivers'
			LEFT JOIN drivers ON drivers.id = ent_dr.entity_id
			LEFT JOIN contacts AS ct ON ct.id = u.ext_contact_id
			WHERE m.id = %d
		)
		SELECT
			pg_notify('TmInMessage.insert',
				json_build_object(
					'params',json_build_object(
						'text',(SELECT text FROM msg_d),
						'sender',(SELECT sender FROM msg_d),
						'ext_obj',(SELECT ext_obj FROM msg_d),
						'media_type',(SELECT media_type FROM msg_d),
						'msg_id',(SELECT msg_id FROM msg_d)
					)
				)::text			
			) AS notif,
			(SELECT msg_id FROM msg_d) AS msg_id,
			(SELECT driver_id FROM msg_d) AS driver_id,
			(SELECT text FROM msg_d) AS text
			"
		,MS_APP_ID
		,$_REQUEST['id']		
	));
	
	//driver
	if(is_array($ar) && count($ar) && isset($ar['driver_id']) ){
		$dbLink->query(sprintf(
			"INSERT INTO  shipment_media (
				driver_id,
				message_id
			)
			VALUES (%d,
				'%s'
			)"	
			,$ar['driver_id']
			,$ar['msg_id']
		));		
	}
}

?>
