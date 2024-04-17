<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
 
class TmUser_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('notifications');
		
		$this->setTableName("ext_users");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field ext_contact_id ***
		$f_opts = array();
		$f_opts['id']="ext_contact_id";
						
		$f_ext_contact_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ext_contact_id",$f_opts);
		$this->addField($f_ext_contact_id);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
