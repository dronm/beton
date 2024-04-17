<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
 
class VehicleTotRepCommonItemValue_Model extends ModelSQL{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("vehicle_tot_rep_common_item_vals");
			
		//*** Field vehicle_owner_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=FALSE;
		$f_opts['id']="vehicle_owner_id";
						
		$f_vehicle_owner_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_owner_id",$f_opts);
		$this->addField($f_vehicle_owner_id);
		//********************
		
		//*** Field vehicle_tot_rep_common_item_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=FALSE;
		$f_opts['id']="vehicle_tot_rep_common_item_id";
						
		$f_vehicle_tot_rep_common_item_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"vehicle_tot_rep_common_item_id",$f_opts);
		$this->addField($f_vehicle_tot_rep_common_item_id);
		//********************
		
		//*** Field period ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		$f_opts['autoInc']=FALSE;
		
		$f_opts['alias']='First date of month';
		$f_opts['id']="period";
						
		$f_period=new FieldSQLDate($this->getDbLink(),$this->getDbName(),$this->getTableName(),"period",$f_opts);
		$this->addField($f_period);
		//********************
		
		//*** Field value ***
		$f_opts = array();
		
		$f_opts['alias']='Ручное значение';
		$f_opts['id']="value";
						
		$f_value=new FieldSQLFloat($this->getDbLink(),$this->getDbName(),$this->getTableName(),"value",$f_opts);
		$this->addField($f_value);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
