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


class UserOperation_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtString('operation_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('operation'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('status'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('percent'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDateTimeTZ('date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('error_text'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('comment_text'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDateTimeTZ('date_time_end'
				,$f_params);
		$pm->addParam($param);
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['user_id'
			,'operation_id'
			]
		];
		$pm->addEvent('UserOperation.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('UserOperation_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_user_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtString('old_operation_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('operation_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('operation'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('status'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('percent'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('error_text'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('comment_text'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('date_time_end'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('user_id',array(
			));
			$pm->addParam($param);
		
			$param = new FieldExtString('operation_id',array(
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['user_id'
				,'operation_id'
				]
			];
			$pm->addEvent('UserOperation.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('UserOperation_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('user_id'
		));		
		
		$pm->addParam(new FieldExtString('operation_id'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['user_id'
			,'operation_id'
			]
		];
		$pm->addEvent('UserOperation.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('UserOperation_Model');

			
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
		
		$this->setListModelId('UserOperation_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('user_id'
		));
		
		$pm->addParam(new FieldExtString('operation_id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('UserOperation_Model');		

		
	}	
	
}
?>