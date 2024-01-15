<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class GornyiCarrierMatchList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("gornyi_carrier_match_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field carrier_id ***
		$f_opts = array();
		
		$f_opts['alias']='Перевозчик';
		$f_opts['id']="carrier_id";
						
		$f_carrier_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"carrier_id",$f_opts);
		$this->addField($f_carrier_id);
		//********************
		
		//*** Field carriers_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Перевозчик';
		$f_opts['id']="carriers_ref";
						
		$f_carriers_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"carriers_ref",$f_opts);
		$this->addField($f_carriers_ref);
		//********************
		
		//*** Field plate ***
		$f_opts = array();
		$f_opts['length']=8;
		$f_opts['id']="plate";
						
		$f_plate=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"plate",$f_opts);
		$this->addField($f_plate);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
