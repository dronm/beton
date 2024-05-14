<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class OrderMakeForLabDialog_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("orders_make_for_lab_dialog");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
		//********************
		
		//*** Field concrete_types_ref ***
		$f_opts = array();
		$f_opts['id']="concrete_types_ref";
						
		$f_concrete_types_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"concrete_types_ref",$f_opts);
		$this->addField($f_concrete_types_ref);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
