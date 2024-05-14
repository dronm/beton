<?php
require_once(dirname(__FILE__).'/../Config.php');
require_once('db_con.php');
require_once(USER_CONTROLLERS_PATH.'ClientDebt_Controller.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtFloat.php');

try{
	$contr = new ClientDebt_Controller($dbLink);
	$contr->update_from_1c(NULL);
	
}catch(Exception $e){
	$msg = "ClientDebt_Controller->update_from_1c() failed: ". $e->getMessage();
	if(!defined("DEBUG") || DEBUG!==TRUE){
		error_log($msg);
	}else{
		throw new Exception($msg);
	}
}
?>
