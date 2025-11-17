<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLDOC.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSONB.php');
 
class ExtProduction_Model extends ModelSQLDOC{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("ext_productions");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field ext_id ***
		$f_opts = array();
		$f_opts['id']="ext_id";
						
		$f_ext_id=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ext_id",$f_opts);
		$this->addField($f_ext_id);
		//********************
		
		//*** Field production_site_id ***
		$f_opts = array();
		$f_opts['id']="production_site_id";
						
		$f_production_site_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_site_id",$f_opts);
		$this->addField($f_production_site_id);
		//********************
		
		//*** Field updated_at ***
		$f_opts = array();
		
		$f_opts['alias']='Время последнего изменения';
		$f_opts['defaultValue']='CURRENT_TIMESTAMP';
		$f_opts['id']="updated_at";
						
		$f_updated_at=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"updated_at",$f_opts);
		$this->addField($f_updated_at);
		//********************
		
		//*** Field head ***
		$f_opts = array();
		$f_opts['id']="head";
						
		$f_head=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"head",$f_opts);
		$this->addField($f_head);
		//********************
		
		//*** Field materials ***
		$f_opts = array();
		$f_opts['id']="materials";
						
		$f_materials=new FieldSQLJSONB($this->getDbLink(),$this->getDbName(),$this->getTableName(),"materials",$f_opts);
		$this->addField($f_materials);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_id,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
