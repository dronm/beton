<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
 
class LeasingList_Model extends {
	
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
		
		//*** Field contract_dt ***
		$f_opts = array();
		$f_opts['id']="contract_dt";
						
		$f_contract_dt=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contract_dt",$f_opts);
		$this->addField($f_contract_dt);
		//********************
		
		//*** Field contract_num ***
		$f_opts = array();
		$f_opts['id']="contract_num";
						
		$f_contract_num=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contract_num",$f_opts);
		$this->addField($f_contract_num);
		//********************
		
		//*** Field leasor ***
		$f_opts = array();
		$f_opts['id']="leasor";
						
		$f_leasor=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"leasor",$f_opts);
		$this->addField($f_leasor);
		//********************
		
		//*** Field total ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="total";
						
		$f_total=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"total",$f_opts);
		$this->addField($f_total);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
