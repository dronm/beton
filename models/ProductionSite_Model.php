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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLArray.php');
 
class ProductionSite_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("production_sites");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		$f_opts['length']=100;
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field elkon_connection ***
		$f_opts = array();
		$f_opts['id']="elkon_connection";
						
		$f_elkon_connection=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"elkon_connection",$f_opts);
		$this->addField($f_elkon_connection);
		//********************
		
		//*** Field elkon_params ***
		$f_opts = array();
		$f_opts['id']="elkon_params";
						
		$f_elkon_params=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"elkon_params",$f_opts);
		$this->addField($f_elkon_params);
		//********************
		
		//*** Field active ***
		$f_opts = array();
		
		$f_opts['alias']='Активен';
		$f_opts['id']="active";
						
		$f_active=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"active",$f_opts);
		$this->addField($f_active);
		//********************
		
		//*** Field last_elkon_production_id ***
		$f_opts = array();
		$f_opts['id']="last_elkon_production_id";
						
		$f_last_elkon_production_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"last_elkon_production_id",$f_opts);
		$this->addField($f_last_elkon_production_id);
		//********************
		
		//*** Field missing_elkon_production_ids ***
		$f_opts = array();
		$f_opts['id']="missing_elkon_production_ids";
						
		$f_missing_elkon_production_ids=new FieldSQLArray($this->getDbLink(),$this->getDbName(),$this->getTableName(),"missing_elkon_production_ids",$f_opts);
		$this->addField($f_missing_elkon_production_ids);
		//********************
		
		//*** Field destination_id ***
		$f_opts = array();
		
		$f_opts['alias']='Зона';
		$f_opts['id']="destination_id";
						
		$f_destination_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destination_id",$f_opts);
		$this->addField($f_destination_id);
		//********************
		
		//*** Field production_plant_type ***
		$f_opts = array();
		
		$f_opts['alias']='Вид завода';
		$f_opts['id']="production_plant_type";
						
		$f_production_plant_type=new FieldSQLEnum($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_plant_type",$f_opts);
		$this->addField($f_production_plant_type);
		//********************
		
		//*** Field production_base_id ***
		$f_opts = array();
		
		$f_opts['alias']='База';
		$f_opts['id']="production_base_id";
						
		$f_production_base_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_base_id",$f_opts);
		$this->addField($f_production_base_id);
		//********************
		
		//*** Field dispatcher_id ***
		$f_opts = array();
		
		$f_opts['alias']='Диспетчер (ТТН)';
		$f_opts['id']="dispatcher_id";
						
		$f_dispatcher_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"dispatcher_id",$f_opts);
		$this->addField($f_dispatcher_id);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_name,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
