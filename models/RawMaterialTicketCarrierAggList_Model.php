<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLJSON.php');
 
class RawMaterialTicketCarrierAggList_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("raw_material_ticket_carrier_agg_list");
			
		//*** Field id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=TRUE;
		$f_opts['id']="id";
						
		$f_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"id",$f_opts);
		$this->addField($f_id);
		//********************
		
		//*** Field carriers_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Перевозчик';
		$f_opts['id']="carriers_ref";
						
		$f_carriers_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"carriers_ref",$f_opts);
		$this->addField($f_carriers_ref);
		//********************
		
		//*** Field raw_materials_ref ***
		$f_opts = array();
		
		$f_opts['alias']='Материал';
		$f_opts['id']="raw_materials_ref";
						
		$f_raw_materials_ref=new FieldSQLJSON($this->getDbLink(),$this->getDbName(),$this->getTableName(),"raw_materials_ref",$f_opts);
		$this->addField($f_raw_materials_ref);
		//********************
		
		//*** Field quant ***
		$f_opts = array();
		
		$f_opts['alias']='Вес, т';
		$f_opts['id']="quant";
						
		$f_quant=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant",$f_opts);
		$this->addField($f_quant);
		//********************
		
		//*** Field ticket_count ***
		$f_opts = array();
		
		$f_opts['alias']='Количество';
		$f_opts['id']="ticket_count";
						
		$f_ticket_count=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"ticket_count",$f_opts);
		$this->addField($f_ticket_count);
		//********************
		
		//*** Field quant_tot ***
		$f_opts = array();
		
		$f_opts['alias']='Вес, т';
		$f_opts['id']="quant_tot";
						
		$f_quant_tot=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"quant_tot",$f_opts);
		$this->addField($f_quant_tot);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	$this->setAggFunctions(
		array(array('alias'=>'total_quant','expr'=>'sum(quant_tot)')
)
	);	

	}

}
?>
