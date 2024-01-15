<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class OrderDescr_Model extends {
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("");
			
		//*** Field descr ***
		$f_opts = array();
		$f_opts['id']="descr";
						
		$f_descr=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"descr",$f_opts);
		$this->addField($f_descr);
		//********************
		
		//*** Field phone_cel ***
		$f_opts = array();
		$f_opts['id']="phone_cel";
						
		$f_phone_cel=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"phone_cel",$f_opts);
		$this->addField($f_phone_cel);
		//********************
		
		//*** Field langs_ref ***
		$f_opts = array();
		$f_opts['id']="langs_ref";
						
		$f_langs_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"langs_ref",$f_opts);
		$this->addField($f_langs_ref);
		//********************
		
		//*** Field clients_ref ***
		$f_opts = array();
		$f_opts['id']="clients_ref";
						
		$f_clients_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"clients_ref",$f_opts);
		$this->addField($f_clients_ref);
		//********************
		
		//*** Field client_tels_ref ***
		$f_opts = array();
		$f_opts['id']="client_tels_ref";
						
		$f_client_tels_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_tels_ref",$f_opts);
		$this->addField($f_client_tels_ref);
		//********************
		
		//*** Field tm_exists ***
		$f_opts = array();
		$f_opts['id']="tm_exists";
						
		$f_tm_exists=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_exists",$f_opts);
		$this->addField($f_tm_exists);
		//********************
		
		//*** Field tm_activated ***
		$f_opts = array();
		$f_opts['id']="tm_activated";
						
		$f_tm_activated=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tm_activated",$f_opts);
		$this->addField($f_tm_activated);
		//********************
		
		//*** Field contact_id ***
		$f_opts = array();
		$f_opts['id']="contact_id";
						
		$f_contact_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_id",$f_opts);
		$this->addField($f_contact_id);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
