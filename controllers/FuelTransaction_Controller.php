<?php
require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtPassword.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInterval.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtArray.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBytea.php');

/**
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */


class FuelTransaction_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			$param = new FieldExtText('transaction_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtDateTime('date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtText('card_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtJSON('attrs'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('quant'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtFloat('total'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('FuelTransaction.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('FuelTransaction_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('transaction_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTime('date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('card_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtJSON('attrs'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('quant'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtFloat('total'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('id',array(
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['id'
				]
			];
			$pm->addEvent('FuelTransaction.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('FuelTransaction_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('id'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('FuelTransaction.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('FuelTransaction_Model');

			
		/* get_list */
		$pm = new PublicMethod('get_list');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);
		
		$this->setListModelId('FuelTransactionList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('FuelTransactionList_Model');		

			
		$pm = new PublicMethod('import_data');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('file_excel',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	public function import_data($pm){
		if(
			!isset($_FILES["file_excel"]["tmp_name"])
			|| !is_array($_FILES["file_excel"]["tmp_name"])
			|| $_FILES["file_excel"]["error"][0] !== UPLOAD_ERR_OK
		){
			throw new Exception("Файл не найден или ошибка загрузки");
		}

		$tmp_name = $_FILES["file_excel"]["tmp_name"][0];
		$user_name = $_FILES["file_excel"]["name"][0];

		// Validate file extension
		$allowed_extensions = ['xls', 'xlsx'];
		$file_ext = strtolower(pathinfo($user_name, PATHINFO_EXTENSION));

		if(!in_array($file_ext, $allowed_extensions)){
			throw new Exception("Неподдерживаемый формат файла");
		}

		$csv_name = OUTPUT_PATH . uniqid('fuel_import_', true) . ".csv";

		$cmd = sprintf(
			"ssconvert %s %s",
			escapeshellarg($tmp_name),
			escapeshellarg($csv_name)
		);

		$output = [];
		$return_var = NULL;

		exec($cmd, $output, $return_var);

		if($return_var !== 0 || !file_exists($csv_name)){
			@unlink($csv_name);
			throw new Exception("Ошибка конвертирования файла");
		}

		try {
			$handle = fopen($csv_name, "r");

			if($handle === FALSE){
				throw new Exception("Ошибка открытия CSV файла");
			}

			$cols = [
				"ID" => 0,
				"DATE" => 1,
				"CARD_ID" => 2,
				"FIO" => 3,
				"AZS" => 4,
				"SUPPLIER" => 6,
				"PLACE" => 9,
				"ITEM" => 10,
				"QUANT" => 11,
				"OPER" => 12,
				"CUR" => 13,
				"TOTAL" => 19
			];

			$queries = [];
			$row = 0;

			while(($data = fgetcsv($handle, 10000, ",")) !== FALSE){
				$row++;

				// Skip header
				if($row === 1){
					continue;
				}

				$vals = [];

				foreach($cols as $col_id => $col_ind){
					$vals[$col_id] = isset($data[$col_ind])
						? trim($data[$col_ind])
						: null;
				}

				/*
				 * Skip completely empty rows.
				 *
				 * This must be done before checking required fields because
				 * Excel/ssconvert may produce trailing empty CSV rows.
				 */
				$is_empty_row = true;

				foreach($vals as $value){
					if($value !== null && $value !== ''){
						$is_empty_row = false;
						break;
					}
				}

				if($is_empty_row){
					continue;
				}

				// Skip footer
				if($vals["ID"] === "Итого:"){
					continue;
				}

				/*
				 * Validate required fields.
				 *
				 * Do not use empty() here because values such as "0"
				 * are considered empty by PHP.
				 */
				$missing_fields = [];

				if($vals["ID"] === null || $vals["ID"] === ''){
					$missing_fields[] = "Идентификатор";
				}

				if($vals["DATE"] === null || $vals["DATE"] === ''){
					$missing_fields[] = "Период";
				}

				if($vals["CARD_ID"] === null || $vals["CARD_ID"] === ''){
					$missing_fields[] = "Номер карты";
				}

				if(count($missing_fields) > 0){
					throw new Exception(
						sprintf(
							"Строка %d: не заполнены обязательные поля: %s",
							$row,
							implode(", ", $missing_fields)
						)
					);
				}

				$attrs = [
					'fio' => $vals['FIO'] ?? '',
					'azs' => $vals['AZS'] ?? '',
					'supplier' => $vals['SUPPLIER'] ?? '',
					'place' => $vals['PLACE'] ?? '',
					'item' => $vals['ITEM'] ?? '',
					'oper' => $vals['OPER'] ?? '',
					'cur' => $vals['CUR'] ?? ''
				];

				// Convert date to PostgreSQL-compatible format
				$date_obj = DateTime::createFromFormat(
					'd.m.Y H:i:s',
					$vals["DATE"]
				);

				if($date_obj === false){
					throw new Exception(
						sprintf(
							"Строка %d: неверный формат даты \"%s\"",
							$row,
							$vals["DATE"]
						)
					);
				}

				$date = $date_obj->format('Y-m-d H:i:s');

				$queries[] = [
					'transaction_id' => $vals["ID"],
					'date' => $date,
					'card_id' => $vals["CARD_ID"],
					'attrs' => json_encode(
						$attrs,
						JSON_UNESCAPED_UNICODE
					),
					'quant' => floatval(
						str_replace(
							',',
							'.',
							$vals["QUANT"] ?? 0
						)
					),
					'total' => floatval(
						str_replace(
							',',
							'.',
							$vals["TOTAL"] ?? 0
						)
					)
				];
			}

			fclose($handle);
			$handle = null;

			@unlink($csv_name);

			/*
			 * Database insertion.
			 */
			$link = $this->getDbLinkMaster();
			$link->query("BEGIN");

			try {
				foreach($queries as $params){
					/*
					 * Resolve vehicle before inserting the transaction.
					 *
					 * LIMIT 2 is enough because we only need to distinguish:
					 * 0 vehicles
					 * 1 vehicle
					 * more than 1 vehicle
					 */
					$vehicle_res = $link->query(
						"SELECT id
						FROM vehicles
						WHERE fuel_card_id = $1
						ORDER BY id
						LIMIT 2",
						[
							$params['card_id']
						]
					);

					$vehicle_count = pg_num_rows($vehicle_res);

					if($vehicle_count > 1){
						throw new Exception(
							sprintf(
								"Для топливной карты %s найдено более одного автомобиля",
								$params['card_id']
							)
						);
					}

					$vehicle_id = null;

					if($vehicle_count === 1){
						$vehicle_row = pg_fetch_assoc($vehicle_res);
						$vehicle_id = (int)$vehicle_row['id'];
					}

					$insert_params = [
						$params['transaction_id'],
						$params['date'],
						$params['card_id'],
						$vehicle_id,
						$params['attrs'],
						$params['quant'],
						$params['total']
					];

					$link->query(
						"INSERT INTO fuel_transactions (
							transaction_id,
							date_time,
							card_id,
							vehicle_id,
							attrs,
							quant,
							total
						)
						VALUES (
							$1,
							$2,
							$3,
							$4,
							$5,
							$6,
							$7
						)
						ON CONFLICT (transaction_id) DO UPDATE SET
							date_time = EXCLUDED.date_time,
							card_id = EXCLUDED.card_id,
							vehicle_id = EXCLUDED.vehicle_id,
							attrs = EXCLUDED.attrs,
							quant = EXCLUDED.quant,
							total = EXCLUDED.total",
						$insert_params
					);
				}

				$link->query("COMMIT");
			} catch(Exception $e){
				$link->query("ROLLBACK");

				throw new Exception(
					"Ошибка записи в БД: " . $e->getMessage(),
					0,
					$e
				);
			}
		} catch(Exception $e){
			if(isset($handle) && is_resource($handle)){
				fclose($handle);
			}

			if(file_exists($csv_name)){
				@unlink($csv_name);
			}

			throw $e;
		}
	}

}
?>
