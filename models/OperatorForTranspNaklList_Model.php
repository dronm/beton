<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class OperatorForTranspNaklList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("operators_for_transp_nakls_list");
			
		//*** Field user_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['id']="user_id";
						
		$f_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"user_id",$f_opts);
		$this->addField($f_user_id);
		//********************
		
		//*** Field production_site_id ***
		$f_opts = array();
		$f_opts['id']="production_site_id";
						
		$f_production_site_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_site_id",$f_opts);
		$this->addField($f_production_site_id);
		//********************
		
		//*** Field production_sites_ref ***
		$f_opts = array();
		$f_opts['id']="production_sites_ref";
						
		$f_production_sites_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_sites_ref",$f_opts);
		$this->addField($f_production_sites_ref);
		//********************
		
		//*** Field users_ref ***
		$f_opts = array();
		$f_opts['id']="users_ref";
						
		$f_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"users_ref",$f_opts);
		$this->addField($f_users_ref);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
