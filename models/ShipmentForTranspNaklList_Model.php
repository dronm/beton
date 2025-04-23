<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class ShipmentForTranspNaklList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("shipments_for_transp_nakl_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Номер';
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field order_id ***
		$f_opts = array();
		
		$f_opts['alias']='Order ID';
		$f_opts['id']="order_id";
						
		$f_order_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"order_id",$f_opts);
		$this->addField($f_order_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Дата';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field shipments_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Shipment';
		$f_opts['id']="shipments_ref";
						
		$f_shipments_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipments_ref",$f_opts);
		$this->addField($f_shipments_ref);
		//********************
		
		//*** Field production_sites_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Production site';
		$f_opts['id']="production_sites_ref";
						
		$f_production_sites_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_sites_ref",$f_opts);
		$this->addField($f_production_sites_ref);
		//********************
		
		//*** Field vehicles_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Vehicle';
		$f_opts['id']="vehicles_ref";
						
		$f_vehicles_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicles_ref",$f_opts);
		$this->addField($f_vehicles_ref);
		//********************
		
		//*** Field drivers_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Driver';
		$f_opts['id']="drivers_ref";
						
		$f_drivers_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"drivers_ref",$f_opts);
		$this->addField($f_drivers_ref);
		//********************
		
		//*** Field driver_sig_exists ***
		$f_opts = array();
		
		$f_opts['alias']='Driver sig';
		$f_opts['id']="driver_sig_exists";
						
		$f_driver_sig_exists=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"driver_sig_exists",$f_opts);
		$this->addField($f_driver_sig_exists);
		//********************
		
		//*** Field operators_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Operator';
		$f_opts['id']="operators_ref";
						
		$f_operators_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"operators_ref",$f_opts);
		$this->addField($f_operators_ref);
		//********************
		
		//*** Field operator_sig_exists ***
		$f_opts = array();
		
		$f_opts['alias']='Operator sig';
		$f_opts['id']="operator_sig_exists";
						
		$f_operator_sig_exists=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"operator_sig_exists",$f_opts);
		$this->addField($f_operator_sig_exists);
		//********************
		
		//*** Field carriers_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Carrier';
		$f_opts['id']="carriers_ref";
						
		$f_carriers_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"carriers_ref",$f_opts);
		$this->addField($f_carriers_ref);
		//********************
		
		//*** Field carrier_ref_1c_exists ***
		$f_opts = array();
		$f_opts['id']="carrier_ref_1c_exists";
						
		$f_carrier_ref_1c_exists=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"carrier_ref_1c_exists",$f_opts);
		$this->addField($f_carrier_ref_1c_exists);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Кол-во,м3';
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_date_time,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
