<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
 
class BuhDoc_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("buh_docs");
			
		//*** Field order_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="order_id";
						
		$f_order_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"order_id",$f_opts);
		$this->addField($f_order_id);
		//********************
		
		//*** Field nomer ***
		$f_opts = array();
		$f_opts['id']="nomer";
						
		$f_nomer=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"nomer",$f_opts);
		$this->addField($f_nomer);
		//********************
		
		//*** Field date ***
		$f_opts = array();
		$f_opts['id']="date";
						
		$f_date=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date",$f_opts);
		$this->addField($f_date);
		//********************
		
		//*** Field ref_1c ***
		$f_opts = array();
		$f_opts['length']=36;
		$f_opts['id']="ref_1c";
						
		$f_ref_1c=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref_1c",$f_opts);
		$this->addField($f_ref_1c);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
