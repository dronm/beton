<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class VehicleMileageList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("vehicle_mileages_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field vehicle_id ***
		$f_opts = array();
		
		$f_opts['alias']='ТС';
		$f_opts['id']="vehicle_id";
						
		$f_vehicle_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_id",$f_opts);
		$this->addField($f_vehicle_id);
		//********************
		
		//*** Field for_date ***
		$f_opts = array();
		
		$f_opts['alias']='Дата';
		$f_opts['id']="for_date";
						
		$f_for_date=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"for_date",$f_opts);
		$this->addField($f_for_date);
		//********************
		
		//*** Field mileage ***
		$f_opts = array();
		
		$f_opts['alias']='Пробег';
		$f_opts['id']="mileage";
						
		$f_mileage=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"mileage",$f_opts);
		$this->addField($f_mileage);
		//********************
		
		//*** Field users_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Who set value';
		$f_opts['id']="users_ref";
						
		$f_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"users_ref",$f_opts);
		$this->addField($f_users_ref);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
