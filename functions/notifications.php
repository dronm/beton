<?php
require_once(dirname(__FILE__).'/../Config.php');
require_once(dirname(__FILE__).'/../Config.uniq.php');
require_once(dirname(__FILE__).'/tm_sync_files.php');

require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');

function add_ref($ref){
	return (!isset($ref) || $ref == '')? '{}':$ref;
}
/*
function notify_tm_msg_out($linkMaster, $msg, $extObj){
	$linkMaster->query(sprintf(
	"SELECT
		pg_notify('TmOutMessage.insert'
			,json_build_object(
				'params',json_build_object(								
					'ext_obj', '%s'
					,'text', '%s'
				)
			)::text
		
		)",
		add_ref($extObj),
		$msg
	));					
}
 */
//returns:
//photo, document, audio, video
//based on file mime type
function get_tm_mime_type($fileMimeType){
	$mime_types = array(
		'text/plain'						=> 'document',
		'text/html'						=> 'document',
		'application/xml'					=> 'document',
		'text/x-php'						=> 'document',
		'image/tiff'						=> 'document',
		'application/zip'					=> 'document',
		'application/pdf'					=> 'document',
		'application/msword'					=> 'document',
		'application/vnd.oasis.opendocument.text'		=> 'document',
		'application/vnd.oasis.opendocument.spreadsheet'	=> 'document',
		'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'=> 'document',
		'application/vnd.ms-excel'				=> 'document',
		'application/rtf'					=> 'document',		
		'application/octet-stream'                              => 'document',
		
		'video/x-flv'		=> 'video',
		'audio/mpeg'		=> 'video',
		'video/quicktime'	=> 'video',
		
		'image/png'		=> 'photo',
		'image/jpeg'		=> 'photo',
		'image/jpg'		=> 'photo',
		'image/gif'		=> 'photo',
		'image/bmp'		=> 'photo'
	);
	if (array_key_exists($fileMimeType, $mime_types)) {
		return $mime_types[$fileMimeType];
	}
}

function callback_on_msg_sent($linkMaster, $msgId, $res, $errText){
	$linkMaster->query(sprintf(
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
		,$msgId
		,$res
		,$errText		
	));
	
}

function parse_send_file_resp($linkMaster, $resp, $contactId){
	$resp['chat_id'] = $resp['chat']['id'];
	$ar_id = $linkMaster->query_first('SELECT notifications.tm_out_messages_nextval() AS id');
	if(!$ar_id || !is_array($ar_id) || !isset($ar_id)){
		throw new Exception("notifications.tm_out_messages_nextval() failed");
		
	}
	$linkMaster->query(sprintf("INSERT INTO notifications.tm_out_messages
		(id, app_id, message, date_time, sent_date_time, sent, ext_user, ext_contact_id)
		VALUES (
			%d,
			%d,
			'%s',
			NOW(), NOW(), TRUE,
			(SELECT
				users_ref(u)
			FROM users AS u
			WHERE u.id = %d
			),
			%d
		)"
		,$ar_id['id']
		,MS_APP_ID
		,json_encode($resp)
		,$_SESSION['user_id']
		,$contactId
	));
	callback_on_msg_sent($linkMaster, $ar_id['id'], 'TRUE', '');
}

//media file
function send_file_to_user($linkMaster, $tmId, $cap, $file, $tmMime, $postedFileName, $contactId){
	$dbTMConn = getTMDbConn();
	$q_params = $dbTMConn->query_first(sprintf(
		"SELECT
			tm_params
		FROM apps WHERE id = %d", MS_APP_ID
	));
	if(!isset($q_params['tm_params'])){
		throw new Exception('TM params not found on application ID:'.TM_APP_NAME);
	}
	$tm_params = json_decode($q_params['tm_params'], TRUE);

	$resp = NULL;
	if($tmMime == "document"){
		$resp = apiSendDocument($tm_params['token'], $tmId, $cap, $file, $postedFileName);		

	}else if($tmMime == "photo"){
		$resp = apiSendPhoto($tm_params['token'], $tmId, $cap, $file, $postedFileName);		

	}else if($tmMime == "audio"){
		$resp = apiSendAudio($tm_params['token'], $tmId, $cap, $file, $postedFileName);		

	}else if($tmMime == "video"){
		$resp = apiSendVideo($tm_params['token'], $tmId, $cap, $file, $postedFileName);		
	}
	if(!isset($resp) || !is_array($resp) || !count($resp)){
		if(is_string($resp)){
			throw new Exception($resp);
		}
		throw new Exception('Ошибка отправки сообщения: '. var_export($resp, TRUE));
		
	}
//file_put_contents('/home/andrey/www/htdocs/beton_new/output/notif.txt', var_export($resp,TRUE).PHP_EOL, FILE_APPEND);
	//rename file to TM file_id based on tm type and download preview
	$tm_file_id = NULL; //short ID for file name
	$tm_thubn_full_id = NULL;
	if($tmMime == "document"){
		if(isset($resp['document']['file_id'])){
			$tm_file_id = $resp['document']['file_unique_id'];
		}
		if(isset($message['document']['thumb']['file_id'])){
			$tm_thubn_full_id = $message['document']['thumb']['file_id']; 
		}

	}else if($tmMime == "photo"){
		if(isset($resp['photo']) && is_array($resp['photo']) && count($resp['photo'])){
			//the biggest picture file_unique_id is a short ID
			$tm_file_id = $resp['photo'][count($resp['photo'])-1]['file_unique_id'];
			if(count($resp['photo']) > 1){
				//the smallest picture
				$tm_thubn_full_id = $resp['photo'][0]['file_id'];
			}
		}
		
	}else if($tmMime == "audio"){
		if(isset($resp['audio']['file_id'])){
			$tm_file_id = $resp['audio']['file_unique_id'];
		}
		$tm_thubn_full_id = $message['audio']['thumb']['file_id']; 

	}else if($tmMime == "video"){
		$tm_file_id = $resp['video']['file_unique_id'];
		$tm_thubn_full_id = $message['video']['thumb']['file_id']; 
	}

	//+thumbnail
	if(isset($tm_thubn_full_id)){
		$tm_thubn_id = apiDownloadFile($tm_params['token'], $tm_thubn_full_id, TM_STORE);
//file_put_contents('/home/andrey/www/htdocs/beton_new/output/notif.txt', 'tm_thubn_id='.$tm_thubn_id.PHP_EOL, FILE_APPEND);
		syncStore(TM_STORE.'/'. $tm_thubn_id);
	}	

	//rename main file	
	if($tm_file_id){
		rename($file, TM_STORE.'/'. $tm_file_id);
//file_put_contents('/home/andrey/www/htdocs/beton_new/output/notif.txt', 'renamed main file to='.TM_STORE.'/'. $tm_file_id." from ".$file.PHP_EOL.PHP_EOL, FILE_APPEND);		
		syncStore(TM_STORE.'/'. $tm_file_id);
	}
	parse_send_file_resp($linkMaster, $resp, $contactId);
}

//simple notification
function add_notification_from_contact($linkMaster, $tel, $msg, $smsType, $docRef, $extContactId){
	//error_log(sprintf('add_notification_from_contact tel=%s, msg==%s, smsType=%s, docRef=%s, extContactId=%d', $tel, $msg, $smsType, add_ref($docRef), $extContactId));
	//return;
	
	$msg_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $msg, $msg_for_db);

	$type_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $smsType, $type_for_db);

	$tel_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $tel, $tel_for_db);

	$ref = add_ref($docRef);
	$ref_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $ref, $ref_for_db);

	$linkMaster->query(sprintf(
		"INSERT INTO notifications.ext_messages VALUES(
				jsonb_build_object(
					'app_id', %d,
					'messages', jsonb_build_array(
						jsonb_build_object(
							'ext_contact_id', %d,
							'tm', jsonb_build_object(
								'text', %s
							),
							'ext_user',(SELECT users_ref(u) FROM users AS u WHERE u.id=%d),
							'sms',jsonb_build_object(
								'tel', %s,
								'body', %s,
								'sms_type', %s,
								'doc_ref', %s::jsonb
							)							
						)
					)
				)
		)",
		MS_APP_ID,
		$extContactId,
		$msg_for_db,
		$_SESSION['user_id'],
		$tel_for_db,
		$msg_for_db,
		$type_for_db,
		$ref_for_db
	));
	
	//notify_tm_msg_out($linkMaster, $msg, $extObj);					
}

function add_notification_from_contact_tm($linkMaster, $tel, $msg, $smsType, $docRef, $extContactId){
	$msg_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $msg, $msg_for_db);

	$linkMaster->query(sprintf(
		"INSERT INTO notifications.ext_messages VALUES(
				jsonb_build_object(
					'app_id', %d,
					'messages', jsonb_build_array(
						jsonb_build_object(
							'ext_contact_id', %d,
							'tm', jsonb_build_object(
								'text', %s
							),
							'ext_user',(SELECT users_ref(u) FROM users AS u WHERE u.id=%d)
						)
					)
				)
		)",
		MS_APP_ID,
		$extContactId,
		$msg_for_db,
		isset($_SESSION['user_id'])? $_SESSION['user_id']:0
	));
}

function add_notification_from_contact_sms($linkMaster, $tel, $msg, $smsType, $docRef, $extContactId){
	$msg_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $msg, $msg_for_db);

	$type_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $smsType, $type_for_db);

	$tel_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $tel, $tel_for_db);

	$ref = add_ref($docRef);
	$ref_for_db = NULL;
	FieldSQLString::formatForDb($linkMaster, $ref, $ref_for_db);

	$linkMaster->query(sprintf(
		"INSERT INTO notifications.ext_messages VALUES(
				jsonb_build_object(
					'app_id', %d,
					'messages', jsonb_build_array(
						jsonb_build_object(
							'ext_contact_id', %d,
							'sms',jsonb_build_object(
								'tel', %s,
								'body', %s,
								'sms_type', %s,
								'doc_ref', %s::jsonb
							)							
						)
					)
				)
		)",
		MS_APP_ID,
		$extContactId,
		$tel_for_db,
		$msg_for_db,
		$type_for_db,
		$ref_for_db
	));					
}


?>
