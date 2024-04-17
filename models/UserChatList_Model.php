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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class UserChatList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("user_chat_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='Пользователь';
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field name_short ***
		$f_opts = array();
		
		$f_opts['alias']='Пользователm ФИО';
		$f_opts['id']="name_short";
						
		$f_name_short=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name_short",$f_opts);
		$this->addField($f_name_short);
		//********************
		
		//*** Field chat_statuses_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Статус';
		$f_opts['id']="chat_statuses_ref";
						
		$f_chat_statuses_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"chat_statuses_ref",$f_opts);
		$this->addField($f_chat_statuses_ref);
		//********************
		
		//*** Field role_id ***
		$f_opts = array();
		
		$f_opts['alias']='Роль';
		$f_opts['id']="role_id";
						
		$f_role_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"role_id",$f_opts);
		$this->addField($f_role_id);
		//********************
		
		//*** Field is_online ***
		$f_opts = array();
		
		$f_opts['alias']='В сети';
		$f_opts['id']="is_online";
						
		$f_is_online=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"is_online",$f_opts);
		$this->addField($f_is_online);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
