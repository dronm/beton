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


class RawMaterialTicket_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Перевозчик';
			$param = new FieldExtInt('carrier_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Материал';
			$param = new FieldExtInt('raw_material_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Карьер';
			$param = new FieldExtInt('quarry_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Штрихкод';
			$param = new FieldExtString('barcode'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Вес, т';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('quant'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDateTimeTZ('issue_date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDateTimeTZ('close_date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Пользователь';
			$param = new FieldExtInt('close_user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Пользователь';
			$param = new FieldExtInt('issue_user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Дата окончания срока';
			$param = new FieldExtDate('expire_date'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('RawMaterialTicket.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('RawMaterialTicket_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Перевозчик';
			$param = new FieldExtInt('carrier_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Материал';
			$param = new FieldExtInt('raw_material_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Карьер';
			$param = new FieldExtInt('quarry_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Штрихкод';
			$param = new FieldExtString('barcode'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Вес, т';
			$param = new FieldExtInt('quant'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('issue_date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('close_date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Пользователь';
			$param = new FieldExtInt('close_user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Пользователь';
			$param = new FieldExtInt('issue_user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Дата окончания срока';
			$param = new FieldExtDate('expire_date'
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
			$pm->addEvent('RawMaterialTicket.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('RawMaterialTicket_Model');

			
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
		$pm->addEvent('RawMaterialTicket.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('RawMaterialTicket_Model');

			
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
		
		$this->setListModelId('RawMaterialTicketList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('RawMaterialTicketDialog_Model');		

			
		$pm = new PublicMethod('generate');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('carrier_id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('raw_material_id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('quarry_id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('quant',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('barcode_from',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('barcode_to',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtDate('expire_date',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('close_ticket');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('barcode',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_carrier_agg_list');
		
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
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('inline',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	public static function getCarrierAggModel($dbLink){
		$model = new ModelSQL($dbLink,array('id'=>'RawMaterialTicketCarrierAggList_Model'));
		$model->addField(new FieldSQLString($dbLink,null,null,"date",DT_DATE));
		$model->query("SELECT * FROM raw_material_ticket_carrier_agg_list", TRUE);
		return $model;		
	}

	public function get_carrier_agg_list($pm){
		$this->setListModelId('RawMaterialTicketCarrierAggList_Model');
		parent::get_list($pm);
	}

	public function close_ticket($pm){		
		$code = intval($this->getExtDbVal($pm, 'barcode'));
		$ar = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT
				barcode,
				close_date_time
			FROM raw_material_tickets
			WHERE barcode = '%s'"
			,$code
		));
		if(!is_array($ar) || !count($ar) || !isset($ar['barcode'])){
			throw new Exception('Талон не найден!@1000');
		}
		
		if(isset($ar['close_date_time'])){
			throw new Exception('Талон уже погашен!@1001');
		}

		$this->getDbLinkMaster()->query(sprintf(
			"UPDATE raw_material_tickets
			SET
				close_date_time = now()
				,close_user_id = %d				
			WHERE barcode = '%s'"
			,$_SESSION['user_id']
			,$code
		));
	}

	public function generate($pm){		
		try{
			$this->getDbLinkMaster()->query(sprintf(
				"INSERT INTO raw_material_tickets
				(carrier_id, quarry_id, raw_material_id, barcode, quant, expire_date, issue_date_time, issue_user_id)
				SELECT
					%d,
					%d,
					%d,
					code,
					%d,
					%s,
					now(),
					%d
				FROM generate_series(%d, %d) AS code"
				,$this->getExtDbVal($pm, 'carrier_id')
				,$this->getExtDbVal($pm, 'quarry_id')
				,$this->getExtDbVal($pm, 'raw_material_id')
				,$this->getExtDbVal($pm, 'quant')
				,$this->getExtDbVal($pm, 'expire_date')
				,$_SESSION['user_id']
				,$this->getExtDbVal($pm, 'barcode_from')
				,$this->getExtDbVal($pm, 'barcode_to')				
			));
		}catch(Exception $e){
			if(strpos($e->getMessage(), "SQL: 23505")!==FALSE){
				throw new Exception('Есть пересекающиеся номера!');
			}else{
				throw $e;
			}
		}
	}


}
?>