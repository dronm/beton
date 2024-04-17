<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
 
class RouteRest_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("route_rests");
			
		//*** Field tracker_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['length']=15;
		$f_opts['id']="tracker_id";
						
		$f_tracker_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"tracker_id",$f_opts);
		$this->addField($f_tracker_id);
		//********************
		
		//*** Field route_rest ***
		$f_opts = array();
		$f_opts['id']="route_rest";
						
		$f_route_rest=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"route_rest",$f_opts);
		$this->addField($f_route_rest);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
