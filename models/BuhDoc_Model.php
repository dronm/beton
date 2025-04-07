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
		
		//*** Field data ***
		$f_opts = array();
		
		$f_opts['alias']='Formatted document datetime';
		$f_opts['id']="data";
						
		$f_data=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"data",$f_opts);
		$this->addField($f_data);
		//********************
		
		//*** Field faktura_nomer ***
		$f_opts = array();
		$f_opts['id']="faktura_nomer";
						
		$f_faktura_nomer=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"faktura_nomer",$f_opts);
		$this->addField($f_faktura_nomer);
		//********************
		
		//*** Field faktura_data ***
		$f_opts = array();
		
		$f_opts['alias']='Formatted document datetime';
		$f_opts['id']="faktura_data";
						
		$f_faktura_data=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"faktura_data",$f_opts);
		$this->addField($f_faktura_data);
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
