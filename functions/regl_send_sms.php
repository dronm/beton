<?php
require_once("db_con_f.php");
require_once("common/SMSService.php");

//Более не используется!!!
//Все перенаправляется в notifications.ext_messages

//sygnal file
$syg_file = OUTPUT_PATH.'sms.syg';

if (!file_exists($syg_file) && SMS_ACTIVE){

	file_put_contents($syg_file, 'Busy');
	try{
		$dbLink = db_con();		
		
		$sms = new SMSService(SMS_LOGIN,SMS_PWD);
		$id = $dbLink->query(
		"SELECT
			id,tel,body
		FROM sms_for_sending
		WHERE sent=FALSE");
		while ($ar=$dbLink->fetch_array($id)){
			try{
				$sms_id = $sms->send($ar['tel'],$ar['body'],SMS_SIGN,SMS_TEST);
				$dbLink->query(sprintf(
				"UPDATE sms_for_sending
					SET sent=TRUE,
						sms_id='%s',
						sent_date_time=now()::timestamp
				WHERE id=%d",
				$sms_id,$ar['id']));			
				//echo 'Sent '.$sms_id.PHP_EOL;
			}
			catch(Exception $e){
			}
		}
		
	}finally{
		unlink($syg_file);
	}
}

?>
