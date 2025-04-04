<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class ExcelTemplateDialog_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("excel_templates_dialog");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='Описание шаблона';
		$f_opts['id']="name";
						
		$f_name=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field file_info ***
		$f_opts = array();
		$f_opts['id']="file_info";
						
		$f_file_info=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"file_info",$f_opts);
		$this->addField($f_file_info);
		//********************
		
		//*** Field sql_query ***
		$f_opts = array();
		$f_opts['id']="sql_query";
						
		$f_sql_query=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sql_query",$f_opts);
		$this->addField($f_sql_query);
		//********************
		
		//*** Field image_sql ***
		$f_opts = array();
		$f_opts['id']="image_sql";
						
		$f_image_sql=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"image_sql",$f_opts);
		$this->addField($f_image_sql);
		//********************
		
		//*** Field cell_matching ***
		$f_opts = array();
		$f_opts['id']="cell_matching";
						
		$f_cell_matching=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"cell_matching",$f_opts);
		$this->addField($f_cell_matching);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
