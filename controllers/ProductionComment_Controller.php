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


class ProductionComment_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('production_site_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtString('production_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('material_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('comment_text'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDateTimeTZ('date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('user_id'
				,$f_params);
		$pm->addParam($param);
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['production_site_id'
			,'production_id'
			,'material_id'
			]
		];
		$pm->addEvent('ProductionComment.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('ProductionComment_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_production_site_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtString('old_production_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('old_material_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('production_site_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('production_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('material_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('comment_text'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('user_id'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('production_site_id',array(
			));
			$pm->addParam($param);
		
			$param = new FieldExtString('production_id',array(
			));
			$pm->addParam($param);
		
			$param = new FieldExtInt('material_id',array(
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['production_site_id'
				,'production_id'
				,'material_id'
				]
			];
			$pm->addEvent('ProductionComment.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('ProductionComment_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('production_site_id'
		));		
		
		$pm->addParam(new FieldExtString('production_id'
		));		
		
		$pm->addParam(new FieldExtInt('material_id'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['production_site_id'
			,'production_id'
			,'material_id'
			]
		];
		$pm->addEvent('ProductionComment.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('ProductionComment_Model');

			
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
		
		$this->setListModelId('ProductionComment_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('production_site_id'
		));
		
		$pm->addParam(new FieldExtString('production_id'
		));
		
		$pm->addParam(new FieldExtInt('material_id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('ProductionComment_Model');		

		
	}	
	

	public function insert($pm){
		$this->getDbLinkMaster()->query('BEGIN');
		try{
			$this->getDbLinkMaster()->query(sprintf(
				"DELETE FROM production_comments
				WHERE production_site_id=%d AND production_id=%s AND material_id=%d"
				,$this->getExtDbVal($pm,'production_site_id')
				,$this->getExtDbVal($pm,'production_id')
				,$this->getExtDbVal($pm,'material_id')
			));
			if ($this->getExtVal($pm,'comment_text') != 'NULL') {
				$this->getDbLinkMaster()->query(sprintf(
					"INSERT INTO production_comments
					(production_site_id,production_id,material_id,comment_text,date_time,user_id)
					VALUES
					(%d, %s, %d, %s, now(), %d)"
					,$this->getExtDbVal($pm,'production_site_id')
					,$this->getExtDbVal($pm,'production_id')
					,$this->getExtDbVal($pm,'material_id')
					,$this->getExtDbVal($pm,'comment_text')
					,$_SESSION['user_id']
				));
				$this->getDbLinkMaster()->query('COMMIT');
				
				$inserted_id_ar = [
					'production_site_id'=>$this->getExtVal($pm,'production_site_id')
					,'production_id' => $this->getExtVal($pm,'production_id')
					,'material_id'=>$this->getExtVal($pm,'material_id')
				];
				$this->addInsertedIdModel($inserted_id_ar);
				
			}else{
				$this->getDbLinkMaster()->query('COMMIT');
			}			
			
		}catch(Exception $e){
			$this->getDbLinkMaster()->query('ROLLBACK');
			
			throw $e;
		}
	}


}
?>