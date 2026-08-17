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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
 
class ShipmentWeight_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("shipment_weights");
			
		//*** Field shipment_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=FALSE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="shipment_id";
						
		$f_shipment_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipment_id",$f_opts);
		$this->addField($f_shipment_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Дата';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
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
		
		//*** Field unloading_warehouse ***
		$f_opts = array();
		
		$f_opts['alias']='Склад разгрузки';
		$f_opts['id']="unloading_warehouse";
						
		$f_unloading_warehouse=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"unloading_warehouse",$f_opts);
		$this->addField($f_unloading_warehouse);
		//********************
		
		//*** Field ship_weighing_cause ***
		$f_opts = array();
		$f_opts['id']="ship_weighing_cause";
						
		$f_ship_weighing_cause=new FieldSQLEnum($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ship_weighing_cause",$f_opts);
		$this->addField($f_ship_weighing_cause);
		//********************
		
		//*** Field uploaded_at ***
		$f_opts = array();
		
		$f_opts['alias']='Дата';
		$f_opts['id']="uploaded_at";
						
		$f_uploaded_at=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"uploaded_at",$f_opts);
		$this->addField($f_uploaded_at);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
