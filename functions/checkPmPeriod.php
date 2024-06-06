<?php
require_once(dirname(__FILE__).'/db_con_f.php');
require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQL.php');

function checkPublicMethodPeriod($pm, $model, $fieldId, $allowedDays){
	$conn = db_readOnlyCon();
	$contr = new ControllerSQL($conn, $conn);
	$where = $contr->conditionFromParams($pm, $model);
	$d_from = $where->getFieldsById($fieldId, "<=");
	$d_to = $where->getFieldsById($fieldId, ">=");
	$d1 = (new DateTime())->setTimestamp($d_from);
	$d2 = (new DateTime())->setTimestamp($d_to);
	if($d2->diff(d1) > $allowedDays){
		throw new Exception("Период превышает максимальный интервал в %d дней.", $allowedDays);
	}
}
?>

