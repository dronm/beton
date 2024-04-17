<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
 
class DestinationForSiteList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("");
			
		//*** Field address ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="address";
						
		$f_address=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"address",$f_opts);
		$this->addField($f_address);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
