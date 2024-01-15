<?php
require_once(dirname(__FILE__).'/../Config.php');

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
function add_notification_from_contact($linkMaster, $tel, $msg, $smsType, $docRef, $extContactId){
	//error_log(sprintf('add_notification_from_contact tel=%s, msg==%s, smsType=%s, docRef=%s, extContactId=%d', $tel, $msg, $smsType, add_ref($docRef), $extContactId));
	//return;
	$linkMaster->query(sprintf(
		"INSERT INTO notifications.ext_messages VALUES(
				jsonb_build_object(
					'app_id', %d,
					'messages', jsonb_build_array(
						jsonb_build_object(
							'ext_contact_id', %d,
							'tm', jsonb_build_object(
								'text', '%s'
							),
							'ext_user',(SELECT users_ref(u) FROM users AS u WHERE u.id=%d),
							'sms',jsonb_build_object(
								'tel','%s',
								'body','%s',
								'sms_type','%s',
								'doc_ref', '%s'::jsonb
							)							
						)
					)
				)
		)",
		MS_APP_ID,
		$extContactId,
		$msg,
		$_SESSION['user_id'],
		$tel,
		$msg,
		$smsType,
		add_ref($docRef)
	));
	
	//notify_tm_msg_out($linkMaster, $msg, $extObj);					
}

function add_notification_from_contact_tm($linkMaster, $tel, $msg, $smsType, $docRef, $extContactId){
	$linkMaster->query(sprintf(
		"INSERT INTO notifications.ext_messages VALUES(
				jsonb_build_object(
					'app_id', %d,
					'messages', jsonb_build_array(
						jsonb_build_object(
							'ext_contact_id', %d,
							'tm', jsonb_build_object(
								'text', '%s'
							),
							'ext_user',(SELECT users_ref(u) FROM users AS u WHERE u.id=%d)
						)
					)
				)
		)",
		MS_APP_ID,
		$extContactId,
		$msg,
		isset($_SESSION['user_id'])? $_SESSION['user_id']:0
	));
	//notify_tm_msg_out($linkMaster, $msg, $extObj);					
}

function add_notification_from_contact_sms($linkMaster, $tel, $msg, $smsType, $docRef, $extContactId){
	$linkMaster->query(sprintf(
		"INSERT INTO notifications.ext_messages VALUES(
				jsonb_build_object(
					'app_id', %d,
					'messages', jsonb_build_array(
						jsonb_build_object(
							'ext_contact_id', %d,
							'sms',jsonb_build_object(
								'tel','%s',
								'body','%s',
								'sms_type','%s',
								'doc_ref', '%s'::jsonb
							)							
						)
					)
				)
		)",
		MS_APP_ID,
		$extContactId,
		$tel,
		$msg,
		$smsType,
		add_ref($docRef)
	));					
}


?>
