<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class MaxUserList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('notifications');
		
		$this->setTableName("max_users_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field max_user_id ***
		$f_opts = array();
		$f_opts['id']="max_user_id";
						
		$f_max_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"max_user_id",$f_opts);
		$this->addField($f_max_user_id);
		//********************
		
		//*** Field username ***
		$f_opts = array();
		$f_opts['id']="username";
						
		$f_username=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"username",$f_opts);
		$this->addField($f_username);
		//********************
		
		//*** Field avatar_url ***
		$f_opts = array();
		$f_opts['id']="avatar_url";
						
		$f_avatar_url=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"avatar_url",$f_opts);
		$this->addField($f_avatar_url);
		//********************
		
		//*** Field raw_user ***
		$f_opts = array();
		$f_opts['id']="raw_user";
						
		$f_raw_user=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"raw_user",$f_opts);
		$this->addField($f_raw_user);
		//********************
		
		//*** Field raw_user_with_phote ***
		$f_opts = array();
		$f_opts['id']="raw_user_with_phote";
						
		$f_raw_user_with_phote=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"raw_user_with_phote",$f_opts);
		$this->addField($f_raw_user_with_phote);
		//********************
		
		//*** Field contacts_ref ***
		$f_opts = array();
		$f_opts['id']="contacts_ref";
						
		$f_contacts_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contacts_ref",$f_opts);
		$this->addField($f_contacts_ref);
		//********************
		
		//*** Field updated_at ***
		$f_opts = array();
		$f_opts['id']="updated_at";
						
		$f_updated_at=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"updated_at",$f_opts);
		$this->addField($f_updated_at);
		//********************
		
		//*** Field contacts_tel ***
		$f_opts = array();
		$f_opts['id']="contacts_tel";
						
		$f_contacts_tel=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contacts_tel",$f_opts);
		$this->addField($f_contacts_tel);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_updated_at,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
