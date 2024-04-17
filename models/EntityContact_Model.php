<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
 
class EntityContact_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("entity_contacts");
			
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
						
		$f_entity_type=new FieldSQLEnum($this->getDbLink(),$this->getDbName(),$this->getTableName(),"entity_type",$f_opts);
		$this->addField($f_entity_type);
		//********************
		
		//*** Field entity_id ***
		$f_opts = array();
		$f_opts['id']="entity_id";
						
		$f_entity_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"entity_id",$f_opts);
		$this->addField($f_entity_id);
		//********************
		
		//*** Field contact_id ***
		$f_opts = array();
		$f_opts['id']="contact_id";
						
		$f_contact_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"contact_id",$f_opts);
		$this->addField($f_contact_id);
		//********************
		
		//*** Field mod_date_time ***
		$f_opts = array();
		$f_opts['defaultValue']='CURRENT_TIMESTAMP';
		$f_opts['id']="mod_date_time";
						
		$f_mod_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"mod_date_time",$f_opts);
		$this->addField($f_mod_date_time);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
