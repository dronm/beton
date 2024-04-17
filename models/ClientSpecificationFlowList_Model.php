<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class ClientSpecificationFlowList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("client_specification_flows_list");
			
		//*** Field client_specification_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="client_specification_id";
						
		$f_client_specification_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_specification_id",$f_opts);
		$this->addField($f_client_specification_id);
		//********************
		
		//*** Field shipment_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="shipment_id";
						
		$f_shipment_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipment_id",$f_opts);
		$this->addField($f_shipment_id);
		//********************
		
		//*** Field client_specifications_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Спецификация';
		$f_opts['id']="client_specifications_ref";
						
		$f_client_specifications_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_specifications_ref",$f_opts);
		$this->addField($f_client_specifications_ref);
		//********************
		
		//*** Field shipments_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Отгрузка';
		$f_opts['id']="shipments_ref";
						
		$f_shipments_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipments_ref",$f_opts);
		$this->addField($f_shipments_ref);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Количество';
		$f_opts['length']=19;
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
