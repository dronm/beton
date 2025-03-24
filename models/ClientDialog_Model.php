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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class ClientDialog_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("clients_dialog");
			
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
		
		//*** Field name_full ***
		$f_opts = array();
		
		$f_opts['alias']='Полное наименование';
		$f_opts['id']="name_full";
						
		$f_name_full=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name_full",$f_opts);
		$this->addField($f_name_full);
		//********************
		
		//*** Field manager_comment ***
		$f_opts = array();
		
		$f_opts['alias']='Комментарий';
		$f_opts['id']="manager_comment";
						
		$f_manager_comment=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"manager_comment",$f_opts);
		$this->addField($f_manager_comment);
		//********************
		
		//*** Field client_types_ref ***
		$f_opts = array();
		$f_opts['id']="client_types_ref";
						
		$f_client_types_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_types_ref",$f_opts);
		$this->addField($f_client_types_ref);
		//********************
		
		//*** Field client_come_from_ref ***
		$f_opts = array();
		$f_opts['id']="client_come_from_ref";
						
		$f_client_come_from_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_come_from_ref",$f_opts);
		$this->addField($f_client_come_from_ref);
		//********************
		
		//*** Field phone_cel ***
		$f_opts = array();
		$f_opts['id']="phone_cel";
						
		$f_phone_cel=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"phone_cel",$f_opts);
		$this->addField($f_phone_cel);
		//********************
		
		//*** Field email ***
		$f_opts = array();
		$f_opts['id']="email";
						
		$f_email=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"email",$f_opts);
		$this->addField($f_email);
		//********************
		
		//*** Field client_kind ***
		$f_opts = array();
		$f_opts['id']="client_kind";
						
		$f_client_kind=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_kind",$f_opts);
		$this->addField($f_client_kind);
		//********************
		
		//*** Field users_ref ***
		$f_opts = array();
		$f_opts['id']="users_ref";
						
		$f_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"users_ref",$f_opts);
		$this->addField($f_users_ref);
		//********************
		
		//*** Field inn ***
		$f_opts = array();
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
		
		//*** Field account_from_date ***
		$f_opts = array();
		$f_opts['id']="account_from_date";
						
		$f_account_from_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"account_from_date",$f_opts);
		$this->addField($f_account_from_date);
		//********************
		
		//*** Field bank_account ***
		$f_opts = array();
		
		$f_opts['alias']='Банковский счет';
		$f_opts['id']="bank_account";
						
		$f_bank_account=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"bank_account",$f_opts);
		$this->addField($f_bank_account);
		//********************
		
		//*** Field banks_ref ***
		$f_opts = array();
		
		$f_opts['alias']='БИК банка';
		$f_opts['id']="banks_ref";
						
		$f_banks_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"banks_ref",$f_opts);
		$this->addField($f_banks_ref);
		//********************
		
		//*** Field kpp ***
		$f_opts = array();
		$f_opts['length']=10;
		$f_opts['id']="kpp";
						
		$f_kpp=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"kpp",$f_opts);
		$this->addField($f_kpp);
		//********************
		
		//*** Field address_legal ***
		$f_opts = array();
		$f_opts['id']="address_legal";
						
		$f_address_legal=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"address_legal",$f_opts);
		$this->addField($f_address_legal);
		//********************
		
		//*** Field address_fact ***
		$f_opts = array();
		$f_opts['id']="address_fact";
						
		$f_address_fact=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"address_fact",$f_opts);
		$this->addField($f_address_fact);
		//********************
		
		//*** Field ref_1c ***
		$f_opts = array();
		$f_opts['id']="ref_1c";
						
		$f_ref_1c=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref_1c",$f_opts);
		$this->addField($f_ref_1c);
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
