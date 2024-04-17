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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
 
class VehicleSchedule_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("vehicle_schedules");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field schedule_date ***
		$f_opts = array();
		
		$f_opts['alias']='Дата';
		$f_opts['id']="schedule_date";
						
		$f_schedule_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"schedule_date",$f_opts);
		$this->addField($f_schedule_date);
		//********************
		
		//*** Field vehicle_id ***
		$f_opts = array();
		
		$f_opts['alias']='Автомобиль';
		$f_opts['id']="vehicle_id";
						
		$f_vehicle_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_id",$f_opts);
		$this->addField($f_vehicle_id);
		//********************
		
		//*** Field driver_id ***
		$f_opts = array();
		
		$f_opts['alias']='Водитель';
		$f_opts['id']="driver_id";
						
		$f_driver_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"driver_id",$f_opts);
		$this->addField($f_driver_id);
		//********************
		
		//*** Field production_base_id ***
		$f_opts = array();
		
		$f_opts['alias']='База';
		$f_opts['id']="production_base_id";
						
		$f_production_base_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_base_id",$f_opts);
		$this->addField($f_production_base_id);
		//********************
		
		//*** Field edit_user_id ***
		$f_opts = array();
		
		$f_opts['alias']='Кто внес данные';
		$f_opts['id']="edit_user_id";
						
		$f_edit_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"edit_user_id",$f_opts);
		$this->addField($f_edit_user_id);
		//********************
		
		//*** Field edit_date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Когда внес данные';
		$f_opts['id']="edit_date_time";
						
		$f_edit_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"edit_date_time",$f_opts);
		$this->addField($f_edit_date_time);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
