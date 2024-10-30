<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
 
class LeasorList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("leasors_list");
			
		//*** Field leasor ***
		$f_opts = array();
		$f_opts['id']="leasor";
						
		$f_leasor=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"leasor",$f_opts);
		$this->addField($f_leasor);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
