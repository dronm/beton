<?php
require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQLDOC.php');
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


require_once(FRAME_WORK_PATH.'basic_classes/ModelReportSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelWhereSQL.php');

require_once(ABSOLUTE_PATH.'functions/checkPmPeriod.php');
require_once(ABSOLUTE_PATH.'functions/material_period_check.php');

class DOCMaterialProcurement_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Дата';
			$param = new FieldExtDateTime('date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Номер';
			$param = new FieldExtString('number'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('doc_ref'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Проведен';
			$param = new FieldExtBool('processed'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Автор';
			$param = new FieldExtInt('user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Поставщик';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('supplier_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Перевозчик';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('carrier_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Водитель';
			$param = new FieldExtString('driver'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='гос.номер';
			$param = new FieldExtString('vehicle_plate'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Материал';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('material_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Силос';
			$param = new FieldExtInt('cement_silos_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Брутто';
			$param = new FieldExtFloat('quant_gross'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Нетто';
			$param = new FieldExtFloat('quant_net'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('store'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('sender_name'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='База';
			$param = new FieldExtInt('production_base_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Брутто по документам';
			$param = new FieldExtFloat('doc_quant_gross'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Нетто по документам';
			$param = new FieldExtFloat('doc_quant_net'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtText('comment_text'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Кто последний вносил изменения';
			$param = new FieldExtInt('last_modif_user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Время последнего изменения';
			$param = new FieldExtDateTimeTZ('last_modif_date_time'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('DOCMaterialProcurement.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('DOCMaterialProcurement_Model');

			
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
			$param = new FieldExtDateTime('date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Номер';
			$param = new FieldExtString('number'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('doc_ref'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Проведен';
			$param = new FieldExtBool('processed'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Автор';
			$param = new FieldExtInt('user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Поставщик';
			$param = new FieldExtInt('supplier_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Перевозчик';
			$param = new FieldExtInt('carrier_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Водитель';
			$param = new FieldExtString('driver'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='гос.номер';
			$param = new FieldExtString('vehicle_plate'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Материал';
			$param = new FieldExtInt('material_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Силос';
			$param = new FieldExtInt('cement_silos_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Брутто';
			$param = new FieldExtFloat('quant_gross'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Нетто';
			$param = new FieldExtFloat('quant_net'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('store'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('sender_name'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='База';
			$param = new FieldExtInt('production_base_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Брутто по документам';
			$param = new FieldExtFloat('doc_quant_gross'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Нетто по документам';
			$param = new FieldExtFloat('doc_quant_net'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtText('comment_text'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Кто последний вносил изменения';
			$param = new FieldExtInt('last_modif_user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Время последнего изменения';
			$param = new FieldExtDateTimeTZ('last_modif_date_time'
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
			$pm->addEvent('DOCMaterialProcurement.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('DOCMaterialProcurement_Model');

			
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
		$pm->addEvent('DOCMaterialProcurement.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('DOCMaterialProcurement_Model');

			
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
		
		$this->setListModelId('DOCMaterialProcurementList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('DOCMaterialProcurementDialog_Model');		

			
		$pm = new PublicMethod('before_open');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('doc_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_actions');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('doc_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_print');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('doc_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_material_list');
		
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

			
		$pm = new PublicMethod('get_shift_list');
		
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

			
		$pm = new PublicMethod('complete_driver');
		
				
	$opts=array();
	
		$opts['alias']='Водитель';		
		$pm->addParam(new FieldExtString('driver',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_vehicle_plate');
		
				
	$opts=array();
	
		$opts['alias']='ТС';		
		$pm->addParam(new FieldExtString('vehicle_plate',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_store');
		
				
	$opts=array();
	
		$opts['alias']='Склад';		
		$pm->addParam(new FieldExtString('store',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_sender_name');
		
				
	$opts=array();
	
		$opts['alias']='Пункт отправления';		
		$pm->addParam(new FieldExtString('sender_name',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}
	
	public function insert($pm){
		//doc owner
		if(!$pm->getParamValue('date_time')){
			$pm->setParamValue('date_time',date('Y-m-d H:i:s'));
		}
		if(!$pm->getParamValue('user_id') || $_SESSION['role_id']!='owner'){
			$pm->setParamValue('user_id',$_SESSION['user_id']);
		}

		$pm->setParamValue('last_modif_user_id',$_SESSION['user_id']);
		$pm->setParamValue('last_modif_date_time', date("Y-m-d H:i:s"));

		material_period_check($this->getDbLink(), $_SESSION["user_id"], $this->getExtDbVal($pm, 'date_time'));

		return parent::insert($pm);		
	}
	
	public function update($pm){
		if(!$pm->getParamValue('date_time')){
			//retrieve date from db
			$ar = $this->getDbLink()->query_first(
				sprintf("SELECT date_time FROM doc_material_procurements WHERE id = %d"
				,$this->getExtDbVal($pm, 'old_id')
				)
			);
			if(!is_array($ar) || !count($ar)){
				throw new Exception("document not found.");
			}
			$date_time = "'".$ar["date_time"]."'";
		}else{
			$date_time = $this->getExtDbVal($pm, 'date_time');
		}
		material_period_check($this->getDbLink(), $_SESSION["user_id"], $date_time);
		
		$pm->setParamValue('last_modif_user_id',$_SESSION['user_id']);
		$pm->setParamValue('last_modif_date_time', date("Y-m-d H:i:s"));

		parent::update($pm);
	}

	public function get_details($pm){		
		$model = new DOCMaterialProcurementMaterialList_Model($this->getDbLink());	
		$from = null; $count = null;
		$limit = $this->limitFromParams($pm,$from,$count);
		$calc_total = ($count>0);
		if ($from){
			$model->setListFrom($from);
		}
		if ($count){
			$model->setRowsPerPage($count);
		}		
		$order = $this->orderFromParams($pm);
		$where = $this->conditionFromParams($pm,$model);
		$fields = $this->fieldsFromParams($pm);		
		$material_group_id = $where->getFieldValueForDb('material_group_id','=',0,0);
		if ($material_group_id==0){
			//throw new Exception($material_group_id);
			$where->deleteField('material_group_id','=');
		}
		
		$model->select(FALSE,$where,$order,
			$limit,$fields,NULL,NULL,
			$calc_total,TRUE);
		//
		$this->addModel($model);
		
	}
	public function get_print($pm){
		$this->addNewModel(
			sprintf(
			'SELECT number,
			get_date_str_rus(date_time::date) AS date_time_descr,
			supplier_descr,carrier_descr,material_descr,
			format_quant(quant_gross) AS quant_gross,
			format_quant(quant_net) AS quant_net,
			FROM doc_material_procurements_list_view
			WHERE id=%d',
			$pm->getParamValue('doc_id')),
		'head');
	}
	private function add_material_model($link){
		$mat_model = new ModelSQL($link,array('id'=>'RawMaterial_Model'));
		$mat_model->addField(new FieldSQLInt($link,null,null,"id"));
		$mat_model->addField(new FieldSQLString($link,null,null,"name"));
		$mat_model->query("SELECT id,name FROM raw_materials WHERE name <>'' ORDER BY ord",
		TRUE);
		$this->addModel($mat_model);			
	}
	
	public function get_shift_list($pm){
		//$link = $this->getDbLink();
		//$this->add_material_model($link);
		
		$cond = '';

		$list_model = new DOCMaterialProcurementShiftList_Model($this->getDbLink());
		$where = $this->conditionFromParams($pm,$list_model);
		if(isset($where)){
			//$where = new ModelWhereSQL();
		
			$list_model->addStoredFilter($where);			
			$list_model->addGlobalFilter($where);

			$production_base_id = $where->getFieldValueForDb('production_base_id','=',0,0);
			if ($production_base_id != 0){
				$cond = sprintf("production_base_id = %d", $production_base_id);
			}
		}
		
		if(isset($where) && $where->getFieldsById('shift_date_time','>=') && $where->getFieldsById('shift_date_time','<=')){
			$def_date=null;
			FieldSQLDateTime::formatForDb(time(),$def_date);

			if($cond != ""){
				$cond.= " AND ";
			}
			$cond.= sprintf("date_time::date BETWEEN %s AND %s",
				$where->getFieldValueForDb('shift_date_time','>=',0,$def_date),
				$where->getFieldValueForDb('shift_date_time','<=',0,$def_date)			
			);
		}
				
		$this->addNewModel(
			sprintf(
			"SELECT DISTINCT ON (m.ord,d.material_id)
				d.material_id AS id,
				m.name
			FROM doc_material_procurements AS d
			LEFT JOIN raw_materials AS m ON m.id=d.material_id
			%s
			GROUP BY m.ord,d.material_id,m.name
			ORDER BY m.ord",
			!isset($where)? '' : 'WHERE '.$cond
			),
		'RawMaterial_Model');
		
		$this->modelGetList($list_model,$pm);
		
		//$this->setListModelId('DOCMaterialProcurementShiftList_Model');		
		//$this->get_list($pm);
	}
	
	public function get_list($pm){	
		checkPublicMethodPeriod($pm, new DOCMaterialProcurementList_Model($this->getDbLink()), "date_time", 370);
		parent::get_list($pm);
	}

	/*
	public function get_material_list($pm){
		$link = $this->getDbLink();
		$ar = $link->query_first("SELECT COUNT(*) AS cnt FROM raw_materials WHERE name <>''");
		$mat_count = $ar['cnt'];				
		//
		//result model
		$model = new ModelReportSQL($link,array("id"=>"get_material_list"));
		$model->addField(new FieldSQLString($link,null,null,"shift"));
		$model->addField(new FieldSQLString($link,null,null,"shift_descr"));		
		$model->addField(new FieldSQLString($link,null,null,"shift_from_descr"));		
		$model->addField(new FieldSQLString($link,null,null,"shift_to_descr"));		

		$fld_list='';
		$fld_def = '';
		for ($i = 1; $i <= $mat_count; $i++) {
			$fld_list.=',mat'.$i.'_quant';
			$fld_def.=',mat'.$i.'_quant numeric';
			$model->addField(new FieldSQLString($link,null,null,'mat'.$i.'_quant'));
		}
		$def_date=null;
		FieldSQLDateTime::formatForDb(time(),$def_date);
		
		$model_params = new ModelReportSQL($link);
		$model_params->addField(new FieldSQLDateTime($link,null,null,"date_time"));		
		$where = $this->conditionFromParams($pm,$model_params);
		if (!$where){
			throw new Exception("Не заданы условия!");
		}
		$sql=sprintf("SELECT
			shift,shift_descr,
			shift_from_descr,shift_to_descr%s
		FROM raw_material_procurement_dates(%s,%s)
		AS (shift timestamp,
		shift_descr text,
		shift_from_descr text,
		shift_to_descr text%s)",
		$fld_list,
		$where->getFieldValueForDb('date_time','>=',0,$def_date),
		$where->getFieldValueForDb('date_time','<=',0,$def_date),
		$fld_def);
		//throw new Exception($sql);
		$model->query($sql,TRUE);
		$this->addModel($model);		
		
		$this->add_material_model($link);
	}
	*/
	
	public function complete_driver($pm){
		$this->addNewModel(sprintf(
			"SELECT driver FROM doc_material_procurements_driver_list
			WHERE lower(driver) LIKE '%%'||lower(%s)||'%%'
			ORDER BY position(lower(%s) in lower(driver))
			LIMIT 10"
			,$this->getExtDbVal($pm,'driver')
			,$this->getExtDbVal($pm,'driver')
		), 'DOCMaterialProcurementDriverList_Model');
	}

	public function complete_store($pm){
		$this->addNewModel(sprintf(
			"SELECT store FROM doc_material_procurements_store_list
			WHERE lower(store) LIKE '%%'||lower(%s)||'%%'
			ORDER BY position(lower(%s) in lower(store))
			LIMIT 10"
			,$this->getExtDbVal($pm,'store')
			,$this->getExtDbVal($pm,'store')
		), 'DOCMaterialProcurementStoreList_Model');
	}
	public function complete_vehicle_plate($pm){
		$this->addNewModel(sprintf(
			"SELECT vehicle_plate FROM doc_material_procurements_vehicle_list
			WHERE lower(vehicle_plate) LIKE '%%'||lower(%s)||'%%'
			ORDER BY position(lower(%s) in lower(vehicle_plate))
			LIMIT 10"
			,$this->getExtDbVal($pm,'vehicle_plate')
			,$this->getExtDbVal($pm,'vehicle_plate')
		), 'DOCMaterialProcurementVehicleList_Model');
	}
	
	public function complete_sender_name($pm){
		$this->addNewModel(sprintf(
			"SELECT sender_name FROM doc_material_procurements_sender_name_list
			WHERE lower(sender_name) LIKE '%%'||lower(%s)||'%%'
			ORDER BY position(lower(%s) in lower(sender_name))
			LIMIT 10"
			,$this->getExtDbVal($pm,'sender_name')
			,$this->getExtDbVal($pm,'sender_name')
		), 'DOCMaterialProcurementSenderNameList_Model');
	}
	
}
?>