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



require_once(ABSOLUTE_PATH.'functions/material_period_check.php');

class RawMaterialConsRateDate_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Дата';
			
				$f_params['required']=TRUE;
			$param = new FieldExtDateTime('dt'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Наименование';
			$param = new FieldExtText('name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Номер подбора';
			$param = new FieldExtInt('code'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Элемент-основание';
			$param = new FieldExtInt('base_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Завод';
			$param = new FieldExtInt('production_site_id'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('RawMaterialConsRateDate.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('RawMaterialConsRateDate_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Дата';
			$param = new FieldExtDateTime('dt'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Наименование';
			$param = new FieldExtText('name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Номер подбора';
			$param = new FieldExtInt('code'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Элемент-основание';
			$param = new FieldExtInt('base_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Завод';
			$param = new FieldExtInt('production_site_id'
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
			$pm->addEvent('RawMaterialConsRateDate.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('RawMaterialConsRateDate_Model');

			
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
		$pm->addEvent('RawMaterialConsRateDate.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('RawMaterialConsRateDate_Model');

			
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
		
		$this->setListModelId('RawMaterialConsRateDateList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('RawMaterialConsRateDateList_Model');		

			
		$pm = new PublicMethod('recalc_consumption');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('period_id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_site_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('code'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('RawMaterialConsRateDateList_Model');

		
	}
	
	public function recalc_consumption($pm){
		$period_id = $this->getExtDbVal('period_id');
		$link_master = $this->getDbLinkMaster();

		$ar = $link_master->query_first(sprintf("SELECT dt FROM raw_material_cons_rate_dates WHERE id = %d",$period_id));
		if(!is_array($ar) || !count($ar) || !isset($ar["dt"])){
			throw new Exception("date not defined");
		}
		material_period_check($link_master, $_SESSION["user_id"], $ar["dt"]);

		$link_master->query(sprintf(
			"CALL recalc_consumption(%d, %d)",
			$period_id,
			$pm->getParamValue('production_site_id')
		));
	}

}
?>