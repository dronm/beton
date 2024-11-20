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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
 
class Driver_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("drivers");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='Наименование';
		$f_opts['length']=50;
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field driver_licence ***
		$f_opts = array();
		
		$f_opts['alias']='Водительское удостоверение';
		$f_opts['id']="driver_licence";
						
		$f_driver_licence=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"driver_licence",$f_opts);
		$this->addField($f_driver_licence);
		//********************
		
		//*** Field driver_licence_class ***
		$f_opts = array();
		
		$f_opts['alias']='Класс водительского удостоверения';
		$f_opts['length']=10;
		$f_opts['id']="driver_licence_class";
						
		$f_driver_licence_class=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"driver_licence_class",$f_opts);
		$this->addField($f_driver_licence_class);
		//********************
		
		//*** Field employed ***
		$f_opts = array();
		
		$f_opts['alias']='Официально устроен';
		$f_opts['id']="employed";
						
		$f_employed=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"employed",$f_opts);
		$this->addField($f_employed);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'ASC';
		$order->addField($f_name,$direct);
$this->setLimitConstant('doc_per_page_count');
	}

}
?>
