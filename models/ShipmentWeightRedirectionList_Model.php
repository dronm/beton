<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class ShipmentWeightRedirectionList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("shipment_weights_redirection_list");
			
		//*** Field shipment_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=FALSE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="shipment_id";
						
		$f_shipment_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipment_id",$f_opts);
		$this->addField($f_shipment_id);
		//********************
		
		//*** Field vehicles_ref ***
		$f_opts = array();
		$f_opts['id']="vehicles_ref";
						
		$f_vehicles_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicles_ref",$f_opts);
		$this->addField($f_vehicles_ref);
		//********************
		
		//*** Field vehicle_id ***
		$f_opts = array();
		$f_opts['id']="vehicle_id";
						
		$f_vehicle_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_id",$f_opts);
		$this->addField($f_vehicle_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Дата';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field number ***
		$f_opts = array();
		
		$f_opts['alias']='Номер';
		$f_opts['id']="number";
						
		$f_number=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"number",$f_opts);
		$this->addField($f_number);
		//********************
		
		//*** Field material ***
		$f_opts = array();
		
		$f_opts['alias']='Груз';
		$f_opts['id']="material";
						
		$f_material=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"material",$f_opts);
		$this->addField($f_material);
		//********************
		
		//*** Field sender_name ***
		$f_opts = array();
		
		$f_opts['alias']='ПунктОтправления';
		$f_opts['id']="sender_name";
						
		$f_sender_name=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sender_name",$f_opts);
		$this->addField($f_sender_name);
		//********************
		
		//*** Field sender_client ***
		$f_opts = array();
		
		$f_opts['alias']='Отправитель';
		$f_opts['id']="sender_client";
						
		$f_sender_client=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sender_client",$f_opts);
		$this->addField($f_sender_client);
		//********************
		
		//*** Field quant_gross ***
		$f_opts = array();
		
		$f_opts['alias']='Брутто';
		$f_opts['length']=19;
		$f_opts['id']="quant_gross";
						
		$f_quant_gross=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_gross",$f_opts);
		$this->addField($f_quant_gross);
		//********************
		
		//*** Field quant_net ***
		$f_opts = array();
		
		$f_opts['alias']='Нетто';
		$f_opts['length']=19;
		$f_opts['id']="quant_net";
						
		$f_quant_net=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_net",$f_opts);
		$this->addField($f_quant_net);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Объем';
		$f_opts['length']=19;
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		
		$f_opts['alias']='Комментарий';
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
		//********************
		
		//*** Field unloading_warehouse ***
		$f_opts = array();
		
		$f_opts['alias']='Склад разгрузки';
		$f_opts['id']="unloading_warehouse";
						
		$f_unloading_warehouse=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"unloading_warehouse",$f_opts);
		$this->addField($f_unloading_warehouse);
		//********************
		
		//*** Field amount ***
		$f_opts = array();
		
		$f_opts['alias']='Деньги';
		$f_opts['id']="amount";
						
		$f_amount=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"amount",$f_opts);
		$this->addField($f_amount);
		//********************
		
		//*** Field payment ***
		$f_opts = array();
		$f_opts['id']="payment";
						
		$f_payment=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"payment",$f_opts);
		$this->addField($f_payment);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_date_time,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
