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



require_once(ABSOLUTE_PATH.'functions/ExtProg.php');

class ClientSpecification_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Контрагент';
			$param = new FieldExtInt('client_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('client_contract_1c_ref'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtDate('specification_date'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Договор';
			$param = new FieldExtText('contract'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Спецификация';
			$param = new FieldExtText('specification'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Марка';
			$param = new FieldExtInt('concrete_type_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Объект';
			$param = new FieldExtInt('destination_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('client_contract_ref_1c'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Количество';
			$param = new FieldExtFloat('quant'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Цена';
			$param = new FieldExtFloat('price'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Сумма';
			$param = new FieldExtFloat('total'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('ClientSpecification.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('ClientSpecification_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Контрагент';
			$param = new FieldExtInt('client_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('client_contract_1c_ref'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDate('specification_date'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Договор';
			$param = new FieldExtText('contract'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Спецификация';
			$param = new FieldExtText('specification'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Марка';
			$param = new FieldExtInt('concrete_type_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Объект';
			$param = new FieldExtInt('destination_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('client_contract_ref_1c'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Количество';
			$param = new FieldExtFloat('quant'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Цена';
			$param = new FieldExtFloat('price'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Сумма';
			$param = new FieldExtFloat('total'
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
			$pm->addEvent('ClientSpecification.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('ClientSpecification_Model');

			
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
		$pm->addEvent('ClientSpecification.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('ClientSpecification_Model');

			
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
		
		$this->setListModelId('ClientSpecificationList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('ClientSpecificationList_Model');		

			
		$pm = new PublicMethod('complete_for_client');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtInt('client_id',$opts));
	
				
	$opts=array();
			
		$pm->addParam(new FieldExtInt('concrete_type_id',$opts));
	
				
	$opts=array();
			
		$pm->addParam(new FieldExtInt('destination_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=100;				
		$pm->addParam(new FieldExtString('search',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	public function check_contract($pm){
		if($pm->getParamValue("client_contract_1c_ref")){
			$ar = $this->getDbLink()->query_first(sprintf(
				"SELECT id FROM client_contracts_1c WHERE ref_1c->>'ref_1c'=%s"
				,$this->getExtDbVal($pm, 'client_contract_1c_ref')
			));
			if(!is_array($ar) || !count($ar) || !isset($ar["id"])){
				$client_id = NULL;
				if($pm->getParamValue("client_id")){
					$client_id = $this->getExtDbVal($pm, 'client_id');
				}else{
					$ar = $this->getDbLink()->query_first(sprintf(
						"SELECT client_id FROM client_specifications WHERE id=%d"
						,$this->getExtDbVal($pm, 'old_id')
					));
					$client_id = $ar["client_id"];
				}

				$resp = ExtProg::getClientContract($this->getExtVal($pm, "client_contract_1c_ref"));
				/* $name = $resp["models"]["Contract1cList_Model"]["rows"][0]["name"]; */
				$name = $resp["models"]["Contract1cList_Model"]["rows"][0]["name"];
				$this->getDbLinkMaster()->query(sprintf(
					"INSERT INTO client_contracts_1c (ref_1c, client_id)
					VALUES (jsonb_build_object('ref_1c', %s, 'descr', '%s'), %d)
					RETURNING id"
					,$this->getExtDbVal($pm, 'client_contract_1c_ref')
					,$name
					,$client_id
				));
			}
		}
	}

	public function update($pm){
		$this->check_contract($pm);
		parent::update($pm);
	}

	public function insert($pm){
		$this->check_contract($pm);
		parent::insert($pm);
	}

	public function complete_for_client($pm){
		$client_id = $this->getExtDbVal($pm, 'client_id');
		$concrete_type_id = $this->getExtDbVal($pm, 'concrete_type_id');
		$destination_id = $this->getExtDbVal($pm, 'destination_id');
		$cond = '';
		if($this->getExtVal($pm, 'search')){
			$search = $this->getExtDbVal($pm, 'search');
			$cond = " AND ((contract ilike '%%'||".$search."||'%%') OR (specification ilike '%%'||".$search."||'%%'))";
		}
		
		$this->addNewModel(sprintf(
			"SELECT * FROM client_specifications_list
			WHERE
				client_id = %d
				AND destination_id = %d
				AND concrete_type_id = %d".$cond."
				ORDER BY specification_date DESC"
			,$client_id
			,$destination_id
			,$concrete_type_id
		),'ClientSpecificationList_Model'
		);
	}


}
?>
