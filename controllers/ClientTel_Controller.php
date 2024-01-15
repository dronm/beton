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


class ClientTel_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			$param = new FieldExtInt('client_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='ФИО';
			$param = new FieldExtText('name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Телефон';
			
				$f_params['required']=TRUE;
			$param = new FieldExtString('tel'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Эл.почта';
			
				$f_params['required']=FALSE;
			$param = new FieldExtString('email'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Должность';
			
				$f_params['required']=FALSE;
			$param = new FieldExtString('post'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('search'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('ClientTel.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('ClientTel_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('client_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='ФИО';
			$param = new FieldExtText('name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Телефон';
			$param = new FieldExtString('tel'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Эл.почта';
			$param = new FieldExtString('email'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Должность';
			$param = new FieldExtString('post'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('search'
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
			$pm->addEvent('ClientTel.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('ClientTel_Model');

			
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
		$pm->addEvent('ClientTel.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('ClientTel_Model');

			
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
		
		$this->setListModelId('ClientTelList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('ClientTel_Model');		

			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('search'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('ClientTelList_Model');

			
		$pm = new PublicMethod('complete_tel');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtString('search',$opts));
	
				
	$opts=array();
			
		$pm->addParam(new FieldExtBool('tm_exists',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('upsert');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('client_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=250;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('name',$opts));
	
				
	$opts=array();
	
		$opts['length']=50;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_ref');
		
				
	$opts=array();
	
		$opts['length']=50;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	public function get_ref($pm){
		$this->addNewModel(sprintf(
			"SELECT client_tels_ref_on_tel(%s) AS ref"
			,$this->getExtDbVal($pm, 'tel')
		), 'Ref_Model');		
	}

	public function upsert($pm){
		$this->addNewModel(sprintf(
			"SELECT client_tels_upsert(%d, %s, %s) AS ref"
			,$this->getExtDbVal($pm, 'client_id')
			,$this->getExtDbVal($pm, 'name')
			,$this->getExtDbVal($pm, 'tel')
		), 'Ref_Model');
	}

	public function complete_tel($pm){
		$cond = '';
		$tm_exists = $this->getExtVal($pm, 'tm_exists');		
		if($tm_exists){
			$cond = ' AND tl.tm_exists';
		}
		$this->addNewModel(sprintf(
			"SELECT
				tl.*
			FROM client_tels_list AS tl
			WHERE lower(tl.search) LIKE '%%'||lower(%s)||'%%'%s
			ORDER BY search
			LIMIT 10"
			,$this->getExtDbVal($pm, 'search')
			,$cond
		), 'ClientTelList_Model');		
	}


}
?>