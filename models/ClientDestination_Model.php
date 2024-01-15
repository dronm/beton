<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
 
class ClientDestination_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("client_destinations");
			
		//*** Field client_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Клиент';
		$f_opts['id']="client_id";
						
		$f_client_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_id",$f_opts);
		$this->addField($f_client_id);
		//********************
		
		//*** Field destination_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Объект';
		$f_opts['id']="destination_id";
						
		$f_destination_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destination_id",$f_opts);
		$this->addField($f_destination_id);
		//********************
		
		//*** Field lon ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="lon";
						
		$f_lon=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"lon",$f_opts);
		$this->addField($f_lon);
		//********************
		
		//*** Field lat ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="lat";
						
		$f_lat=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"lat",$f_opts);
		$this->addField($f_lat);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
