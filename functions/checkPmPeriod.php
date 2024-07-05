<?php
require_once(dirname(__FILE__).'/db_con_f.php');
require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQL.php');

function checkPublicMethodPeriod($pm, $model, $fieldId, $allowedDays){
	$conn = db_readOnlyCon();
	$contr = new ControllerSQL($conn, $conn);
	$where = $contr->conditionFromParams($pm, $model);
	if(!isset($where)){
		return;
	}
	$d_to = $where->getFieldsById($fieldId, "<=");
	$d_from = $where->getFieldsById($fieldId, ">=");
	
	//what if d_from/d_to not set?
	if(!isset($d_from)||!count($d_from)){
		throw new Exception("Не задана дата начала отчета");
	}
	if(!isset($d_to)||!count($d_to)){
		throw new Exception("Не задана дата окончания отчета");
	}
	$d1 = (new DateTime())->setTimestamp($d_from[0]->getValue());
	$d2 = (new DateTime())->setTimestamp($d_to[0]->getValue());
	if($d1->diff($d2)->days > $allowedDays){
		throw new Exception(sprintf("Период превышает максимальный интервал в %d дней.", $allowedDays));
	}
	// throw new Exception("stop diff:".$d1->diff($d2)->days);
}
?>

