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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class SupplierList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("suppliers_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='Наименование';
		$f_opts['length']=100;
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field contact_list ***
		$f_opts = array();
		
		$f_opts['alias']='Контакты';
		$f_opts['id']="contact_list";
						
		$f_contact_list=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_list",$f_opts);
		$this->addField($f_contact_list);
		//********************
		
		//*** Field contact_ids ***
		$f_opts = array();
		
		$f_opts['alias']='Контакты';
		$f_opts['id']="contact_ids";
						
		$f_contact_ids=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_ids",$f_opts);
		$this->addField($f_contact_ids);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
