<?php

require_once(dirname(__FILE__).'/../functions/db_con_f.php');

try{

	$dbLink = db_con();
	$q = "SELECT
			proc.id,
			proc.date_time,
			proc.vehicle_plate,
			proc.driver,			
			carrier.name AS carrier_name,
			proc.doc_ref,
			proc.store,
			proc.quant_gross,
			proc.quant_net,
			proc.doc_quant_gross,
			proc.doc_quant_net,
			proc.material_id
			
		FROM doc_material_procurements2 AS proc
		LEFT JOIN suppliers AS carrier ON carrier.id = proc.carrier_id
		WHERE
			proc.doc_ref_1c IS NULL
			AND proc.date_time::date>='2021-06-24'
			AND proc.quant_net>0
			AND doc_material_procurements2_material_check(proc.material_name)
		ORDER BY date_time";
	//$q = 'SELECT * FROM doc_material_procurements2 LIMIT 5';
	$ar = $dbLink->query_first(sprintf("SELECT query_to_xml('%s',true,true,'') AS xml", str_replace("'","''",$q)));
	
	ob_clean();
	header('Content-Type: text/xml; charset="utf-8"');
	echo '<?xml version="1.0" encoding="UTF-8"?>';
	echo '<rows>';
	if(is_array($ar) && count($ar)){
		echo $ar['xml'];
	}
	echo '</rows>';
	
}catch(Exception $e){
	error_log($e->getMessage());
	ob_clean();
	header('Content-Type: text/plain; charset="utf-8"');
	header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
	echo $e->getMessage();
}
?>
