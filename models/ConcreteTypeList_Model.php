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
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLBool.php');
 
class ConcreteTypeList_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("concrete_types_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Код';
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field name ***
		$f_opts = array();
		
		$f_opts['alias']='Наименование';
		$f_opts['id']="name";
						
		$f_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"name",$f_opts);
		$this->addField($f_name);
		//********************
		
		//*** Field code_1c ***
		$f_opts = array();
		
		$f_opts['alias']='Код 1С';
		$f_opts['id']="code_1c";
						
		$f_code_1c=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"code_1c",$f_opts);
		$this->addField($f_code_1c);
		//********************
		
		//*** Field pres_norm ***
		$f_opts = array();
		
		$f_opts['alias']='Норма давл.';
		$f_opts['id']="pres_norm";
						
		$f_pres_norm=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"pres_norm",$f_opts);
		$this->addField($f_pres_norm);
		//********************
		
		//*** Field mpa_ratio ***
		$f_opts = array();
		
		$f_opts['alias']='Кф.МПА';
		$f_opts['id']="mpa_ratio";
						
		$f_mpa_ratio=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"mpa_ratio",$f_opts);
		$this->addField($f_mpa_ratio);
		//********************
		
		//*** Field price ***
		$f_opts = array();
		
		$f_opts['alias']='Цена';
		$f_opts['id']="price";
						
		$f_price=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"price",$f_opts);
		$this->addField($f_price);
		//********************
		
		//*** Field material_cons_rates ***
		$f_opts = array();
		
		$f_opts['alias']='Есть нормы расхода';
		$f_opts['id']="material_cons_rates";
						
		$f_material_cons_rates=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"material_cons_rates",$f_opts);
		$this->addField($f_material_cons_rates);
		//********************
		
		//*** Field show_on_site ***
		$f_opts = array();
		
		$f_opts['alias']='Отображать на сайте';
		$f_opts['id']="show_on_site";
						
		$f_show_on_site=new FieldSQLBool($this->getDbLink(),$this->getDbName(),$this->getTableName(),"show_on_site",$f_opts);
		$this->addField($f_show_on_site);
		//********************
		
		//*** Field official_name ***
		$f_opts = array();
		
		$f_opts['alias']='Официальное наименование для накладной';
		$f_opts['id']="official_name";
						
		$f_official_name=new FieldSQLString($this->getDbLink(),$this->getDbName(),$this->getTableName(),"official_name",$f_opts);
		$this->addField($f_official_name);
		//********************
		
		//*** Field prochnost ***
		$f_opts = array();
		
		$f_opts['alias']='Прочность для паспорта качества';
		$f_opts['id']="prochnost";
						
		$f_prochnost=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"prochnost",$f_opts);
		$this->addField($f_prochnost);
		//********************
		
		//*** Field f_val ***
		$f_opts = array();
		
		$f_opts['alias']='F';
		$f_opts['id']="f_val";
						
		$f_f_val=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"f_val",$f_opts);
		$this->addField($f_f_val);
		//********************
		
		//*** Field w_val ***
		$f_opts = array();
		
		$f_opts['alias']='W';
		$f_opts['id']="w_val";
						
		$f_w_val=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"w_val",$f_opts);
		$this->addField($f_w_val);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
