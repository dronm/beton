<?php
require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtPassword.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInterval.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtArray.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBytea.php');

/**
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */


require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelWhereSQL.php');

require_once(FRAME_WORK_PATH.'basic_classes/ValidatorDate.php');

require_once(ABSOLUTE_PATH.'functions/Beton.php');

class VehicleSchedule_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Дата';
			$param = new FieldExtDate('schedule_date'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Автомобиль';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Водитель';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('driver_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='База';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('production_base_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Кто внес данные';
			$param = new FieldExtInt('edit_user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Когда внес данные';
			$param = new FieldExtDateTimeTZ('edit_date_time'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('VehicleSchedule.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('VehicleSchedule_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			
				$f_params['alias']='Код';
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Дата';
			$param = new FieldExtDate('schedule_date'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Автомобиль';
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Водитель';
			$param = new FieldExtInt('driver_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='База';
			$param = new FieldExtInt('production_base_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Кто внес данные';
			$param = new FieldExtInt('edit_user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Когда внес данные';
			$param = new FieldExtDateTimeTZ('edit_date_time'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('id',array(
			
				'alias'=>'Код'
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['id'
				]
			];
			$pm->addEvent('VehicleSchedule.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('VehicleSchedule_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('id'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('VehicleSchedule.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('VehicleSchedule_Model');

			
		/* get_list */
		$pm = new PublicMethod('get_list');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);
		
		$this->setListModelId('VehicleScheduleList_Model');
		
			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('vehicle_schedule_descr'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('VehicleScheduleComplete_Model');

			
		$pm = new PublicMethod('get_current_veh_list');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);

			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('VehicleScheduleList_Model');		

			
		$pm = new PublicMethod('set_free');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_base_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('set_production_base');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_base_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=100;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('last_state',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('set_out');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtText('comment_text',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('gen_schedule');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtDate('date_from',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtDate('date_to',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_base_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('vehicle_list',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('vehicle_feature',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtBool('day1',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtBool('day2',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtBool('day3',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtBool('day4',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtBool('day5',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtBool('day6',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtBool('day7',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_vehicle_efficiency');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

				
	$opts=array();
					
		$pm->addParam(new FieldExtString('templ',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_schedule_report');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_schedule_report_all');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

				
	$opts=array();
					
		$pm->addParam(new FieldExtString('templ',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_vehicle_runs');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_vehicle_owner_schedule');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtDate('date_from',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtDate('date_to',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('vehicle_owner_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('set_schedule');
		
				
	$opts=array();
	
		$opts['length']=5000;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('vehicles',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}

	public function insert($pm){
		$pm->setParamValue("edit_user_id", $_SESSION['user_id']);
		parent::insert($pm);
	}
	public function update($pm){
		$pm->setParamValue("edit_user_id", $_SESSION['user_id']);
		$pm->setParamValue("edit_date_time", date("Y-m-dTH:i:s"));
		parent::update($pm);
	}
	
	public function set_free($pm){
		$dbLink = $this->getDbLinkMaster();
		$dbLink->query(
			sprintf("SELECT set_vehicle_schedule_free(%d, %d)",
			$this->getExtDbVal($pm, 'id'),
			$this->getExtDbVal($pm, 'production_base_id')
		));
	}
	public function set_out($pm){
		$dbLink = $this->getDbLinkMaster();
		$dbLink->query(
			sprintf("INSERT INTO out_comments
			(vehicle_schedule_id,comment_text)
			VALUES (%d,%s)",
			$this->getExtDbVal($pm,'id'),
			$this->getExtDbVal($pm,'comment_text')
			)
		);
	}
	
	public function gen_schedule($pm){
		$date_from = $this->getExtDbVal($pm,'date_from');
		$date_to = $this->getExtDbVal($pm,'date_to');
		
		$dbLink = $this->getDbLinkMaster();
		
		$production_base_id = $this->getExtDbVal($pm, 'production_base_id');
		
		$vehicle_feature = strtolower($this->getExtVal($pm, 'vehicle_feature'));

		if($vehicle_feature == 'null'){
			$vehicle_feature = NULL;
		}else{
			$vehicle_feature = $this->getExtDbVal($pm, 'vehicle_feature');
		}

		$veh_list_v = json_decode($this->getExtVal($pm,'vehicle_list'));
		if(is_null($vehicle_feature) && !isset($veh_list_v->value)){		
			throw new Exception('Свойство не заполнено, список ТС пустой!');
		}
		$veh_list = json_decode($veh_list_v->value);
		if(is_null($vehicle_feature) && (!isset($veh_list->rows)||!count($veh_list->rows)) ){		
			throw new Exception('Свойство не заполнено, список ТС пустой!');
		}
		
		if(!is_null($vehicle_feature)){
			//select vehicles
			$veh_ar = array('rows' => array());
			$q_id = $this->getDbLink()->query(sprintf(
				"SELECT
					v.id AS vehicle_id,
					v.driver_id
				FROM vehicles AS v
				WHERE v.feature = %s"
				,$vehicle_feature
			));
			while($ar = $this->getDbLink()->fetch_array($q_id)){

				array_push($veh_ar['rows'], (object) array(
					'fields' => (object) array(
						'vehicle' => (object) array(
							'keys' => (object) array('id' => $ar['vehicle_id'])
						)
						,'driver' => (object) array(
							'keys' => (object) array('id' => $ar['driver_id'])
						)
					)
				));
			}
			$veh_list = (object) $veh_ar;
		}
		
		$vehicle_for_rep_id = 0;
		
		foreach($veh_list->rows as $row){
			$vehicle_id = 0;
			
			if(isset($row->fields->vehicle)&&isset($row->fields->vehicle->keys)&&isset($row->fields->vehicle->keys->id)){
				$vehicle_id = intval($row->fields->vehicle->keys->id);
			}
			if(!$vehicle_id){
				continue;
			}
			
			$driver_id = 0;
			if(isset($row->fields->driver)&&isset($row->fields->driver->keys)&&isset($row->fields->driver->keys->id)){
				$driver_id = intval($row->fields->driver->keys->id);
			}			
			if($driver_id){
				$ar = $dbLink->query_first(sprintf("SELECT driver_id FROM vehicles WHERE id=%d",$vehicle_id));
				if($ar['driver_id'] != $driver_id){
					$dbLink->query_first(sprintf(
					"UPDATE vehicles SET driver_id=%d WHERE id=%d",
					$driver_id,$vehicle_id
					));
				}			
			}
			
			$vehicle_for_rep_id = $vehicle_id;
			//$vehicle_for_rep_id.= ($vehicle_for_rep_id==0)? '':', ';
			//$vehicle_for_rep_id.=$vehicle_id;
			
			$dbLink->query(
				sprintf("SELECT gen_schedule(%d, %d, %d, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
				$_SESSION['user_id'],
				$production_base_id,
				$vehicle_id,
				$date_from,
				$date_to,
				$this->getExtDbVal($pm,'day1'),
				$this->getExtDbVal($pm,'day2'),
				$this->getExtDbVal($pm,'day3'),
				$this->getExtDbVal($pm,'day4'),
				$this->getExtDbVal($pm,'day5'),
				$this->getExtDbVal($pm,'day6'),
				$this->getExtDbVal($pm,'day7')
				));
		}
		//return report
		if($vehicle_for_rep_id){
			$model = new ModelSQL($dbLink,array("id"=>"VehicleScheduleReport_Model"));
	
			$model->setSelectQueryText(sprintf(
			"SELECT * FROM get_schedule_on_vehicle(%s,%s,%d)",
			$date_from,$date_to,$vehicle_for_rep_id
			));
	
			$model->select(false,null,null,
				null,null,null,null,null,TRUE);
			//
			$this->addModel($model);				
		}
	}
	public function get_current_veh_list($pm){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array('id'=>'VehicleScheduleMakeOrderList_Model'));
		$model->addField(new FieldSQLString($link,null,null,"date",DT_DATE));
		$where = $this->conditionFromParams($pm,$model);
		if(is_null($where)){
			$date = "'".date('Y-m-d',Beton::shiftStart())."'";
		}
		else{
			foreach($where->fields as $w_field){
				$id = $w_field['field']->getId();
				if ($id=='date'){
					$date = $w_field['field']->getValueForDb();
				}
			}
		}
		$model->setSelectQueryText(sprintf(
			"SELECT * FROM vehicle_last_states(%s)",
			$date)
		);		
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		$this->addModel($model);				
		
		//features count
		/*
		$model_f = new ModelSQL($link,array('id'=>'VehFeaturesOnDateList_Model'));
		$model_f->setSelectQueryText(sprintf(
			"SELECT * FROM vehicle_feature_count WHERE schedule_date=%s",
			$date)
		);		
		$model_f->select(false,null,null,
			null,null,null,null,null,TRUE);
		$this->addModel($model_f);				
		*/
	}
	public function get_vehicle_efficiency(){
		$pm = $this->getPublicMethod('get_vehicle_efficiency');
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array("id"=>"VehicleEfficiency_Model"));
		$model->addField(new FieldSQLDateTime($link,null,null,"date_time",DT_DATETIME));
		$model->addField(new FieldSQLInt($link,null,null,"vehicle_id",DT_INT));
		$model->addField(new FieldSQLInt($link,null,null,"vehicle_owner_id",DT_INT));
		$model->addField(new FieldSQLString($link,null,null,"vehicle_feature",DT_STRING));
		$model->addField(new FieldSQLString($link,null,null,"run_type",DT_STRING));
		$model->addField(new FieldSQLString($link,null,null,"shift_type",DT_STRING));
		$where = $this->conditionFromParams($pm,$model);

		$from = null;
		$to = null;
		$vehicle_id = 0;
		$vehicle_owner_id = "''";
		$vehicle_feature = "''";
		$run_type = "0";
		$shift_type = "0";
		
		foreach($where->fields as $w_field){
			$id = $w_field['field']->getId();
			if ($id=='date_time'){
				if ($w_field['signe']=='>='){
					$from = $w_field['field']->getValueForDb();
				}
				else{
					$to = $w_field['field']->getValueForDb();
				}
			}
			else if ($id=='vehicle_id'){
				$vehicle_id = $w_field['field']->getValueForDb();
			}
			else if ($id=='vehicle_owner_id'){
				$vehicle_owner_id = $w_field['field']->getValueForDb();
			}
			else if ($id=='vehicle_feature'){
				$vehicle_feature = $w_field['field']->getValueForDb();
			}
			else if ($id=='run_type'){
				switch ($w_field['field']->getValue()){
					case 'run_type_day':
						$run_type = 1;
						break;
					case 'run_type_night':
						$run_type = 2;
						break;
				}
			}			
			else if ($id=='shift_type'){
				switch ($w_field['field']->getValue()){
					case 'shift_type_on':
						$shift_type = 1;
						break;
					case 'shift_type_off':
						$shift_type = 2;
						break;
				}
			}						
		}
		$model->setSelectQueryText(
			sprintf(
				"SELECT * FROM vehicle_efficiency(%s, %s, %d, %d, %s, %d, %d)",
				$from,$to, $vehicle_id, $vehicle_owner_id, $vehicle_feature,
				$run_type, $shift_type
			)
		);
		
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		//
		$this->addModel($model);				
	}
	public function get_schedule_report(){
		$pm = $this->getPublicMethod('get_schedule_report');
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array("id"=>"VehicleScheduleReport_Model"));
		$model->addField(new FieldSQLDateTime($link,null,null,"date",DT_DATE));
		$model->addField(new FieldSQLInt($link,null,null,"vehicle_id",DT_INT));
		$where = $this->conditionFromParams($pm,$model);

		$from = null;
		$to = null;
		$vehicle_id = 0;
		
		foreach($where->fields as $w_field){
			$id = $w_field['field']->getId();
			if ($id=='date'){
				if ($w_field['signe']=='>='){
					$from = $w_field['field']->getValueForDb();
				}
				else{
					$to = $w_field['field']->getValueForDb();
				}
			}
			else if ($id=='vehicle_id'){
				$vehicle_id = $w_field['field']->getValueForDb();
			}
		}
				
		$model->setSelectQueryText(
		sprintf(
		"SELECT * FROM get_schedule_on_vehicle(%s,%s,%d)",
		$from,$to,$vehicle_id));
		
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		//
		$this->addModel($model);				
		
	}
	public function get_schedule_report_all($pm){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array('id'=>'get_schedule_report_all'));
		$model->addField(new FieldSQLDateTime($link,null,null,"date",DT_DATE));
		$model->addField(new FieldSQLInt($link,null,null,"vehicle_id",DT_INT));
		$where = $this->conditionFromParams($pm,$model);

		$from = null;
		$to = null;
		$vehicle_id = 0;
		
		foreach($where->fields as $w_field){
			$id = $w_field['field']->getId();
			if ($id=='date'){
				if ($w_field['signe']=='>='){
					$from = $w_field['field']->getValueForDb();
				}
				else{
					$to = $w_field['field']->getValueForDb();
				}
			}
			else if ($id=='vehicle_id'){
				$vehicle_id = $w_field['field']->getValueForDb();
			}
		}
				
		$model->setSelectQueryText(
		sprintf(
		"SELECT * FROM get_schedule_for_all2(%s,%s,%d)",
		$from,$to,$vehicle_id));
		
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		//
		$this->addModel($model);				
		
	}
	
	public function get_vehicle_runs($pm){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array("id"=>"VehicleRun_Model"));
		$model->addField(new FieldSQLInt($link,null,null,"schedule_id",DT_INT));
		$where = $this->conditionFromParams($pm,$model);
		if (!isset($where)){
			throw new Exception('Condition fields not set!');
		}
	
		$schedule_id = 0;
		
		foreach($where->fields as $w_field){
			$id = $w_field['field']->getId();
			if ($id=='schedule_id'){
				$schedule_id = $w_field['field']->getValueForDb();
			}
		}
	
		$model->setSelectQueryText(
			sprintf(
				"SELECT * FROM vehicle_run_inf_on_schedule(%d)",
			$schedule_id)
		);
		
		$model->select(false,null,null,null,null,null,null,null,TRUE);
		//
		$this->addModel($model);						
	}	
	
	public static function getMakeListModel($dbLink,$dateForDb){
		$model = new ModelSQL($dbLink,array('id'=>'VehicleScheduleMakeOrderList_Model'));
		$model->addField(new FieldSQLString($dbLink,null,null,"date",DT_DATE));
		$model->query(sprintf(
			"SELECT * FROM vehicle_last_states(%s)",		
			$dateForDb
			),
		TRUE);
		return $model;	
	}
	
	public static function getFeatureListModel($dbLink,$dateForDb){
		$model = new ModelSQL($dbLink,array('id'=>'VehFeaturesOnDateList_Model'));
		$model->addField(new FieldSQLString($dbLink,null,null,"date",DT_DATE));
		$model->query(sprintf(
			"SELECT * FROM veh_feature_count WHERE schedule_date=%s",		
			$dateForDb
			),
		TRUE);
		return $model;	
	}
	
	public function get_list($pm){
		$model = new VehicleScheduleList_Model($this->getDbLink());
		$where = $this->conditionFromParams($pm,$model);
		if(is_null($where)){
			$where = new ModelWhereSQL();
			$field = new FieldSQLDate($this->getDbLink(),null,null,"schedule_date",DT_DATE);
			
			$field->setValue(Beton::shiftStart());
			$where->addField($field);
		}
		
		$model->select(false,$where,null,
			null,null,null,null,FALSE,TRUE);
		//
		$this->addModel($model);						
		
	}
	
	public function get_vehicle_owner_schedule($pm){
		$date_from = $this->getExtDbVal($pm, 'date_from');
		$date_to = $this->getExtDbVal($pm, 'date_to');
		
		if($_SESSION['role_id'] == "vehicle_owner"){
			$vehicle_owner_id = $_SESSION['global_vehicle_owner_id'];
		}else{
			$vehicle_owner_id = $this->getExtDbVal($pm, 'vehicle_owner_id');
		}
		
		$this->addNewModel(sprintf(
			"SELECT
				sch.schedule_date,
				vehicles_ref(v) AS vehicles_ref,
				drivers_ref(d) AS drivers_ref,
				production_bases_ref(b) AS production_bases_ref
			FROM vehicle_schedules AS sch
			LEFT JOIN vehicles AS v ON v.id = sch.vehicle_id
			LEFT JOIN drivers AS d ON d.id = sch.driver_id
			LEFT JOIN production_bases AS b ON b.id = sch.production_base_id
			WHERE (vehicle_owner_on_date(v.vehicle_owners, %s)->'keys'->>'id')::int = %d
				AND sch.schedule_date BETWEEN %s AND %s
			ORDER BY
				v.plate,
				sch.schedule_date"
			,$date_to
			,$vehicle_owner_id
			,$date_from
			,$date_to
		),'VehicleOwnerSchedule_Model'
		);	
		
		//авто, на которые за этот период нет расписания, ни одного
		$this->addNewModel(sprintf(
			"SELECT
				vehicles_ref(v) AS vehicles_ref
			FROM vehicles AS v
			WHERE ((vehicle_owner_on_date(v.vehicle_owners, %s))->'keys'->>'id')::int = %d
			AND coalesce((SELECT
				 	TRUE
				 FROM vehicle_schedules AS sch
				 WHERE sch.vehicle_id = v.id
				 	AND sch.schedule_date BETWEEN %s AND %s
				 LIMIT 1
			), FALSE) = FALSE
			ORDER BY v.plate"
			,$date_to
			,$vehicle_owner_id
			,$date_from
			,$date_to
		),'MissingVehicle_Model'
		);	
		
	}

	/**
	 * vehicles - array of objects {"vehicle_id":VH_ID, "days":[{"date":DATE, "shift":true, "driver_id":DRIVER_ID}]}	
	 */
	public function set_schedule($pm){		
		$vehicles = json_decode($this->getExtVal($pm, 'vehicles'), TRUE);
		
		$common_production_base_id = 1;
		$validator = new ValidatorDate();
		$db_link = $this->getDbLink();
		$db_link->query('BEGIN');
		try{
			foreach($vehicles as $vehicle){
				$vehicle_id = intval($vehicle['vehicle_id']);
				if($vehicle_id == 0){
					throw new Exception("Vehicle not defined");
				}
			
				foreach($vehicle['days'] as $day){
					$is_shift = boolval($day['shift']);
					$driver_id = intval($day['driver_id']);
					if($is_shift && $driver_id == 0){
						throw new Exception("Driver not defined");
					}
					$prod_base_id = isset($day['prod_base_id'])? intval($day['prod_base_id']) : $common_production_base_id;
					if($prod_base_id == 0){
						$prod_base_id = $common_production_base_id;
					}
					$validator->validate($day['date']);

					if($_SESSION['role_id'] == "vehicle_owner"){
						//check vehicle
						$ar = $db_link->query_first(sprintf(
							"SELECT
								((vehicle_owner_on_date(v.vehicle_owners, '%sT06:00:00'))->'keys'->>'id')::int = %d AS belongs_to_owner
							FROM vehicles AS v
							WHERE v.id = %d"
							,$day['date']
							,$_SESSION['global_vehicle_owner_id']
							,$vehicle_id
						));
						if(!is_array($ar) || !count($ar) || $ar['belongs_to_owner']!='t'){
							throw new Exception('Vehicle ID error!');
						}
					}
									
					if(!$is_shift){
						$db_link->query(sprintf(
							"DELETE FROM vehicle_schedules
							WHERE schedule_date = '%s'
								AND vehicle_id = %d"
							,$day['date']
							,$vehicle_id
						));
					}else{
						//shift
						$ar = $db_link->query_first(sprintf(
							"SELECT id
							FROM vehicle_schedules
							WHERE schedule_date = '%s' AND vehicle_id = %d
							LIMIT 1"
							,$day['date']
							,$vehicle_id
						));
						
						if(!is_array($ar) || !count($ar) ||!isset($ar['id'])){
							$db_link->query_first(sprintf(
								"INSERT INTO vehicle_schedules
								(schedule_date, vehicle_id, driver_id, production_base_id, edit_user_id, edit_date_time, auto_gen)
								VALUES
								('%s', %d, %d, %d, %d, now(), TRUE)"
								,$day['date']
								,$vehicle_id
								,$driver_id
								,$prod_base_id
								,$_SESSION['user_id']
							));
						}else{
							$db_link->query_first(sprintf(
								"UPDATE vehicle_schedules SET
									driver_id = %d,
									production_base_id = %d,
									edit_user_id = %d,
									edit_date_time = now(),
									auto_gen = TRUE
								WHERE schedule_date = '%s' AND vehicle_id = %d"
								,$driver_id
								,$prod_base_id
								,$_SESSION['user_id']
								,$day['date']
								,$vehicle_id
							));
						}
					}
				}
			}
			$db_link->query('COMMIT');
			
		}catch(Exception $e){
			$db_link->query('ROLLBACK');
			throw $e;
		}
	}
	
	/**
	 * changes production base
	 */
	public function set_production_base($pm){
		$this->getDbLinkMaster()->query(
			sprintf(
				"UPDATE vehicle_schedule_states
				SET production_base_id = %d
				WHERE id = (
					SELECT
						v_st.id
					FROM vehicle_schedule_states AS v_st
					WHERE v_st.schedule_id = %d AND v_st.state = %s
					ORDER BY v_st.date_time DESC
					LIMIT 1			
				)"
				,$this->getExtDbVal($pm, 'production_base_id')
				,$this->getExtDbVal($pm, 'id')
				,$this->getExtDbVal($pm, 'last_state')
			)
		);
	}
	
}
?>
