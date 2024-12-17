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



require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

class Client_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Наименование';
			
				$f_params['required']=TRUE;
			$param = new FieldExtString('name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Полное наименование';
			$param = new FieldExtText('name_full'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Сотовый телефон';
			
				$f_params['required']=FALSE;
			$param = new FieldExtString('phone_cel'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Комментарий';
			$param = new FieldExtText('manager_comment'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Вид контрагента';
			$param = new FieldExtInt('client_type_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Тип контрагента';
			
				$param = new FieldExtEnum('client_kind',',','buyer,acc,else'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Источник обращения';
			$param = new FieldExtInt('client_come_from_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Менеджер';
			$param = new FieldExtInt('manager_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDate('create_date'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=FALSE;
			$param = new FieldExtString('email'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('inn'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('kpp'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('address_legal'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Аккаунт';
			$param = new FieldExtInt('user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Дата начала выборки данных';
			$param = new FieldExtDate('account_from_date'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='БИК банка';
			$param = new FieldExtString('bank_bik'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Банковский счет';
			$param = new FieldExtString('bank_account'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Ссылка на справочник 1с';
			$param = new FieldExtJSONB('ref_1c'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtFloat('shipment_quant_for_cost'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('Client.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('Client_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			
				$f_params['alias']='Код';
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Наименование';
			$param = new FieldExtString('name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Полное наименование';
			$param = new FieldExtText('name_full'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Сотовый телефон';
			$param = new FieldExtString('phone_cel'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Комментарий';
			$param = new FieldExtText('manager_comment'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Вид контрагента';
			$param = new FieldExtInt('client_type_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Тип контрагента';
			
				$param = new FieldExtEnum('client_kind',',','buyer,acc,else'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Источник обращения';
			$param = new FieldExtInt('client_come_from_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Менеджер';
			$param = new FieldExtInt('manager_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDate('create_date'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('email'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('inn'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('kpp'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('address_legal'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Аккаунт';
			$param = new FieldExtInt('user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Дата начала выборки данных';
			$param = new FieldExtDate('account_from_date'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='БИК банка';
			$param = new FieldExtString('bank_bik'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Банковский счет';
			$param = new FieldExtString('bank_account'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Ссылка на справочник 1с';
			$param = new FieldExtJSONB('ref_1c'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtFloat('shipment_quant_for_cost'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('id',array(
			
				'alias'=>'Код'
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['id'
				]
			];
			$pm->addEvent('Client.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('Client_Model');

			
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
		$pm->addEvent('Client.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('Client_Model');

			
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
		
		$this->setListModelId('ClientList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('ClientDialog_Model');		

			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('name'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('Client_Model');

			
		$pm = new PublicMethod('complete_for_order');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtString('name',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('union');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('main_client_id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('client_ids',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('set_duplicate_valid');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('tel',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('client_ids',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_duplicates_list');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('from',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('ord_fields',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtString('ord_directs',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('insert_from_order');
		
				
	$opts=array();
	
		$opts['length']=100;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('name',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}
	public function union($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();		
		
		$client_ids = $params->getVal('client_ids');
		//validation
		$ids_ar = split(',',$client_ids);
		foreach($ids_ar as $id){
			if (!ctype_digit($id)){
				throw new Exception('Not int found!');
			}
		}
		
		$this->getDbLinkMaster()->query(sprintf(
		//throw new Exception(sprintf(
			"SELECT clients_union(%d,ARRAY[%s])",
			$params->getParamById('main_client_id'),
			$client_ids
		));
	}
	public function get_duplicates_list($pm){
		$this->addNewModel("SELECT * FROM client_duplicates_list",
			'get_duplicates_list'
		);
	}
	public function set_duplicate_valid($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();		
		
		$client_ids = $params->getVal('client_ids');
		$tel = $params->getDbVal('tel');
		
		//validation
		$ids_ar = split(',',$client_ids);
		foreach($ids_ar as $id){
			if (!ctype_digit($id)){
				throw new Exception('Not int found!');
			}
		}
		$l = $this->getDbLinkMaster();
		foreach($ids_ar as $id){
			$l->query(sprintf(
				"INSERT INTO client_valid_duplicates
				(tel,client_id)
				VALUES (%s,%d)",
				$tel,
				$id
			));
		}
	}
	public function insert($pm){
		if (!$pm->getParamValue('manager_id')){
			$pm->setParamValue('manager_id',$_SESSION['user_id']);
		}
		parent::insert($pm);
	}
	
	public function insert_from_order($pm){
		$res = $this->getDbLink()->query_first(sprintf("SELECT id FROM clients WHERE name=%s",$this->getExtDbVal($pm,"name")));
		if(!is_array($res) || !count($res)){
			$res = $this->getDbLinkMaster()->query_first(sprintf("INSERT INTO clients (name,name_full) VALUES (%s,%s) RETURNING id",
			$this->getExtDbVal($pm,"name"),
			$this->getExtDbVal($pm,"name")
			));
		}
		$this->addModel(new ModelVars(
			array('id'=>'Client_Model',
				'values'=>array(
					new Field('id',DT_INT,
						array('value'=>$res['id'])
					)
				)
			)
		));		
	}
	
	public function complete_for_order($pm){
	
		$this->addNewModel(sprintf(
			"SELECT
				clients.id,
				clients.name,
				clients.inn AS inn,
				o_last.descr,
				o_last.phone_cel,
				concrete_types_ref(ct) AS concrete_types_ref,
				destinations_ref(dest) AS destinations_ref,
				o_last.quant,
				o_last.date_time,
				debts.debt_total AS client_debt
			FROM clients
			LEFT JOIN (
				SELECT
					max(orders.date_time) AS date_time,
					orders.client_id
				FROM orders
				GROUP BY orders.client_id
			) AS o_cl ON o_cl.client_id = clients.id
			LEFT JOIN orders AS o_last ON o_last.client_id = clients.id AND o_last.date_time = o_cl.date_time
			LEFT JOIN concrete_types AS ct ON ct.id=o_last.concrete_type_id
			LEFT JOIN destinations AS dest ON dest.id=o_last.destination_id
			LEFT JOIN (
				SELECT
					d.client_id,
					sum(d.debt_total) AS debt_total
				FROM client_debts AS d		
				GROUP BY d.client_id
			) AS debts ON debts.client_id = clients.id			
			WHERE lower(clients.name) LIKE lower(%s)||'%%'
			LIMIT 5",
			$this->getExtDbVal($pm,'name')
			),
			'OrderClient_Model'
		);	
	}
	
	/* !!!ПЕРЕКРЫТИЕ МЕТОДА!!! */
	
	
}
?>