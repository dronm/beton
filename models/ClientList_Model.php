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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class ClientList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("clients_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='Наименование';
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field manager_comment ***
		$f_opts = array();
		$f_opts['id']="manager_comment";
						
		$f_manager_comment=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"manager_comment",$f_opts);
		$this->addField($f_manager_comment);
		//********************
		
		//*** Field client_type_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="client_type_id";
						
		$f_client_type_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_type_id",$f_opts);
		$this->addField($f_client_type_id);
		//********************
		
		//*** Field client_types_ref ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="client_types_ref";
						
		$f_client_types_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_types_ref",$f_opts);
		$this->addField($f_client_types_ref);
		//********************
		
		//*** Field client_come_from_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Источник';
		$f_opts['id']="client_come_from_ref";
						
		$f_client_come_from_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_come_from_ref",$f_opts);
		$this->addField($f_client_come_from_ref);
		//********************
		
		//*** Field client_come_from_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="client_come_from_id";
						
		$f_client_come_from_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_come_from_id",$f_opts);
		$this->addField($f_client_come_from_id);
		//********************
		
		//*** Field phone_cel ***
		$f_opts = array();
		
		$f_opts['alias']='Телефон';
		$f_opts['id']="phone_cel";
						
		$f_phone_cel=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"phone_cel",$f_opts);
		$this->addField($f_phone_cel);
		//********************
		
		//*** Field ours ***
		$f_opts = array();
		
		$f_opts['alias']='Наш';
		$f_opts['id']="ours";
						
		$f_ours=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ours",$f_opts);
		$this->addField($f_ours);
		//********************
		
		//*** Field client_kind ***
		$f_opts = array();
		
		$f_opts['alias']='Вид клиента';
		$f_opts['id']="client_kind";
						
		$f_client_kind=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_kind",$f_opts);
		$this->addField($f_client_kind);
		//********************
		
		//*** Field email ***
		$f_opts = array();
		
		$f_opts['alias']='Email';
		$f_opts['id']="email";
						
		$f_email=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"email",$f_opts);
		$this->addField($f_email);
		//********************
		
		//*** Field first_call_date ***
		$f_opts = array();
		
		$f_opts['alias']='Первое обращение';
		$f_opts['id']="first_call_date";
						
		$f_first_call_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"first_call_date",$f_opts);
		$this->addField($f_first_call_date);
		//********************
		
		//*** Field users_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Кто завел';
		$f_opts['id']="users_ref";
						
		$f_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"users_ref",$f_opts);
		$this->addField($f_users_ref);
		//********************
		
		//*** Field inn ***
		$f_opts = array();
		
		$f_opts['alias']='ИНН';
		$f_opts['id']="inn";
						
		$f_inn=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"inn",$f_opts);
		$this->addField($f_inn);
		//********************
		
		//*** Field accounts_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Аккаунт';
		$f_opts['id']="accounts_ref";
						
		$f_accounts_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"accounts_ref",$f_opts);
		$this->addField($f_accounts_ref);
		//********************
		
		//*** Field contact_list ***
		$f_opts = array();
		
		$f_opts['alias']='Контакты';
		$f_opts['id']="contact_list";
						
		$f_contact_list=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_list",$f_opts);
		$this->addField($f_contact_list);
		//********************
		
		//*** Field contact_ids ***
		$f_opts = array();
		
		$f_opts['alias']='Ids for filter';
		$f_opts['id']="contact_ids";
						
		$f_contact_ids=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_ids",$f_opts);
		$this->addField($f_contact_ids);
		//********************
		
		//*** Field descr ***
		$f_opts = array();
		$f_opts['id']="descr";
						
		$f_descr=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"descr",$f_opts);
		$this->addField($f_descr);
		//********************
		
		//*** Field ref_1c_exists ***
		$f_opts = array();
		$f_opts['id']="ref_1c_exists";
						
		$f_ref_1c_exists=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref_1c_exists",$f_opts);
		$this->addField($f_ref_1c_exists);
		//********************
		
		//*** Field shipment_quant_for_cost ***
		$f_opts = array();
		$f_opts['length']=19;
		$f_opts['id']="shipment_quant_for_cost";
						
		$f_shipment_quant_for_cost=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipment_quant_for_cost",$f_opts);
		$this->addField($f_shipment_quant_for_cost);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
