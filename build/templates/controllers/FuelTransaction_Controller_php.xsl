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
		if(!isset($_FILES["file_excel"]) ||
		!isset($_FILES["file_excel"]["tmp_name"])
		){
			throw new Exception("Файл не найден");
		}

		if(is_array($_FILES["file_excel"]["tmp_name"])){
			$tmp_name = $_FILES["file_excel"]["tmp_name"][0];
			$name = basename($_FILES["file_excel"]["tmp_name"][0]);
			$user_name = $_FILES["file_excel"]["name"][0];
		}else{	
			$tmp_name = $_FILES["file_excel"]["tmp_name"];
			$name = basename($_FILES["file_excel"]["tmp_name"]);
			$user_name = $_FILES["file_excel"]["name"];
		}

		$csv_name = OUTPUT_PATH.uniqid().".csv";
		$cmd = sprintf("ssconvert %s %s", $tmp_name, $csv_name);
		$output = [];
		$return_var;
		exec($cmd, $output, $return_var);
		if ($return_var !== 0) {
			throw new Exception("Ошибка конвертирования файла: ".implode("\n", $output));
		}

		if(!file_exists($csv_name)){
		}
		$handle = fopen($csv_name, "r");
		if($handle!==TRUE){
			throw new Exception("Ошибка открытия файла csv");
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
		while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
			if($row == 0){
				continue; //header
			}

			$vals = [];
			foreach($cols as $col_id => $col_ind){
				if(count($data) &lt; $col_ind){
					$vals[$col_id] = $data[$col];
				}
			}

			//extra attrs json
			$attrs = array(
				'fio' => $vals['FIO'],
				'azs' => $vals['AZS'],
				'supplier' => $vals['SUPPLIER'],
				'item' => $vals['ITEM'],
				'oper' => $vals['OPER']
			);

			$q = ($rows &gt; 1)? ",":"" .sprintf("
			INSESRT INTO id, date_time, vehicle_id, attrs, quant, total
			VALUES
				('%s', '%s', 
				(SELECT vh.id FROM vehicles AS vh WHERE vh.cart_id = '%s'),
				'%s',
				%d, %f) ON CONFLICT (id) DO UPDATE SET
					vehicle_id = EXCLUDED.vehicle_id,
					attrs = EXCLUDED.attrs,
					quant = EXCLUDED.quant,
					total = EXCLUDED.total", 

				$vals["ID"]
				,$vals["DATE"]
				,$vals["CARD_ID"]
				,json_encode($attrs)
				,intval($vals["QUANT"])
				,floatval($vals["TOTAL"])
			);
			array_push($queries, $q);

			$row++;
		}
		fclose($handle);
		<!-- move_uploaded_file($tmp_name, $uniq_name); -->

		$link = $this->getDbLinkMaster();
		$link->query("BEGIN");
		try{
			foreach($queries as $q){
				$link->query($q);
			}
		}catch(Exception $e){
			$link->query("ROLLBACK");
			throw $e;
		}
	}

</xsl:template>

</xsl:stylesheet>
