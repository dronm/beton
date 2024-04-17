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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class TmUserDialog_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('notifications');
		
		$this->setTableName("ext_users_dialog");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field tm_id ***
		$f_opts = array();
		$f_opts['id']="tm_id";
						
		$f_tm_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_id",$f_opts);
		$this->addField($f_tm_id);
		//********************
		
		//*** Field tm_first_name ***
		$f_opts = array();
		$f_opts['id']="tm_first_name";
						
		$f_tm_first_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_first_name",$f_opts);
		$this->addField($f_tm_first_name);
		//********************
		
		//*** Field ext_obj ***
		$f_opts = array();
		$f_opts['id']="ext_obj";
						
		$f_ext_obj=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ext_obj",$f_opts);
		$this->addField($f_ext_obj);
		//********************
		
		//*** Field app_id ***
		$f_opts = array();
		$f_opts['id']="app_id";
						
		$f_app_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"app_id",$f_opts);
		$this->addField($f_app_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field tm_photo ***
		$f_opts = array();
		$f_opts['id']="tm_photo";
						
		$f_tm_photo=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_photo",$f_opts);
		$this->addField($f_tm_photo);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
