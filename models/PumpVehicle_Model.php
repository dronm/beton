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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInterval.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class PumpVehicle_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("pump_vehicles");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field vehicle_id ***
		$f_opts = array();
		$f_opts['id']="vehicle_id";
						
		$f_vehicle_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_id",$f_opts);
		$this->addField($f_vehicle_id);
		//********************
		
		//*** Field pump_price_id ***
		$f_opts = array();
		$f_opts['id']="pump_price_id";
						
		$f_pump_price_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_price_id",$f_opts);
		$this->addField($f_pump_price_id);
		//********************
		
		//*** Field phone_cel ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="phone_cel";
						
		$f_phone_cel=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"phone_cel",$f_opts);
		$this->addField($f_phone_cel);
		//********************
		
		//*** Field pump_length ***
		$f_opts = array();
		$f_opts['id']="pump_length";
						
		$f_pump_length=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pump_length",$f_opts);
		$this->addField($f_pump_length);
		//********************
		
		//*** Field deleted ***
		$f_opts = array();
		$f_opts['defaultValue']='FALSE';
		$f_opts['id']="deleted";
						
		$f_deleted=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"deleted",$f_opts);
		$this->addField($f_deleted);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		$f_opts['length']=100;
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
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
		
		//*** Field specialist_inform ***
		$f_opts = array();
		$f_opts['id']="specialist_inform";
						
		$f_specialist_inform=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"specialist_inform",$f_opts);
		$this->addField($f_specialist_inform);
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
