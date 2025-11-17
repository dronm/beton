<?php

require_once(dirname(__FILE__).'/../functions/db_con_f.php');
require_once(dirname(__FILE__).'/../functions/http_headers.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');

/**
 * Прием данных от ТД Горный, POST запрос, поле events - массив структур GO, поле k ключ авторизации
	ID string `json:"id"`
	EventDateTime string `json:"eventDateTime"`
	VehiclePlate sql.NullString `json:"vehiclePlate"`
	DriverName sql.NullString `json:"driverName"`
	VehicleMake sql.NullString `json:"vehicleMake"`
	Brutto sql.NullFloat64 `json:"brutto"`
	Netto sql.NullFloat64 `json:"netto"`
	DocBrutto sql.NullFloat64 `json:"docBrutto"`
	DocNetto sql.NullFloat64 `json:"docNetto"`		
 *
 */

/*
Проверить:
update doc_material_procurements2
set material_id = (select id from raw_materials where name='Песок'),
carrier_id = (SELECT m.carrier_id FROM gornyi_carrier_match AS m
				WHERE m.plate = vehicle_plate)
where material_id=7 AND material_name='Песок Евробетон'


*/

if(!isset($_REQUEST) || !isset($_REQUEST['k']) || !isset($_REQUEST['events']) ){
	set_headers_status(400);
	exit;
	
}else if($_REQUEST['k'] != AUTH_GORNY_KEY){
	set_headers_status(403);
	exit;
}

try{
	$events = json_decode($_REQUEST['events']);
	//$events = json_decode('[{"id":"4F1EF659-261E-0E4F-AC33-4841AFAD1580","eventDateTime":"2023-04-14T11:21:18.3000","vehiclePlate":{"String":"м676ув72","Valid":true},
//"driverName":{"String":"","Valid":false},"vehicleMake":{"String":"FRED","Valid":true},"materialName":{"String":"Цемент42,5","Valid":true},
//"brutto":{"Float64":16980,"Valid":true},"netto":{"Float64":0,"Valid":false},"docBrutto":{"Float64":0,"Valid":false},"docNetto":{"Float64":26000,"Valid":true}}]');
	//set_headers_status(200);
	//exit;

	if(count($events)){
		$dbLink = db_con();
		
		$q_tmpl = "INSERT INTO doc_material_procurements2
			(date_time, number, doc_ref, user_id, supplier_id, carrier_id, driver, vehicle_plate, material_id, material_name,
			quant_gross, quant_net, doc_quant_gross, doc_quant_net)
			VALUES (%s, NULL, %s, %s, %s, %s, %s, %s, %d, %s,
				%s, %s, %s, %s)
			ON CONFLICT (doc_ref) DO UPDATE SET
				date_time = %s,
				number = NULL,
				doc_ref = %s,
				user_id = %s,
				supplier_id = %s,
				carrier_id = %s,
				driver = %s,
				vehicle_plate = %s,
				material_id = %d,
				material_name = %s,
				quant_gross = %s,
				quant_net = %s,
				doc_quant_gross = %s,
				doc_quant_net = %s
				
			";
		$user_ar = $dbLink->query_first(sprintf("SELECT id FROM users WHERE name='Регламент' LIMIT 1"));
		$user_id = (is_array($user_ar) && $user_ar['id'])? $user_ar['id']:'NULL';
		
		$supplier_ar = $dbLink->query_first(sprintf("SELECT id FROM suppliers where name='Транзит-97 (ГОРНЫЙ)' LIMIT 1"));
		$supplier_id = (is_array($supplier_ar) && $supplier_ar['id'])? $supplier_ar['id']:'NULL';	
		
		$materals = [];//Список материалов, которые уже находили, ключ mat_NAME, значение - ID
		
//file_put_contents('gornyi.txt', var_export($events, TRUE), FILE_APPEND);		
//throw new Exception('TEST');

		foreach($events as $ev){

			if(!isset($ev->eventDateTime)){
				throw new Exception('Missing required parameter eventDateTime');
			}
			if(!isset($ev->id)){
				throw new Exception('Missing required parameter id');
			}
			if(!isset($ev->vehiclePlate)){
				throw new Exception('Missing required parameter vehiclePlate');
			}

			$eventDateTime = "'".$ev->eventDateTime."'";
			$id = "'".$ev->id."'";
			$driverName = $ev->driverName->Valid? "'".$ev->driverName->String."'":'NULL';
			$materialName = (isset($ev->materialName)&&$ev->materialName->Valid)? "'".$ev->materialName->String."'":'NULL';
			$vehiclePlate = $ev->vehiclePlate->Valid? "'".$ev->vehiclePlate->String."'":'NULL';
			$brutto = $ev->brutto->Valid? floatval($ev->brutto->Float64):'0';
			$netto = $ev->netto->Valid? floatval($ev->netto->Float64):'0';
			$docBrutto = $ev->docBrutto->Valid? floatval($ev->docBrutto->Float64):'0';
			$docNetto = $ev->docNetto->Valid? floatval($ev->docNetto->Float64):'0';

			//material ID resolving 
			$material_name = mb_strtolower($materialName);
			if($materialName == 'null'||$materialName == 'NULL'){
				$material_name = 'Цемент';
				
			}else if(mb_strpos($material_name, 'песок') !== FALSE ){					
				$material_name = 'Песок';
				
			}else if(mb_strpos($material_name, 'щебен') !== FALSE || mb_strpos($material_name, '5-20') !== FALSE || mb_strpos($material_name, '4-70') !== FALSE){
				$material_name = 'Щебень';
				
			}else if(mb_strpos($material_name, 'цемент') !== FALSE ){
				$material_name = 'Цемент';
			}
			$material_id = 0;
			if(isset($materals[$material_name])){
				$material_id = $materals[$material_name];
			}else{			
				$material_name_for_db = NULL;
                FieldSQLString::formatForDb($dbLink, $material_name, $material_name_for_db);			
                                
				$material_ar = $dbLink->query_first(sprintf("SELECT id FROM raw_materials WHERE name = %s LIMIT 1", $material_name_for_db));
				if(is_array($material_ar) && count($material_ar) && isset($material_ar['id'])){
					$material_id = $material_ar['id'];
					$materals[$material_name] = $material_id;
				}
			}
			
			$carrier_ar = $dbLink->query_first(sprintf(
				"SELECT carrier_id FROM gornyi_carrier_match
				WHERE plate = %s"
				,$vehiclePlate
			));
			if(is_array($carrier_ar) && count($carrier_ar)){
				$carrier_id = isset($carrier_ar['carrier_id'])? $carrier_ar['carrier_id']:'NULL';
				
			}else{
				//no carrier
				$carrier_ar = $dbLink->query_first(sprintf(
					"INSERT INTO gornyi_carrier_match (plate) VALUES(%s)"
					,$vehiclePlate
				));
				$carrier_id = 'NULL';
			}
			
			$s = sprintf($q_tmpl
				,$eventDateTime
				,$id
				,$user_id
				,$supplier_id
				,$carrier_id
				,$driverName
				,$vehiclePlate
				,$material_id
				,$materialName
				,$brutto
				,$netto
				,$docBrutto
				,$docNetto

				,$eventDateTime
				,$id
				,$user_id
				,$supplier_id
				,$carrier_id
				,$driverName
				,$vehiclePlate
				,$material_id
				,$materialName
				,$brutto
				,$netto
				,$docBrutto
				,$docNetto
				
			);
			//file_put_contents('/home/andrey/www/htdocs/beton_new/output/111.sql', $s);
			$dbLink->query($s);
		}
	}

	set_headers_status(200);
	
}catch(Exception $e){
	syslog(LOG_ERR, $e->getMessage());
	set_headers_status(500);
	exit;	
}

?>
