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


class Contact_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Наименование';
			
				$f_params['required']=TRUE;
			$param = new FieldExtString('name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Должность';
			$param = new FieldExtInt('post_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Email';
			
				$f_params['required']=FALSE;
			$param = new FieldExtString('email'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Телефон';
			
				$f_params['required']=FALSE;
			$param = new FieldExtString('tel'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Добавочный номер';
			$param = new FieldExtString('tel_ext'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Описание для поиска';
			$param = new FieldExtText('descr'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Комментарий';
			$param = new FieldExtText('comment_text'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('Contact.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('Contact_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Наименование';
			$param = new FieldExtString('name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Должность';
			$param = new FieldExtInt('post_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Email';
			$param = new FieldExtString('email'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Телефон';
			$param = new FieldExtString('tel'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Добавочный номер';
			$param = new FieldExtString('tel_ext'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Описание для поиска';
			$param = new FieldExtText('descr'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Комментарий';
			$param = new FieldExtText('comment_text'
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
			$pm->addEvent('Contact.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('Contact_Model');

			
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
		$pm->addEvent('Contact.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('Contact_Model');

			
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
		
		$this->setListModelId('ContactList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('ContactDialog_Model');		

			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('descr'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('ContactList_Model');

			
		$pm = new PublicMethod('complete_tm');
		
				
	$opts=array();
	
		$opts['alias']='Описание для поиска';		
		$pm->addParam(new FieldExtText('descr',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('upsert');
		
				
	$opts=array();
	
		$opts['length']=250;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('name',$opts));
	
				
	$opts=array();
	
		$opts['length']=11;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
				
	$opts=array();
	
		$opts['length']=100;				
		$pm->addParam(new FieldExtString('email',$opts));
	
				
	$opts=array();
	
		$opts['length']=20;				
		$pm->addParam(new FieldExtString('tel_ext',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	public function upsert($pm){
		$this->addNewModel(sprintf(
			"SELECT contacts_upsert(%s, %s, %s %s) AS ref"
			,$this->getExtDbVal($pm, 'name')
			,$this->getExtDbVal($pm, 'tel')
			,$this->getExtDbVal($pm, 'email')
			,$this->getExtDbVal($pm, 'tel_ext')
		), 'Ref_Model');
	}

	public function complete_tm($pm){
		$this->addNewModel(sprintf(
			"SELECT
				ct.*
			FROM contacts_list AS ct
			WHERE (lower(ct.tel) LIKE '%%'||lower(%s)||'%%'
				OR lower(ct.name) LIKE '%%'||lower(%s)||'%%')
				AND ct.tm_activated
			ORDER BY ct.name
			LIMIT 10"
			,$this->getExtDbVal($pm, 'descr')
			,$this->getExtDbVal($pm, 'descr')
		), 'ContactList_Model');		
	}


}
?>