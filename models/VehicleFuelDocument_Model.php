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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
 
class VehicleFuelDocument_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("vehicle_fuel_documents");
			
		//*** Field vehicle_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="vehicle_id";
						
		$f_vehicle_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_id",$f_opts);
		$this->addField($f_vehicle_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Дата';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field doc_type ***
		$f_opts = array();
		$f_opts['id']="doc_type";
						
		$f_doc_type=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"doc_type",$f_opts);
		$this->addField($f_doc_type);
		//********************
		
		//*** Field source_id ***
		$f_opts = array();
		$f_opts['id']="source_id";
						
		$f_source_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"source_id",$f_opts);
		$this->addField($f_source_id);
		//********************
		
		//*** Field quant_deb ***
		$f_opts = array();
		$f_opts['id']="quant_deb";
						
		$f_quant_deb=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_deb",$f_opts);
		$this->addField($f_quant_deb);
		//********************
		
		//*** Field quant_kred ***
		$f_opts = array();
		$f_opts['id']="quant_kred";
						
		$f_quant_kred=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_kred",$f_opts);
		$this->addField($f_quant_kred);
		//********************
		
		//*** Field total ***
		$f_opts = array();
		$f_opts['id']="total";
						
		$f_total=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"total",$f_opts);
		$this->addField($f_total);
		//********************
		
		//*** Field mileage ***
		$f_opts = array();
		$f_opts['id']="mileage";
						
		$f_mileage=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"mileage",$f_opts);
		$this->addField($f_mileage);
		//********************
		
		//*** Field timing ***
		$f_opts = array();
		$f_opts['id']="timing";
						
		$f_timing=new FieldSQLTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"timing",$f_opts);
		$this->addField($f_timing);
		//********************
		
		//*** Field card_id ***
		$f_opts = array();
		$f_opts['id']="card_id";
						
		$f_card_id=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"card_id",$f_opts);
		$this->addField($f_card_id);
		//********************
		
		//*** Field transaction_id ***
		$f_opts = array();
		$f_opts['id']="transaction_id";
						
		$f_transaction_id=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"transaction_id",$f_opts);
		$this->addField($f_transaction_id);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_date_time,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
