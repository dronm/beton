<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class OwnerList_Model extends {
	
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
						
		$f_dt_from=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"dt_from",$f_opts);
		$this->addField($f_dt_from);
		//********************
		
		//*** Field owner ***
		$f_opts = array();
		$f_opts['id']="owner";
						
		$f_owner=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"owner",$f_opts);
		$this->addField($f_owner);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
