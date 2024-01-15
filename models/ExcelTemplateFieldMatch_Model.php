<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
 
class ExcelTemplateFieldMatch_Model extends {
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field field ***
		$f_opts = array();
		$f_opts['length']=100;
		$f_opts['id']="field";
						
		$f_field=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"field",$f_opts);
		$this->addField($f_field);
		//********************
		
		//*** Field cell ***
		$f_opts = array();
		$f_opts['length']=20;
		$f_opts['id']="cell";
						
		$f_cell=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"cell",$f_opts);
		$this->addField($f_cell);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
