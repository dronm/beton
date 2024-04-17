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


class QualityPassport_Controller extends ControllerSQL{
	
	const COMPLETE_LIMIT = 10;
	
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='F';
			$param = new FieldExtInt('f_val'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='W';
			$param = new FieldExtInt('w_val'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Гост вида смеси';
			$param = new FieldExtText('vid_smesi_gost'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Место укладки';
			$param = new FieldExtText('uklad'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('sohran_udobouklad'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('kf_prochnosti'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('prochnost'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('naim_dobavki'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('aeff'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('krupnost'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDate('vidan'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('shipment_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('smes_num'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('order_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('client_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('reg_nomer_dekl'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('QualityPassport.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('QualityPassport_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='F';
			$param = new FieldExtInt('f_val'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='W';
			$param = new FieldExtInt('w_val'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Гост вида смеси';
			$param = new FieldExtText('vid_smesi_gost'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Место укладки';
			$param = new FieldExtText('uklad'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('sohran_udobouklad'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('kf_prochnosti'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('prochnost'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('naim_dobavki'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('aeff'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('krupnost'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDate('vidan'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('shipment_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('smes_num'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('order_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('client_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('reg_nomer_dekl'
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
			$pm->addEvent('QualityPassport.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('QualityPassport_Model');

			
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
		$pm->addEvent('QualityPassport.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('QualityPassport_Model');

			
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
		
		$this->setListModelId('QualityPassportList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('QualityPassport_Model');		

			
		$pm = new PublicMethod('get_object_or_last');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtInt('shipment_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_vid_smesi_gost');
		
				
	$opts=array();
	
		$opts['alias']='Гост вида смеси';		
		$pm->addParam(new FieldExtText('vid_smesi_gost',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_uklad');
		
				
	$opts=array();
	
		$opts['alias']='Место укладки';		
		$pm->addParam(new FieldExtText('uklad',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_sohran_udobouklad');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('sohran_udobouklad',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_kf_prochnosti');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('kf_prochnosti',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_prochnost');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtInt('prochnost',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_naim_dobavki');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('naim_dobavki',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_aeff');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('aeff',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_krupnost');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('krupnost',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_reg_nomer_dekl');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('reg_nomer_dekl',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('count',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
	public function get_object_or_last($pm){
		$shipment_id = 0;
		if($pm->getParamValue('shipment_id')){
			$shipment_id = $this->getExtDbVal($pm,"shipment_id");
		}
		$this->addNewModel(
			sprintf("SELECT * FROM quality_passports_object_or_last(%d)", $shipment_id),		
			'QualityPassport_Model'		
		);
	}
	
	//no search
	private static function get_complete_query_for_field($fieldId){
		return sprintf(
			"SELECT
				DISTINCT %s
			FROM quality_passports
			ORDER BY %s
			LIMIT %d",
			$fieldId,
			$fieldId,
			self::COMPLETE_LIMIT
		);		
	}

	//with serach
	private static function get_complete_search_query_for_field($fieldId, $searchValForDb, $rightLeft){
		return sprintf(
			"SELECT
				DISTINCT %s
			FROM quality_passports
			WHERE %s::text ilike ". ($rightLeft? "'%%'||" : "") ."%s||'%%'
			ORDER BY %s
			LIMIT %d",
			$fieldId,
			$fieldId,
			$searchValForDb,
			$fieldId,
			self::COMPLETE_LIMIT
		);								
	}
	
	//*******************
	
	//
	private function complete_for_field($pm, $fieldId, $rightLeft){
		$s = $pm->getParamValue($fieldId);
		if($s && strlen($s) && $s != 'null'){
			$q = self::get_complete_search_query_for_field($fieldId, $this->getExtDbVal($pm, $fieldId), $rightLeft);			
		}else{
			$q = self::get_complete_query_for_field($fieldId);			
		}
		$this->addNewModel($q, 'QualityPassport_Model');
	}
	
	public function complete_vid_smesi_gost($pm){
		$this->complete_for_field($pm,'vid_smesi_gost', TRUE);
	}
	
	public function complete_uklad($pm){
		$this->complete_for_field($pm,'uklad', TRUE);
	}

	public function complete_sohran_udobouklad($pm){
		$this->complete_for_field($pm,'sohran_udobouklad', FALSE);
	}

	public function complete_kf_prochnosti($pm){
		$this->complete_for_field($pm,'kf_prochnosti', TRUE);
	}

	public function complete_prochnost($pm){
		$this->complete_for_field($pm,'prochnost', FALSE);
	}

	public function complete_naim_dobavki($pm){
		$this->complete_for_field($pm,'naim_dobavki', TRUE);
	}

	public function complete_aeff($pm){
		$this->complete_for_field($pm,'aeff', TRUE);
	}
	public function complete_reg_nomer_dekl($pm){
		$this->complete_for_field($pm,'reg_nomer_dekl', TRUE);
	}
	
	public function complete_krupnost($pm){
		$this->complete_for_field($pm,'krupnost', FALSE);
	}
	

}
?>