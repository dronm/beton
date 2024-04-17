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
 
class UserMacAddress_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("user_mac_addresses");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field user_id ***
		$f_opts = array();
		$f_opts['id']="user_id";
						
		$f_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"user_id",$f_opts);
		$this->addField($f_user_id);
		//********************
		
		//*** Field mac_address ***
		$f_opts = array();
		$f_opts['length']=17;
		$f_opts['id']="mac_address";
						
		$f_mac_address=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"mac_address",$f_opts);
		$this->addField($f_mac_address);
		//********************
		
		//*** Field mac_address_hash ***
		$f_opts = array();
		$f_opts['length']=32;
		$f_opts['id']="mac_address_hash";
						
		$f_mac_address_hash=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"mac_address_hash",$f_opts);
		$this->addField($f_mac_address_hash);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
