<?php
require_once(dirname(__FILE__).'/../Config.php');
require_once(FRAME_WORK_PATH.'db/db_pgsql.php');

function db_con(){
	$link = new DB_Sql();
	$link->appname = APP_NAME;
	$link->technicalemail = TECH_EMAIL;
	$link->detailedError = defined('DETAILED_ERROR')? DETAILED_ERROR:DEBUG;

	/*conneсtion*/
	$link->server		= DB_SERVER_MASTER;
	$link->user		= DB_USER;
	$link->password	= DB_PASSWORD;
	$link->database	= DB_NAME;
	$link->connect(DB_SERVER_MASTER, DB_USER, DB_PASSWORD);

	//ВНИМАНИЕ!!! БЕЗ reportError=TRUE исключение не генерится!!!!
	
	return $link;
}
?>
