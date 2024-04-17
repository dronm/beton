<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLArray.php');
 
class VehicleDialog_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("vehicles_dialog");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field plate ***
		$f_opts = array();
		
		$f_opts['alias']='Номер';
		$f_opts['length']=6;
		$f_opts['id']="plate";
						
		$f_plate=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"plate",$f_opts);
		$this->addField($f_plate);
		//********************
		
		//*** Field load_capacity ***
		$f_opts = array();
		
		$f_opts['alias']='Грузоподъемность';
		$f_opts['length']=15;
		$f_opts['id']="load_capacity";
						
		$f_load_capacity=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"load_capacity",$f_opts);
		$this->addField($f_load_capacity);
		//********************
		
		//*** Field make ***
		$f_opts = array();
		
		$f_opts['alias']='Марка';
		$f_opts['length']=200;
		$f_opts['id']="make";
						
		$f_make=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"make",$f_opts);
		$this->addField($f_make);
		//********************
		
		//*** Field drivers_ref ***
		$f_opts = array();
		$f_opts['id']="drivers_ref";
						
		$f_drivers_ref=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"drivers_ref",$f_opts);
		$this->addField($f_drivers_ref);
		//********************
		
		//*** Field feature ***
		$f_opts = array();
		
		$f_opts['alias']='Свойство';
		$f_opts['id']="feature";
						
		$f_feature=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"feature",$f_opts);
		$this->addField($f_feature);
		//********************
		
		//*** Field tracker_id ***
		$f_opts = array();
		
		$f_opts['alias']='Трэкер';
		$f_opts['id']="tracker_id";
						
		$f_tracker_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tracker_id",$f_opts);
		$this->addField($f_tracker_id);
		//********************
		
		//*** Field sim_id ***
		$f_opts = array();
		
		$f_opts['alias']='Идентификатор SIM карты';
		$f_opts['id']="sim_id";
						
		$f_sim_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sim_id",$f_opts);
		$this->addField($f_sim_id);
		//********************
		
		//*** Field sim_number ***
		$f_opts = array();
		
		$f_opts['alias']='Номер телефона SIM карты';
		$f_opts['id']="sim_number";
						
		$f_sim_number=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sim_number",$f_opts);
		$this->addField($f_sim_number);
		//********************
		
		//*** Field tracker_last_dt ***
		$f_opts = array();
		$f_opts['id']="tracker_last_dt";
						
		$f_tracker_last_dt=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tracker_last_dt",$f_opts);
		$this->addField($f_tracker_last_dt);
		//********************
		
		//*** Field tracker_sat_num ***
		$f_opts = array();
		$f_opts['id']="tracker_sat_num";
						
		$f_tracker_sat_num=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tracker_sat_num",$f_opts);
		$this->addField($f_tracker_sat_num);
		//********************
		
		//*** Field vehicle_owners_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Последний владелец';
		$f_opts['id']="vehicle_owners_ref";
						
		$f_vehicle_owners_ref=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owners_ref",$f_opts);
		$this->addField($f_vehicle_owners_ref);
		//********************
		
		//*** Field vehicle_owner_id ***
		$f_opts = array();
		
		$f_opts['alias']='Последний владелец';
		$f_opts['id']="vehicle_owner_id";
						
		$f_vehicle_owner_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owner_id",$f_opts);
		$this->addField($f_vehicle_owner_id);
		//********************
		
		//*** Field vehicle_owners ***
		$f_opts = array();
		
		$f_opts['alias']='История владелецев';
		$f_opts['id']="vehicle_owners";
						
		$f_vehicle_owners=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owners",$f_opts);
		$this->addField($f_vehicle_owners);
		//********************
		
		//*** Field vehicle_owners_ar ***
		$f_opts = array();
		$f_opts['id']="vehicle_owners_ar";
						
		$f_vehicle_owners_ar=new FieldSQLArray($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owners_ar",$f_opts);
		$this->addField($f_vehicle_owners_ar);
		//********************
		
		//*** Field ord_num ***
		$f_opts = array();
		$f_opts['id']="ord_num";
						
		$f_ord_num=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ord_num",$f_opts);
		$this->addField($f_ord_num);
		//********************
		
		//*** Field weight_t ***
		$f_opts = array();
		
		$f_opts['alias']='Масса, тонн';
		$f_opts['id']="weight_t";
						
		$f_weight_t=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"weight_t",$f_opts);
		$this->addField($f_weight_t);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
