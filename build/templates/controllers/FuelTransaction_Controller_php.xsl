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
		if(!isset($_FILES["file_excel"]["tmp_name"]) || 
		!is_array($_FILES["file_excel"]["tmp_name"]) ||
		$_FILES["file_excel"]["error"][0] !== UPLOAD_ERR_OK){
			throw new Exception("Файл не найден или ошибка загрузки");
		}
		$tmp_name = $_FILES["file_excel"]["tmp_name"][0];
		$user_name = $_FILES["file_excel"]["name"][0];
		
		// 3. Validate file extension
		$allowed_extensions = ['xls', 'xlsx'];
		$file_ext = strtolower(pathinfo($user_name, PATHINFO_EXTENSION));
		if(!in_array($file_ext, $allowed_extensions)){
			throw new Exception("Неподдерживаемый формат файла");
		}

		$csv_name = OUTPUT_PATH . uniqid('fuel_import_', true) . ".csv";

		$cmd = sprintf("ssconvert %s %s", 
			escapeshellarg($tmp_name), 
			escapeshellarg($csv_name)
		);

		/* throw new Exception($cmd); */
		$output = [];
		$return_var = NULL;
		exec($cmd, $output, $return_var);

		if ($return_var !== 0 || !file_exists($csv_name)) {
			@unlink($csv_name); // Clean up
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
			
			while (($data = fgetcsv($handle, 10000, ",")) !== FALSE) {
				if($row == 0){
					$row++;
					continue; // Skip header
				}

				$vals = [];
				foreach($cols as $col_id => $col_ind){
					$vals[$col_id] = isset($data[$col_ind]) ? trim($data[$col_ind]) : null;
				}

				if($vals["ID"] == "Итого:"){
					continue; //footer
				}
				/* file_put_contents(OUTPUT_PATH.'fuel.txt', var_export($vals, true)); */

				// Validate required fields
				if(empty($vals["ID"]) || empty($vals["DATE"]) || empty($vals["CARD_ID"])){
					throw new Exception("Не заполнены обязательные поля: Идентификатор, Период, Номер карты");
				}

				// Prepare data
				$attrs = [
					'fio' => $vals['FIO'] ?? '',
					'azs' => $vals['AZS'] ?? '',
					'supplier' => $vals['SUPPLIER'] ?? '',
					'item' => $vals['ITEM'] ?? '',
					'oper' => $vals['OPER'] ?? ''
				];

				//convert date to a compatible format
				$date_obj = DateTime::createFromFormat('d.m.Y H:i:s', $vals["DATE"]);
				if ($date_obj !== false) {
					$vals["DATE"] = $date_obj->format('Y-m-d H:i:s');
				} else {
					// Handle invalid date - log error or use default
					throw new Exception("failed to convert date to a database compatible format");
				}

				// Use prepared statement parameters
				$queries[] = [
					'id' => $vals["ID"],
					'date' => $vals["DATE"],
					'card_id' => $vals["CARD_ID"] ?? '',
					'attrs' => json_encode($attrs, JSON_UNESCAPED_UNICODE),
					'quant' => floatval(str_replace(',', '.', $vals["QUANT"] ?? 0)),
					'total' => floatval(str_replace(',', '.', $vals["TOTAL"] ?? 0))
				];
				
				$row++;
			}
			fclose($handle);
			
			@unlink($csv_name);
/* file_put_contents(OUTPUT_PATH.'fuel.txt', var_export($queries, true)); */
			// Database insertion with prepared statements
			$link = $this->getDbLinkMaster();
			$link->query("BEGIN");
			
			try {
				foreach($queries as $params){
					/* file_put_contents(OUTPUT_PATH.'fuel.txt', var_export($params, true).PHP_EOL.PHP_EOL, FILE_APPEND); */
					$link->query(
						"INSERT INTO fuel_transactions 
						(id, date_time, card_id, vehicle_id, attrs, quant, total)
						VALUES ($1, $2, $3,
							(SELECT vh.id FROM vehicles AS vh WHERE vh.fuel_card_id = $3),
							$4, $5, $6)
						ON CONFLICT (id) DO UPDATE SET
							card_id = EXCLUDED.card_id,
							vehicle_id = EXCLUDED.vehicle_id,
							attrs = EXCLUDED.attrs,
							quant = EXCLUDED.quant,
							total = EXCLUDED.total",
						$params
					);
				}
				
				$link->query("COMMIT");
				
			} catch(Exception $e){
				$link->query("ROLLBACK");
				throw new Exception("Ошибка записи в БД: " . $e->getMessage());
			}
			
		} catch(Exception $e){
			// Clean up on any error
			if(file_exists($csv_name)) @unlink($csv_name);
			throw $e;
		}
	}

</xsl:template>

</xsl:stylesheet>
