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
 
class MaxOutMessageList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('notifications');
		
		$this->setTableName("max_out_messages_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field message ***
		$f_opts = array();
		$f_opts['id']="message";
						
		$f_message=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"message",$f_opts);
		$this->addField($f_message);
		//********************
		
		//*** Field created_at ***
		$f_opts = array();
		$f_opts['id']="created_at";
						
		$f_created_at=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"created_at",$f_opts);
		$this->addField($f_created_at);
		//********************
		
		//*** Field sent_at ***
		$f_opts = array();
		$f_opts['id']="sent_at";
						
		$f_sent_at=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sent_at",$f_opts);
		$this->addField($f_sent_at);
		//********************
		
		//*** Field max_chat_id ***
		$f_opts = array();
		$f_opts['id']="max_chat_id";
						
		$f_max_chat_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"max_chat_id",$f_opts);
		$this->addField($f_max_chat_id);
		//********************
		
		//*** Field contact_id ***
		$f_opts = array();
		$f_opts['id']="contact_id";
						
		$f_contact_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_id",$f_opts);
		$this->addField($f_contact_id);
		//********************
		
		//*** Field contacts_ref ***
		$f_opts = array();
		$f_opts['id']="contacts_ref";
						
		$f_contacts_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contacts_ref",$f_opts);
		$this->addField($f_contacts_ref);
		//********************
		
		//*** Field error_str ***
		$f_opts = array();
		$f_opts['id']="error_str";
						
		$f_error_str=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"error_str",$f_opts);
		$this->addField($f_error_str);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_created_at,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
