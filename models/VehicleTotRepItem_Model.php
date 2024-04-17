<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
 
class VehicleTotRepItem_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("vehicle_tot_rep_items");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field code ***
		$f_opts = array();
		$f_opts['id']="code";
						
		$f_code=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"code",$f_opts);
		$this->addField($f_code);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		$f_opts['id']="name";
						
		$f_name=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field query ***
		$f_opts = array();
		
		$f_opts['alias']='Текст запроса SQL, если задан рассчитывается автоматически';
		$f_opts['id']="query";
						
		$f_query=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"query",$f_opts);
		$this->addField($f_query);
		//********************
		
		//*** Field is_income ***
		$f_opts = array();
		$f_opts['id']="is_income";
						
		$f_is_income=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"is_income",$f_opts);
		$this->addField($f_is_income);
		//********************
		
		//*** Field info ***
		$f_opts = array();
		$f_opts['id']="info";
						
		$f_info=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"info",$f_opts);
		$this->addField($f_info);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
