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


class ProductionSite_Controller extends ControllerSQL{

	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			$param = new FieldExtString('name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtJSONB('elkon_connection'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtJSONB('elkon_params'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Активен';
			$param = new FieldExtBool('active'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('last_elkon_production_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtArray('missing_elkon_production_ids'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Зона';
			$param = new FieldExtInt('destination_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Вид завода';
			
				$param = new FieldExtEnum('production_plant_type',',','elkon,ammann'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='База';
			$param = new FieldExtInt('production_base_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Диспетчер (ТТН)';
			$param = new FieldExtInt('dispatcher_id'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('ProductionSite.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('ProductionSite_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtJSONB('elkon_connection'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtJSONB('elkon_params'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Активен';
			$param = new FieldExtBool('active'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('last_elkon_production_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtArray('missing_elkon_production_ids'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Зона';
			$param = new FieldExtInt('destination_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Вид завода';
			
				$param = new FieldExtEnum('production_plant_type',',','elkon,ammann'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='База';
			$param = new FieldExtInt('production_base_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Диспетчер (ТТН)';
			$param = new FieldExtInt('dispatcher_id'
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
			$pm->addEvent('ProductionSite.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('ProductionSite_Model');

			
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
		$pm->addEvent('ProductionSite.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('ProductionSite_Model');

			
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
		
		$this->setListModelId('ProductionSite_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('ProductionSiteForEditList_Model');		

			
		$pm = new PublicMethod('get_list_for_edit');
		
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

		
	}	
	
	public function get_list_for_edit($pm){
		$link = $this->getDbLink();		
		$model = new ProductionSiteForEditList_Model($this->getDbLink());
		$model->query("SELECT * FROM production_sites_for_edit_list",TRUE);
		$this->addModel($model);
		
	}

}
?>