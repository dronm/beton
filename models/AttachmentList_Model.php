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
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class AttachmentList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("attachments_list");
			
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
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field ref ***
		$f_opts = array();
		$f_opts['id']="ref";
						
		$f_ref=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref",$f_opts);
		$this->addField($f_ref);
		//********************
		
		//*** Field content_info ***
		$f_opts = array();
		$f_opts['id']="content_info";
						
		$f_content_info=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"content_info",$f_opts);
		$this->addField($f_content_info);
		//********************
		
		//*** Field content_preview ***
		$f_opts = array();
		$f_opts['id']="content_preview";
						
		$f_content_preview=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"content_preview",$f_opts);
		$this->addField($f_content_preview);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_date_time,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
