<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'FuelTransaction'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">

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
					if($value !== null &amp;&amp; $value !== ''){
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
			if(isset($handle) &amp;&amp; is_resource($handle)){
				fclose($handle);
			}

			if(file_exists($csv_name)){
				@unlink($csv_name);
			}

			throw $e;
		}
	}

</xsl:template>

</xsl:stylesheet>
