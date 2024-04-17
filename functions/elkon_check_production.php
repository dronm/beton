<?php
require_once('db_con.php');
require_once(USER_CONTROLLERS_PATH.'Production_Controller.php');

/**
 * 2 параметра: productionSiteId, productionId
 */

if (count($argv)<3){
	die("Arguments: productionSiteId, productionId");
}
$productionSiteId = $argv[1];
$productionId = $argv[2];

//При ошибке все залогится куда надо...
$dbLink->reportError = TRUE;
$contr = new Production_Controller($dbLink);
$contr->check_data(NULL);
$contr->check_production_by_id($productionSiteId, $productionId);

?>
