<?php
/**
 * Ammann production
 * parse && load
 */
 
class Ammann {

	const LOG_LEVEL_DEBUG = 9;
	const LOG_LEVEL_NOTE = 3;
	const LOG_LEVEL_ERROR = 0;
	

	private static function log_action($dbLink, $prodSiteId, $mes, $mesLevel, $servLevel){
		if($servLevel >= $mesLevel){
			 $dbLink->query(sprintf(
			 	"SELECT elkon_log_upsert((NULL, now(), %d, '%s', %d)::elkon_log)",
			 	$prodSiteId,
			 	$mes,
			 	$mesLevel
			 ));
		}
	}

	private static function get_val_before($val, $search){
		$p = strpos($val, $search);
		if($p!==FALSE){
			return substr($val,0,$p);
		}else{
			return $val;
		}
	}

	private static function get_ammann_eol($haystack, $offset){
		for($i=0; $i+$offset < mb_strlen($haystack); $i++){
			if(ord(mb_substr($haystack, $offset+$i, 1)) == 10){
				break;
			}
		}
		return $i;
	}

	private static function ammann_split_line($line){
		$i = self::get_ammann_eol($line, 0);
		$res = [];
		$ar = explode('     ', mb_substr($line, 0, $i));
		foreach($ar as $part){
			if($part==''){
				continue;
			}
			array_push($res, trim($part));
		}
		return $res;
	}
 
 	/**
 	 * throws error if cannot procede of returns $result['errors']
 	 */
 	public static function parseProduction($pdfFile, &$result){
 		$out_file = sys_get_temp_dir().DIRECTORY_SEPARATOR.uniqid();
 		try{
			//pdf file is expected		
			exec('pdftotext -layout '.$pdfFile.' '.$out_file);
			if(!file_exists($out_file)){
				throw new Exception('Error converting file from PDF:'.$pdfFile);
			}
 		
 			$out_file_cont = file_get_contents($out_file);
			$data_ar = explode(PHP_EOL, $out_file_cont);
//file_put_contents('/home/andrey/www/htdocs/beton_new/build/Konkred/dump.txt',var_export($data_ar,TRUE));
			$result = array(
				'errors' => NULL
				,'client' => NULL
				,'vehicle' => NULL
				,'operator' => NULL
				,'concr_quant' => NULL
				,'concr_type' => NULL
				,'production_num' => NULL
				,'production_id' => NULL
				,'prod_date' => NULL
				,'time_start' => NULL
				,'time_end' => NULL
				,'materials' => array()
			);

			//0- not started, >0 started, -1 done
			$mat_tb_h_started = 0;
			$mat_cnt = 0;
			$time_cnt = 0;
			$time_tb_h_started = 0;
 			$mat_tb_done = FALSE;
 		
			foreach($data_ar as $line){
				if(is_null($result['client']) && mb_substr($line, 0, mb_strlen('Клиент:')) == 'Клиент:'){
					$client_ar = self::ammann_split_line($line);
					if(count($client_ar)>=2){
						$result['client'] = $client_ar[1];
					}		
					
				}else if(is_null($result['concr_quant']) && mb_substr($line, 0, mb_strlen('Изготовл. кол-во:')) == 'Изготовл. кол-во:'){
					$concr_quant_ar = self::ammann_split_line($line);
					if(count($concr_quant_ar)>=2){
						$result['concr_quant'] = floatval(self::get_val_before($concr_quant_ar[1], ' m'));
					}		
					
				}else if(is_null($result['operator']) && ($op_pos = mb_strpos($line, 'Оператор:'))!==FALSE ){
					$result['operator'] = trim(mb_substr($line, $op_pos + mb_strlen('Оператор:')));

				}else if(is_null($result['vehicle']) && ($op_pos = mb_strpos($line, 'Машина:'))!==FALSE ){
					//no region!
					$result['vehicle'] = mb_substr( trim(self::get_val_before(mb_substr($line, $op_pos + mb_strlen('Машина:')), ' (')), 0,6);
					
					
				}else if(is_null($result['concr_type']) && mb_substr($line, 0, mb_strlen('Рецепт:')) == 'Рецепт:'){
					$concr_type_ar = self::ammann_split_line($line);
					if(count($concr_type_ar)>=2){
						$result['concr_type'] = self::get_val_before($concr_type_ar[1],' (');
					}		

				}else if(is_null($result['production_num']) && mb_substr($line, 0, mb_strlen('Накладная №:')) == 'Накладная №:'){
					$production_num_ar = self::ammann_split_line($line);
					if(count($production_num_ar)>=2){
						$result['production_num'] = $production_num_ar[1];
					}
					if(count($production_num_ar)>=3){
						$result['production_id'] = $production_num_ar[2];
					}

				}else if(is_null($result['prod_date']) && mb_substr($line, 0, mb_strlen('Дата изготовления:')) == 'Дата изготовления:'){
					$prod_date_ar = self::ammann_split_line($line);
					if(count($prod_date_ar)>=2){
						$prod_date_part_ar = explode('.',$prod_date_ar[1]);
						if(count($prod_date_part_ar)>=3){
							$result['prod_date'] = $prod_date_part_ar[2].'-'.$prod_date_part_ar[1].'-'.$prod_date_part_ar[0];
						}
					}
				
				}else if($mat_tb_h_started==0 && mb_substr($line, 0, mb_strlen('Доля компонентов')) == 'Доля компонентов'){
					$mat_tb_h_started = 1;
					
				}else if(
				!$mat_tb_done &&
				(($mat_tb_h_started==1 && mb_substr($line, 0, mb_strlen('Наименование')) == 'Наименование')
				||($mat_tb_h_started>=2 && $mat_tb_h_started<4) )
				){
					$mat_tb_h_started++;
					
				}else if(!$mat_tb_done && $mat_tb_h_started==4){
					$mat_tb_h_started = -1;//done
					
				}else if(!$mat_tb_done && $mat_tb_h_started==-1 && mb_substr($line, 0, mb_strlen('Порции продукции')) == 'Порции продукции'){
					$time_tb_h_started = 1;
					$mat_tb_done = TRUE;

				}else if($time_tb_h_started==1 && ord(substr(trim($line), 0, 1)) >=49  && ord(substr(trim($line), 0, 1)) <=57 ){
					$prod_ar = self::ammann_split_line($line);
					if(count($prod_ar)>=2){
						if($time_cnt==0){
							$result['time_start'] = $prod_ar[1];
							//time in seconds
							$tm_s = intval(trim(str_replace(' s','',$prod_ar[3])));
							if($tm_s){
								$result['time_end'] = date('H:i:s', strtotime($result['time_start'])+$tm_s);
							}
							//throw new Exception('TIME='.$result['time_end']);
							
						}else if(!isset($result['time_end']) && strlen($prod_ar[1])==8){//time
							$result['time_end'] = $prod_ar[1];
						}
						$time_cnt++;
					}

				}else if($time_tb_h_started==1 && mb_substr($line, 0, mb_strlen('Итого')) == 'Итого'){
					//Done!
					break;

				}else if(!$mat_tb_done && $mat_tb_h_started==-1){
					$mat_cnt++;
					//material
					$m_data = self::ammann_split_line($line);
					if(!count($m_data)){
						//No $production_num!!!
						$result['errors'].= 'Производство '.$production_num.', строка материала '.$mat_cnt.'; ошибка разбора: '.$line.PHP_EOL;
						continue;
					}

					if(count($m_data)>=3){
					
						//выбрасываем скобки
						array_push($result['materials'], array(
							'descr' => self::get_val_before($m_data[0], ' (')
							,'quant' => floatval(str_replace(',','',$m_data[2]))
						));
						
					}else{
						$result['errors'].= 'Производство '.$production_num.', строка материала '.$mat_cnt.'; ошибка разбора количества: '.$line.PHP_EOL;
						continue;
					}
				}
				
			}
 		
 		}finally{
 			if(file_exists($out_file)){
	 			unlink($out_file);
	 		}
 		}
 	}
 	
	public static function uploadProductionFile(&$dbLinkMaster, $prodSiteId, $file, $interactive){
		$DEF_OPERATOR_USER_ID = 1; 
//throw new Exception('File='.$file);
		$result = NULL;
		$servLevel = self::LOG_LEVEL_ERROR;
		try{
		
			$ar_params = $dbLinkMaster->query_first(sprintf(
				"SELECT
					elkon_params AS prod_params
					,elkon_connection AS prod_connection
				FROM production_sites
				WHERE id=%d"
				,$prodSiteId
			));
			if(!is_array($ar_params) || !count($ar_params) || !isset($ar_params['prod_params'])){
				throw new Exception('production_sites params not found!');
			}
			$prod_params = json_decode($ar_params['prod_params']);
			if(!isset($prod_params->default_silo)){
				throw new Exception('default_silo param not found!');
				
			}else if(!isset($prod_params->default_silo->keys) || !isset($prod_params->default_silo->keys->id)){
				throw new Exception('default_silo unknown struct!');
			}
			//Our firm
			if(!isset($prod_params->ammann_client_descr)){
				throw new Exception('ammann_client_descr not found!');
			}
		
			$prod_connection = json_decode($ar_params['prod_connection']);
			if(!isset($prod_connection->logLevel)){
				throw new Exception('connection->logLevel param not found!');
				
			}
			$servLevel = $prod_connection->logLevel;

			self::log_action($dbLinkMaster, $prodSiteId, "Парсинг файла производства", self::LOG_LEVEL_DEBUG, $servLevel);
			self::parseProduction($file, $result);

			if($servLevel == self::LOG_LEVEL_DEBUG){
				$str = var_export($result,TRUE);
				$str = str_replace("'", '"', $str);
				self::log_action($dbLinkMaster, $prodSiteId, $str, self::LOG_LEVEL_DEBUG, $servLevel);
			}			

			if(isset($result['errors']) && strlen($result['errors'])){			
				throw new Exception($result['errors']);
			}
			
			if(!isset($result['client'])){
				throw new Exception('Не определен клиент.');
				
			}else if(!isset($result['concr_type'])){
				throw new Exception('Не определена марка бетона.');
				
			}else if(!isset($result['production_id'])){
				throw new Exception('Не определен идентификатор отгрузки.');

			}else if(!isset($result['prod_date'])){
				throw new Exception('Не определена дата производства.');				
			}
			
			if($result['client']!=$prod_params->ammann_client_descr){
				throw new Exception('Клиент не соответствует!');				
			}
			
			//***** Dates
			$production_dt_start = strtotime($result['prod_date']. (isset($result['time_start'])? 'T'.$result['time_start'] : '') );
			//10 minutes if empty!
			$prod_dur = 10*60;
			$production_dt_end = (isset($result['time_end']))? strtotime($result['prod_date'].  'T'.$result['time_end']) : $production_dt_start + $prod_dur;
			//empty time!
			//throw new Exception('DTEnd='.$result['prod_date'].  'T'.$result['time_end']);
			if($production_dt_start > $production_dt_end){
				$production_dt_end = $production_dt_start + $prod_dur;
			}
			//throw new Exception('DTEnd='.date('Y-m-d H:i:s',$production_dt_end));
			//***** Марка бетона идентификатор
			$ar = $dbLinkMaster->query_first(sprintf("SELECT material_fact_consumptions_add_concrete_type('%s') AS concrete_type_id",$result['concr_type']));
			$concrete_type_id = !isset($ar['concrete_type_id'])? 'NULL':$ar['concrete_type_id'];
			
			//!!Временно!!
			if(strlen($result['vehicle'])>5){
				$result['vehicle'] = mb_substr($result['vehicle'],1,3);
			}
//throw new Exception('client='.$result['client'].' '.$prod_params->ammann_client_descr);
			//Шапка производства
			self::log_action($dbLinkMaster, $prodSiteId, "Вставка шапки производства", self::LOG_LEVEL_DEBUG, $servLevel);
			$prod_head = $dbLinkMaster->query_first(sprintf(
				"INSERT INTO productions (
					production_id,
					production_dt_start,
					production_dt_end,
					dt_end_set,
					production_user,
					production_vehicle_descr,
					production_site_id,
					concrete_type_id,
					concrete_quant,
					production_concrete_type_descr				
				) VALUES (
					'%s',
					'%s',
					'%s',
					now(),
					'%s',
					'%s',
					%d,
					%s,
					%f,
					'%s'
				)
				ON CONFLICT (production_site_id, production_id) DO UPDATE SET
					production_dt_start = '%s',
					production_dt_end = '%s', 
					dt_end_set = now(),
					production_user = '%s',
					production_vehicle_descr = '%s',
					production_site_id = %d,
					concrete_type_id = %s,
					concrete_quant = %f,
					production_concrete_type_descr = '%s'
				RETURNING vehicle_id,vehicle_schedule_state_id"
				,$result['production_id']
				,date('Y-m-d H:i:s',$production_dt_start)
				,date('Y-m-d H:i:s',$production_dt_end)
				,$result['operator']
				,$result['vehicle']
				,$prodSiteId
				,$concrete_type_id
				,$result['concr_quant']
				,$result['concr_type']				
				
				,date('Y-m-d H:i:s',$production_dt_start)
				,date('Y-m-d H:i:s',$production_dt_end)
				,$result['operator']
				,$result['vehicle']
				,$prodSiteId
				,$concrete_type_id
				,$result['concr_quant']
				,$result['concr_type']			
			));
			
			//Clear materials
			$dbLinkMaster->query(sprintf(
				"DELETE FROM material_fact_consumptions
				WHERE production_site_id=%d AND production_id='%s'"
				,$prodSiteId
				,$result['production_id']
			));
			
			//материалы
			if(count($result['materials'])){
				$q_head = "INSERT INTO material_fact_consumptions
					(production_site_id,
					upload_date_time,
					upload_user_id,
					date_time,
					concrete_type_production_descr,
					concrete_type_id,
					raw_material_production_descr,
					raw_material_id,
					vehicle_production_descr,
					vehicle_id,
					vehicle_schedule_state_id,
					concrete_quant,
					material_quant,
					material_quant_req,
					cement_silo_id,
					production_id) VALUES ";
					
				$q_body = '';
				
				//operator user_id
				$ar = $dbLinkMaster->query_first(sprintf(
					"SELECT
						u_map.user_id
					FROM user_map_to_production AS u_map
					WHERE
						u_map.production_site_id=%d
					AND u_map.production_descr='%s'",
					$prodSiteId,
					$result['operator'],
				));										
				
				$material_attrs = [];
				foreach($result['materials'] as $material){
					
					$ar = $dbLinkMaster->query_first(sprintf(
					//throw new Exception(sprintf(
						"SELECT material_fact_consumptions_add_material(%d,'%s','%s') AS material_id",
						$prodSiteId,
						$material['descr'],
						date('Y-m-d H:i:s',$production_dt_end)
					));										
					$mat_id = !isset($ar['material_id'])? 'NULL':$ar['material_id'];
					$silo = 'NULL';
					if(isset($ar['material_id'])){
						if(!isset($material_attrs[$mat_id])){
							$ar_mat = $dbLinkMaster->query_first(sprintf(
								"SELECT
									is_cement
								FROM raw_materials
								WHERE id=%d",
								$mat_id
							));
							if(is_array($ar_mat) && isset($ar_mat)){
								$material_attrs[$mat_id] = array(
									'is_cement' => ($ar_mat['is_cement']=='t')
								);
							}
						}
						if($material_attrs[$mat_id]['is_cement']){
							$silo = $prod_params->default_silo->keys->id;
						}
					}
					
					$q_body.= ($q_body=='')? '':',';
					$q_body.= sprintf(
						"(%d,
						now(),
						%d,
						'%s',
						'%s',
						%d,
						'%s',
						%s,
						'%s',
						%s,
						%s,
						%f,
						%f,
						%f,
						%s,
						'%s')",
					$prodSiteId,
					isset($_SESSION)&&isset($_SESSION['user_id'])? $_SESSION['user_id']:1,
					date('Y-m-d H:i:s',$production_dt_end),
					$result['concr_type'],
					$concrete_type_id,
					$material['descr'],
					$mat_id,
					$result['vehicle'],
					isset($prod_head['vehicle_id'])? $prod_head['vehicle_id']:'NULL',
					isset($prod_head['vehicle_schedule_state_id'])? $prod_head['vehicle_schedule_state_id']:'NULL',
					$result['concr_quant'],
					floatval($material['quant'])/1000,
					floatval($material['quant'])/1000,
					$silo,
					$result['production_id']
					);
					
				}
				
				if(strlen($q_body)){
					//file_put_contents('/home/andrey/www/htdocs/beton_new/build/Konkred/q.sql',$q_head.$q_body);	
					//throw new Exception($q_head.$q_body);
					self::log_action($dbLinkMaster, $prodSiteId, "Вставка строк по материалам: ", self::LOG_LEVEL_DEBUG, $servLevel);
					//self::log_action($dbLinkMaster, $prodSiteId, $q_head.$q_body, self::LOG_LEVEL_DEBUG, $servLevel);
					$dbLinkMaster->query($q_head.$q_body);
				}
			}			
			
		}catch(Exception $e){
		
			//&& $servLevel == self::LOG_LEVEL_DEBUG 
			if(isset($servLevel) && isset($file) && file_exists($file)
			&& isset($result) && isset($result['client']) && isset($prod_params)
			&& ($result['client']==$prod_params->ammann_client_descr)
			){
				//save file
				$dir = dirname(__FILE__).'/../output/productions';
				if(!file_exists($dir)){
					mkdir($dir);
				}
				$deb_file_name = (isset($result['production_id']))? $result['production_id']:uniqid();
				copy($file, $dir.'/'.$deb_file_name.'.pdf'); 
			}						
		
			if($interactive){
				throw new Exception($e->getMessage());
			}
						
			//log
			self::log_action($dbLinkMaster, $prodSiteId, $e->getMessage(), self::LOG_LEVEL_ERROR, $servLevel);
			/*
			$dbLinkMaster->query(sprintf(
			 	"SELECT elkon_log_upsert((NULL,now(),%d,'%s',%d)::elkon_log)",
			 	$prodSiteId,
			 	,
			 	0
			));*/
		}
			
	}
 	
}
?>
