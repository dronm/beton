<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLDOC.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
 
class FuelConsumptionSchemaDetail_Model extends ModelSQLDOC{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("fuel_consumption_schema_details");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field fuel_consumption_schema_id ***
		$f_opts = array();
		$f_opts['id']="fuel_consumption_schema_id";
						
		$f_fuel_consumption_schema_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"fuel_consumption_schema_id",$f_opts);
		$this->addField($f_fuel_consumption_schema_id);
		//********************
		
		//*** Field month_from ***
		$f_opts = array();
		
		$f_opts['alias']='1-12';
		$f_opts['id']="month_from";
						
		$f_month_from=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"month_from",$f_opts);
		$this->addField($f_month_from);
		//********************
		
		//*** Field month_to ***
		$f_opts = array();
		
		$f_opts['alias']='1-12';
		$f_opts['id']="month_to";
						
		$f_month_to=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"month_to",$f_opts);
		$this->addField($f_month_to);
		//********************
		
		//*** Field quant_distance ***
		$f_opts = array();
		
		$f_opts['alias']='Расход на 100 км';
		$f_opts['id']="quant_distance";
						
		$f_quant_distance=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_distance",$f_opts);
		$this->addField($f_quant_distance);
		//********************
		
		//*** Field quant_time ***
		$f_opts = array();
		
		$f_opts['alias']='Расход на 1 час';
		$f_opts['id']="quant_time";
						
		$f_quant_time=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_time",$f_opts);
		$this->addField($f_quant_time);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
