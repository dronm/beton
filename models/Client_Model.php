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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class Client_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("clients");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='Наименование';
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
		
		//*** Field phone_cel ***
		$f_opts = array();
		
		$f_opts['alias']='Сотовый телефон';
		$f_opts['length']=15;
		$f_opts['id']="phone_cel";
						
		$f_phone_cel=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"phone_cel",$f_opts);
		$this->addField($f_phone_cel);
		//********************
		
		//*** Field manager_comment ***
		$f_opts = array();
		
		$f_opts['alias']='Комментарий';
		$f_opts['id']="manager_comment";
						
		$f_manager_comment=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"manager_comment",$f_opts);
		$this->addField($f_manager_comment);
		//********************
		
		//*** Field client_type_id ***
		$f_opts = array();
		
		$f_opts['alias']='Вид контрагента';
		$f_opts['id']="client_type_id";
						
		$f_client_type_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_type_id",$f_opts);
		$this->addField($f_client_type_id);
		//********************
		
		//*** Field client_kind ***
		$f_opts = array();
		
		$f_opts['alias']='Тип контрагента';
		$f_opts['id']="client_kind";
						
		$f_client_kind=new FieldSQLEnum($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_kind",$f_opts);
		$this->addField($f_client_kind);
		//********************
		
		//*** Field client_come_from_id ***
		$f_opts = array();
		
		$f_opts['alias']='Источник обращения';
		$f_opts['id']="client_come_from_id";
						
		$f_client_come_from_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_come_from_id",$f_opts);
		$this->addField($f_client_come_from_id);
		//********************
		
		//*** Field manager_id ***
		$f_opts = array();
		
		$f_opts['alias']='Менеджер';
		$f_opts['id']="manager_id";
						
		$f_manager_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"manager_id",$f_opts);
		$this->addField($f_manager_id);
		//********************
		
		//*** Field create_date ***
		$f_opts = array();
		$f_opts['id']="create_date";
						
		$f_create_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"create_date",$f_opts);
		$this->addField($f_create_date);
		//********************
		
		//*** Field email ***
		$f_opts = array();
		$f_opts['length']=50;
		$f_opts['id']="email";
						
		$f_email=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"email",$f_opts);
		$this->addField($f_email);
		//********************
		
		//*** Field inn ***
		$f_opts = array();
		$f_opts['length']=12;
		$f_opts['id']="inn";
						
		$f_inn=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"inn",$f_opts);
		$this->addField($f_inn);
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
		
		//*** Field tels_1c ***
		$f_opts = array();
		$f_opts['id']="tels_1c";
						
		$f_tels_1c=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tels_1c",$f_opts);
		$this->addField($f_tels_1c);
		//********************
		
		//*** Field user_id ***
		$f_opts = array();
		
		$f_opts['alias']='Аккаунт';
		$f_opts['id']="user_id";
						
		$f_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"user_id",$f_opts);
		$this->addField($f_user_id);
		//********************
		
		//*** Field account_from_date ***
		$f_opts = array();
		
		$f_opts['alias']='Дата начала выборки данных';
		$f_opts['id']="account_from_date";
						
		$f_account_from_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"account_from_date",$f_opts);
		$this->addField($f_account_from_date);
		//********************
		
		//*** Field bank_bik ***
		$f_opts = array();
		
		$f_opts['alias']='БИК банка';
		$f_opts['length']=9;
		$f_opts['id']="bank_bik";
						
		$f_bank_bik=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"bank_bik",$f_opts);
		$this->addField($f_bank_bik);
		//********************
		
		//*** Field bank_account ***
		$f_opts = array();
		
		$f_opts['alias']='Банковский счет';
		$f_opts['length']=20;
		$f_opts['id']="bank_account";
						
		$f_bank_account=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"bank_account",$f_opts);
		$this->addField($f_bank_account);
		//********************
		
		//*** Field ref_1c ***
		$f_opts = array();
		
		$f_opts['alias']='Ссылка на справочник 1с';
		$f_opts['id']="ref_1c";
						
		$f_ref_1c=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref_1c",$f_opts);
		$this->addField($f_ref_1c);
		//********************
		
		//*** Field shipment_quant_for_cost ***
		$f_opts = array();
		$f_opts['length']=19;
		$f_opts['id']="shipment_quant_for_cost";
						
		$f_shipment_quant_for_cost=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipment_quant_for_cost",$f_opts);
		$this->addField($f_shipment_quant_for_cost);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_name,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
