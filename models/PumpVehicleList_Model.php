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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInterval.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLArray.php');
 
class PumpVehicleList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("pump_veh_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field phone_cel ***
		$f_opts = array();
		$f_opts['id']="phone_cel";
						
		$f_phone_cel=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"phone_cel",$f_opts);
		$this->addField($f_phone_cel);
		//********************
		
		//*** Field pump_prices_ref ***
		$f_opts = array();
		$f_opts['id']="pump_prices_ref";
						
		$f_pump_prices_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_prices_ref",$f_opts);
		$this->addField($f_pump_prices_ref);
		//********************
		
		//*** Field pump_vehicles_ref ***
		$f_opts = array();
		$f_opts['id']="pump_vehicles_ref";
						
		$f_pump_vehicles_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_vehicles_ref",$f_opts);
		$this->addField($f_pump_vehicles_ref);
		//********************
		
		//*** Field vehicle_owners_ref ***
		$f_opts = array();
		$f_opts['id']="vehicle_owners_ref";
						
		$f_vehicle_owners_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owners_ref",$f_opts);
		$this->addField($f_vehicle_owners_ref);
		//********************
		
		//*** Field feature ***
		$f_opts = array();
		$f_opts['id']="feature";
						
		$f_feature=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"feature",$f_opts);
		$this->addField($f_feature);
		//********************
		
		//*** Field make ***
		$f_opts = array();
		$f_opts['id']="make";
						
		$f_make=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"make",$f_opts);
		$this->addField($f_make);
		//********************
		
		//*** Field plate ***
		$f_opts = array();
		$f_opts['id']="plate";
						
		$f_plate=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"plate",$f_opts);
		$this->addField($f_plate);
		//********************
		
		//*** Field deleted ***
		$f_opts = array();
		$f_opts['id']="deleted";
						
		$f_deleted=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"deleted",$f_opts);
		$this->addField($f_deleted);
		//********************
		
		//*** Field pump_length ***
		$f_opts = array();
		$f_opts['id']="pump_length";
						
		$f_pump_length=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_length",$f_opts);
		$this->addField($f_pump_length);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
		//********************
		
		//*** Field vehicle_owner_id ***
		$f_opts = array();
		$f_opts['id']="vehicle_owner_id";
						
		$f_vehicle_owner_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owner_id",$f_opts);
		$this->addField($f_vehicle_owner_id);
		//********************
		
		//*** Field phone_cels ***
		$f_opts = array();
		$f_opts['id']="phone_cels";
						
		$f_phone_cels=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"phone_cels",$f_opts);
		$this->addField($f_phone_cels);
		//********************
		
		//*** Field pump_prices ***
		$f_opts = array();
		$f_opts['id']="pump_prices";
						
		$f_pump_prices=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_prices",$f_opts);
		$this->addField($f_pump_prices);
		//********************
		
		//*** Field vehicle_owners_ar ***
		$f_opts = array();
		$f_opts['id']="vehicle_owners_ar";
						
		$f_vehicle_owners_ar=new FieldSQLArray($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owners_ar",$f_opts);
		$this->addField($f_vehicle_owners_ar);
		//********************
		
		//*** Field self_ref ***
		$f_opts = array();
		$f_opts['id']="self_ref";
						
		$f_self_ref=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"self_ref",$f_opts);
		$this->addField($f_self_ref);
		//********************
		
		//*** Field specialist_inform ***
		$f_opts = array();
		$f_opts['id']="specialist_inform";
						
		$f_specialist_inform=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"specialist_inform",$f_opts);
		$this->addField($f_specialist_inform);
		//********************
		
		//*** Field contact_list ***
		$f_opts = array();
		
		$f_opts['alias']='Контакты';
		$f_opts['id']="contact_list";
						
		$f_contact_list=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_list",$f_opts);
		$this->addField($f_contact_list);
		//********************
		
		//*** Field contact_ids ***
		$f_opts = array();
		
		$f_opts['alias']='Ids for search';
		$f_opts['id']="contact_ids";
						
		$f_contact_ids=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_ids",$f_opts);
		$this->addField($f_contact_ids);
		//********************
		
		//*** Field driver_ship_inform ***
		$f_opts = array();
		$f_opts['id']="driver_ship_inform";
						
		$f_driver_ship_inform=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"driver_ship_inform",$f_opts);
		$this->addField($f_driver_ship_inform);
		//********************
		
		//*** Field min_order_quant ***
		$f_opts = array();
		
		$f_opts['alias']='Минимальное количество м3 для заявки';
		$f_opts['id']="min_order_quant";
						
		$f_min_order_quant=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"min_order_quant",$f_opts);
		$this->addField($f_min_order_quant);
		//********************
		
		//*** Field min_order_time_interval ***
		$f_opts = array();
		
		$f_opts['alias']='Минимальный интервал между заявками';
		$f_opts['id']="min_order_time_interval";
						
		$f_min_order_time_interval=new FieldSQLInterval($this->getDbLink(),$this->getDbName(),$this->getTableName(),"min_order_time_interval",$f_opts);
		$this->addField($f_min_order_time_interval);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
