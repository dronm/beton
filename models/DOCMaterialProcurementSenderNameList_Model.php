<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLDOC.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
 
class DOCMaterialProcurementSenderNameList_Model extends ModelSQLDOC{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("doc_material_procurements_sender_name_list");
			
		//*** Field sender_name ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Пункт отправления';
		$f_opts['id']="sender_name";
						
		$f_sender_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sender_name",$f_opts);
		$this->addField($f_sender_name);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
