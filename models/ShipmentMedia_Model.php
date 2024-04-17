<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
 
class ShipmentMedia_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("shipment_media");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field driver_id ***
		$f_opts = array();
		$f_opts['id']="driver_id";
						
		$f_driver_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"driver_id",$f_opts);
		$this->addField($f_driver_id);
		//********************
		
		//*** Field shipment_id ***
		$f_opts = array();
		$f_opts['id']="shipment_id";
						
		$f_shipment_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipment_id",$f_opts);
		$this->addField($f_shipment_id);
		//********************
		
		//*** Field order_id ***
		$f_opts = array();
		$f_opts['id']="order_id";
						
		$f_order_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"order_id",$f_opts);
		$this->addField($f_order_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['defaultValue']='CURRENT_TIMESTAMP';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field message_id ***
		$f_opts = array();
		$f_opts['id']="message_id";
						
		$f_message_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"message_id",$f_opts);
		$this->addField($f_message_id);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
