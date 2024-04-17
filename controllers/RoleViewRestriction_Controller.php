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



require_once(FRAME_WORK_PATH.'basic_classes/SessionVarManager.php');

class RoleViewRestriction_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Роль';
			
				$param = new FieldExtEnum('role_id',',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Сколько дней разрешено для просмотра назад';
			$param = new FieldExtInt('back_days_allowed'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Сколько дней разрешено для просмотра вперед';
			$param = new FieldExtInt('front_days_allowed'
				,$f_params);
		$pm->addParam($param);
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['role_id'
			]
		];
		$pm->addEvent('RoleViewRestriction.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('RoleViewRestriction_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtEnum('old_role_id',',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			
				$f_params['alias']='Роль';
			
				$param = new FieldExtEnum('role_id',',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Сколько дней разрешено для просмотра назад';
			$param = new FieldExtInt('back_days_allowed'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Сколько дней разрешено для просмотра вперед';
			$param = new FieldExtInt('front_days_allowed'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtEnum('role_id',',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing',array(
			
				'alias'=>'Роль'
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['role_id'
				]
			];
			$pm->addEvent('RoleViewRestriction.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('RoleViewRestriction_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtEnum('role_id'
		,',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing'));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['role_id'
			]
		];
		$pm->addEvent('RoleViewRestriction.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('RoleViewRestriction_Model');

			
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
		
		$this->setListModelId('RoleViewRestriction_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtEnum('role_id'
		,',','admin,owner,boss,operator,manager,dispatcher,accountant,lab_worker,supplies,sales,plant_director,supervisor,vehicle_owner,client,weighing'));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('RoleViewRestriction_Model');		

		
	}	
	

	public function update_user_restrictions($pm, $oper){
	
		$role_id = $this->getExtVal($pm,'role_id');
		$back_days_allowed = $this->getExtVal($pm,'back_days_allowed');
		$front_days_allowed = $this->getExtVal($pm,'front_days_allowed');
		
		if($oper=='update' && isset($role_id)){
			//change role - error
			throw new Exception("Сначала удалите правило, потом заведите новое!");
		
		}else if($oper!='insert' && (!isset($back_days_allowed) || !isset($front_days_allowed)) ){
			//get fields
			$ar_role = $this->getDbLink()->query_first(sprintf(
				"SELECT
					back_days_allowed,
					front_days_allowed
				FROM role_view_restrictions WHERE role_id=%s"
				,($oper=='update')? $this->getExtDbVal($pm,'old_role_id'):$this->getExtDbVal($pm,'role_id')
			));
			if(!is_array($ar_role) || !count($ar_role)){
				throw new Exception('Element not found.');
			}
			if(!isset($back_days_allowed)){
				$back_days_allowed = $ar_role['back_days_allowed'];
			}
			if(!isset($front_days_allowed)){
				$front_days_allowed = $ar_role['front_days_allowed'];
			}
		}
		if($oper=='update'){
			$role_id = $this->getExtVal($pm,'old_role_id');
		}		
	
		$sess_qid = $this->getDbLink()->query(sprintf(
		"SELECT
			sess_enc_read(l.session_id, '%s') AS data,
			l.session_id
			
		FROM logins AS l
		LEFT JOIN users AS u on u.id= l.user_id
		where l.date_time_out is null
		AND u.role_id = '%s'"
		,SESSION_KEY
		,$role_id
		));
		$my_sess = $_SESSION;
		
		if($oper=='delete'){
			$new_val = NULL;
		}else{
			$new_val = json_decode(sprintf('{"back_days_allowed":%s,"front_days_allowed":%s}', is_null($back_days_allowed)? 'null':$back_days_allowed, is_null($front_days_allowed)? 'null':$front_days_allowed));
		}
		try{
			while($sess_ar = $this->getDbLink()->fetch_array($sess_qid)){				
				//put to $_SESSION
				session_decode(base64_decode($sess_ar['data']));
				$old_val = SessionVarManager::getValue('role_view_restriction');
				SessionVarManager::setValue('role_view_restriction', $new_val, TRUE);
				//update
				try{
					$this->getDbLinkMaster()->query(sprintf(
						"SELECT sess_enc_write('%s','%s','%s','%s')"
						,$sess_ar['session_id']
						,base64_encode(session_encode())
						,SESSION_KEY
						,isset($_SERVER["REMOTE_ADDR"])? $_SERVER["REMOTE_ADDR"] : '127.0.0.1'
					));
				}catch(Exception $e) {
					SessionVarManager::setValue('role_view_restriction', $old_val, TRUE);	
				}
			}
		}finally{
			$_SESSION = $my_sess;
		}
	}
	
	public function update($pm){
		$this->update_user_restrictions($pm, 'update');
		parent::update($pm);
	}

	public function insert($pm){
		$this->update_user_restrictions($pm, 'insert');
		parent::insert($pm);
	}

	public function delete($pm){
		$this->update_user_restrictions($pm, 'delete');
		parent::delete($pm);
	}
	


}
?>