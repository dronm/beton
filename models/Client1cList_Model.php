<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class Client1cList_Model extends ModelJSON{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("");
			
		//*** Field inn ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=FALSE;
		$f_opts['id']="inn";
						
		$f_inn=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"inn",$f_opts);
		$this->addField($f_inn);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		$f_opts['id']="name";
						
		$f_name=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field search ***
		$f_opts = array();
		$f_opts['id']="search";
						
		$f_search=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"search",$f_opts);
		$this->addField($f_search);
		//********************
		
		//*** Field ref ***
		$f_opts = array();
		$f_opts['id']="ref";
						
		$f_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref",$f_opts);
		$this->addField($f_ref);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
