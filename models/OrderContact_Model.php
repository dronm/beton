<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
 
class OrderContact_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("order_contacts");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field order_id ***
		$f_opts = array();
		$f_opts['id']="order_id";
						
		$f_order_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"order_id",$f_opts);
		$this->addField($f_order_id);
		//********************
		
		//*** Field contact_id ***
		$f_opts = array();
		$f_opts['id']="contact_id";
						
		$f_contact_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_id",$f_opts);
		$this->addField($f_contact_id);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
