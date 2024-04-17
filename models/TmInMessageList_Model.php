<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class TmInMessageList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('notifications');
		
		$this->setTableName("tm_in_messages_beton_list");
			
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
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field contacts_ref ***
		$f_opts = array();
		$f_opts['id']="contacts_ref";
						
		$f_contacts_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contacts_ref",$f_opts);
		$this->addField($f_contacts_ref);
		//********************
		
		//*** Field entity ***
		$f_opts = array();
		$f_opts['id']="entity";
						
		$f_entity=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"entity",$f_opts);
		$this->addField($f_entity);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
