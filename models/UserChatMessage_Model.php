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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class UserChatMessage_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('notifications');
		
		$this->setTableName("user_chat_messages");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['defaultValue']='CURRENT_TIMESTAMP';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field from_user ***
		$f_opts = array();
		$f_opts['id']="from_user";
						
		$f_from_user=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"from_user",$f_opts);
		$this->addField($f_from_user);
		//********************
		
		//*** Field to_user ***
		$f_opts = array();
		$f_opts['id']="to_user";
						
		$f_to_user=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"to_user",$f_opts);
		$this->addField($f_to_user);
		//********************
		
		//*** Field media_type ***
		$f_opts = array();
		$f_opts['id']="media_type";
						
		$f_media_type=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"media_type",$f_opts);
		$this->addField($f_media_type);
		//********************
		
		//*** Field message ***
		$f_opts = array();
		$f_opts['id']="message";
						
		$f_message=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"message",$f_opts);
		$this->addField($f_message);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
