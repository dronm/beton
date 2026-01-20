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



require_once(ABSOLUTE_PATH.'functions/exch1c.php');

class ClientContract1c_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
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
		
		$this->setListModelId('ClientDebtList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('ClientDebtList_Model');		

			
		$pm = new PublicMethod('get_dog_all');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('client_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_from_1c');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
	
		$opts['length']=36;				
		$pm->addParam(new FieldExtString('client_ref_1c',$opts));
	
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('search',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	public function get_dog_all($pm){		
		$link = $this->getDbLinkMaster();		
		$clientId = $this->getExtVal($pm, "client_id");

		$clAr = $link->query_first(
			sprintf("SELECT ref_1c->'keys'->>'ref_1c' AS ref FROM clients WHERE id = %d", $clientId)
		);
		if(!is_array($clAr) || !count($clAr) || !isset($clAr["ref"])){
			throw new Exception("Client not found");
		}
		$clientRef = $clAr["ref"];

		$dogovors = Exch1c::clientDogovorList($clientRef);

		$queries = array();

		foreach($dogovors as $dog){
			//contract
			$contractAr = $link->query_first(sprintf(
					"SELECT t.id FROM client_contracts_1c AS t WHERE t.ref_1c->>'ref_1c' = '%s'",
					$dog["ref"]
				)
			);
			$contractId = NULL;
			if (!is_array($contractAr) || !count($contractAr) || !isset($contractAr['id'])){
				//add new contract

				$ar = $link->query_first(sprintf(
					"INSERT INTO client_contracts_1c (ref_1c, client_id)
					VALUES (
						jsonb_build_object(
							'ref_1c', '%s',
							'descr', '%s'
						), %d
					)
					RETURNING id"
					,$dog["ref"]
					,$dog["name"]
					,$clientId
				));
				$contractId = $ar["id"];
			}else {
				$contractId = $contractAr["id"];
			}				

			$q = sprintf(
				"INSERT INTO client_specifications (client_id, client_contract_id, client_contract_1c_ref)
				VALUES(%d, %d, '%s')
				ON CONFLICT (client_id, client_contract_id) DO NOTHING"
				,$clientId
				,$contractId
				,$dog["ref"]
			);

			array_push($queries, $q);
		}

		$link->query("BEGIN");
		try{
			foreach($queries as $q){
				$link->query($q);
			}
			$link->query("COMMIT");

		}catch(Exception $e){
			$link->query("ROLLBACK");
			throw $e;
		}
	}

	public function complete_from_1c($pm){		
		$search = $this->getExtVal($pm, "search");
		$clientRef = $this->getExtVal($pm, "client_ref_1c");
		$dogovors = Exch1c::completeClientDogovor($clientRef, $search);
		$model = new Model(array("id"=>"ClientContract1cList_Model"));
		foreach($dogovors as $dog){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $dog["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $dog["name"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
		
	}

}
?>