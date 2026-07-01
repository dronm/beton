<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLDOC.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class SpecialVehicleList_Model extends ModelSQLDOC{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("special_vehicles_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field vehicles_ref ***
		$f_opts = array();
		$f_opts['id']="vehicles_ref";
						
		$f_vehicles_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicles_ref",$f_opts);
		$this->addField($f_vehicles_ref);
		//********************
		
		//*** Field tracker_id ***
		$f_opts = array();
		$f_opts['id']="tracker_id";
						
		$f_tracker_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tracker_id",$f_opts);
		$this->addField($f_tracker_id);
		//********************
		
		//*** Field make ***
		$f_opts = array();
		$f_opts['id']="make";
						
		$f_make=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"make",$f_opts);
		$this->addField($f_make);
		//********************
		
		//*** Field tracker_no_signal ***
		$f_opts = array();
		$f_opts['id']="tracker_no_signal";
						
		$f_tracker_no_signal=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tracker_no_signal",$f_opts);
		$this->addField($f_tracker_no_signal);
		//********************
		
		//*** Field no_tracker ***
		$f_opts = array();
		$f_opts['id']="no_tracker";
						
		$f_no_tracker=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"no_tracker",$f_opts);
		$this->addField($f_no_tracker);
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
						
		$f_timing=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"timing",$f_opts);
		$this->addField($f_timing);
		//********************
		
		//*** Field fuel_flow_start ***
		$f_opts = array();
		$f_opts['id']="fuel_flow_start";
						
		$f_fuel_flow_start=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"fuel_flow_start",$f_opts);
		$this->addField($f_fuel_flow_start);
		//********************
		
		//*** Field fuel_flow_in ***
		$f_opts = array();
		$f_opts['id']="fuel_flow_in";
						
		$f_fuel_flow_in=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"fuel_flow_in",$f_opts);
		$this->addField($f_fuel_flow_in);
		//********************
		
		//*** Field fuel_flow_out ***
		$f_opts = array();
		$f_opts['id']="fuel_flow_out";
						
		$f_fuel_flow_out=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"fuel_flow_out",$f_opts);
		$this->addField($f_fuel_flow_out);
		//********************
		
		//*** Field fuel_flow_end ***
		$f_opts = array();
		$f_opts['id']="fuel_flow_end";
						
		$f_fuel_flow_end=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"fuel_flow_end",$f_opts);
		$this->addField($f_fuel_flow_end);
		//********************
		
		//*** Field map_picture ***
		$f_opts = array();
		$f_opts['id']="map_picture";
						
		$f_map_picture=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"map_picture",$f_opts);
		$this->addField($f_map_picture);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
