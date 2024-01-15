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


class EntityContact_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			
				$param = new FieldExtEnum('entity_type',',','users,clients,suppliers,pump_vehicles,drivers'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('entity_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('contact_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtDateTimeTZ('mod_date_time'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('EntityContact.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('EntityContact_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$param = new FieldExtEnum('entity_type',',','users,clients,suppliers,pump_vehicles,drivers'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('entity_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('contact_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('mod_date_time'
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
			$pm->addEvent('EntityContact.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('EntityContact_Model');

			
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
		$pm->addEvent('EntityContact.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('EntityContact_Model');

			
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
		
		$this->setListModelId('EntityContactList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('EntityContactList_Model');		

		
	}	
	
	public static function get_entuty_descr($entityType){
		if($entityType == 'clients'){
			return 'Контрагенты';
		}else if($entityType == 'users'){
			return 'Пользователи';
		}else if($entityType == 'suppliers'){
			return 'Поставщики';			
		}else if($entityType == 'pump_vehicles'){
			return 'Насосы';			
		}
	}
	
	public function check_contact($pm, $oldId){
		$ent_exists = $this->getDbLink()->query_first(sprintf(
			"SELECT
				e_ct.entity_id,
				e_ct.entity_type,
				CASE
					WHEN e_ct.entity_type = 'clients' THEN
						(SELECT t.name FROM clients AS t WHERE t.id = e_ct.entity_id)
					WHEN e_ct.entity_type = 'users' THEN
						(SELECT t.name FROM users AS t WHERE t.id = e_ct.entity_id)
					WHEN e_ct.entity_type = 'suppliers' THEN
						(SELECT t.name_full FROM suppliers AS t WHERE t.id = e_ct.entity_id)
					WHEN e_ct.entity_type = 'pump_vehicles' THEN
						(SELECT
							pump_vehicles_ref(t, v, v_o)->>'descr'
						FROM pump_vehicles AS t
						LEFT JOIN vehicles AS v ON v.id = t.vehicle_id
						LEFT JOIN vehicle_owners AS v_o ON v_o.id = v.vehicle_owner_id
						WHERE t.id = e_ct.entity_id
					)
					ELSE 'Нет представления для '||e_ct.entity_type
				END AS entity_descr
			FROM entity_contacts AS e_ct
			WHERE e_ct.entity_type = %s AND e_ct.entity_id = %d
				AND e_ct.contact_id = %d
				AND (%d = 0 OR e_ct.id <> %d)"
			,$this->getExtDbVal($pm, 'entity_type')
			,$this->getExtDbVal($pm, 'entity_id')
			,$this->getExtDbVal($pm, 'contact_id')
			,$oldId
			,$oldId
		));
		if(is_array($ent_exists) && count($ent_exists) && isset($ent_exists['entity_id']) && intval($ent_exists['entity_id'])){
			throw new Exception(sprintf('Контакт уже существует у "%s": %s (код %d)'
				,self::get_entuty_descr($ent_exists['entity_type'])
				,$ent_exists['entity_descr']
				,$ent_exists['entity_id']				
			));
		}		
	}
	
	public function insert($pm){
		$this->check_contact($pm, 0);
		parent::insert($pm);
	}
	public function update($pm){
		$this->check_contact($pm, $this->getExtDbVal($pm, 'old_id'));
		parent::update($pm);
	}
	

}
?>