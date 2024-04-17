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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class ShipmentDialog_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("shipments_dialog");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field orders_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Заявка';
		$f_opts['id']="orders_ref";
						
		$f_orders_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"orders_ref",$f_opts);
		$this->addField($f_orders_ref);
		//********************
		
		//*** Field clients_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Клиент';
		$f_opts['id']="clients_ref";
						
		$f_clients_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"clients_ref",$f_opts);
		$this->addField($f_clients_ref);
		//********************
		
		//*** Field destinations_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Объект';
		$f_opts['id']="destinations_ref";
						
		$f_destinations_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destinations_ref",$f_opts);
		$this->addField($f_destinations_ref);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field ship_date_time ***
		$f_opts = array();
		$f_opts['id']="ship_date_time";
						
		$f_ship_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ship_date_time",$f_opts);
		$this->addField($f_ship_date_time);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Количество';
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
		
		//*** Field vehicle_schedules_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Экипаж';
		$f_opts['id']="vehicle_schedules_ref";
						
		$f_vehicle_schedules_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_schedules_ref",$f_opts);
		$this->addField($f_vehicle_schedules_ref);
		//********************
		
		//*** Field production_sites_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Завод';
		$f_opts['id']="production_sites_ref";
						
		$f_production_sites_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_sites_ref",$f_opts);
		$this->addField($f_production_sites_ref);
		//********************
		
		//*** Field shipped ***
		$f_opts = array();
		
		$f_opts['alias']='Отгружен';
		$f_opts['id']="shipped";
						
		$f_shipped=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipped",$f_opts);
		$this->addField($f_shipped);
		//********************
		
		//*** Field client_mark ***
		$f_opts = array();
		
		$f_opts['alias']='Оценка';
		$f_opts['id']="client_mark";
						
		$f_client_mark=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_mark",$f_opts);
		$this->addField($f_client_mark);
		//********************
		
		//*** Field demurrage ***
		$f_opts = array();
		
		$f_opts['alias']='Простой';
		$f_opts['id']="demurrage";
						
		$f_demurrage=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"demurrage",$f_opts);
		$this->addField($f_demurrage);
		//********************
		
		//*** Field blanks_exist ***
		$f_opts = array();
		
		$f_opts['alias']='Наличие бланков';
		$f_opts['id']="blanks_exist";
						
		$f_blanks_exist=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"blanks_exist",$f_opts);
		$this->addField($f_blanks_exist);
		//********************
		
		//*** Field acc_comment ***
		$f_opts = array();
		
		$f_opts['alias']='Комментарий бухгалетрии';
		$f_opts['id']="acc_comment";
						
		$f_acc_comment=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"acc_comment",$f_opts);
		$this->addField($f_acc_comment);
		//********************
		
		//*** Field acc_comment_shipment ***
		$f_opts = array();
		
		$f_opts['alias']='Комментарий (миксер)';
		$f_opts['id']="acc_comment_shipment";
						
		$f_acc_comment_shipment=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"acc_comment_shipment",$f_opts);
		$this->addField($f_acc_comment_shipment);
		//********************
		
		//*** Field vehicle_owner_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="vehicle_owner_id";
						
		$f_vehicle_owner_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owner_id",$f_opts);
		$this->addField($f_vehicle_owner_id);
		//********************
		
		//*** Field pump_cost ***
		$f_opts = array();
		
		$f_opts['alias']='Стоимость насос';
		$f_opts['id']="pump_cost";
						
		$f_pump_cost=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_cost",$f_opts);
		$this->addField($f_pump_cost);
		//********************
		
		//*** Field pump_cost_default ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="pump_cost_default";
						
		$f_pump_cost_default=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_cost_default",$f_opts);
		$this->addField($f_pump_cost_default);
		//********************
		
		//*** Field pump_cost_edit ***
		$f_opts = array();
		$f_opts['id']="pump_cost_edit";
						
		$f_pump_cost_edit=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_cost_edit",$f_opts);
		$this->addField($f_pump_cost_edit);
		//********************
		
		//*** Field ship_cost ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="ship_cost";
						
		$f_ship_cost=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ship_cost",$f_opts);
		$this->addField($f_ship_cost);
		//********************
		
		//*** Field ship_cost_default ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="ship_cost_default";
						
		$f_ship_cost_default=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ship_cost_default",$f_opts);
		$this->addField($f_ship_cost_default);
		//********************
		
		//*** Field ship_cost_edit ***
		$f_opts = array();
		$f_opts['id']="ship_cost_edit";
						
		$f_ship_cost_edit=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ship_cost_edit",$f_opts);
		$this->addField($f_ship_cost_edit);
		//********************
		
		//*** Field pump_vehicles_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Насос';
		$f_opts['id']="pump_vehicles_ref";
						
		$f_pump_vehicles_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_vehicles_ref",$f_opts);
		$this->addField($f_pump_vehicles_ref);
		//********************
		
		//*** Field order_last_shipment ***
		$f_opts = array();
		$f_opts['id']="order_last_shipment";
						
		$f_order_last_shipment=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"order_last_shipment",$f_opts);
		$this->addField($f_order_last_shipment);
		//********************
		
		//*** Field pump_for_client_cost ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="pump_for_client_cost";
						
		$f_pump_for_client_cost=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_for_client_cost",$f_opts);
		$this->addField($f_pump_for_client_cost);
		//********************
		
		//*** Field pump_for_client_cost_default ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="pump_for_client_cost_default";
						
		$f_pump_for_client_cost_default=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_for_client_cost_default",$f_opts);
		$this->addField($f_pump_for_client_cost_default);
		//********************
		
		//*** Field pump_for_client_cost_edit ***
		$f_opts = array();
		$f_opts['id']="pump_for_client_cost_edit";
						
		$f_pump_for_client_cost_edit=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_for_client_cost_edit",$f_opts);
		$this->addField($f_pump_for_client_cost_edit);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
