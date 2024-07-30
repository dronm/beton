<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class CementSiloMaterialList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("cement_silo_materials_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field cement_silo_id ***
		$f_opts = array();
		$f_opts['id']="cement_silo_id";
						
		$f_cement_silo_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"cement_silo_id",$f_opts);
		$this->addField($f_cement_silo_id);
		//********************
		
		//*** Field cement_silos_ref ***
		$f_opts = array();
		$f_opts['id']="cement_silos_ref";
						
		$f_cement_silos_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"cement_silos_ref",$f_opts);
		$this->addField($f_cement_silos_ref);
		//********************
		
		//*** Field materials_ref ***
		$f_opts = array();
		$f_opts['id']="materials_ref";
						
		$f_materials_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"materials_ref",$f_opts);
		$this->addField($f_materials_ref);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
