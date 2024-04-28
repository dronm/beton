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



require_once(FUNC_PATH.'ExtProg.php');
require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

class ClientDebt_Controller extends ControllerSQL{
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

			
		$pm = new PublicMethod('update_from_1c');
		
		$this->addPublicMethod($pm);

		
	}	
	
	
	public function update_from_1c($pm){		
		$debt_list = ExtProg::getClientDebtList();
		if(!isset($debt_list['models']['ClientDebt1cList_Model'])){
			throw new Exception('model ClientDebt1cList_Model not found');
		}
		if(!isset($debt_list['models']['ClientDebt1cList_Model']['rows'])){
			throw new Exception('rows of model ClientDebt1cList_Model not found');
		}
		$rows = $debt_list['models']['ClientDebt1cList_Model']['rows'];
		$link = $this->getDbLinkMaster();		
		$par = new ParamsSQL(NULL, $link);
		
		$cur_time_s = date('Y-m-d H:i:s',time());
		
		$firm_ids = array();
		$q = '';
		for($i = 0; $i < count($rows); $i++){	
			$rec = $rows[$i];
			$par->add('client_ref', DT_STRING, $rec['client_ref']);
			
			$debt_total = floatval($rec['debt_total']);
			//client
			$client_ar = $link->query_first(sprintf(
				"SELECT t.id
				FROM clients t WHERE t.ref_1c->'keys'->>'ref_1c' = %s",
				$par->getDbVal('client_ref'))
			);

			if (!is_array($client_ar) || !count($client_ar)){
				continue; //does not exist
			}
			//фирма
			if (!array_key_exists($rec['firm_ref'], $firm_ids)){
				$par->add('firm_ref', DT_STRING, $rec['firm_ref']);
				
				$ar = $link->query_first(sprintf(
						"SELECT t.id FROM firms_1c AS t WHERE t.ref_1c->'keys'->>'ref_1c' = %s",
						$par->getDbVal('firm_ref')					
					)
				);
				if (!is_array($ar) || !count($ar) || !isset($ar['id'])){					
					//нет такой фирмы - добавим
					$par->add('firm', DT_STRING, $rec['firm']);
					$par->add('firm_inn', DT_STRING, $rec['firm_inn']);
					$firm_ar = $link->query_first(sprintf(
						"INSERT INTO firms_1c (ref_1c, inn)
						VALUES (jsonb_build_object('ref_1c', %s, 'descr', %s), %s)
						RETURNING id"
						,$par->getDbVal('firm_ref')
						,$par->getDbVal('firm')
						,$par->getDbVal('firm_inn')
					));
					$firm_ids[$rec['firm_ref']] = $firm_ar['id']; //add id for farther ref
				}				
			}
			$q = sprintf(
				"INSERT INTO client_debts (firm_id, client_id, debt_total, update_date)
				VALUES(%d, %d, %s, now())
				ON CONFLICT (firm_id, client_id) DO UPDATE
				SET
					debt_total = %s,
					update_date = now()"
				,$firm_ids[$rec['firm_ref']]
				,$client_ar['id']
				,$debt_total
				,$debt_total
			);
			$link->query($q);
			//throw new Exception($q);
		}
		$link->query(sprintf("DELETE FROM client_debts WHERE update_date < '%s'", $cur_time_s));		
	}

}
?>
