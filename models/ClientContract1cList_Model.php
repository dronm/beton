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
 
class ClientContract1cList_Model extends ModelJSON{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("");
			
		//*** Field name ***
		$f_opts = array();
		$f_opts['id']="name";
						
		$f_name=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field ref_1c ***
		$f_opts = array();
		$f_opts['id']="ref_1c";
						
		$f_ref_1c=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref_1c",$f_opts);
		$this->addField($f_ref_1c);
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
