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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class OrderMakeList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("orders_make_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field clients_ref ***
		$f_opts = array();
		$f_opts['id']="clients_ref";
						
		$f_clients_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"clients_ref",$f_opts);
		$this->addField($f_clients_ref);
		//********************
		
		//*** Field client_id ***
		$f_opts = array();
		$f_opts['id']="client_id";
						
		$f_client_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_id",$f_opts);
		$this->addField($f_client_id);
		//********************
		
		//*** Field destination_id ***
		$f_opts = array();
		$f_opts['id']="destination_id";
						
		$f_destination_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destination_id",$f_opts);
		$this->addField($f_destination_id);
		//********************
		
		//*** Field user_id ***
		$f_opts = array();
		$f_opts['id']="user_id";
						
		$f_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"user_id",$f_opts);
		$this->addField($f_user_id);
		//********************
		
		//*** Field destinations_ref ***
		$f_opts = array();
		$f_opts['id']="destinations_ref";
						
		$f_destinations_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destinations_ref",$f_opts);
		$this->addField($f_destinations_ref);
		//********************
		
		//*** Field concrete_types_ref ***
		$f_opts = array();
		$f_opts['id']="concrete_types_ref";
						
		$f_concrete_types_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"concrete_types_ref",$f_opts);
		$this->addField($f_concrete_types_ref);
		//********************
		
		//*** Field concrete_type_id ***
		$f_opts = array();
		$f_opts['id']="concrete_type_id";
						
		$f_concrete_type_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"concrete_type_id",$f_opts);
		$this->addField($f_concrete_type_id);
		//********************
		
		//*** Field f_val ***
		$f_opts = array();
		
		$f_opts['alias']='F';
		$f_opts['id']="f_val";
						
		$f_f_val=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"f_val",$f_opts);
		$this->addField($f_f_val);
		//********************
		
		//*** Field w_val ***
		$f_opts = array();
		
		$f_opts['alias']='W';
		$f_opts['id']="w_val";
						
		$f_w_val=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"w_val",$f_opts);
		$this->addField($f_w_val);
		//********************
		
		//*** Field unload_type ***
		$f_opts = array();
		$f_opts['id']="unload_type";
						
		$f_unload_type=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"unload_type",$f_opts);
		$this->addField($f_unload_type);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
		//********************
		
		//*** Field descr ***
		$f_opts = array();
		$f_opts['id']="descr";
						
		$f_descr=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"descr",$f_opts);
		$this->addField($f_descr);
		//********************
		
		//*** Field phone_cel ***
		$f_opts = array();
		$f_opts['id']="phone_cel";
						
		$f_phone_cel=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"phone_cel",$f_opts);
		$this->addField($f_phone_cel);
		//********************
		
		//*** Field unload_speed ***
		$f_opts = array();
		$f_opts['id']="unload_speed";
						
		$f_unload_speed=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"unload_speed",$f_opts);
		$this->addField($f_unload_speed);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field date_time_to ***
		$f_opts = array();
		$f_opts['id']="date_time_to";
						
		$f_date_time_to=new FieldSQLTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time_to",$f_opts);
		$this->addField($f_date_time_to);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
		
		//*** Field quant_rest ***
		$f_opts = array();
		$f_opts['id']="quant_rest";
						
		$f_quant_rest=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_rest",$f_opts);
		$this->addField($f_quant_rest);
		//********************
		
		//*** Field quant_ordered_before_now ***
		$f_opts = array();
		$f_opts['id']="quant_ordered_before_now";
						
		$f_quant_ordered_before_now=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_ordered_before_now",$f_opts);
		$this->addField($f_quant_ordered_before_now);
		//********************
		
		//*** Field quant_shipped_before_now ***
		$f_opts = array();
		$f_opts['id']="quant_shipped_before_now";
						
		$f_quant_shipped_before_now=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_shipped_before_now",$f_opts);
		$this->addField($f_quant_shipped_before_now);
		//********************
		
		//*** Field quant_shipped_day_before_now ***
		$f_opts = array();
		$f_opts['id']="quant_shipped_day_before_now";
						
		$f_quant_shipped_day_before_now=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_shipped_day_before_now",$f_opts);
		$this->addField($f_quant_shipped_day_before_now);
		//********************
		
		//*** Field quant_ordered_day ***
		$f_opts = array();
		$f_opts['id']="quant_ordered_day";
						
		$f_quant_ordered_day=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_ordered_day",$f_opts);
		$this->addField($f_quant_ordered_day);
		//********************
		
		//*** Field no_ship_mark ***
		$f_opts = array();
		$f_opts['id']="no_ship_mark";
						
		$f_no_ship_mark=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"no_ship_mark",$f_opts);
		$this->addField($f_no_ship_mark);
		//********************
		
		//*** Field payed ***
		$f_opts = array();
		$f_opts['id']="payed";
						
		$f_payed=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"payed",$f_opts);
		$this->addField($f_payed);
		//********************
		
		//*** Field under_control ***
		$f_opts = array();
		$f_opts['id']="under_control";
						
		$f_under_control=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"under_control",$f_opts);
		$this->addField($f_under_control);
		//********************
		
		//*** Field pay_cash ***
		$f_opts = array();
		$f_opts['id']="pay_cash";
						
		$f_pay_cash=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pay_cash",$f_opts);
		$this->addField($f_pay_cash);
		//********************
		
		//*** Field pump_vehicle_owners_ref ***
		$f_opts = array();
		$f_opts['id']="pump_vehicle_owners_ref";
						
		$f_pump_vehicle_owners_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_vehicle_owners_ref",$f_opts);
		$this->addField($f_pump_vehicle_owners_ref);
		//********************
		
		//*** Field total ***
		$f_opts = array();
		$f_opts['id']="total";
						
		$f_total=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"total",$f_opts);
		$this->addField($f_total);
		//********************
		
		//*** Field pump_vehicle_length ***
		$f_opts = array();
		$f_opts['id']="pump_vehicle_length";
						
		$f_pump_vehicle_length=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_vehicle_length",$f_opts);
		$this->addField($f_pump_vehicle_length);
		//********************
		
		//*** Field pump_vehicle_comment ***
		$f_opts = array();
		$f_opts['id']="pump_vehicle_comment";
						
		$f_pump_vehicle_comment=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_vehicle_comment",$f_opts);
		$this->addField($f_pump_vehicle_comment);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
