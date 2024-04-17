<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
 
class ViewSectionList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("views_section_list");
			
		//*** Field section ***
		$f_opts = array();
		$f_opts['id']="section";
						
		$f_section=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"section",$f_opts);
		$this->addField($f_section);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
