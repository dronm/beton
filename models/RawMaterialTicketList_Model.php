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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class RawMaterialTicketList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("raw_material_tickets_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field carrier_id ***
		$f_opts = array();
		
		$f_opts['alias']='Перевозчик';
		$f_opts['id']="carrier_id";
						
		$f_carrier_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"carrier_id",$f_opts);
		$this->addField($f_carrier_id);
		//********************
		
		//*** Field carriers_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Перевозчик';
		$f_opts['id']="carriers_ref";
						
		$f_carriers_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"carriers_ref",$f_opts);
		$this->addField($f_carriers_ref);
		//********************
		
		//*** Field raw_material_id ***
		$f_opts = array();
		
		$f_opts['alias']='Материал';
		$f_opts['id']="raw_material_id";
						
		$f_raw_material_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"raw_material_id",$f_opts);
		$this->addField($f_raw_material_id);
		//********************
		
		//*** Field raw_materials_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Материал';
		$f_opts['id']="raw_materials_ref";
						
		$f_raw_materials_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"raw_materials_ref",$f_opts);
		$this->addField($f_raw_materials_ref);
		//********************
		
		//*** Field barcode ***
		$f_opts = array();
		
		$f_opts['alias']='Штрихкод';
		$f_opts['id']="barcode";
						
		$f_barcode=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"barcode",$f_opts);
		$this->addField($f_barcode);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Вес, т';
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
		
		//*** Field issue_date_time ***
		$f_opts = array();
		$f_opts['id']="issue_date_time";
						
		$f_issue_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"issue_date_time",$f_opts);
		$this->addField($f_issue_date_time);
		//********************
		
		//*** Field close_date_time ***
		$f_opts = array();
		$f_opts['id']="close_date_time";
						
		$f_close_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"close_date_time",$f_opts);
		$this->addField($f_close_date_time);
		//********************
		
		//*** Field issue_users_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Кто выпустил';
		$f_opts['id']="issue_users_ref";
						
		$f_issue_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"issue_users_ref",$f_opts);
		$this->addField($f_issue_users_ref);
		//********************
		
		//*** Field issue_user_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="issue_user_id";
						
		$f_issue_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"issue_user_id",$f_opts);
		$this->addField($f_issue_user_id);
		//********************
		
		//*** Field close_users_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Кто погасил';
		$f_opts['id']="close_users_ref";
						
		$f_close_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"close_users_ref",$f_opts);
		$this->addField($f_close_users_ref);
		//********************
		
		//*** Field close_user_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="close_user_id";
						
		$f_close_user_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"close_user_id",$f_opts);
		$this->addField($f_close_user_id);
		//********************
		
		//*** Field expire_date ***
		$f_opts = array();
		
		$f_opts['alias']='Дата окончания срока';
		$f_opts['id']="expire_date";
						
		$f_expire_date=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"expire_date",$f_opts);
		$this->addField($f_expire_date);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_issue_date_time,$direct);
$this->setLimitConstant('doc_per_page_count');
	$this->setAggFunctions(
		array(array('alias'=>'total_quant','expr'=>'sum(quant)')
)
	);	

	}

}
?>
