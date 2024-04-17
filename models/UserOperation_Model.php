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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
 
class UserOperation_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("user_operations");
			
		//*** Field user_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=FALSE;
		$f_opts['id']="user_id";
						
		$f_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"user_id",$f_opts);
		$this->addField($f_user_id);
		//********************
		
		//*** Field operation_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=FALSE;
		$f_opts['length']=36;
		$f_opts['id']="operation_id";
						
		$f_operation_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"operation_id",$f_opts);
		$this->addField($f_operation_id);
		//********************
		
		//*** Field operation ***
		$f_opts = array();
		$f_opts['id']="operation";
						
		$f_operation=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"operation",$f_opts);
		$this->addField($f_operation);
		//********************
		
		//*** Field status ***
		$f_opts = array();
		$f_opts['id']="status";
						
		$f_status=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"status",$f_opts);
		$this->addField($f_status);
		//********************
		
		//*** Field percent ***
		$f_opts = array();
		$f_opts['id']="percent";
						
		$f_percent=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"percent",$f_opts);
		$this->addField($f_percent);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['defaultValue']='CURRENT_TIMESTAMP';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field error_text ***
		$f_opts = array();
		$f_opts['id']="error_text";
						
		$f_error_text=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"error_text",$f_opts);
		$this->addField($f_error_text);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
		//********************
		
		//*** Field date_time_end ***
		$f_opts = array();
		$f_opts['id']="date_time_end";
						
		$f_date_time_end=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time_end",$f_opts);
		$this->addField($f_date_time_end);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
