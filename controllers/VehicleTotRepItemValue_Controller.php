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



require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');

class VehicleTotRepItemValue_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('vehicle_tot_rep_item_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='First date of month';
			$param = new FieldExtDate('period'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Ручное значение';
			$param = new FieldExtFloat('value'
				,$f_params);
		$pm->addParam($param);
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['vehicle_id'
			,'vehicle_tot_rep_item_id'
			,'period'
			]
		];
		$pm->addEvent('VehicleTotRepItemValue.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('VehicleTotRepItemValue_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_vehicle_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('old_vehicle_tot_rep_item_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtDate('old_period',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('vehicle_tot_rep_item_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='First date of month';
			$param = new FieldExtDate('period'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Ручное значение';
			$param = new FieldExtFloat('value'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('vehicle_id',array(
			));
			$pm->addParam($param);
		
			$param = new FieldExtInt('vehicle_tot_rep_item_id',array(
			));
			$pm->addParam($param);
		
			$param = new FieldExtDate('period',array(
			
				'alias'=>'First date of month'
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['vehicle_id'
				,'vehicle_tot_rep_item_id'
				,'period'
				]
			];
			$pm->addEvent('VehicleTotRepItemValue.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('VehicleTotRepItemValue_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('vehicle_id'
		));		
		
		$pm->addParam(new FieldExtInt('vehicle_tot_rep_item_id'
		));		
		
		$pm->addParam(new FieldExtDate('period'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['vehicle_id'
			,'vehicle_tot_rep_item_id'
			,'period'
			]
		];
		$pm->addEvent('VehicleTotRepItemValue.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('VehicleTotRepItemValue_Model');

			
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
		
		$this->setListModelId('VehicleTotRepItemValue_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('vehicle_id'
		));
		
		$pm->addParam(new FieldExtInt('vehicle_tot_rep_item_id'
		));
		
		$pm->addParam(new FieldExtDate('period'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('VehicleTotRepItemValue_Model');		

			
		$pm = new PublicMethod('update_values');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('values',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('common_values',$opts));
	
				
	$opts=array();
	
		$opts['alias']='Владелец ТС для остатка';				
		$pm->addParam(new FieldExtInt('balance_vehicle_owner_id',$opts));
	
				
	$opts=array();
	
		$opts['alias']='Периоды со значениями остатков';				
		$pm->addParam(new FieldExtText('balance_values',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	/**
	 * updates multiple values
	 */
	public function update_values($pm){
		$values = json_decode($this->getExtVal($pm, 'values'), TRUE);
		$common_values = json_decode($this->getExtVal($pm, 'common_values'), TRUE);
		
		$dbLink = $this->getDbLinkMaster();
		
		$dbLink->query("BEGIN");
		try{
			if(isset($values) && is_array($values) && count($values)){
				foreach($values as $v){
					$vehicle_id = intval($v['vehicle_id']);
					$item_id = intval($v['item_id']);
					$val = floatval($v['val']);
					$period = NULL;
					FieldSQLDate::formatForDb(strtotime($v['period']), $period);
					
					if($val == 0){
						$dbLink->query(sprintf(
							"DELETE FROM vehicle_tot_rep_item_vals WHERE vehicle_id = %d AND vehicle_tot_rep_item_id = %d AND period = %s"
							,$vehicle_id
							,$item_id
							,$period
						));
					}else{
						$dbLink->query(sprintf(
							"INSERT INTO vehicle_tot_rep_item_vals
							(vehicle_id, vehicle_tot_rep_item_id, period, value)
							VALUES (%d, %d, %s, %f)
							ON CONFLICT (vehicle_id, vehicle_tot_rep_item_id, period) DO UPDATE SET
								value = %f"
							,$vehicle_id
							,$item_id
							,$period
							,$val
							,$val
						));
					}				
				}
			}
			
			//common item values
			if(isset($common_values) && is_array($common_values) && count($common_values)){
				$vehicle_owner_id = $this->getExtDbVal($pm, 'balance_vehicle_owner_id');
				foreach($common_values as $v){					
					$item_id = intval($v['item_id']);
					$val = floatval($v['val']);
					$period = NULL;
					FieldSQLDate::formatForDb(strtotime($v['period']), $period);
					
					if($val == 0){
						$dbLink->query(sprintf(
							"DELETE FROM vehicle_tot_rep_common_item_vals WHERE vehicle_owner_id = %d AND vehicle_tot_rep_common_item_id = %d AND period = %s"
							,$vehicle_owner_id
							,$item_id
							,$period
						));
					}else{
						$dbLink->query(sprintf(
							"INSERT INTO vehicle_tot_rep_common_item_vals
							(vehicle_owner_id, vehicle_tot_rep_common_item_id, period, value)
							VALUES (%d, %d, %s, %f)
							ON CONFLICT (vehicle_owner_id, vehicle_tot_rep_common_item_id, period) DO UPDATE SET
								value = %f"
							,$vehicle_owner_id
							,$item_id
							,$period
							,$val
							,$val
						));
					}
					
				}
			}
			
			$balance_values = json_decode($this->getExtVal($pm, 'balance_values'), TRUE);
			if(isset($balance_values) && is_array($balance_values) && count($balance_values)){
				foreach($balance_values as $p=>$v){
					$period = NULL;
					FieldSQLDate::formatForDb(strtotime($p), $period);
					$v_f = floatval($v);
					$dbLink->query(sprintf(
						"INSERT INTO vehicle_tot_rep_balances (vehicle_owner_id, period, value)
						VALUES (%d, %s, %f)
						ON CONFLICT (vehicle_owner_id, period) DO UPDATE
						SET value = %f"
						,$this->getExtDbVal($pm, 'balance_vehicle_owner_id')
						,$period
						,$v_f
						,$v_f
					));
					
				}
			}
			
			$dbLink->query("COMMIT");
			
		}catch (Exception $e){
			$dbLink->query("ROLLBACK");
			throw $e;
		}
	}
	

}
?>