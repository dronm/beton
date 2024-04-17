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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class LabEntryList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("lab_entry_list");
			
		//*** Field shipment_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Основной ключ! тк. lab_entry может быть NULL';
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="shipment_id";
						
		$f_shipment_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"shipment_id",$f_opts);
		$this->addField($f_shipment_id);
		//********************
		
		//*** Field samples_exist ***
		$f_opts = array();
		
		$f_opts['alias']='Подборы';
		$f_opts['id']="samples_exist";
						
		$f_samples_exist=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"samples_exist",$f_opts);
		$this->addField($f_samples_exist);
		//********************
		
		//*** Field date_time ***
		$f_opts = array();
		$f_opts['id']="date_time";
						
		$f_date_time=new FieldSQLDateTime($this->getDbLink(),$this->getDbName(),$this->getTableName(),"date_time",$f_opts);
		$this->addField($f_date_time);
		//********************
		
		//*** Field production_sites_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Завод';
		$f_opts['id']="production_sites_ref";
						
		$f_production_sites_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_sites_ref",$f_opts);
		$this->addField($f_production_sites_ref);
		//********************
		
		//*** Field production_site_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="production_site_id";
						
		$f_production_site_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"production_site_id",$f_opts);
		$this->addField($f_production_site_id);
		//********************
		
		//*** Field concrete_types_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Марка';
		$f_opts['id']="concrete_types_ref";
						
		$f_concrete_types_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"concrete_types_ref",$f_opts);
		$this->addField($f_concrete_types_ref);
		//********************
		
		//*** Field concrete_type_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="concrete_type_id";
						
		$f_concrete_type_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"concrete_type_id",$f_opts);
		$this->addField($f_concrete_type_id);
		//********************
		
		//*** Field ok ***
		$f_opts = array();
		$f_opts['id']="ok";
						
		$f_ok=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ok",$f_opts);
		$this->addField($f_ok);
		//********************
		
		//*** Field weight ***
		$f_opts = array();
		$f_opts['id']="weight";
						
		$f_weight=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"weight",$f_opts);
		$this->addField($f_weight);
		//********************
		
		//*** Field p7 ***
		$f_opts = array();
		$f_opts['id']="p7";
						
		$f_p7=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"p7",$f_opts);
		$this->addField($f_p7);
		//********************
		
		//*** Field p28 ***
		$f_opts = array();
		$f_opts['id']="p28";
						
		$f_p28=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"p28",$f_opts);
		$this->addField($f_p28);
		//********************
		
		//*** Field samples ***
		$f_opts = array();
		
		$f_opts['alias']='Подборы';
		$f_opts['id']="samples";
						
		$f_samples=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"samples",$f_opts);
		$this->addField($f_samples);
		//********************
		
		//*** Field materials ***
		$f_opts = array();
		
		$f_opts['alias']='Материалы';
		$f_opts['id']="materials";
						
		$f_materials=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"materials",$f_opts);
		$this->addField($f_materials);
		//********************
		
		//*** Field client_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="client_id";
						
		$f_client_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_id",$f_opts);
		$this->addField($f_client_id);
		//********************
		
		//*** Field clients_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Заказчик';
		$f_opts['id']="clients_ref";
						
		$f_clients_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"clients_ref",$f_opts);
		$this->addField($f_clients_ref);
		//********************
		
		//*** Field client_phone ***
		$f_opts = array();
		
		$f_opts['alias']='Телефон';
		$f_opts['id']="client_phone";
						
		$f_client_phone=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"client_phone",$f_opts);
		$this->addField($f_client_phone);
		//********************
		
		//*** Field destination_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="destination_id";
						
		$f_destination_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destination_id",$f_opts);
		$this->addField($f_destination_id);
		//********************
		
		//*** Field destinations_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Объект';
		$f_opts['id']="destinations_ref";
						
		$f_destinations_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destinations_ref",$f_opts);
		$this->addField($f_destinations_ref);
		//********************
		
		//*** Field ok2 ***
		$f_opts = array();
		
		$f_opts['alias']='ОК2';
		$f_opts['id']="ok2";
						
		$f_ok2=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ok2",$f_opts);
		$this->addField($f_ok2);
		//********************
		
		//*** Field time ***
		$f_opts = array();
		
		$f_opts['alias']='Время';
		$f_opts['id']="time";
						
		$f_time=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"time",$f_opts);
		$this->addField($f_time);
		//********************
		
		//*** Field raw_material_cons_rate_dates_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Подбор';
		$f_opts['id']="raw_material_cons_rate_dates_ref";
						
		$f_raw_material_cons_rate_dates_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"raw_material_cons_rate_dates_ref",$f_opts);
		$this->addField($f_raw_material_cons_rate_dates_ref);
		//********************
		
		//*** Field rate_date_id ***
		$f_opts = array();
		$f_opts['sysCol']=TRUE;
		$f_opts['id']="rate_date_id";
						
		$f_rate_date_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"rate_date_id",$f_opts);
		$this->addField($f_rate_date_id);
		//********************
		
		//*** Field no_additive_material ***
		$f_opts = array();
		
		$f_opts['alias']='Нет добавки';
		$f_opts['id']="no_additive_material";
						
		$f_no_additive_material=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"no_additive_material",$f_opts);
		$this->addField($f_no_additive_material);
		//********************
		
		//*** Field f ***
		$f_opts = array();
		
		$f_opts['alias']='f';
		$f_opts['id']="f";
						
		$f_f=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"f",$f_opts);
		$this->addField($f_f);
		//********************
		
		//*** Field w ***
		$f_opts = array();
		
		$f_opts['alias']='w';
		$f_opts['id']="w";
						
		$f_w=new FieldSQLText($this->getDbLink(),$this->getDbName(),$this->getTableName(),"w",$f_opts);
		$this->addField($f_w);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
