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


class PumpVehicle_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('pump_price_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('phone_cel'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('pump_length'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtBool('deleted'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('comment_text'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtJSONB('phone_cels'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtJSONB('pump_prices'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtBool('specialist_inform'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtBool('driver_ship_inform'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Минимальное количество м3 для заявки';
			$param = new FieldExtInt('min_order_quant'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Минимальный интервал между заявками';
			$param = new FieldExtInterval('min_order_time_interval'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('PumpVehicle.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('PumpVehicle_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('pump_price_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('phone_cel'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('pump_length'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtBool('deleted'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('comment_text'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtJSONB('phone_cels'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtJSONB('pump_prices'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtBool('specialist_inform'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtBool('driver_ship_inform'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Минимальное количество м3 для заявки';
			$param = new FieldExtInt('min_order_quant'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Минимальный интервал между заявками';
			$param = new FieldExtInterval('min_order_time_interval'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('id',array(
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['id'
				]
			];
			$pm->addEvent('PumpVehicle.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('PumpVehicle_Model');

			
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
		$pm->addEvent('PumpVehicle.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('PumpVehicle_Model');

			
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
		
		$this->setListModelId('PumpVehicleList_Model');
		
			
		$pm = new PublicMethod('get_work_list');
		
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
		$this->setObjectModelId('PumpVehicleList_Model');		

			
		$pm = new PublicMethod('get_price');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('pump_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=19;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtFloat('quant',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_contact_refs');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('check_order_min_vals');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('pump_vehicle_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('order_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=19;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtFloat('order_quant',$opts));
	
				
	$opts=array();
	
		$opts['length']=19;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtDateTime('order_date_time',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	public function get_work_list($pm){
		$this->setListModelId("PumpVehicleWorkList_Model");
		parent::get_list($pm);
	}
	
	private static function min_vals_enabled(){
		return ($_SESSION['role_id']=='owner' || $_SESSION["role_id"]=="admin" || $_SESSION["role_id"]=="boss");
	}

	private static function before_write_check($pm){
		//some attrs are not allowed to be changed: min_order_quant, min_order_time_interval
		if(!self::min_vals_enabled()){
			$min_order_quant = $pm->getParamValue('min_order_quant');
			$min_order_time_interval = $pm->getParamValue('min_order_time_interval');
			if($min_order_time_interval || $min_order_quant){
				throw new Exception("Запрещено менять минтмальное количество и интервал для заявки!");
			}
		}
	}

	public function insert($pm){
		self::before_write_check($pm);
		parent::insert($pm);
	}
	public function update($pm){
		self::before_write_check($pm);
		parent::update($pm);
	}

	public function get_contact_refs($pm){
		$this->addNewModel(sprintf(
			"SELECT
				client_tels_ref_on_tel(format_cel_standart(sub.tels->'fields'->>'tel')) AS ref
			FROM (
				SELECT jsonb_array_elements(phone_cels->'rows') AS tels
				FROM pump_vehicles
				WHERE id = %d
			) AS sub"
			,$this->getExtDbVal($pm, 'id')
		), 'Ref_Model');		
	}

	public function check_order_min_vals($pm){
		$this->addNewModel(sprintf(
		// throw new Exception(sprintf(
			"SELECT * FROM pump_vehicles_check_order_min_vals(%d, %f, %s, %s) AS (passed bool, min_quant numeric(19,2), min_time_interval interval)"
			,$this->getExtDbVal($pm, 'pump_vehicle_id')
			,$this->getExtDbVal($pm, 'order_quant')
			,$this->getExtDbVal($pm, 'order_date_time')
			,$pm->getParamValue('order_id')? $this->getExtDbVal($pm, 'order_id'):'null'
		), 'CheckResult_Model'
		);		
	}
	

}
?>
