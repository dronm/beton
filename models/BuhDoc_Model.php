<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class BuhDoc_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("buh_docs");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field ref_1c ***
		$f_opts = array();
		
		$f_opts['alias']='Ссылка на документ 1с';
		$f_opts['id']="ref_1c";
						
		$f_ref_1c=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref_1c",$f_opts);
		$this->addField($f_ref_1c);
		//********************
		
		//*** Field faktura_ref_1c ***
		$f_opts = array();
		$f_opts['id']="faktura_ref_1c";
						
		$f_faktura_ref_1c=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"faktura_ref_1c",$f_opts);
		$this->addField($f_faktura_ref_1c);
		//********************
		
		//*** Field items ***
		$f_opts = array();
		$f_opts['id']="items";
						
		$f_items=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"items",$f_opts);
		$this->addField($f_items);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
