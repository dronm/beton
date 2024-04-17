<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class EntityContactList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("entity_contacts_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field entity_type ***
		$f_opts = array();
		$f_opts['id']="entity_type";
						
		$f_entity_type=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"entity_type",$f_opts);
		$this->addField($f_entity_type);
		//********************
		
		//*** Field entity_id ***
		$f_opts = array();
		$f_opts['id']="entity_id";
						
		$f_entity_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"entity_id",$f_opts);
		$this->addField($f_entity_id);
		//********************
		
		//*** Field entities_ref ***
		$f_opts = array();
		$f_opts['id']="entities_ref";
						
		$f_entities_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"entities_ref",$f_opts);
		$this->addField($f_entities_ref);
		//********************
		
		//*** Field contact_id ***
		$f_opts = array();
		$f_opts['id']="contact_id";
						
		$f_contact_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_id",$f_opts);
		$this->addField($f_contact_id);
		//********************
		
		//*** Field contact_name ***
		$f_opts = array();
		$f_opts['id']="contact_name";
						
		$f_contact_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_name",$f_opts);
		$this->addField($f_contact_name);
		//********************
		
		//*** Field contact_attrs ***
		$f_opts = array();
		$f_opts['id']="contact_attrs";
						
		$f_contact_attrs=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_attrs",$f_opts);
		$this->addField($f_contact_attrs);
		//********************
		
		//*** Field contacts_ref ***
		$f_opts = array();
		$f_opts['id']="contacts_ref";
						
		$f_contacts_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contacts_ref",$f_opts);
		$this->addField($f_contacts_ref);
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
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
