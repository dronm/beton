<?php
require_once("db_con_f.php");
require_once("common/SMSService.php");

if (SMS_ACTIVE){

	$dbLink = db_con();		
	
	$sms = new SMSService(SMS_LOGIN,SMS_PWD);
	//отметки
	$id = $dbLink->query(
	"SELECT
		id,sms_id
	FROM sms_for_sending
	WHERE sent=TRUE AND delivered=FALSE AND sent_date_time BETWEEN now()::timestamp-'24 hours'::interval AND now()::timestamp");
	
	while ($ar=$dbLink->fetch_array($id)){
		try{
			if ($sms->get_delivered($ar['sms_id'])){
				$dbLink->query(sprintf(
				"UPDATE sms_for_sending
					SET delivered=TRUE,
						delivered_date_time=now()::timestamp
				WHERE id=%d",
				$ar['id']));
			}
		}
		catch(Exception $e){
		}
	}
}

?>
