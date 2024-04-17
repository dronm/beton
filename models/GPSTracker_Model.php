<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
 
class GPSTracker_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("gps_trackers");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['length']=15;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field sim_number ***
		$f_opts = array();
		$f_opts['length']=15;
		$f_opts['id']="sim_number";
						
		$f_sim_number=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sim_number",$f_opts);
		$this->addField($f_sim_number);
		//********************
		
		//*** Field sim_id ***
		$f_opts = array();
		$f_opts['length']=20;
		$f_opts['id']="sim_id";
						
		$f_sim_id=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"sim_id",$f_opts);
		$this->addField($f_sim_id);
		//********************
		
		//*** Field puk ***
		$f_opts = array();
		$f_opts['length']=8;
		$f_opts['id']="puk";
						
		$f_puk=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"puk",$f_opts);
		$this->addField($f_puk);
		//********************
		
		//*** Field from_date ***
		$f_opts = array();
		$f_opts['id']="from_date";
						
		$f_from_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"from_date",$f_opts);
		$this->addField($f_from_date);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_id,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
