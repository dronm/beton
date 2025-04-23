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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class OrderForTranspNaklList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("orders_for_transp_nakl_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Номер заявки';
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Дата заявки';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field orders_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Order';
		$f_opts['id']="orders_ref";
						
		$f_orders_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"orders_ref",$f_opts);
		$this->addField($f_orders_ref);
		//********************
		
		//*** Field order_num ***
		$f_opts = array();
		
		$f_opts['alias']='Order num';
		$f_opts['id']="order_num";
						
		$f_order_num=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"order_num",$f_opts);
		$this->addField($f_order_num);
		//********************
		
		//*** Field clients_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Клиент';
		$f_opts['id']="clients_ref";
						
		$f_clients_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"clients_ref",$f_opts);
		$this->addField($f_clients_ref);
		//********************
		
		//*** Field client_descr ***
		$f_opts = array();
		
		$f_opts['alias']='Клиент';
		$f_opts['id']="client_descr";
						
		$f_client_descr=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_descr",$f_opts);
		$this->addField($f_client_descr);
		//********************
		
		//*** Field client_ref_1c_exists ***
		$f_opts = array();
		$f_opts['id']="client_ref_1c_exists";
						
		$f_client_ref_1c_exists=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_ref_1c_exists",$f_opts);
		$this->addField($f_client_ref_1c_exists);
		//********************
		
		//*** Field destinations_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Объект';
		$f_opts['id']="destinations_ref";
						
		$f_destinations_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destinations_ref",$f_opts);
		$this->addField($f_destinations_ref);
		//********************
		
		//*** Field concrete_types_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Марка';
		$f_opts['id']="concrete_types_ref";
						
		$f_concrete_types_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"concrete_types_ref",$f_opts);
		$this->addField($f_concrete_types_ref);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Кол-во в заявке,м3';
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_client_descr,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
