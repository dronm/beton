<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLDOC.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelOrderSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class DOCMaterialMovementList_Model extends ModelSQLDOC{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("doc_material_movements_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Дата';
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field number ***
		$f_opts = array();
		
		$f_opts['alias']='Номер';
		$f_opts['id']="number";
						
		$f_number=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"number",$f_opts);
		$this->addField($f_number);
		//********************
		
		//*** Field production_base_from_id ***
		$f_opts = array();
		$f_opts['id']="production_base_from_id";
						
		$f_production_base_from_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_base_from_id",$f_opts);
		$this->addField($f_production_base_from_id);
		//********************
		
		//*** Field production_base_to_id ***
		$f_opts = array();
		$f_opts['id']="production_base_to_id";
						
		$f_production_base_to_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_base_to_id",$f_opts);
		$this->addField($f_production_base_to_id);
		//********************
		
		//*** Field production_bases_from_ref ***
		$f_opts = array();
		$f_opts['id']="production_bases_from_ref";
						
		$f_production_bases_from_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_bases_from_ref",$f_opts);
		$this->addField($f_production_bases_from_ref);
		//********************
		
		//*** Field production_bases_to_ref ***
		$f_opts = array();
		$f_opts['id']="production_bases_to_ref";
						
		$f_production_bases_to_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_bases_to_ref",$f_opts);
		$this->addField($f_production_bases_to_ref);
		//********************
		
		//*** Field materials_ref ***
		$f_opts = array();
		$f_opts['id']="materials_ref";
						
		$f_materials_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"materials_ref",$f_opts);
		$this->addField($f_materials_ref);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Количество';
		$f_opts['length']=19;
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
		
		//*** Field users_ref ***
		$f_opts = array();
		$f_opts['id']="users_ref";
						
		$f_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"users_ref",$f_opts);
		$this->addField($f_users_ref);
		//********************
		
		//*** Field carriers_ref ***
		$f_opts = array();
		$f_opts['id']="carriers_ref";
						
		$f_carriers_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"carriers_ref",$f_opts);
		$this->addField($f_carriers_ref);
		//********************
		
		//*** Field vehicle_plate ***
		$f_opts = array();
		
		$f_opts['alias']='Vehicle plate';
		$f_opts['id']="vehicle_plate";
						
		$f_vehicle_plate=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_plate",$f_opts);
		$this->addField($f_vehicle_plate);
		//********************
		
		//*** Field last_modif_users_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Кто последний вносил изменения';
		$f_opts['id']="last_modif_users_ref";
						
		$f_last_modif_users_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"last_modif_users_ref",$f_opts);
		$this->addField($f_last_modif_users_ref);
		//********************
		
		//*** Field last_modif_date_time ***
		$f_opts = array();
		
		$f_opts['alias']='Время последнего изменения';
		$f_opts['id']="last_modif_date_time";
						
		$f_last_modif_date_time=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"last_modif_date_time",$f_opts);
		$this->addField($f_last_modif_date_time);
		//********************
		
		//*** Field comment_text ***
		$f_opts = array();
		$f_opts['id']="comment_text";
						
		$f_comment_text=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"comment_text",$f_opts);
		$this->addField($f_comment_text);
		//********************
	
		$order = new ModelOrderSQL();		
		$this->setDefaultModelOrder($order);		
		$direct = 'DESC';
		$order->addField($f_date_time,$direct);
$this->setLimitConstant('doc_per_page_count');
	$this->setAggFunctions(
		array(array('alias'=>'total_quant','expr'=>'sum(quant)')
)
	);	

	}

}
?>
