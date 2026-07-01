<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLDOC.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInterval.php');
 
class FuelConsumption_Model extends ModelSQLDOC{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("fuel_consumptions");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Период';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field vehicle_id ***
		$f_opts = array();
		$f_opts['id']="vehicle_id";
						
		$f_vehicle_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_id",$f_opts);
		$this->addField($f_vehicle_id);
		//********************
		
		//*** Field mileage ***
		$f_opts = array();
		$f_opts['id']="mileage";
						
		$f_mileage=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"mileage",$f_opts);
		$this->addField($f_mileage);
		//********************
		
		//*** Field timing ***
		$f_opts = array();
		$f_opts['id']="timing";
						
		$f_timing=new FieldSQLInterval($this->getDbLink(),$this->getDbName(),$this->getTableName(),"timing",$f_opts);
		$this->addField($f_timing);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Количество';
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
