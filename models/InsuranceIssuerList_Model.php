<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
 
class InsuranceIssuerList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("insurance_issuers_list");
			
		//*** Field issuer ***
		$f_opts = array();
		$f_opts['id']="issuer";
						
		$f_issuer=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"issuer",$f_opts);
		$this->addField($f_issuer);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
