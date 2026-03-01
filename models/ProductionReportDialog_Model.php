<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class ProductionReportDialog_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("production_reports_dialog");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field shift_from ***
		$f_opts = array();
		$f_opts['id']="shift_from";
						
		$f_shift_from=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shift_from",$f_opts);
		$this->addField($f_shift_from);
		//********************
		
		//*** Field shift_to ***
		$f_opts = array();
		$f_opts['id']="shift_to";
						
		$f_shift_to=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shift_to",$f_opts);
		$this->addField($f_shift_to);
		//********************
		
		//*** Field ref_1c ***
		$f_opts = array();
		
		$f_opts['alias']='Ссылка на документ 1с';
		$f_opts['id']="ref_1c";
						
		$f_ref_1c=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ref_1c",$f_opts);
		$this->addField($f_ref_1c);
		//********************
		
		//*** Field material_ref_1c ***
		$f_opts = array();
		
		$f_opts['alias']='Требование накладная';
		$f_opts['id']="material_ref_1c";
						
		$f_material_ref_1c=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"material_ref_1c",$f_opts);
		$this->addField($f_material_ref_1c);
		//********************
		
		//*** Field items ***
		$f_opts = array();
		$f_opts['id']="items";
						
		$f_items=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"items",$f_opts);
		$this->addField($f_items);
		//********************
		
		//*** Field materials ***
		$f_opts = array();
		$f_opts['id']="materials";
						
		$f_materials=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"materials",$f_opts);
		$this->addField($f_materials);
		//********************
		
		//*** Field date_for_1c ***
		$f_opts = array();
		$f_opts['id']="date_for_1c";
						
		$f_date_for_1c=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_for_1c",$f_opts);
		$this->addField($f_date_for_1c);
		//********************
		
		//*** Field date_for_1c_current ***
		$f_opts = array();
		$f_opts['id']="date_for_1c_current";
						
		$f_date_for_1c_current=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_for_1c_current",$f_opts);
		$this->addField($f_date_for_1c_current);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
