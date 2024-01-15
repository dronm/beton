<?php
/**
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 */

require_once(FRAME_WORK_PATH.'basic_classes/ModelSQLBeton.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTimeTZ.php');
 
class VehicleTemplateRoute_Model extends ModelSQLBeton{
	
	public function __construct($dbLink){
		parent::__construct($dbLink);
		
		
		$this->setDbName('public');
		
		$this->setTableName("vehicle_template_routes");
			
		//*** Field destination_from_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Объект откуда';
		$f_opts['id']="destination_from_id";
						
		$f_destination_from_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destination_from_id",$f_opts);
		$this->addField($f_destination_from_id);
		//********************
		
		//*** Field destination_to_id ***
		$f_opts = array();
		$f_opts['primaryKey'] = TRUE;
		
		$f_opts['alias']='Объект куда';
		$f_opts['id']="destination_to_id";
						
		$f_destination_to_id=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"destination_to_id",$f_opts);
		$this->addField($f_destination_to_id);
		//********************
		
		//*** Field route_osrm ***
		$f_opts = array();
		
		$f_opts['alias']='Данные маршрута OSRM (encoded(5) polyline)';
		$f_opts['id']="route_osrm";
						
		$f_route_osrm=new FieldSQLgeometry($this->getDbLink(),$this->getDbName(),$this->getTableName(),"route_osrm",$f_opts);
		$this->addField($f_route_osrm);
		//********************
		
		//*** Field update_dt ***
		$f_opts = array();
		
		$f_opts['alias']='Время обновления';
		$f_opts['id']="update_dt";
						
		$f_update_dt=new FieldSQLDateTimeTZ($this->getDbLink(),$this->getDbName(),$this->getTableName(),"update_dt",$f_opts);
		$this->addField($f_update_dt);
		//********************
		
		//*** Field point_cnt ***
		$f_opts = array();
		
		$f_opts['alias']='Количество точек маршрута';
		$f_opts['id']="point_cnt";
						
		$f_point_cnt=new FieldSQLInt($this->getDbLink(),$this->getDbName(),$this->getTableName(),"point_cnt",$f_opts);
		$this->addField($f_point_cnt);
		//********************
	$this->setLimitConstant('doc_per_page_count');
	}

}
?>
