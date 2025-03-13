<?php
require_once('db_con.php');
require_once(USER_CONTROLLERS_PATH.'Production_Controller.php');
//При ошибке все залогится куда надо... исключения не будет!!!
//$dbLink->reportError = TRUE;

$sygFile = OUTPUT_PATH."elkon_upload.syg";
if(file_exists($sygFile)){
	exit;
}

file_put_contents($sygFile, date("Y-m-dTH:i:s"));
try{
	$contr = new Production_Controller($dbLink);
	$contr->check_data(NULL);
}finally{
	unlink($sygFile);
}

?>
