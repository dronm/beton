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
 
class InsurenceList_Model extends {
	
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
		
		//*** Field dt_from ***
		$f_opts = array();
		$f_opts['id']="dt_from";
						
		$f_dt_from=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"dt_from",$f_opts);
		$this->addField($f_dt_from);
		//********************
		
		//*** Field dt_to ***
		$f_opts = array();
		$f_opts['id']="dt_to";
						
		$f_dt_to=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"dt_to",$f_opts);
		$this->addField($f_dt_to);
		//********************
		
		//*** Field issuer ***
		$f_opts = array();
		$f_opts['id']="issuer";
						
		$f_issuer=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"issuer",$f_opts);
		$this->addField($f_issuer);
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
