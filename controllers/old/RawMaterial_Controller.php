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

/**
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */


require_once(FRAME_WORK_PATH.'basic_classes/ModelSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/ConditionParamsSQL.php');

require_once('common/MyDate.php');
require_once(ABSOLUTE_PATH.'functions/Beton.php');
require_once(USER_CONTROLLERS_PATH.'Order_Controller.php');

class RawMaterial_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster){
		parent::__construct($dbLinkMaster);
			

		/* insert */
		$pm = new PublicMethod('insert');
		$param = new FieldExtString('name'
				,array('required'=>TRUE,
				'alias'=>'Наименование'
			));
		$pm->addParam($param);
		$param = new FieldExtFloat('planned_procurement'
				,array(
				'alias'=>'Плановый приход'
			));
		$pm->addParam($param);
		$param = new FieldExtInt('supply_days_count'
				,array(
				'alias'=>'Дней завоза'
			));
		$pm->addParam($param);
		$param = new FieldExtBool('concrete_part'
				,array());
		$pm->addParam($param);
		$param = new FieldExtInt('ord'
				,array('required'=>TRUE));
		$pm->addParam($param);
		$param = new FieldExtInt('supply_volume'
				,array(
				'alias'=>'Объем ТС завоза'
			));
		$pm->addParam($param);
		$param = new FieldExtInt('store_days'
				,array());
		$pm->addParam($param);
		$param = new FieldExtFloat('min_end_quant'
				,array());
		$pm->addParam($param);
		$param = new FieldExtFloat('max_required_quant_tolerance_percent'
				,array());
		$pm->addParam($param);
		$param = new FieldExtFloat('max_fact_quant_tolerance_percent'
				,array());
		$pm->addParam($param);
		$param = new FieldExtBool('is_cement'
				,array(
				'alias'=>'Цемент,учет в силосе'
			));
		$pm->addParam($param);
		$param = new FieldExtBool('dif_store'
				,array(
				'alias'=>'Учет по местам хранения'
			));
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('RawMaterial.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('RawMaterial_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		$param = new FieldExtInt('id'
				,array(
			
				'alias'=>'Код'
			));
			$pm->addParam($param);
		$param = new FieldExtString('name'
				,array(
			
				'alias'=>'Наименование'
			));
			$pm->addParam($param);
		$param = new FieldExtFloat('planned_procurement'
				,array(
			
				'alias'=>'Плановый приход'
			));
			$pm->addParam($param);
		$param = new FieldExtInt('supply_days_count'
				,array(
			
				'alias'=>'Дней завоза'
			));
			$pm->addParam($param);
		$param = new FieldExtBool('concrete_part'
				,array(
			));
			$pm->addParam($param);
		$param = new FieldExtInt('ord'
				,array(
			));
			$pm->addParam($param);
		$param = new FieldExtInt('supply_volume'
				,array(
			
				'alias'=>'Объем ТС завоза'
			));
			$pm->addParam($param);
		$param = new FieldExtInt('store_days'
				,array(
			));
			$pm->addParam($param);
		$param = new FieldExtFloat('min_end_quant'
				,array(
			));
			$pm->addParam($param);
		$param = new FieldExtFloat('max_required_quant_tolerance_percent'
				,array(
			));
			$pm->addParam($param);
		$param = new FieldExtFloat('max_fact_quant_tolerance_percent'
				,array(
			));
			$pm->addParam($param);
		$param = new FieldExtBool('is_cement'
				,array(
			
				'alias'=>'Цемент,учет в силосе'
			));
			$pm->addParam($param);
		$param = new FieldExtBool('dif_store'
				,array(
			
				'alias'=>'Учет по местам хранения'
			));
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
			$pm->addEvent('RawMaterial.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('RawMaterial_Model');

			
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
		$pm->addEvent('RawMaterial.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('RawMaterial_Model');

			
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
		
		$this->setListModelId('RawMaterial_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('RawMaterial_Model');		

			
		/* complete  */
		$pm = new PublicMethod('complete');
		$pm->addParam(new FieldExtString('pattern'));
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('ic'));
		$pm->addParam(new FieldExtInt('mid'));
		$pm->addParam(new FieldExtString('name'));		
		$this->addPublicMethod($pm);					
		$this->setCompleteModelId('RawMaterial_Model');

			
		$pm = new PublicMethod('get_list_for_concrete');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('supplier_orders_list');
		
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

			
		$pm = new PublicMethod('update_procurement');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('docs',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('load_procurement');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('doc',$opts));
	
			
		$this->addPublicMethod($pm);

			
			
		$pm = new PublicMethod('oper_week_report');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('total_report');
		
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

			
		$pm = new PublicMethod('total_details_report');
		
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

			
		$pm = new PublicMethod('set_min_quant');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDateTime('week_day',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('material_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=19;				
		$pm->addParam(new FieldExtFloat('quant',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('correct_consumption');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('material_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=19;
		$opts['unsigned']=FALSE;				
		$pm->addParam(new FieldExtFloat('quant',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('correct_obnul');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtDate('date',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('material_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=19;
		$opts['unsigned']=FALSE;				
		$pm->addParam(new FieldExtFloat('quant',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('correct_list');
		
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

			
		$pm = new PublicMethod('total_list');
		
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

			
		$pm = new PublicMethod('mat_totals');
		
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
					
		$pm->addParam(new FieldExtInt('production_base_id',$opts));
	
			
		$this->addPublicMethod($pm);
	
			
		$pm = new PublicMethod('get_material_actions_list');
		
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

			
		$pm = new PublicMethod('get_material_avg_cons_on_ctp');
		
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

			
		$pm = new PublicMethod('get_material_cons_tolerance_violation_list');
		
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
	public function get_list_for_concrete($pm){		
		$this->addNewModel(
			"SELECT *
			FROM raw_materials
			WHERE concrete_part=TRUE
			ORDER BY ord",
		"RawMaterial_Model");
	}
	/*
	public function get_planned_consuption($pm){		
		$date = $pm->getParamValue('date');
		$days = $pm->getParamValue('days');
		$link = $this->getDbLink();
		
		$model = new ModelSQL($link,array("id"=>"RawMaterialConsuption_Model"));
		$model->addField(new FieldSQL($link,null,null,"raw_material_id",DT_INT));
		$model->addField(new FieldSQL($link,null,null,"raw_material_descr",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"planned_procurement",DT_FLOAT));
		$model->addField(new FieldSQL($link,null,null,"quant_balance",DT_FLOAT));
		$model->addField(new FieldSQL($link,null,null,"quant_ordered",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"planned_consuption",DT_STRING));
				
		
		$model->setSelectQueryText(
		sprintf(
		"SELECT *
		FROM get_raw_material_planned_consuption_report('%s',%d)"
		,date("Y-m-d",$date),$days));
		
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		//
		$this->addModel($model);			
	}
	*/
	
	//2 метода старый update_procurement и load_procurement
	
	/**
	 * старевший метод чтения XML
	 */
	/*public function update_procurement($pm){
		$docs_str = $pm->getParamValue('docs');
		
		$link_master = $this->getDbLinkMaster();
		$link = $this->getDbLink();
		
		$xml = new SimpleXMLElement($docs_str);
		$doc_cnt = 0;
		try{
			foreach ($xml->doc as $doc) {
				$this->loadProcurementDocument($pm, $doc);
				
				$doc_cnt++;
			}
			
			$res = 'true';
			$descr = 'null';
		
		}catch (Exception $e){
			$res = 'false';			
			$descr = "'".str_replace("'",'"',$e->getMessage())."'";
		}
		
		$link_master->query("DELETE FROM raw_material_procur_uploads");
		$link_master->query(sprintf(
			"INSERT INTO raw_material_procur_uploads
			(date_time,result,descr,doc_count)
			VALUES ('%s',%s,%s,%d)",
			date('Y-m-d H:i:s'),$res,$descr,$doc_cnt
		));
		if ($res == 'false'){
			throw $e;
		}
		
	}*/

	public function load_procurement($pm){
		$link_master = $this->getDbLinkMaster();
		$link = $this->getDbLink();
		
		try{
			$doc = json_decode($pm->getParamValue('doc'),FALSE);
			if(isset($doc->cmd)){
				$cmd = trim($doc->cmd);
			}else{
				$cmd = 'update';
			}
			
			if($cmd == 'delete'){
				$this->deleteProcurementDocument($pm, $doc);
			}else{
				$this->loadProcurementDocument($pm, $doc);
			}
			
			$doc_cnt = 1;		
			$res = 'true';
			$descr = 'null';
		
		}catch (Exception $e){
			$res = 'false';			
			$descr = "'".str_replace("'",'"',$e->getMessage())."'";
			$doc_cnt = 0;
		}
		
		$link_master->query("BEGIN");
		$link_master->query("DELETE FROM raw_material_procur_uploads");
		$link_master->query(sprintf(
			"INSERT INTO raw_material_procur_uploads
			(date_time, result, descr, doc_count)
			VALUES ('%s', %s, %s, %d)"
			,date('Y-m-d H:i:s')
			,$res
			,$descr
			,$doc_cnt
		));
		$link_master->query("COMMIT");
		if ($res == 'false'){
			throw $e;
		}
		
	}
	
	public function deleteProcurementDocument($pm, $doc){
	
		$link_master = $this->getDbLinkMaster();
		
		$doc_params = new ParamsSQL($pm,$link_master);				
		$doc_params->add('doc_ref',DT_STRING,$doc->doc_ref);
		
		$doc_ar = $link_master->query_first(sprintf(
			"DELETE FROM doc_material_procurements WHERE doc_ref=%s",
			$doc_params->getParamById('doc_ref')
		));
	
	}
	
	public function loadProcurementDocument($pm, $doc){
	
		if(!isset($doc->material)){
			return;
		}
		
		$link = $this->getDbLink();
		$link_master = $this->getDbLinkMaster();
		
		//supplier
		$sup_params = new ParamsSQL($pm,$link);				
		$sup_params->add('supplier_ref',DT_STRING,$doc->supplier_ref);
		$sup_params->add('supplier_name',DT_STRING,$doc->supplier_name);
		$sup_params->add('supplier_name_full',DT_STRING,$doc->supplier_name_full);				
		
		$supplier_name_db = $sup_params->getParamById('supplier_name');
		$supplier_name_full_db = $sup_params->getParamById('supplier_name_full');
		$supplier_ref_db = $sup_params->getParamById('supplier_ref');
		
		$supplier_ar = $link->query_first(sprintf(
			"SELECT id,name,name_full
			FROM suppliers
			WHERE ext_ref_scales=%s",
			$supplier_ref_db
		));
	
		if (!is_array($supplier_ar)|| count($supplier_ar)==0){
			//new supplier
			$supplier_ar = $link_master->query_first(sprintf(
				"INSERT INTO suppliers
				(name,name_full,ext_ref_scales)
				VALUES (%s,%s,%s) RETURNING id",
				$supplier_name_db,
				$supplier_name_full_db,
				$supplier_ref_db
			));						
		}
		else if($supplier_name_db!=$supplier_ar['name'] || $supplier_name_full_db!=$supplier_ar['name_full']){
			$link_master->query(sprintf(
				"UPDATE suppliers
				SET name=%s,name_full=%s
				WHERE ext_ref_scales=%s",
				$supplier_name_db,
				$supplier_name_full_db,
				$supplier_ref_db
			));
		}
		$supplier_id = intval($supplier_ar['id']);
		
		//Для Горного: если supplier_id=Горный и дата МЕНЬШЕ= 24/06/21 - Не грузить!
		if($supplier_id==5 && strtotime($doc->date_time) <= strtotime('2021-06-24T00:00:00')){
			return;
		}
						
		//carrier
		$car_params = new ParamsSQL($pm,$link);
		$car_params->add('carrier_ref',DT_STRING,$doc->carrier_ref);
		$car_params->add('carrier_name',DT_STRING,$doc->carrier_name);
		$car_params->add('carrier_name_full',DT_STRING,$doc->carrier_name_full);				
		
		$carrier_name_db = $car_params->getParamById('carrier_name');
		$carrier_name_full_db = $car_params->getParamById('carrier_name_full');
		$carrier_ref_db = $car_params->getParamById('carrier_ref');
		
		$carrier_ar = $link->query_first(sprintf(
			"SELECT id,name,name_full
			FROM suppliers
			WHERE ext_ref_scales=%s",
			$carrier_ref_db
		));
	
		if (!is_array($carrier_ar) || count($carrier_ar)==0){
			//new carrier
			$carrier_ar = $link_master->query_first(sprintf(
				"INSERT INTO suppliers
				(name,name_full,ext_ref_scales)
				VALUES (%s,%s,%s)
				RETURNING id",
				$carrier_name_db,
				$carrier_name_full_db,
				$carrier_ref_db
			));
		}
		else if($carrier_name_db!=$carrier_ar['name'] || $carrier_name_full_db!=$carrier_ar['name_full']){
			$link_master->query(sprintf(
				"UPDATE suppliers
				SET name=%s,name_full=%s
				WHERE ext_ref_scales=%s",
				$carrier_name_db,
				$carrier_name_full_db,
				$carrier_ref_db
			));
		}
		$carrier_id = $carrier_ar['id'];
						
		//material
		$mat_params = new ParamsSQL($pm,$link);				
		$mat_params->add('material',DT_STRING,$doc->material);				
		$material_db = $mat_params->getParamById('material');
		$material_ar = $link->query_first(sprintf(
			"SELECT id FROM raw_materials
			WHERE name=%s",
			$material_db
		));
		if (!is_array($material_ar)|| count($material_ar)==0){
			//new material
			$material_ar=$link_master->query_first(sprintf(
				"INSERT INTO raw_materials (name)
				VALUES (%s) RETURNING id",
				$material_db
			));
		}
		$material_id = $material_ar['id'];
		
		//silo
		$store = "NULL";
		$cement_silos_id = "NULL";
		if(isset($doc->silo_name)){				
			$silo_params = new ParamsSQL($pm,$link);				
			$silo_params->add('silo_name',DT_STRING,$doc->silo_name);
			$store = $silo_params->getParamById('silo_name');
			$silo_ar = $link->query_first(
				sprintf("SELECT id
					FROM cement_silos
					WHERE weigh_app_name=%s",
					$store
				)
			);
			if(is_array($silo_ar) && count($silo_ar) && $silo_ar['id']){
				$cement_silos_id = $silo_ar['id'];
			}					
		}
		
		//doc				
		$doc_params = new ParamsSQL($pm,$link);				
		$doc_params->add('number',DT_STRING,$doc->number);
		$doc_params->add('doc_ref',DT_STRING,$doc->doc_ref);
		$doc_params->add('date_time',DT_DATETIME,$doc->date_time);
		$doc_params->add('driver',DT_STRING,$doc->driver);
		$doc_params->add('vehicle_plate',DT_STRING,$doc->vehicle_plate);
		$doc_params->add('material',DT_STRING,$doc->material);
		
		$quant_gross = ($doc->quant_gross=='0')? 0:$doc->quant_gross/1000;
		$quant_net = ($doc->quant_net=='0')? 0:$doc->quant_net/1000;
		$doc_quant_net = (!isset($doc->quant_net_document)||$doc->quant_net_document=='0')? 0:$doc->quant_net_document/1000;
		
		$doc_params->add('quant_gross',DT_STRING,$quant_gross);
		$doc_params->add('quant_net',DT_STRING,$quant_net);
		$doc_ar = $link->query_first(sprintf(
			"SELECT id FROM doc_material_procurements WHERE doc_ref=%s",
			$doc_params->getParamById('doc_ref')
		));
		if (!is_array($doc_ar)|| count($doc_ar)==0){
			//new doc
			$link_master->query_first(sprintf(
			"INSERT INTO doc_material_procurements
			(	date_time,
				number,
				doc_ref,
				supplier_id,
				carrier_id,
				cement_silos_id,
				store,
				driver,
				vehicle_plate,
				material_id,
				quant_gross,
				quant_net,
				doc_quant_net
			)
			VALUES (%s,%s,%s,%d,%d,%s,%s,%s,%s,%d,%f,%f,%f)
			RETURNING id",
			$doc_params->getParamById('date_time'),
			$doc_params->getParamById('number'),
			$doc_params->getParamById('doc_ref'),
			$supplier_id,
			$carrier_id,
			$cement_silos_id,
			$store,
			$doc_params->getParamById('driver'),
			$doc_params->getParamById('vehicle_plate'),
			$material_id,
			$quant_gross,
			$quant_net,
			$doc_quant_net
			));
		}
		else{
			//update doc
			$link_master->query_first(sprintf(
			"UPDATE doc_material_procurements
			SET
				date_time=%s,number=%s,
				supplier_id=%d,carrier_id=%d,driver=%s,
				vehicle_plate=%s,
				material_id=%d,
				cement_silos_id=%s,
				store=%s,
				quant_gross=%f,
				quant_net=%f,
				doc_quant_net=%f
			WHERE id=%d",
			$doc_params->getParamById('date_time'),
			$doc_params->getParamById('number'),
			$supplier_id,
			$carrier_id,
			$doc_params->getParamById('driver'),
			$doc_params->getParamById('vehicle_plate'),
			$material_id,
			$cement_silos_id,
			$store,
			$quant_gross,
			$quant_net,
			$doc_quant_net,
			$doc_ar['id']
			));					
		}
	
	}
	
	//AS IS
	public function update_procurement($pm, $doc){
		$docs_str = $pm->getParamValue('docs');
		
		$link_master = $this->getDbLinkMaster();
		$link = $this->getDbLink();
		
		$xml = new SimpleXMLElement($docs_str);
		try{
			$cement_silos_ids = [];
			$material_ids = [];
			$supplier_ids = [];
			$carrier_ids = [];
			
			$doc_cnt=0;
			foreach ($xml->doc as $doc) {
			
				if(!isset($doc->material)){
					continue;
				}
				
				$doc_cnt++;
				//supplier
				$sup_params = new ParamsSQL($pm,$link);				
				$sup_params->add('supplier_ref',DT_STRING,$doc->supplier_ref);
				$sup_params->add('supplier_name',DT_STRING,$doc->supplier_name);
				$sup_params->add('supplier_name_full',DT_STRING,$doc->supplier_name_full);				
				
				$supplier_name_db = $sup_params->getParamById('supplier_name');
				$supplier_name_full_db = $sup_params->getParamById('supplier_name_full');
				$supplier_ref_db = $sup_params->getParamById('supplier_ref');
				
				if(isset($supplier_ids[$supplier_name_db])){
					$supplier_id = $supplier_ids[$supplier_name_db];
				}
				else{
					$supplier_ar = $link->query_first(sprintf(
						"SELECT id,name,name_full
						FROM suppliers
						WHERE ext_ref_scales=%s",
						$supplier_ref_db
					));
				
					if (!is_array($supplier_ar)|| count($supplier_ar)==0){
						//new supplier
						$supplier_ar = $link_master->query_first(sprintf(
							"INSERT INTO suppliers
							(name,name_full,ext_ref_scales)
							VALUES (%s,%s,%s) RETURNING id",
							$supplier_name_db,
							$supplier_name_full_db,
							$supplier_ref_db
						));						
					}
					else if($supplier_name_db!=$supplier_ar['name'] || $supplier_name_full_db!=$supplier_ar['name_full']){
						$link_master->query(sprintf(
							"UPDATE suppliers
							SET name=%s,name_full=%s
							WHERE ext_ref_scales=%s",
							$supplier_name_db,
							$supplier_name_full_db,
							$supplier_ref_db
						));
					}
					$supplier_id = $supplier_ar['id'];
					$supplier_ids[$supplier_name_db] = $supplier_id;
				}
								
				//carrier
				$car_params = new ParamsSQL($pm,$link);
				$car_params->add('carrier_ref',DT_STRING,$doc->carrier_ref);
				$car_params->add('carrier_name',DT_STRING,$doc->carrier_name);
				$car_params->add('carrier_name_full',DT_STRING,$doc->carrier_name_full);				
				
				$carrier_name_db = $car_params->getParamById('carrier_name');
				$carrier_name_full_db = $car_params->getParamById('carrier_name_full');
				$carrier_ref_db = $car_params->getParamById('carrier_ref');
				
				if(isset($carrier_ids[$carrier_name_db])){
					$carrier_id = $carrier_ids[$carrier_name_db];
				}
				else{
					$carrier_ar = $link->query_first(sprintf(
						"SELECT id,name,name_full
						FROM suppliers
						WHERE ext_ref_scales=%s",
						$carrier_ref_db
					));
				
					if (!is_array($carrier_ar) || count($carrier_ar)==0){
						//new carrier
						$carrier_ar = $link_master->query_first(sprintf(
							"INSERT INTO suppliers
							(name,name_full,ext_ref_scales)
							VALUES (%s,%s,%s)
							RETURNING id",
							$carrier_name_db,
							$carrier_name_full_db,
							$carrier_ref_db
						));
					}
					else if($carrier_name_db!=$carrier_ar['name'] || $carrier_name_full_db!=$carrier_ar['name_full']){
						$link_master->query(sprintf(
							"UPDATE suppliers
							SET name=%s,name_full=%s
							WHERE ext_ref_scales=%s",
							$carrier_name_db,
							$carrier_name_full_db,
							$carrier_ref_db
						));
					}
					$carrier_id = $carrier_ar['id'];
					$carrier_ids[$carrier_name_db] = $carrier_id;
				}
								
				//material
				$mat_params = new ParamsSQL($pm,$link);				
				$mat_params->add('material',DT_STRING,$doc->material);				
				$material_db = $mat_params->getParamById('material');
				if(isset($material_ids[$material_db])){
					$material_id = $material_ids[$material_db];
				}
				else{
					$material_ar = $link->query_first(sprintf(
						"SELECT id FROM raw_materials
						WHERE name=%s",
						$material_db
					));
					if (!is_array($material_ar)|| count($material_ar)==0){
						//new material
						$material_ar=$link_master->query_first(sprintf(
							"INSERT INTO raw_materials (name)
							VALUES (%s) RETURNING id",
							$material_db
						));
					}
					$material_id = $material_ar['id'];
					$material_ids[$material_db] = $material_id;					
				}
				
				//silo
				$store = "NULL";
				$cement_silos_id = "NULL";
				if(isset($doc->silo_name)){				
					$silo_params = new ParamsSQL($pm,$link);				
					$silo_params->add('silo_name',DT_STRING,$doc->silo_name);
					$store = $silo_params->getParamById('silo_name');
					if(isset($cement_silos_ids[$store])){
						$cement_silos_id = $cement_silos_ids[$store];
					}
					else{
						$silo_ar = $link->query_first(
							sprintf("SELECT id
								FROM cement_silos
								WHERE weigh_app_name=%s",
								$store
							)
						);
						if(is_array($silo_ar) && count($silo_ar) && $silo_ar['id']){
							$cement_silos_id = $silo_ar['id'];
							$cement_silos_ids[$store] = $cement_silos_id;
						}					
					}
				}
				
				//doc				
				$doc_params = new ParamsSQL($pm,$link);				
				$doc_params->add('number',DT_STRING,$doc->number);
				$doc_params->add('doc_ref',DT_STRING,$doc->doc_ref);
				$doc_params->add('date_time',DT_DATETIME,$doc->date_time);
				$doc_params->add('driver',DT_STRING,$doc->driver);
				$doc_params->add('vehicle_plate',DT_STRING,$doc->vehicle_plate);
				$doc_params->add('material',DT_STRING,$doc->material);
				
				$quant_gross = ($doc->quant_gross=='0')? 0:$doc->quant_gross/1000;
				$quant_net = ($doc->quant_net=='0')? 0:$doc->quant_net/1000;
				$doc_params->add('quant_gross',DT_STRING,$quant_gross);
				$doc_params->add('quant_net',DT_STRING,$quant_net);
				$doc_ar = $link->query_first(sprintf(
					"SELECT id FROM doc_material_procurements WHERE doc_ref=%s",
					$doc_params->getParamById('doc_ref')
				));
				if (!is_array($doc_ar)|| count($doc_ar)==0){
					//new doc
					$link_master->query_first(sprintf(
					"INSERT INTO doc_material_procurements
					(	date_time,
						number,
						doc_ref,
						supplier_id,
						carrier_id,
						cement_silos_id,
						store,
						driver,
						vehicle_plate,
						material_id,
						quant_gross,
						quant_net
					)
					VALUES (%s,%s,%s,%d,%d,%s,%s,%s,%s,%d,%f,%f)
					RETURNING id",
					$doc_params->getParamById('date_time'),
					$doc_params->getParamById('number'),
					$doc_params->getParamById('doc_ref'),
					$supplier_id,
					$carrier_id,
					$cement_silos_id,
					$store,
					$doc_params->getParamById('driver'),
					$doc_params->getParamById('vehicle_plate'),
					$material_id,
					$quant_gross,
					$quant_net
					));
				}
				else{
					//update doc
					$link_master->query_first(sprintf(
					"UPDATE doc_material_procurements
					SET
						date_time=%s,number=%s,
						supplier_id=%d,carrier_id=%d,driver=%s,
						vehicle_plate=%s,
						material_id=%d,
						cement_silos_id=%s,
						store=%s,
						quant_gross=%f,quant_net=%f
					WHERE id=%d",
					$doc_params->getParamById('date_time'),
					$doc_params->getParamById('number'),
					$supplier_id,
					$carrier_id,
					$doc_params->getParamById('driver'),
					$doc_params->getParamById('vehicle_plate'),
					$material_id,
					$cement_silos_id,
					$store,
					$quant_gross,
					$quant_net,
					$doc_ar['id']
					));					
				}
			}
			$res = 'true';
			$descr = 'null';
		}catch (Exception $e){
			$res = 'false';			
			$descr = "'".str_replace("'",'"',$e->getMessage())."'";
		}
		
		$link_master->query("BEGIN");
		$link_master->query("DELETE FROM raw_material_procur_uploads");
		$link_master->query(sprintf(
			"INSERT INTO raw_material_procur_uploads
			(date_time,result,descr,doc_count)
			VALUES ('%s',%s,%s,%d)",
			date('Y-m-d H:i:s'),$res,$descr,$doc_cnt
		));
		$link_master->query("COMMIT");
		
		if ($res == 'false'){
			throw $e;
		}
	}
	public function oper_week_report($pm){
		$days_for_avg = 10;
		$param_change="'08:00'";
		$this->addNewModel(sprintf(
			"SELECT * FROM oper_week_report(%d,%s::interval)",
			$days_for_avg,$param_change)
		,'oper_week_report');
	}
	public function total_report($pm){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array('id'=>'total_report'));
		$model->addField(new FieldSQLInt($link,null,null,"material_id"));
		$model->addField(new FieldSQLDateTime($link,null,null,"date_time"));
		$where = $this->conditionFromParams($pm,$model);
		$this->addNewModel(sprintf(
			"SELECT * FROM raw_material_total_report(%s,%s,%d)",
			$where->getFieldValueForDb('date_time','>=',0),
			$where->getFieldValueForDb('date_time','<=',0),
			$where->getFieldValueForDb('material_id','=',0)
			)
		,'total_report');	
	}
	public function total_details_report($pm){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array('id'=>'total_details_report'));
		$model->addField(new FieldSQLInt($link,null,null,"material_id"));
		$model->addField(new FieldSQLDateTime($link,null,null,"date_time"));
		$where = $this->conditionFromParams($pm,$model);
		$this->addNewModel(sprintf(
			"SELECT * FROM raw_material_total_details_report(
				%s::timestamp without time zone,
				%s::timestamp without time zone,
				%d)",
			$where->getFieldValueForDb('date_time','>=',0),
			$where->getFieldValueForDb('date_time','<=',0),
			$where->getFieldValueForDb('material_id','=',0)
			)
		,'total_details_report');	
	}
	
	public function set_min_quant($pm){
		$link = $this->getDbLinkMaster();
		$params = new ParamsSQL($pm,$link);
		$params->addAll();
		$quant = $pm->getParamValue('quant');
		$link->query(sprintf(
		"SELECT raw_material_min_quant_set(%s,%d,%f)",
		$params->getParamById('week_day'),
		$params->getParamById('material_id'),
		$params->getParamById('quant')
		));
	}
	public function correct_list($pm){
		//material list
		$this->addNewModel(
			"SELECT id,name FROM raw_materials
			WHERE concrete_part=true
			ORDER BY ord",
		'material_list');
		
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array('id'=>'correct_list'));
		$model->addField(new FieldSQLDateTime($link,null,null,"date_time"));
		
		$where = $this->conditionFromParams($pm,$model);
		if(!isset($where)){
			$dt = MyDate::StartMonth(time());
			$dt+= Beton::shiftStartTime();
			$date_from = Beton::shiftStart($dt);
			$date_to = Beton::shiftEnd(MyDate::EndMonth($dt)-24*60*60+Beton::shiftStartTime());
			$date_from_db = "'".date('Y-m-d H:i:s',$date_from)."'";
			$date_to_db = "'".date('Y-m-d H:i:s',$date_to)."'";
		}
		else{
			$date_from_db = $where->getFieldValueForDb('date_time','>=',0);
			$date_to_db = $where->getFieldValueForDb('date_time','<=',0);
		}		
		
		
		$this->addNewModel(sprintf(
		"SELECT 
			get_shift_start(r.date_time) AS shift,
			date8_descr(get_shift_start(r.date_time)::date) AS shift_descr,
			r.material_id,
			sum(coalesce(r.material_quant_norm,0)) AS norm,
			sum(coalesce(r.material_quant_corrected,0)) AS corrected,
			coalesce(obn.quant,0) AS obnul,
			
			sum(coalesce(r.material_quant_corrected,0))-
				sum(coalesce(r.material_quant_norm,0))
			AS balance
			
		 FROM ra_material_consumption AS r
		 LEFT JOIN raw_materials AS m ON m.id=r.material_id
		 LEFT JOIN materials_obnuls AS obn
			ON obn.material_id=r.material_id AND obn.day=get_shift_start(r.date_time)::date
		 WHERE r.date_time BETWEEN %s AND %s
			AND m.concrete_part=true
		 GROUP BY shift,
				shift_descr,
				r.material_id,
				m.name,
				m.ord,
				obn.quant
		 ORDER BY shift,m.ord
		",		
		$date_from_db,
		$date_to_db
		),'correct_list');
	}
	public function total_list($pm){
		//material list
		$this->addNewModel(
			"SELECT
				m.id,
				m.name,
				pp.mat_avg_cons AS avg_cons,
				pp.mat_tot_cons AS tot_cons
			FROM raw_materials AS m
			LEFT JOIN (
				SELECT
					material_id,
					mat_tot_cons,
					mat_avg_cons
				FROM mat_plan_procur(
					now()::timestamp without time zone+'1 day'::interval,
					get_shift_start(now()::timestamp without time zone - (const_days_for_plan_procur_val()||' days')::interval),
					get_shift_end(get_shift_start(now()::timestamp without time zone)-'1 day'::interval),
				null)
				) AS pp ON pp.material_id=m.id
			WHERE concrete_part=true
			ORDER BY ord",
		'material_list');
		
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array('id'=>'total_list'));
		$model->addField(new FieldSQLDateTime($link,null,null,"date_time"));
		
		$where = $this->conditionFromParams($pm,$model);
		if(!isset($where)){
			$dt = MyDate::StartMonth(time());
			$dt+= Beton::shiftStartTime();
			$date_from = Beton::shiftStart($dt);
			$date_to = Beton::shiftEnd(MyDate::EndMonth($dt)-24*60*60+Beton::shiftStartTime());
			$date_from_db = "'".date('Y-m-d H:i:s',$date_from)."'";
			$date_to_db = "'".date('Y-m-d H:i:s',$date_to)."'";
		}
		else{
			$date_from_db = $where->getFieldValueForDb('date_time','>=',0);
			$date_to_db = $where->getFieldValueForDb('date_time','<=',0);
		}		
		
		$this->addNewModel(sprintf(
		"SELECT * FROM raw_material_total_report(%s,%s)",		
		$date_from_db,
		$date_to_db
		),'total_list');
	}
	
	public function correct_consumption($pm){
		$link = $this->getDbLinkMaster();
		$params = new ParamsSQL($pm,$link);
		$params->addAll();
	
		$this->getDbLinkMaster()->query(sprintf(
			"SELECT mat_cons_correct_quant(%s,%d,%f)",
			$params->getParamById('date'),
			$params->getParamById('material_id'),
			$params->getParamById('quant')
			)
		);
	}
	public function correct_obnul($pm){
		$link = $this->getDbLinkMaster();
		$params = new ParamsSQL($pm,$link);
		$params->addAll();
	
		$this->getDbLinkMaster()->query(sprintf(
			"SELECT mat_obnul_correct_quant(%s,%d,%f)",
			$params->getParamById('date'),
			$params->getParamById('material_id'),
			$params->getParamById('quant')
			)
		);
	}
	
	public function supplier_orders_list($pm){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array('id'=>'supplier_orders_list'));
		$model->addField(new FieldSQLDateTime($link,null,null,"shift"));
		$model->addField(new FieldSQLInt($link,null,null,"material_id"));
		$where = $this->conditionFromParams($pm,$model);
		if (!$where){
			throw new Exception("Не заданы параметры!");
		}		
		$mat_id = $where->getFieldValueForDb('material_id','=',0);
		if ($mat_id==0){
			throw new Exception("Не задан материал!");
		}
		$this->addNewModel(sprintf(
		"SELECT
			o.shift,
			o.shift_descr,
			o.supplier_id,
			sp.name AS supplier_descr,
			o.supplier_proc_rate,
			o.quant_to_order,
			o.quant_procur,
			o.quant_balance,
			o.sms_delivered
			
		FROM supplier_orders_list(%s,%s,%d) AS o
		LEFT JOIN suppliers AS sp ON sp.id=o.supplier_id",		
		$where->getFieldValueForDb('shift','>=',0),
		$where->getFieldValueForDb('shift','<=',0),
		$mat_id
		),'supplier_orders_list');		
	}
	
	public static function getTotalsModel($dbLink, $dateForDb, $productioBaseId){
		//.$productioBaseId.
		$model = new ModelSQL($dbLink,array('id'=>'MatTotals'.$productioBaseId.'_Model'));
		$model->addField(new FieldSQLString($dbLink,null,null,"date",DT_DATE));
		$model->query(sprintf(
			"SELECT * FROM mat_totals(%s, %d)",		
			$dateForDb,
			$productioBaseId
			),
		TRUE);
		return $model;	
	
	}
	
	public function mat_totals($pm){
		$link = $this->getDbLink();		
		$this->addModel(self::getTotalsModel($link, $where->getFieldValueForDb('date','=',0), $this->getExtVal($pm, 'production_base_id')));
	}
	
	public function get_material_actions_list($pm){
		$link = $this->getDbLink();		
		$cond = new ConditionParamsSQL($pm, $link);
		$dt_from = $cond->getDbVal('date_time','ge',DT_DATETIME);
		if (!isset($dt_from)){
			throw new Exception('Не задана дата начала!');
		}		
		$dt_to = $cond->getDbVal('date_time','le',DT_DATETIME);
		if (!isset($dt_to)){
			throw new Exception('Не задана дата окончания!');
		}		
		
		Order_Controller::add_production_bases($link);
		if(isset($_SESSION['production_bases']) && count($_SESSION['production_bases'])){
			foreach($_SESSION['production_bases'] as $prod_id){
				$this->addNewModel(
					sprintf("SELECT * FROM material_actions_prod_base(%s, %s, %d)",
						$dt_from,
						$dt_to,
						$prod_id
					),
					"MaterialActionList".$prod_id."_Model"
				);
			}
		}
		
		/*
		$this->addNewModel(
			sprintf("SELECT * FROM material_actions_prod_base1(%s, %s)",
				$dt_from,
				$dt_to
			),
			"MaterialActionList1_Model"
		);

		$this->addNewModel(
			sprintf("SELECT * FROM material_actions_prod_base2(%s, %s)",
				$dt_from,
				$dt_to
			),
			"MaterialActionList2_Model"
		);
		*/
		
		$this->addNewModel(
			sprintf(
			"SELECT
				format_period_rus(%s::date,%s::date,NULL) AS period_descr
			",
			$dt_from,
			$dt_to
			),
		'Head_Model'
		);		
		
	}
	
	public function get_material_cons_tolerance_violation_list($pm){
		$cond = new ConditionParamsSQL($pm,$this->getDbLink());
		$dt_from = $cond->getDbVal('date_time','ge',DT_DATETIME);
		if (!isset($dt_from)){
			throw new Exception('Не задана дата начала!');
		}		
		$dt_to = $cond->getDbVal('date_time','le',DT_DATETIME);
		if (!isset($dt_to)){
			throw new Exception('Не задана дата окончания!');
		}		
	
		$this->addNewModel(
			sprintf(
				"SELECT *
				FROM material_cons_tolerance_violation_list(%s,%s)",
				$dt_from,
				$dt_to
			),
			"MaterialConsToleranceViolationList_Model"
		);
	}
	
	public function get_material_avg_cons_on_ctp($pm){
		$cond = new ConditionParamsSQL($pm,$this->getDbLink());
		$dt_from = $cond->getDbVal('date_time','ge',DT_DATETIME);
		if (!isset($dt_from)){
			throw new Exception('Не задана дата начала!');
		}		
		$dt_to = $cond->getDbVal('date_time','le',DT_DATETIME);
		if (!isset($dt_to)){
			throw new Exception('Не задана дата окончания!');
		}		
	
		$this->addNewModel(
			sprintf("SELECT * FROM material_avg_consumption_on_ctp(%s,%s)",
				$dt_from,
				$dt_to
			),
			"MaterialAvgConsumptionOnCtp_Model"
		);
		
		//корректировка остатков материалов
		$this->addNewModel(
			sprintf("SELECT
					ra.material_id
					,mat.name AS material_name
					,sum(CASE WHEN ra.deb THEN 1 ELSE -1 END*ra.quant) AS quant
					,sum(coalesce(
						(SELECT m_pr.price
						FROM raw_material_prices AS m_pr
						WHERE m_pr.raw_material_id=ra.material_id AND m_pr.date_time<ra.date_time
						ORDER BY m_pr.date_time DESC
						LIMIT 1
						)
					,0)*CASE WHEN ra.deb THEN 1 ELSE -1 END*ra.quant) AS total
					
				FROM ra_material_facts AS ra
				LEFT JOIN raw_materials AS mat ON mat.id=ra.material_id
				WHERE
					ra.date_time BETWEEN %s AND %s
					AND ra.doc_type IN ('cement_silo_balance_reset','material_fact_balance_correction')
				GROUP BY
					ra.material_id,
					mat.name,
					mat.ord
				ORDER BY mat.ord",
				$dt_from,
				$dt_to
			),
			"MaterialBalanceCorretion_Model"
		);
	
		//Цены на метариалы: факт, подбор
		$this->addNewModel(
			sprintf("SELECT
					mat.id,
					mat.name,
					
					coalesce(
						(SELECT
						 	t.price
						FROM raw_material_prices AS t
						WHERE t.raw_material_id = mat.id
							AND t.date_time <= %s
						ORDER BY t.date_time DESC
						LIMIT 1)
					,0) AS price,
					
					coalesce(
						(SELECT
						 	t.price
						FROM raw_material_prices_for_norm AS t
						WHERE t.raw_material_id = mat.id
							AND t.date_time <= %s
						ORDER BY t.date_time DESC
						LIMIT 1)
					,0) AS price_for_norm
					
				FROM raw_materials AS mat
				WHERE mat.concrete_part
				ORDER BY mat.ord"
				,$dt_from
				,$dt_to
			),
			"MaterialPrice_Model"
		);		
	}
	
}
?>