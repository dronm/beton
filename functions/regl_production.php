<?php
require_once('db_con_f.php');
require_once(USER_CONTROLLERS_PATH.'ProductionReport_Controller.php');
require_once(USER_CONTROLLERS_PATH.'Connect1c_Controller.php');

define("PROD_REPORT_USER", 209);
define("PROD_REPORT_MAT_USER", 812);

$dbLink = db_con();

$currentDate = new DateTime();

//$shiftFrom = "2026-03-01T06:00:00";
//$shiftTo = "2026-03-02T05:59:59";
$shiftFrom = (clone $currentDate)
    ->modify('-1 day')
    ->format('Y-m-d') . 'T06:00:00';
$shiftTo = $currentDate->format('Y-m-d') . 'T05:59:59';

ProductionReport_Controller::generateDocs($dbLink, $shiftFrom, $shiftTo);
$ar = $dbLink->query_first(
	"SELECT id FROM production_reports
	WHERE shift_from = $1 AND shift_to = $2",
	[$shiftFrom, $shiftTo]
);
if(is_array($ar) && count($ar) && isset($ar["id"])){
	Connect1c_Controller::exportProductionReport($dbLink, intval($ar["id"]), PROD_REPORT_USER);
}

?>
