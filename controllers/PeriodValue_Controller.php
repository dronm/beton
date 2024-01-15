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



class PeriodValue_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Вид значения';
			
				$f_params['required']=TRUE;
			
				$param = new FieldExtEnum('period_value_type',',','destination_price,destination_price_for_driver,demurrage_cost_per_hour,water_ship_cost'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Ключ';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('key'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDateTimeTZ('date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('val'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('PeriodValue.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('PeriodValue_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Вид значения';
			
				$param = new FieldExtEnum('period_value_type',',','destination_price,destination_price_for_driver,demurrage_cost_per_hour,water_ship_cost'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Ключ';
			$param = new FieldExtInt('key'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('val'
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
			$pm->addEvent('PeriodValue.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('PeriodValue_Model');

			
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
		$pm->addEvent('PeriodValue.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('PeriodValue_Model');

			
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
		
		$this->setListModelId('PeriodValue_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('PeriodValue_Model');		

			
		$pm = new PublicMethod('get_last_val');
		
				
	$opts=array();
	
		$opts['alias']='Вид значения';
		$opts['required']=TRUE;		
		$pm->addParam(new FieldExtEnum('period_value_type',$opts));
	
				
	$opts=array();
	
		$opts['alias']='Ключ';
		$opts['required']=TRUE;		
		$pm->addParam(new FieldExtInt('key',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	public function get_last_val($pm){
		$this->addNewModel(
			sprintf("SELECT *
				FROM period_values
				WHERE period_value_type = %s AND key = %d
					AND date_time <= now()::timestamp
				ORDER BY date_time desc
				LIMIT 1",
				$this->getExtDbVal($pm,'period_value_type'),
				$this->getExtDbVal($pm,'key'),
			),
			'PeriodValue_Model'
		);
	}


}
?>