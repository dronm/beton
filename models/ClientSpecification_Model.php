<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
 
class ClientSpecification_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("client_specifications");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field client_id ***
		$f_opts = array();
		
		$f_opts['alias']='Контрагент';
		$f_opts['id']="client_id";
						
		$f_client_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_id",$f_opts);
		$this->addField($f_client_id);
		//********************
		
		//*** Field client_contract_1c_ref ***
		$f_opts = array();
		$f_opts['length']=36;
		$f_opts['id']="client_contract_1c_ref";
						
		$f_client_contract_1c_ref=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_contract_1c_ref",$f_opts);
		$this->addField($f_client_contract_1c_ref);
		//********************
		
		//*** Field client_contract_id ***
		$f_opts = array();
		
		$f_opts['alias']='Объект';
		$f_opts['id']="client_contract_id";
						
		$f_client_contract_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_contract_id",$f_opts);
		$this->addField($f_client_contract_id);
		//********************
		
		//*** Field specification_date ***
		$f_opts = array();
		$f_opts['id']="specification_date";
						
		$f_specification_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"specification_date",$f_opts);
		$this->addField($f_specification_date);
		//********************
		
		//*** Field contract ***
		$f_opts = array();
		
		$f_opts['alias']='Договор';
		$f_opts['id']="contract";
						
		$f_contract=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contract",$f_opts);
		$this->addField($f_contract);
		//********************
		
		//*** Field specification ***
		$f_opts = array();
		
		$f_opts['alias']='Спецификация';
		$f_opts['id']="specification";
						
		$f_specification=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"specification",$f_opts);
		$this->addField($f_specification);
		//********************
		
		//*** Field concrete_type_id ***
		$f_opts = array();
		
		$f_opts['alias']='Марка';
		$f_opts['id']="concrete_type_id";
						
		$f_concrete_type_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"concrete_type_id",$f_opts);
		$this->addField($f_concrete_type_id);
		//********************
		
		//*** Field destination_id ***
		$f_opts = array();
		
		$f_opts['alias']='Объект';
		$f_opts['id']="destination_id";
						
		$f_destination_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destination_id",$f_opts);
		$this->addField($f_destination_id);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Количество';
		$f_opts['length']=19;
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
		
		//*** Field price ***
		$f_opts = array();
		
		$f_opts['alias']='Цена';
		$f_opts['length']=15;
		$f_opts['id']="price";
						
		$f_price=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"price",$f_opts);
		$this->addField($f_price);
		//********************
		
		//*** Field total ***
		$f_opts = array();
		
		$f_opts['alias']='Сумма';
		$f_opts['length']=15;
		$f_opts['id']="total";
						
		$f_total=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"total",$f_opts);
		$this->addField($f_total);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
