<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ExcelTemplate'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

use PhpOffice\PhpSpreadsheet\IOFactory;
use PhpOffice\PhpSpreadsheet\Worksheet\Drawing;
use PhpOffice\PhpSpreadsheet\Worksheet\MemoryDrawing;

require_once('common/downloader.php');

require_once(USER_CONTROLLERS_PATH.'Attachment_Controller.php');

set_time_limit(300);
ini_set('memory_limit', '-1');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	private function upload_file($pm){
		if (
		(isset($_FILES['excel_file']) &amp;&amp; is_array($_FILES['excel_file']['name']) &amp;&amp; count($_FILES['excel_file']['name']))
		){
			$pm->setParamValue('file_content', pg_escape_bytea($this->getDbLink()->link_id,file_get_contents($_FILES['excel_file']['tmp_name'][0])) );
			$pm->setParamValue('file_info',
				sprintf('{"name":"%s","id":"1","size":"%s"}',
				$_FILES['excel_file']['name'][0],
				filesize($_FILES['excel_file']['tmp_name'][0])
				)
			);			
		}
	}

	public function insert($pm){
		$this->upload_file($pm);
		parent::insert($pm);
	}

	public function update($pm){
		$this->upload_file($pm);
		$tmpl_id = $this->getExtDbVal($pm, 'old_id');
		self::delete_template_file_on_id($this->getDbLink(), $tmpl_id);
		$pm->setParamValue("update_dt", date("Y-m-d H:i:s", time()));
		parent::update($pm);
	}

	public function delete($pm){
		$tmpl_id = $this->getExtDbVal($pm, 'id');
		self::delete_template_file_on_id($this->getDbLink(), $tmpl_id);
		parent::delete($pm);
	}
	
	private static function delete_template_file_on_id($dbLink, $templateID){
		$ar = $dbLink->query_first(sprintf(
			"SELECT
				file_info->>'name' as file_name,
				reverse(substring(reverse(file_info->>'name') from 1 for strpos(reverse(file_info->>'name'),'.')-1)) AS file_ext,
				update_dt
			FROM excel_templates	
			WHERE id = %d"
			,$templateID
		));
		if(is_array($ar) &amp;&amp; isset($ar['file_name'])){
			$tmpl_fl = self::get_template_file_name($templateID, $ar['file_ext'], $ar['update_dt']);
			if(file_exists($tmpl_fl)){
				unlink($tmpl_fl);
			}
		}
	}

	//deletes excel template
	public function delete_excel_file($pm){
		$this->getDbLinkMaster()->query(sprintf(
			"UPDATE excel_templates
			SET
				file_content=NULL,
				file_info=NULL
			WHERE id=%d"
			,$this->getExtDbVal($pm, 'excel_template_id')
		));
	}

	//downloads excel template
	public function download_excel_file($pm){
		$ar = $this->getDbLink()->query_first(sprintf(
			"SELECT
				file_info,
				file_content
			FROM excel_templates
			WHERE id=%d"
			,$this->getExtDbVal($pm, 'excel_template_id')
		));
		
		if(!is_array($ar) || !count($ar)){
			throw new Exception('Файл не найден!');
		}

		$fl = OUTPUT_PATH.uniqid();
		file_put_contents($fl, pg_unescape_bytea($ar['file_content']));
		try{
			$fl_n = json_decode($ar['file_info'])->name;
			$fl_mime = getMimeTypeOnExt($fl_n);
			ob_clean();
			downloadFile(
				$fl,
				$fl_mime,
				'attachment;',
				$fl_n
			);
		}finally{
			unlink($fl);
		}
		return TRUE;
	}

	//deprecated, do not use. Use new function instead.
	public static function downloadFilledTemplate_old($dbLink, $templateName, $paramArray, $erEmpty, $fileName){
		require_once(ABSOLUTE_PATH.'vendor/autoload.php');
		
		$ar = $dbLink->query_first(sprintf(
		"SELECT
			file_info,
			file_content,
			sql_query,
			cell_matching->'rows' AS cell_matching
		FROM excel_templates	
		WHERE name = '%s'",
		$templateName
		));
		
		if(!is_array($ar) || !isset($ar['file_content'])){
			throw new Exception('Шаблон не найден!');
		}
		
		if(!isset($ar['sql_query'])){
			throw new Exception('Запрос не определен!');
		}
		if(!isset($ar['cell_matching'])){
			throw new Exception('Соответствия полей не определены!');
		}
		
		$tmpl_fl = OUTPUT_PATH.uniqid();
		file_put_contents($tmpl_fl, pg_unescape_bytea($ar['file_content']));
		$out_fl = OUTPUT_PATH.uniqid();
		try{

			$ar_data = $dbLink->query_first(vsprintf($ar['sql_query'],$paramArray));
			
			if(!is_array($ar_data) || !count($ar_data)){
				throw new Exception($erEmpty);
			}
			
			$fl_info = json_decode($ar['file_info']);
			if(!isset($fl_info->name)){
				throw new Exception('Не определено имя шаблона');
			}
			$fl_name_parts = explode('.', $fl_info->name);
			if(count($fl_name_parts)==0){
				throw new Exception('Не определено имя шаблона');
			}
			$ext = strtolower($fl_name_parts[count($fl_name_parts)-1]);
			if($ext == 'xlsx'){
				$reader_tp = 'Xlsx';
			}else if($ext == 'xls'){
				$reader_tp = 'Xls';
			}
			if(!isset($reader_tp)){
				throw new Exception(sprintf("Не определен тип файла шаблона '%s'!", $ext));
			}
			
			$reader = \PhpOffice\PhpSpreadsheet\IOFactory::createReader($reader_tp);
			$spreadsheet = $reader->load($tmpl_fl);
			$sheet = $spreadsheet->getActiveSheet();
			
			//замены
			$cell_matching = json_decode($ar['cell_matching']);
			foreach($cell_matching as $match){
				if(isset($match->fields)){
					$fields = $match->fields;
				}else{
					$fields = $match;
				}
				
				if(isset($fields->field) &amp;&amp; isset($fields->cell) &amp;&amp; isset($ar_data[$fields->field])){
					$sheet->setCellValue($fields->cell, $ar_data[$fields->field]);
				}
			}
						
			$writer = new PhpOffice\PhpSpreadsheet\Writer\Xlsx($spreadsheet);
			$writer->save($out_fl);
			$fl_mime = getMimeTypeOnExt($fl_info->name);
			ob_clean();
			downloadFile(
				$out_fl,
				$fl_mime,
				'attachment;',
				$fl_info->name
			);
			return TRUE;
			
		}finally{
			unlink($tmpl_fl);
			if(file_exists($out_fl)){
				unlink($out_fl);
			}
		}
	}

	private static function get_template_file_name($templateID, $fileExt, $updateDate){
		return OUTPUT_PATH. md5('excel_tmpl_'. $templateID.'.'.$updateDate. $fileExt);
	}

	//generates template, populates with data. 
	public static function genFilledTemplate($dbLink, $templateName, $paramArray, $erEmpty, &amp;$outFl, &amp;$flName){
	
		require_once(ABSOLUTE_PATH.'vendor/autoload.php');
		
		$ar = $dbLink->query_first(sprintf(
		"SELECT
			id,
			file_info->>'name' as file_name,
			reverse(substring(reverse(file_info->>'name') from 1 for strpos(reverse(file_info->>'name'),'.')-1)) AS file_ext,
			sql_query,
			cell_matching->'rows' AS cell_matching,
			image_sql->'rows' AS image_sql,
			update_dt
			FROM excel_templates	
		WHERE name = '%s'",
		$templateName
		));
		
		if(!is_array($ar) || !isset($ar['file_name'])){
			throw new Exception('Шаблон не найден!');
		}
		
		if(!isset($ar['sql_query'])){
			throw new Exception('Запрос не определен!');
		}
		if(!isset($ar['cell_matching'])){
			throw new Exception('Соответствия полей не определены!');
		}

		$outFl = OUTPUT_PATH.uniqid();
		$ar_data = $dbLink->query_first(vsprintf($ar['sql_query'],$paramArray));
	
		if(!is_array($ar_data) || !count($ar_data)){
			throw new Exception($erEmpty);
		}
		
		$ext = strtolower($ar['file_ext']);
		if($ext == 'xlsx'){
			$reader_tp = 'Xlsx';
		}else if($ext == 'xls'){
			$reader_tp = 'Xls';
		}
		if(!isset($reader_tp)){
			throw new Exception(sprintf("Не определен тип файла шаблона '%s'!", $ext));
		}

		$tmpl_fl = self::get_template_file_name($ar['id'], $ext, $ar['update_dt']);
		if(!file_exists($tmpl_fl)){
			//get content from database
			$ar_cont = $dbLink->query_first(sprintf(
				"SELECT
					file_content
				FROM excel_templates	
				WHERE id = %d",
				$ar["id"]
			));
			if(!is_array($ar_cont) || !count($ar_cont) || !isset($ar_cont['file_content'])){
				throw new Exception("file content query failed");

			}
			file_put_contents($tmpl_fl, pg_unescape_bytea($ar_cont['file_content']));
		}		

		$attachments = []; //images to be changes

		//generate images for image_sql
		$query_results = [];
		if(isset($ar['image_sql'])){
			$image_sql = json_decode($ar['image_sql']);
			foreach($image_sql as $image){
				if(isset($image->fields)){
					$fields = $image->fields;
				}else{
					$fields = $image;
				}
				
				if(isset($fields->sql_query) &amp;&amp; isset($fields->name) ){
					if(!array_key_exists($fields->sql_query, $query_results)){
						$q = vsprintf($fields->sql_query,$paramArray);
						$ar_att = $dbLink->query_first($q);
						if(!is_array($ar_att) || !count($ar_att) || !isset($ar_att['attachment_id'])){
							throw new Exception("Не найден файл вложения для '".
								(isset($fields->comment_text)? $fields->comment_text : $fields->name) .
								"'"
							);
						}
						$attFile = Attachment_Controller::save_to_tmp($dbLink, $ar_att["attachment_id"]);
						$query_results[$fields->sql_query] = $attFile;
					}
					array_push($attachments, array(
						'coord' => $fields->name,
						'w' => $fields->w,
						'h' => $fields->h,
						'offset_y' => $fields->offset_y,
						'offset_x' => $fields->offset_x,
						'fileName' => $query_results[$fields->sql_query]
					));
				}
			}
		}
		<!-- file_put_contents(OUTPUT_PATH.'att.txt',var_export($attachments, true)); -->

		$reader = \PhpOffice\PhpSpreadsheet\IOFactory::createReader($reader_tp);
		$spreadsheet = $reader->load($tmpl_fl);
		$sheet = $spreadsheet->getActiveSheet();
		
		//замены
		$cell_matching = json_decode($ar['cell_matching']);
		foreach($cell_matching as $match){
			if(isset($match->fields)){
				$fields = $match->fields;
			}else{
				$fields = $match;
			}
			
			if(isset($fields->field) &amp;&amp; isset($fields->cell) &amp;&amp; isset($ar_data[$fields->field])){
				$sheet->setCellValue($fields->cell, $ar_data[$fields->field]);
			}
		}

		//image changes
		foreach($attachments as $att){
			/* self::replaceImageByName($sheet, $att); */
			$y = isset($att["offset_y"])? intval($att["offset_y"]) : 0;
			$x = isset($att["offset_x"])? intval($att["offset_x"]) : 0;
			$newDrawing = new Drawing();
			$newDrawing->setPath($att["fileName"]);
			$newDrawing->setHeight($att["h"]);
			$newDrawing->setWidth($att["w"]);
			$newDrawing->setOffsetY($y);
			$newDrawing->setOffsetX($x);
			$newDrawing->setCoordinates($att["coord"]);
			$newDrawing->setWorksheet($sheet);
		}
					
		$writer = new PhpOffice\PhpSpreadsheet\Writer\Xlsx($spreadsheet);
		$writer->save($outFl);
		
		$flName = $ar["file_name"]; 
	}

	<!-- private static function replaceImageByName($sheet, $imageNameToReplace, $newImagePath) { -->
	<!-- 	$drawings = $sheet->getDrawingCollection(); -->
	<!---->
	<!-- 	$found = false; -->
	<!-- 	$cnt = 0; -->
	<!-- 	foreach ($drawings as $key => $drawing) { -->
	<!-- 		// Check if it's a regular Drawing and name matches -->
	<!-- 		if ( -->
	<!-- 				$drawing->getCoordinates() == $imageNameToReplace -->
	<!-- 		) { -->
	<!-- 			// Create a new Drawing -->
	<!-- 			$newDrawing = new Drawing(); -->
	<!-- 			$newDrawing->setName($drawing->getName()); -->
	<!-- 			$newDrawing->setDescription($drawing->getDescription()); -->
	<!-- 			$newDrawing->setPath($newImagePath); -->
	<!-- 			$newDrawing->setHeight($drawing->getHeight()); -->
	<!-- 			$newDrawing->setCoordinates($drawing->getCoordinates()); -->
	<!-- 			$newDrawing->setWorksheet($sheet); -->
	<!---->
	<!-- 			// Remove the old drawing by unsetting -->
	<!-- 			$found = true; -->
	<!-- 			unset($drawings[$key]); -->
	<!-- 			break; // assuming names are unique -->
	<!-- 		} -->
	<!-- 		$cnt++; -->
	<!-- 	} -->
	<!-- 	if(!$found){ -->
	<!-- 		throw new Exception("image not found by getCoordinates() ".$imageNameToReplace." count:".$cnt); -->
	<!-- 	} -->
	<!-- } -->

	//downloads template as docx, xlsx.
	public static function downloadFilledTemplate($dbLink, $templateName, $paramArray, $erEmpty, $fileName){
		$out_fl = '';
		$fl_name = '';
		self::genFilledTemplate($dbLink, $templateName, $paramArray, $erEmpty, $out_fl, $fl_name);		
		$fl_name_parts = pathinfo($fl_name,  PATHINFO_EXTENSION);
		$fl_ext = '';
		if(is_array($fl_name_parts) &amp;&amp; isset($fl_name_parts['extension'])){
			$fl_ext = $fl_name_parts['extension'];
		}else if (gettype($fl_name_parts) == "string"){
			$fl_ext = $fl_name_parts;
		}
		if(!strlen($fl_ext)){
			$fl_ext = '.xlsx';
		}else if($fl_ext[0] != '.'){
			$fl_ext = '.'.$fl_ext;
		}
		try{
			$fl_mime = getMimeTypeOnExt($fl_name);
			ob_clean();
			downloadFile(
				$out_fl,
				$fl_mime,
				'attachment;',
				$fileName. $fl_ext
			);
			
			return TRUE;
		}finally{
			if(file_exists($out_fl)){
				unlink($out_fl);
			}
		}
	}

	public static function downloadFilledTemplateAsPDF($dbLink, $templateName, $paramArray, $erEmpty, $fileName){
		$out_fl = NULL;
		$fl_name = NULL;
		$out_fl_pdf = NULL;
		try{
			self::genFilledTemplate($dbLink, $templateName, $paramArray, $erEmpty, $out_fl, $fl_name);
			
			//convert to pdf
			//$out_fl_pdf = OUTPUT_PATH . uniqid().'.pdf';
			$out_fl_pdf = OUTPUT_PATH . basename($out_fl).'.pdf';
			$cmd = sprintf('soffice --headless --convert-to pdf:writer_pdf_Export --outdir %s %s', substr(OUTPUT_PATH, 0, strlen(OUTPUT_PATH)-1), $out_fl);
			$output = NULL;
			$retval = NULL;		
			$res = exec($cmd, $output, $retval);
			if($res === FALSE || $retval != 0){
				$er = "Ошибка конвертации в PDF: ".( (is_null($output)||!(is_array($output))||!count($output))? 'неизвестная ошибка, код:'.$retval : implode($output) );
				throw new Exception($er);
			}
			if(!file_exists($out_fl_pdf)){
				throw new Exception("Ошибка конвертации в PDF: файл не найден");
			}
			
			$fl_mime = getMimeTypeOnExt($out_fl_pdf);
			ob_clean();
			downloadFile(
				$out_fl_pdf,
				$fl_mime,
				'inline;',
				$fileName
			);
			
			return TRUE;
		}finally{
			if(!is_null($out_fl) &amp;&amp; file_exists($out_fl)){
				unlink($out_fl);
			}
			if(!is_null($out_fl_pdf) &amp;&amp; file_exists($out_fl_pdf)){
				unlink($out_fl_pdf);
			}
		}

	}
	

</xsl:template>

</xsl:stylesheet>
