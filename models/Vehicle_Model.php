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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLArray.php');
 
class Vehicle_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("vehicles");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['sysCol']=TRUE;
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
		
		//*** Field plate_n ***
		$f_opts = array();
		
		$f_opts['alias']='Номер число для сортировки';
		$f_opts['id']="plate_n";
						
		$f_plate_n=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"plate_n",$f_opts);
		$this->addField($f_plate_n);
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
		
		//*** Field driver_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="driver_id";
						
		$f_driver_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"driver_id",$f_opts);
		$this->addField($f_driver_id);
		//********************
		
		//*** Field feature ***
		$f_opts = array();
		
		$f_opts['alias']='Свойство';
		$f_opts['length']=50;
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
		
		//*** Field vehicle_owner_id ***
		$f_opts = array();
		
		$f_opts['alias']='УДАЛИТЬ Владелец';
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
		
		//*** Field vin ***
		$f_opts = array();
		
		$f_opts['alias']='VIN';
		$f_opts['length']=17;
		$f_opts['id']="vin";
						
		$f_vin=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vin",$f_opts);
		$this->addField($f_vin);
		//********************
		
		//*** Field leasor ***
		$f_opts = array();
		
		$f_opts['alias']='Leasor name';
		$f_opts['id']="leasor";
						
		$f_leasor=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"leasor",$f_opts);
		$this->addField($f_leasor);
		//********************
		
		//*** Field leasing_contract_date ***
		$f_opts = array();
		$f_opts['id']="leasing_contract_date";
						
		$f_leasing_contract_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"leasing_contract_date",$f_opts);
		$this->addField($f_leasing_contract_date);
		//********************
		
		//*** Field leasing_contract_num ***
		$f_opts = array();
		$f_opts['id']="leasing_contract_num";
						
		$f_leasing_contract_num=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"leasing_contract_num",$f_opts);
		$this->addField($f_leasing_contract_num);
		//********************
		
		//*** Field leasing_total ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="leasing_total";
						
		$f_leasing_total=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"leasing_total",$f_opts);
		$this->addField($f_leasing_total);
		//********************
		
		//*** Field insurance_osago ***
		$f_opts = array();
		
		$f_opts['alias']='Insurance osago data';
		$f_opts['id']="insurance_osago";
						
		$f_insurance_osago=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"insurance_osago",$f_opts);
		$this->addField($f_insurance_osago);
		//********************
		
		//*** Field insurance_kasko ***
		$f_opts = array();
		
		$f_opts['alias']='Insurance kasko data';
		$f_opts['id']="insurance_kasko";
						
		$f_insurance_kasko=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"insurance_kasko",$f_opts);
		$this->addField($f_insurance_kasko);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_plate_n,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
