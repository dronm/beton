<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
 
class BuhRBP1cList_Model extends ModelJSON{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("");
			
		//*** Field name ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="name";
						
		$f_name=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field date_from ***
		$f_opts = array();
		$f_opts['id']="date_from";
						
		$f_date_from=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_from",$f_opts);
		$this->addField($f_date_from);
		//********************
		
		//*** Field date_to ***
		$f_opts = array();
		$f_opts['id']="date_to";
						
		$f_date_to=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_to",$f_opts);
		$this->addField($f_date_to);
		//********************
		
		//*** Field total ***
		$f_opts = array();
		$f_opts['id']="total";
						
		$f_total=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"total",$f_opts);
		$this->addField($f_total);
		//********************
		
		//*** Field search ***
		$f_opts = array();
		$f_opts['id']="search";
						
		$f_search=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"search",$f_opts);
		$this->addField($f_search);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
