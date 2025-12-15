<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
 
class AuditLogChange_Model extends {
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("");
			
		//*** Field name ***
		$f_opts = array();
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field new ***
		$f_opts = array();
		$f_opts['id']="new";
						
		$f_new=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"new",$f_opts);
		$this->addField($f_new);
		//********************
		
		//*** Field old ***
		$f_opts = array();
		$f_opts['id']="old";
						
		$f_old=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"old",$f_opts);
		$this->addField($f_old);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
