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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class TmOutMessageList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('notifications');
		
		$this->setTableName("tm_out_messages_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field app_id ***
		$f_opts = array();
		$f_opts['id']="app_id";
						
		$f_app_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"app_id",$f_opts);
		$this->addField($f_app_id);
		//********************
		
		//*** Field message ***
		$f_opts = array();
		$f_opts['id']="message";
						
		$f_message=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"message",$f_opts);
		$this->addField($f_message);
		//********************
		
		//*** Field sent_date_time ***
		$f_opts = array();
		$f_opts['id']="sent_date_time";
						
		$f_sent_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sent_date_time",$f_opts);
		$this->addField($f_sent_date_time);
		//********************
		
		//*** Field sent ***
		$f_opts = array();
		$f_opts['defaultValue']='false';
		$f_opts['id']="sent";
						
		$f_sent=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sent",$f_opts);
		$this->addField($f_sent);
		//********************
		
		//*** Field ext_obj ***
		$f_opts = array();
		$f_opts['id']="ext_obj";
						
		$f_ext_obj=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ext_obj",$f_opts);
		$this->addField($f_ext_obj);
		//********************
		
		//*** Field first_name ***
		$f_opts = array();
		$f_opts['id']="first_name";
						
		$f_first_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"first_name",$f_opts);
		$this->addField($f_first_name);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_sent_date_time,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
