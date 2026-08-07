<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
 
class WorkplaceSchedule_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("workplace_schedules");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field workplace_id ***
		$f_opts = array();
		$f_opts['id']="workplace_id";
						
		$f_workplace_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"workplace_id",$f_opts);
		$this->addField($f_workplace_id);
		//********************
		
		//*** Field user_id ***
		$f_opts = array();
		$f_opts['id']="user_id";
						
		$f_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"user_id",$f_opts);
		$this->addField($f_user_id);
		//********************
		
		//*** Field for_date ***
		$f_opts = array();
		
		$f_opts['alias']='Дата';
		$f_opts['id']="for_date";
						
		$f_for_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"for_date",$f_opts);
		$this->addField($f_for_date);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
