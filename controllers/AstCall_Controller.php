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


require_once(FRAME_WORK_PATH.'basic_classes/ModelVars.php');
require_once(FRAME_WORK_PATH.'basic_classes/Field.php');
require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/CondParamsSQL.php');
require_once('models/AstCallList_Model.php');

class AstCall_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtText('old_unique_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtText('unique_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('caller_id_num'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('ext'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTime('start_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTime('end_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('client_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$param = new FieldExtEnum('call_type',',','in,out'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('user_id_to'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('answer_unique_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTime('dt'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('manager_comment'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtBool('informed'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('create_date'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('record_link'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('call_status'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('contact_id'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtText('unique_id',array(
			));
			$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('contact_name'
			,$f_params);
		$pm->addParam($param);		
		
			$f_params = array();
			$param = new FieldExtString('client_name'
			,$f_params);
		$pm->addParam($param);		
		
			$f_params = array();
			
			$param = new FieldExtEnum('client_kind',',','buyer,acc,else'
			,$f_params);
		$pm->addParam($param);		
		
			$f_params = array();
			$param = new FieldExtInt('client_come_from_id'
			,$f_params);
		$pm->addParam($param);		
		
			$f_params = array();
			$param = new FieldExtInt('client_type_id'
			,$f_params);
		$pm->addParam($param);		
		
			$f_params = array();
			$param = new FieldExtString('manager_comment'
			,$f_params);
		$pm->addParam($param);		
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['unique_id'
				]
			];
			$pm->addEvent('AstCall.update',$ev_opts);
			
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('contact_name',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('client_name',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtEnum('client_kind',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('client_come_from_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('client_type_id',$opts));
	
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('manager_comment',$opts));
	
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('AstCall_Model');

			
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

			$f_params = array();
			$param = new FieldExtString('new_clients'
			,$f_params);
		$pm->addParam($param);		
		
		$this->addPublicMethod($pm);
		
		$this->setListModelId('AstCallList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtText('unique_id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('AstCallList_Model');		

			
		$pm = new PublicMethod('client_call_hist');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('client_ship_hist');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('active_call');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('active_call_inform');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('set_active_call_client_kind');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('kind',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('new_client');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('ast_call_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('client_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('client_name',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('contact_name',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('client_type_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('client_come_from_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('client_comment_text',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('destination_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('concrete_type_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('unload_type',$opts));
	
				
	$opts=array();
	
		$opts['length']=15;				
		$pm->addParam(new FieldExtFloat('concrete_price',$opts));
	
				
	$opts=array();
	
		$opts['length']=15;				
		$pm->addParam(new FieldExtFloat('destination_price',$opts));
	
				
	$opts=array();
	
		$opts['length']=15;				
		$pm->addParam(new FieldExtFloat('unload_price',$opts));
	
				
	$opts=array();
	
		$opts['length']=15;				
		$pm->addParam(new FieldExtFloat('total',$opts));
	
				
	$opts=array();
	
		$opts['length']=19;				
		$pm->addParam(new FieldExtFloat('quant',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('offer_result',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('comment_text',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('manager_report');
		
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

			
		$pm = new PublicMethod('restart_ast');
		
		$this->addPublicMethod($pm);

		
	}	
	

	private static function active_call_query($extraCond='',$commonExt=FALSE){		
		//return "SELECT t.* FROM ast_calls_current t WHERE t.unique_id ='1705400883.117604'";
		//WHERE t.unique_id='1615797498.13391' limit 1";
	
		return sprintf("SELECT t.* FROM ast_calls_current t
		WHERE t.ext='%s'
			%s LIMIT 1",
			($commonExt)? COMMON_EXT:$_SESSION['tel_ext'],
			$extraCond
		);
	}

	public function active_call_inform($pm){		
		if ($_SESSION['tel_ext']){
			$q = sprintf(
			"UPDATE ast_calls
			SET informed=TRUE
			WHERE unique_id = (SELECT t.unique_id FROM (%s) t)
			RETURNING unique_id,caller_id_num AS num,
				(SELECT cl.name
				FROM clients cl WHERE cl.id=client_id) AS client_descr",
			self::active_call_query(' AND coalesce(t.informed,FALSE)=FALSE')
			);
			$ar = $this->getDbLinkMaster()->query_first($q);
			
			if(is_array($ar) && count($ar) && isset($ar['unique_id']) ){
				$m = new ModelVars(array(
					'id'=>'active_call',
					'values'=>array(
					new Field('unique_id',DT_STRING,array('value'=>$ar['unique_id'])),
					new Field('num',DT_STRING,array('value'=> isset($ar['num'])? $ar['num']:'' )),
					new Field('client_descr',DT_STRING,array('value'=>isset($ar['client_descr'])? $ar['client_descr']:'' ))
					)));
				$this->addModel($m);
			}
		}
		$this->addNewModel(
			self::active_call_query(' AND t.answer_time IS NULL',TRUE),
			'active_call_common'
			);
		
	}
	public function active_call($pm){		
		if ($_SESSION['tel_ext']){
			$q = self::active_call_query();
			$ar = $this->getDbLink()->query_first($q);
			$this->addNewModel($q,'AstCallCurrent_Model');
			
			if (is_array($ar)&&count($ar)>0){
				if ($ar['contact_id']){					
					$this->add_contact_call_hist($ar['contact_id']);
				}
				if ($ar['client_id']){					
					$this->add_client_ship_hist($ar['client_id']);				
				}
				return $ar['client_id'];
			}			
		}		
	}

	public static function add_active_call($dbLink,$models){		
		$q = self::active_call_query();
		$ar = $dbLink->query_first($q);
		
		if (is_array($ar)&&count($ar)>0){
			$models->append(new ModelVars(
				array('name'=>'Vars',
					'id'=>'AstCallCurrent_Model',
					'values'=>array(
						new Field('unique_id',DT_STRING, array('value'=>$ar['unique_id'])),
						new Field('ext',DT_STRING,array('value'=>$ar['ext'])),
						new Field('contact_tel',DT_STRING,array('value'=>$ar['contact_tel'])),
						new Field('ring_time',DT_DATETIME,array('value'=>$ar['ring_time'])),
						new Field('answer_time',DT_DATETIME,array('value'=>$ar['answer_time'])),
						new Field('hangup_time',DT_DATETIME,array('value'=>$ar['hangup_time'])),
						new Field('manager_comment',DT_STRING,array('value'=>$ar['manager_comment'])),
						new Field('informed',DT_BOOL,array('value'=>$ar['informed'])),
						new Field('clients_ref',DT_STRING,array('value'=>$ar['clients_ref'])),
						new Field('contact_name',DT_STRING,array('value'=>$ar['contact_name'])),
						//new Field('contact_id',DT_STRING,array('value'=>$ar['contact_id'])),
						new Field('client_id',DT_STRING,array('value'=>$ar['client_id'])),
						//new Field('contact_email',DT_STRING,array('value'=>$ar['contact_email'])),
						//new Field('contact_post_name',DT_STRING,array('value'=>$ar['contact_post_name'])),
						new Field('client_come_from_ref',DT_STRING,array('value'=>$ar['client_come_from_ref'])),
						new Field('client_types_ref',DT_STRING,array('value'=>$ar['client_types_ref'])),
						new Field('client_kind_descr',DT_STRING,array('value'=>$ar['client_kind_descr'])),
					)
				)
			));		
		
			$models->append(self::get_client_call_hist_model(
					$dbLink,
					isset($ar['client_id'])? $ar['client_id'] : NULL,
					isset($ar['contact_id'])? $ar['contact_id'] : NULL
				)
			);
			if (isset($ar['client_id'])){				
				$models->append(self::get_client_ship_hist_model($dbLink, $ar['client_id']));
			}
		}			
	}

	public static function get_client_call_hist_model($dbLink, $clientId, $contactId){
		$cond = '';
		if(!is_null($clientId)){
			$cond.= sprintf('client_id=%d', $clientId);
		}
		if(!is_null($contactId)){
			if(strlen($cond)){
				$cond.= ' OR ';
			}
			$cond.= sprintf('contact_id=%d', $contactId);
		}
		$model = new ModelSQL($dbLink,array('id'=>'AstCallClientCallHistoryList_Model'));
		if($cond != ''){
			$model->query(
				sprintf(
					"SELECT * FROM ast_calls_client_call_history_list
					WHERE %s
					ORDER BY dt DESC
					LIMIT const_call_history_count_val()"
				,$cond
				)
				,TRUE
			);
		}
		return $model;
	}

	protected function add_client_call_hist($clientId, $contactId){		
		$m = self::get_client_call_hist_model($this->getDbLink(), $clientId, $contactId);
		$this->addModel($m);
	}

	public function client_call_hist($pm){		
		$q = self::active_call_query();
		$this->add_client_call_hist(
			sprintf('(SELECT t.client_id FROM (%s) t)', $q)
			,sprintf('(SELECT t.contact_id FROM (%s) t)', $q)
		);
	}

	
	public static function get_client_ship_hist_model($dbLink,$clientId){			
		$model = new ModelSQL($dbLink,array('id'=>'AstCallClientShipHistoryList_Model'));
		$model->query(
			sprintf(
			"SELECT * FROM ast_calls_client_ship_history_list
			WHERE client_id=%s
			ORDER BY date_time DESC
			LIMIT const_call_history_count_val()",
			$clientId)
		);
		return $model;
	}
	
	public function add_client_ship_hist($clientId){			
		$m = self::get_client_ship_hist_model($this->getDbLink(),$clientId);
		$this->addModel($m);
	}
	
	public function client_ship_hist($pm){			
		$this->add_client_ship_hist(
			sprintf(
				'(SELECT t.client_id FROM (%s) t)'
				,self::active_call_query()
			)
		);	
	}

	public function update($pm){
		$l = $this->getDbLinkMaster();

		//Возможные изменяемые поля
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->add('contact_name', DT_STRING,$pm->getParamValue('contact_name'));
		$p->add('contact_tel', DT_STRING,$pm->getParamValue('contact_tel'));
		$p->add('client_id', DT_INT,$pm->getParamValue('client_id'));
		$p->add('client_name', DT_STRING,$pm->getParamValue('client_name'));				
		$p->add('client_come_from_id', DT_INT,$pm->getParamValue('client_come_from_id'));
		$p->add('client_type_id', DT_INT,$pm->getParamValue('client_type_id'));
		$p->add('client_kind', DT_STRING,$pm->getParamValue('client_kind'));
		$p->add('manager_comment', DT_STRING,$pm->getParamValue('manager_comment'));
		$p->add('unique_id', DT_STRING,$pm->getParamValue('old_unique_id'));
	
		//old values
		$ar_old = $l->query_first(sprintf(
		"SELECT
			ast.client_id,
			ast.manager_comment,
			ast.contact_id,
			cl.name AS client_name,
			ct.name AS contact_name,
			cl.client_kind AS client_kind,
			cl.client_come_from_id,
			cl.client_type_id,
			ast.caller_id_num						
			
		FROM ast_calls AS ast
		LEFT JOIN contacts AS ct ON ct.id = ast.contact_id
		LEFT JOIN clients AS cl ON cl.id = ast.client_id
		LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'clients' AND e_ct.entity_id = ast.client_id
		WHERE ast.unique_id = %s",
		$p->getDbVal('unique_id')
		));

		if(!is_array($ar_old) || !count($ar_old)){
			throw new Exception('call not found.');
		}
	
		$l->query("BEGIN");
		try{				
			//Меняем, если что-то поменялось
						
			$contact_id = $p->getDbVal('contact_id');
			$client_id = $p->getDbVal('client_id');
			
			//В звонке нет контака, но пришло имя - создать контакт			
			if(!isset($ar_old['contact_id']) && !is_null($pm->getParamValue('contact_name'))){
				$ar_ct = $l->query_first(sprintf(
					"INSERT INTO contacts (name, tel)
					VALUES (%s, %s)
					ON CONFLICT (tel) DO UPDATE SET name = %s
					RETURNING id"
					,$p->getDbVal('contact_name')
					,$ar_old['caller_id_num']
					,$p->getDbVal('contact_name')
					)
				);
				if(is_array($ar_ct) && count($ar_ct)){
					$contact_id = $ar_ct['id'];					
				}
			}

			//В звонке нет контргента, но пришел контрагент
			if(!isset($ar_old['client_id']) && !is_null($pm->getParamValue('client_id'))){
				$ar_cl = $l->query_first(sprintf(
					"INSERT INTO entity_contacts (entity_type, entity_id, contact_id)
					VALUES ('clients', %d, %d)
					ON CONFLICT (entity_type, entity_id, contact_id) DO UPDATE SET entity_type = 'clients'
					RETURNING id"
					,$p->getDbVal('client_id')
					,$contact_id
				));
				if(is_array($ar_cl) && count($ar_cl)){
					$client_id = ar_cl['id'];
				}
			}
			//Поменялось имя контакта
			if(!is_null($pm->getParamValue('contact_name')) && isset($ar_old['contact_name']) && $ar_old['contact_name'] != $pm->getParamValue('contact_name') ){
				$l->query_first(sprintf(
					"UPDATE contacts SET name = %s WHERE id = %d", $p->getDbVal('contact_name'), $ar_old['contact_id']
				));
			}
						
			//Поменялся клиент
			if(!is_null($pm->getParamValue('client_id'))
			&& isset($ar_old['client_id'])
			&& ($ar_old['client_id'] != $pm->getParamValue('client_id'))
			&& isset($ar_old['contact_id'])
			&& ($ar_old['contact_id'] != $pm->getParamValue('contact_id'))
			){
				$l->query(sprintf(
					"DELETE FROM entity_contacts WHERE contact_id = %d AND entity_type = 'clients' AND entity_id = %d"
					,$ar_old['contact_id']
					,$ar_old['client_id']
				));					
				$l->query(sprintf(
					"UPDATE entity_contacts
					SET entity_id = %d
					WHERE contact_id = %d AND entity_type = 'clients' AND entity_id = %d"
					,$p->getDbVal('client_id')
					,$ar_old['contact_id']					
					,$ar_old['client_id']
				));
			}

			//Звонок: manager_comment, contact_id, client_id
			if(
				!is_null($pm->getParamValue('manager_comment'))
				||isset($client_id)
				||isset($contact_id)
			){
				$upd_f = '';
				if(!is_null($pm->getParamValue('manager_comment'))){
					$upd_f.= ($upd_f == '')? '' : ', ';
					$upd_f.= sprintf("manager_comment = %s", $p->getDbVal('manager_comment'));
				}
				if(!is_null($pm->getParamValue('client_id'))){
					$upd_f.= ($upd_f == '')? '' : ', ';
					$upd_f.= sprintf("client_id = %d", $client_id);
				}
				if(!is_null($pm->getParamValue('contact_id'))){
					$upd_f.= ($upd_f == '')? '' : ', ';
					$upd_f.= sprintf("contact_id = %d", $contact_id);
				}
				$l->query(sprintf(
						"UPDATE ast_calls SET %s WHERE ast_calls.unique_id = %s"
						,$upd_f
						,$p->getDbVal('unique_id')
					)
				);
			}
			
			$l->query("COMMIT");
			
		}catch (Exception $e){
			$l->query("ROLLBACK");
			throw new Exception($e->getMessage());
		}
		parent::update($pm);			
	}

		
	public function set_active_call_client_kind($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->add('id',DT_STRING,$pm->getParamValue('id'));
		$p->add('kind',DT_STRING,$pm->getParamValue('kind'));
	
		$l = $this->getDbLinkMaster();
		$l->query("BEGIN");
			//Новый клиент
			$ar = $l->query_first(sprintf(
			"INSERT INTO clients
			(name, client_kind)
			VALUES ('Клиент '||
				(SELECT coalesce(max(id),0)+1
				FROM clients),%s)
			RETURNING id, name",
			$p->getParamById('kind'))
			);
			
			//Контакт клиента
			$l->query(sprintf("INSERT INTO client_tels
			(client_id,tel)
			VALUES (%d,
				(SELECT ast.caller_id_num FROM ast_calls ast WHERE ast.unique_id=%s)
			)",
			$ar['id'],
			$p->getParamById('id')
			));

			//Звонок
			$l->query(sprintf(
				"UPDATE ast_calls
				SET client_id=%d
				WHERE unique_id=%s",
				$ar['id'],
				$p->getParamById('id')
			));

			$this->addModel(new ModelVars(
				array('name'=>'Vars',
					'id'=>'InsertedId_Model',
					'values'=>array(
							new Field('client_id',DT_INT,array('value'=>$ar['id']))
							,new Field('client_name',DT_STRING,array('value'=>$ar['name']))
						)						
					)
				)
			);					
			
		try{
			$l->query("COMMIT");
		}
		catch (Exception $e){
			$l->query("ROLLBACK");
			throw new Exception($e->getMessage());
		}
	}
	public function new_client($pm){
		$p = new ParamsSQL($pm,$this->getDbLink());
		$p->addAll();
		
		$l = $this->getDbLinkMaster();
		$l->query('BEGIN');
		try{
			$client_id = $p->getParamById('client_id');
			if (!$client_id||$client_id=='null'){
				//новый клиент
				$client_name = $p->getParamById('client_name');
				if ($client_name=="''"){
					$client_name = $p->getParamById('contact_name');
				}
				if ($client_name=="''"||$client_name=="null"){
					$ar = $l->query_first("SELECT COALESCE(max(id),0)+1 AS new_id FROM clients");
					$client_name = "'Клиент ".$ar['new_id']."'";
				}
				$ar = $l->query_first(sprintf(
				"INSERT INTO clients
					(name,name_full,manager_comment,
					client_come_from_id,
					client_type_id,client_kind,
					manager_id)
				VALUES
					(%s,%s,
					%s,
					%d,%d,'buyer',
					(SELECT a.user_id
					FROM ast_calls AS a
					WHERE a.unique_id=%s)
					)
				RETURNING id",
				$client_name,$client_name,
				$p->getParamById('client_comment_text'),
				$p->getParamById('client_come_from_id'),
				$p->getParamById('client_type_id'),
				$p->getParamById('ast_call_id')
				));
				$client_id = $ar['id'];
			}
			else{
				//старый клиент
				$ar = $l->query_first(sprintf(
					"SELECT name
					FROM clients WHERE id=%d",
				$client_id
				));
				if (!is_array($ar)||!count($ar)){
					throw new Exception("Не найдне клиент!");
				}
				$client_name = "'".$ar['name']."'";
			}
			
			//Контакт клиента
			$l->query(sprintf(
			"INSERT INTO client_tels
				(client_id,tel,name)
			VALUES (%d,(
				SELECT format_cel_phone(ast.caller_id_num)
				FROM ast_calls ast WHERE ast.unique_id=%s),
				%s)",
			$client_id,
			$p->getParamById('ast_call_id'),
			$p->getParamById('contact_name')
			));
			
			$concrete_type_id = $p->getParamById('concrete_type_id');
			$concrete_type_id = (is_null($concrete_type_id))? 'null':$concrete_type_id;
			$destination_id = $p->getParamById('destination_id');			
			$destination_id = (is_null($destination_id))? 'null':$destination_id;
			
			$l->query(sprintf(
			"INSERT INTO offer
				(client_id,
				unload_type,unload_price,
				concrete_type_id,concrete_price,
				destination_id,destination_price,
				total,quant,comment_text,
				offer_result,date_time,
				ast_call_unique_id
				)
			VALUES (%d,
				%s,%f,
				%s,%f,
				%s,%f,
				%f,%f,%s,
				%s,now()::timestamp,
				%s
			)",
			$client_id,
			$p->getParamById('unload_type'),$p->getParamById('unload_price'),
			$concrete_type_id,$p->getParamById('concrete_type_price'),
			$destination_id,$p->getParamById('destination_price'),
			$p->getParamById('total'),$p->getParamById('quant'),$p->getParamById('comment_text'),
			$p->getParamById('offer_result'),
			$p->getParamById('ast_call_id')
			));			
			
			$l->query(sprintf(
			"UPDATE ast_calls SET client_id=%d
			WHERE unique_id=%s",
			$client_id,
			$p->getParamById('ast_call_id')
			));
			
			$l->query('COMMIT');
		}		
		catch (Exception $e){
			$l->query("ROLLBACK");
			throw new Exception($e->getMessage());
		}
		
		$this->addNewModel(sprintf(
			"SELECT
				%d AS client_id,
				%s AS client_descr",
		$client_id,$client_name),
		'new_client');
		
	}
	public function manager_report($pm){
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		$manager_id = ($cond->paramExists('manager_id','e'))?
			$cond->getValForDb('manager_id','e',DT_INT) : 0;
	
		$this->addNewModel(sprintf(
		"SELECT * FROM ast_calls_report(%s,%s,%d)",
		$cond->getValForDb('date_time','ge',DT_DATETIME),
		$cond->getValForDb('date_time','le',DT_DATETIME),
		$manager_id
		));
	}
	
	public function get_list($pm){		
		$model = new AstCallList_Model($this->getDbLink());
		$from = null; $count = null;
		$limit = $this->limitFromParams($pm,$from,$count);
		$calc_total = ($count>0);
		if ($from){
			$model->setListFrom($from);
		}
		if ($count){
			$model->setRowsPerPage($count);
		}
		
		$order = $this->orderFromParams($pm,$model);		
		$where = $this->conditionFromParams($pm,$model);
		
		$fields = $this->fieldsFromParams($pm);		
		
		if(isset($where)){
			$new_clients = $where->getFieldsById('new_clients','=');
			if ($new_clients&&count($new_clients)){
				if ($new_clients[0]->getValue()=='t'){
					$start_time_from = $where->getFieldsById('start_time','>=');
					$f = clone $model->getFieldById('create_date');
					$f->setValue($start_time_from[0]->getValue());
					$where->addField($f,'>=');
				
					$start_time_to = $where->getFieldsById('start_time','<=');
					$f = clone $model->getFieldById('create_date');
					$f->setValue($start_time_to[0]->getValue());
					$where->addField($f,'<=');
			
				}
				$where->deleteField('new_clients','=');
			}
		}		
		$model->select(FALSE,
					$where,
					$order,
					$limit,
					$fields,
					NULL,
					NULL,
					$calc_total,TRUE);
		//
		$this->addModel($model);
	}
	
	public function restart_ast($pm){		
		file_put_contents('/tmp/server_cmd','restart_asttodb');
	}

}
?>
