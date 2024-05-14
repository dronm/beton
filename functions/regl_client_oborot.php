<?php
require_once(dirname(__FILE__).'/../Config.php');
require_once(dirname(__FILE__).'/ExtProg.php');
require_once('db_con.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');

function get_owner_id($dbLink, $clientRef, $clientName){
	$owner_q = "SELECT id FROM vehicle_owners
		WHERE client_id = (SELECT id FROM clients WHERE ref_1c->'keys'->>'ref_1c' = %s)";
		
	$ref_db = NULL; //sanatised
	FieldSQLString::formatForDb($dbLink, $clientRef, $ref_db);
	
	$ar = $dbLink->query_first(sprintf($owner_q, $ref_db));
	if(!is_array($ar) || !count($ar)){
		log_error(sprintf('client %s not found by ref', $clientName));
		return NULL;
	}
	return $ar['id'];
}

function insert_value($dbLink, $row, $smField, $itemId){
	$val_query = "INSERT INTO vehicle_tot_rep_common_item_vals (vehicle_owner_id, vehicle_tot_rep_common_item_id, period, value)
		VALUES (
			%d,
			%d,
			'%s',
			%f
		) ON CONFLICT (vehicle_owner_id, vehicle_tot_rep_common_item_id, period)
		DO UPDATE SET value = %f";
	$sm = floatval($row[$smField]);
	$per = strtotime($row['period']);
	$owner_id = get_owner_id($dbLink, $row['client_ref'], $row['client']);
	if(is_null($owner_id)){
		return;
	}
	$q = sprintf($val_query, $owner_id, $itemId, date('Y-m-d', $per), $sm, $sm);
	$dbLink->query($q);
	//echo 'dogovor='.$row['dogovor'].PHP_EOL.$q.PHP_EOL;
}

function log_error($s) {
	//echo 'ERROR: '.$s.PHP_EOL;
	//syslog(LOG_CRIT, $s);	
}

define('ITEM_SHTRAF', 5);
define('ITEM_GSM', 4);
define('ITEM_VIPLATA', 1);

try{
	//$res = ExtProg::getClientOborot();
	//file_put_contents('../output/client_oborot.dt', serialize($res));
	$res = unserialize(file_get_contents('../output/client_oborot.dt'));
	
	if(!isset($res) || !isset($res['models'])
	|| !isset($res['models']['ModelServResponse'])
	|| !isset($res['models']['ModelServResponse']['rows'])
	|| !count($res['models']['ModelServResponse']['rows'])
	|| !isset($res['models']['ModelServResponse']['rows'][0]['result'])
	){
		throw new Exception('ExtProg::getClientOborot() erroneous structure');
	}
	if($res['models']['ModelServResponse']['rows'][0]['result'] == '1'){
		throw new Exception($res['models']['ModelServResponse']['rows'][0]['descr']);
	}
	//file_put_contents('../output/cont1.json', var_export($res, true));
	if(!isset($res['models']['ClientDogOborot_Model'])){
		throw new Exception('ExtProg::getClientOborot() failed: model ClientDogOborot_Model not found');
	}
	if(!isset($res['models']['ClientDogOborot_Model']['rows'])){
		throw new Exception('ExtProg::getClientOborot() failed: model ClientDogOborot_Model rows not found');
	}

	foreach($res['models']['ClientDogOborot_Model']['rows'] as $row){
		if($row['firm_inn']==""){
			continue;
		}
		
		if($row['acc'] == "62.01" && floatval($row['turnover_kt']) > 0){
			insert_value($dbLink, $row, 'turnover_kt', ITEM_VIPLATA);
			
		}else if($row['acc'] == "60.02" && floatval($row['turnover_dt']) > 0){
			$dog = mb_strtolower($row['dogovor']);
			if(mb_strpos($dog, 'штраф') !== FALSE){
				insert_value($dbLink, $row, 'turnover_dt', ITEM_SHTRAF);
				
			}else if(mb_strpos($dog, 'гсм') !== FALSE){
				insert_value($dbLink, $row, 'turnover_dt', ITEM_GSM);
			}
		}
	}
	
}catch(Exception $e){
	$msg = 'Eurobeton regl_client_oborot() failed: '. $e->getMessage();
	if(!defined("DEBUG") || DEBUG!==TRUE){
		error_log($msg);
	}else{
		throw new Exception($msg);
	}
}

?>
