<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
 
class UserChatStatus_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("user_chat_statuses");
			
		//*** Field user_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="user_id";
						
		$f_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"user_id",$f_opts);
		$this->addField($f_user_id);
		//********************
		
		//*** Field chat_status_id ***
		$f_opts = array();
		$f_opts['id']="chat_status_id";
						
		$f_chat_status_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"chat_status_id",$f_opts);
		$this->addField($f_chat_status_id);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
