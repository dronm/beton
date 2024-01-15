<?php

require_once(dirname(__FILE__).'/../functions/db_con_f.php');

ob_clean();
header('Content-Type: text/plain; charset="utf-8"');
$request_string = file_get_contents('php://input');
if (substr($request_string, 0, 3) == "\xef\xbb\xbf") {
	 $request_string = substr($request_string, 3);
}
file_put_contents(OUTPUT_PATH.'from_1c.txt', $request_string);
try{
	if(!isset($request_string)||!strlen($request_string)){
		throw new Exception('param is missing');
	}
	
	if(substr($request_string, 0, strlen('confirmations=')) == 'confirmations='){
		$request_string = substr($request_string, strlen('confirmations='));
		
	}else{
		throw new Exception('param is missing');
	}
	
	$confirmations = json_decode($request_string);
	if($confirmations && count($confirmations)){
		$dbLink = db_con();
		$q = 'UPDATE doc_material_procurements2 SET doc_ref_1c=%s, number=%s WHERE doc_ref=%s';
		foreach($confirmations as $conf){
			if(isset($conf->doc_ref_1c) && isset($conf->doc_ref)){
				$doc_ref_1c = "'".$dbLink->escape_string($conf->doc_ref_1c)."'";
				$number = "'".$dbLink->escape_string($conf->number)."'";
				$doc_ref = "'".$dbLink->escape_string($conf->doc_ref)."'";
				$dbLink->query(sprintf($q, $doc_ref_1c, $number, $doc_ref));			
			}
		}
		
		//$ar = $dbLink->query_first(sprintf("SELECT query_to_xml('%s',true,true,'') AS xml", str_replace("'","''",$q)));
	}	
	
}catch(Exception $e){
	error_log($e->getMessage());
	
	header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
	echo $e->getMessage();
}
?>
