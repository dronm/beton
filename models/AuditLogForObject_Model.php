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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class AuditLogForObject_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("audit_log_dialog");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field table_name ***
		$f_opts = array();
		$f_opts['id']="table_name";
						
		$f_table_name=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"table_name",$f_opts);
		$this->addField($f_table_name);
		//********************
		
		//*** Field record_id ***
		$f_opts = array();
		$f_opts['id']="record_id";
						
		$f_record_id=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"record_id",$f_opts);
		$this->addField($f_record_id);
		//********************
		
		//*** Field operation ***
		$f_opts = array();
		$f_opts['length']=1;
		$f_opts['id']="operation";
						
		$f_operation=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"operation",$f_opts);
		$this->addField($f_operation);
		//********************
		
		//*** Field operation_descr ***
		$f_opts = array();
		$f_opts['id']="operation_descr";
						
		$f_operation_descr=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"operation_descr",$f_opts);
		$this->addField($f_operation_descr);
		//********************
		
		//*** Field changes ***
		$f_opts = array();
		$f_opts['id']="changes";
						
		$f_changes=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"changes",$f_opts);
		$this->addField($f_changes);
		//********************
		
		//*** Field changed_at ***
		$f_opts = array();
		$f_opts['defaultValue']='CURRENT_TIMESTAMP';
		$f_opts['id']="changed_at";
						
		$f_changed_at=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"changed_at",$f_opts);
		$this->addField($f_changed_at);
		//********************
		
		//*** Field changed_by ***
		$f_opts = array();
		$f_opts['id']="changed_by";
						
		$f_changed_by=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"changed_by",$f_opts);
		$this->addField($f_changed_by);
		//********************
		
		//*** Field object_ref ***
		$f_opts = array();
		$f_opts['id']="object_ref";
						
		$f_object_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"object_ref",$f_opts);
		$this->addField($f_object_ref);
		//********************
		
		//*** Field type_descr ***
		$f_opts = array();
		$f_opts['id']="type_descr";
						
		$f_type_descr=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"type_descr",$f_opts);
		$this->addField($f_type_descr);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
