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


require_once(FRAME_WORK_PATH.'basic_classes/CondParamsSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

include("common/pChart2.1.3/class/pData.class.php");
include("common/pChart2.1.3/class/pDraw.class.php");
include("common/pChart2.1.3/class/pImage.class.php");

require_once(ABSOLUTE_PATH.'functions/Beton.php');

class LabEntry_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);
			

		/* insert */
		$pm = new PublicMethod('insert');
		
			$f_params = array();
			
				$f_params['alias']='Отгрузка';
			
				$f_params['required']=TRUE;
			$param = new FieldExtInt('shipment_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Подборы';
			$param = new FieldExtText('samples'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Материалы';
			$param = new FieldExtText('materials'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='OK2';
			$param = new FieldExtText('ok2'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='f';
			$param = new FieldExtText('f'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='w';
			$param = new FieldExtText('w'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Время';
			$param = new FieldExtText('time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			
				$f_params['alias']='Подбор';
			$param = new FieldExtInt('rate_date_id'
				,$f_params);
		$pm->addParam($param);
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['shipment_id'
			]
		];
		$pm->addEvent('LabEntry.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('LabEntry_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_shipment_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			
				$f_params['alias']='Отгрузка';
			$param = new FieldExtInt('shipment_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Подборы';
			$param = new FieldExtText('samples'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Материалы';
			$param = new FieldExtText('materials'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='OK2';
			$param = new FieldExtText('ok2'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='f';
			$param = new FieldExtText('f'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='w';
			$param = new FieldExtText('w'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Время';
			$param = new FieldExtText('time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			
				$f_params['alias']='Подбор';
			$param = new FieldExtInt('rate_date_id'
				,$f_params);
			$pm->addParam($param);
		
			$param = new FieldExtInt('shipment_id',array(
			
				'alias'=>'Отгрузка'
			));
			$pm->addParam($param);
		
			//default event
			$ev_opts = [
				'dbTrigger'=>FALSE
				,'eventParams' =>['shipment_id'
				]
			];
			$pm->addEvent('LabEntry.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('LabEntry_Model');

			
		/* delete */
		$pm = new PublicMethod('delete');
		
		$pm->addParam(new FieldExtInt('shipment_id'
		));		
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));				
				
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['shipment_id'
			]
		];
		$pm->addEvent('LabEntry.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('LabEntry_Model');

			
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
		
		$this->setListModelId('LabEntryList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('shipment_id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('LabEntryList_Model');		

			
		$pm = new PublicMethod('lab_report');
		
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

			
		$pm = new PublicMethod('item_report');
		
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

			
		$pm = new PublicMethod('lab_avg_report');
		
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

			
		$pm = new PublicMethod('item_on_rate_period_report');
		
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

			
		$pm = new PublicMethod('lab_entry30_days');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('lab_vehicle_list');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('lab_orders_list');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('chart_rep_init');
		
		$this->addPublicMethod($pm);

		
	}
	
	public function modelGetList($model,$pm=null){
		$this->beforeSelect();
		if (is_null($pm)){
			$pm = $this->getPublicMethod(ControllerDb::METH_GET_LIST);		
		}
		$from = null; $count = null;
		$limit = $this->limitFromParams($pm,$from,$count);
		$calc_total = ($count>0);
		if ($from){
			$model->setListFrom($from);
		}
		if ($count){
			$model->setRowsPerPage($count);
		}
		
		$order = $this->orderFromParams($pm,$model);
		$where = $this->conditionFromParams($pm,$model);
		if($where){
			$id_ar = $where->getFieldsById('id','IS NOT');
			if (is_array($id_ar) && count($id_ar)){
				if ($id_ar[0]->getValue()==0){
					$where->deleteField('id','IS NOT');
				}
				else{
					$id_ar[0]->setValue(NULL);
				}
			}
		}
		$fields = $this->fieldsFromParams($pm);		
		$grp_fields = $this->grpFieldsFromParams($pm);		
		$agg_fields = $this->aggFieldsFromParams($pm);		
			
		$browse_mode = $pm->getParamValue('browse_mode');
		if (!isset($browse_mode)){
			$browse_mode = BROWSE_MODE_VIEW;
		}
		$model->setBrowseMode($browse_mode);
			
		$is_insert = ($browse_mode==BROWSE_MODE_INSERT);
		$model->select($is_insert,$where,$order,
			$limit,$fields,$grp_fields,$agg_fields,
			$calc_total,TRUE);
		//
		$this->addModel($model);
		
		$this->afterSelect();	
	}
	public function lab_report($pm){
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		$this->addNewModel(sprintf('SELECT * FROM lab_entry_report(%s,%s)',
		$cond->getValForDb('date_time','ge',DT_DATETIME),
		$cond->getValForDb('date_time','le',DT_DATETIME)),
		'lab_report');
	}
	public function item_report($pm){
		//report conditions
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		//
		$item_types = array(
			'ok'=>array('ind'=>0,'descr'=>'OK'),
			'weight'=>array('ind'=>1,'descr'=>'вес'),
			'p7'=>array('ind'=>2,'descr'=>'p7'),
			'p28'=>array('ind'=>3,'descr'=>'p28'),
			'cnt'=>array('ind'=>4,'descr'=>'Кол-во')
			);
		$k = $cond->getVal('item_type','e',DT_STRING);
		if (!array_key_exists($k,$item_types)){
			throw new Exception('Item not found '.$k);
		}
		
		//head
		$this->addModel(new ModelVars(
			array('values'=>array(
				new Field('date_from',DT_STRING,
					array('value'=>$cond->getVal('date_time','ge'))),
				new Field('date_to',DT_STRING,
					array('value'=>$cond->getVal('date_time','le'))),
				new Field('cnt',DT_STRING,
					array('value'=>$cond->getVal('cnt','e'))),
				new Field('item_type',DT_STRING,
					array('value'=>$item_types[$k]['descr'])),			
				)			
			))
			);
		
		//data		
		$this->addNewModel(sprintf('SELECT * FROM lab_item_report(%s,%s,%d,%d)',
		$cond->getValForDb('date_time','ge',DT_DATETIME),
		$cond->getValForDb('date_time','le',DT_DATETIME),
		$cond->getValForDb('cnt','e',DT_INT),
		$item_types[$k]['ind']
		),
		'lab_report');
	}
	public function item_on_rate_period_report($pm){
		//report conditions
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		//
		$item_types = array(
			'ok'=>array('ind'=>0,'descr'=>'OK'),
			'weight'=>array('ind'=>1,'descr'=>'вес'),
			'p7'=>array('ind'=>2,'descr'=>'p7'),
			'p28'=>array('ind'=>3,'descr'=>'p28'),
			'cnt'=>array('ind'=>4,'descr'=>'Кол-во')
			);
		$k = $cond->getVal('item_type','e',DT_STRING);
		if (!array_key_exists($k,$item_types)){
			throw new Exception('Item not found '.$k);
		}
		
		//head
		$this->addModel(new ModelVars(
			array('values'=>array(
				new Field('date_from',DT_STRING,
					array('value'=>$cond->getVal('date_time','ge'))),
				new Field('date_to',DT_STRING,
					array('value'=>$cond->getVal('date_time','le'))),
				new Field('cnt',DT_STRING,
					array('value'=>$cond->getVal('cnt','e'))),
				new Field('item_type',DT_STRING,
					array('value'=>$item_types[$k]['descr'])),			
				)			
			))
			);
		
		//data		
		$this->addNewModel(sprintf('SELECT * FROM lab_item_on_rate_period_report(%s,%s,%d,%d)',
		$cond->getValForDb('date_time','ge',DT_DATETIME),
		$cond->getValForDb('date_time','le',DT_DATETIME),
		$cond->getValForDb('cnt','e',DT_INT),
		$item_types[$k]['ind']
		),
		'lab_report');
	}
	
	private function insert_update($pm,$insert){
		$link = $this->getDbLinkMaster();
		$shipment_id = $this->getExtVal($pm,((!$insert)? 'old_':'').'shipment_id');
		if(!$insert){
			$ar = $link->query_first(sprintf(
				"SELECT			
					samples,
					materials,
					ok2,
					f,
					w,
					time,
					rate_date_id
				FROM lab_entries
				WHERE shipment_id = %d", $shipment_id));
			$samples = ($pm->getParamValue('samples'))? $this->getExtDbVal($pm,'samples') : "'".$ar['samples']."'";
			$materials = ($pm->getParamValue('materials'))? $this->getExtDbVal($pm,'materials') : "'".$ar['materials']."'";
			$ok2 = ($pm->getParamValue('ok2'))? $this->getExtDbVal($pm,'ok2') : "'".$ar['ok2']."'";
			$f = ($pm->getParamValue('f'))? $this->getExtDbVal($pm,'f') : "'".$ar['f']."'";
			$w = ($pm->getParamValue('w'))? $this->getExtDbVal($pm,'w') : "'".$ar['w']."'";
			$time = ($pm->getParamValue('time'))? $this->getExtDbVal($pm,'time') : "'".$ar['time']."'";
			$rate_date_id = ($pm->getParamValue('rate_date_id'))? $this->getExtDbVal($pm,'rate_date_id') : $ar['rate_date_id'];			
		}else{
			$samples = $this->getExtDbVal($pm,'samples');
			$materials = $this->getExtDbVal($pm,'materials');
			$ok2 = $this->getExtDbVal($pm,'ok2');
			$f = $this->getExtDbVal($pm,'f');
			$w = $this->getExtDbVal($pm,'w');
			$time = $this->getExtDbVal($pm,'time');
			$rate_date_id = $this->getExtDbVal($pm,'rate_date_id');			
			if(!isset($rate_date_id)){
				throw new Exception('Не выбран подбор!');
			}
		}
		if(!$rate_date_id){
			throw new Exception('Не выбран подбор!');
		}		
		$link->query(sprintf(
			"SELECT lab_entry_update(%d,%s,%s,%s,%s,%s,%s,%d)",
				$shipment_id
				,$samples
				,$materials
				,$ok2
				,$f
				,$w
				,$time
				,$rate_date_id
			)
		);
	}
	public function insert($pm){
		$this->insert_update($pm,TRUE);
	}
	public function update($pm){
		$this->insert_update($pm,FALSE);
	}	
	public function lab_entry30_days($pm){
		$this->addNewModel('SELECT * FROM lab_entry_30days_2',
		'lab_entry30_days');
	}	
	public function lab_vehicle_list($pm){
		$this->addNewModel('SELECT * FROM lab_cur_vehicle_list',
		'lab_vehicle_list');
	}	
	public function lab_orders_list($pm){
		$this->addNewModel('SELECT * FROM lab_orders_list',
		'lab_orders_list');

	}	
	
	public function lab_avg_report_data($cond,&$concrTypes=NULL){
		$item_type = $cond->getVal('item_type','e',DT_STRING);
		$item_types = array('ok','weight','p7','p28','cnt');
		if (!in_array($item_type,$item_types)){
			throw new Exception('Не определен показатель!');
		}
		
		$link = $this->getDbLink();
		$q_id = $link->query('SELECT id,name FROM concrete_types_for_lab_list');
		$concr_types = '';
		$concr_descrs = '';
		while ($ar=$link->fetch_array($q_id)){
			$id = 'concrete_type_id_'.$ar['id'];
			$concr_type_set = $cond->getVal($id,'in',DT_BOOL);
			if ($concr_type_set=='true'||$concr_type_set=='1'){
				$concr_types.=($concr_types=='')? '':',';
				$concr_types.=$ar['id'];
				
				$concr_descrs.=($concr_descrs=='')? '':', ';
				$concr_descrs.=$ar['name'];
				
				if (!is_null($concrTypes)){
					$concrTypes[$ar['id']] = array(
						'name'=>$ar['name'],
						'vals'=>array()
					);
				}
			}
		}
		
		if ($concr_types==''){
			throw new Exception('Не выбрана ни одна марка!');
		}
		
		//head
		/*
		$this->addModel(new ModelVars(
			array('values'=>array(
				new Field('date_from',DT_STRING,
					array('value'=>$cond->getVal('date_time','ge'))),
				new Field('date_to',DT_STRING,
					array('value'=>$cond->getVal('date_time','le'))),
				new Field('cnt',DT_STRING,
					array('value'=>$cond->getVal('cnt','e'))),
				new Field('concr_descrs',DT_STRING,
					array('value'=>$concr_descrs)),			
				)			
			))
		);		
		*/
		return sprintf(
		"SELECT
			concrete_type_id,
			concrete_type_descr,
			shipment_date AS date,
			date8_descr(shipment_date) AS date_descr,
			ROUND(%s,2) AS val
		FROM lab_avg_vals_report(%s,%s,%d,%s)",
		$item_type,
		$cond->getValForDb('date_time','ge',DT_DATETIME),
		$cond->getValForDb('date_time','le',DT_DATETIME),
		$cond->getValForDb('cnt','e',DT_INT),
		'ARRAY['.$concr_types.']'
		);
	}
	private function lab_avg_report_table($cond){
		$q = $this->lab_avg_report_data($cond);
		$this->addNewModel($q,'lab_avg_report');
	}
	
	/**
	 * Устарел! использовать JavaScript library!
	 */
	private function lab_avg_report_chart($cond){
		$concr_types = array();
		$q = $this->lab_avg_report_data($cond,$concr_types);
		
		$MyData = new pData();
		$chart_dates = array();
		$max_val = 0;
		
		$l = $this->getDbLink();
		$q_id = $l->query($q);
		
		while ($ar=$l->fetch_array($q_id)){
			array_push(
				$concr_types[
					$ar['concrete_type_id']
				]['vals'],
				$ar['val']
			);
			array_push($chart_dates,$ar['date']);
			if ($max_val<$ar['val']){
				$max_val = $ar['val'];
			}			
		}
		
		foreach($concr_types as $concr_type){
			$MyData->addPoints($concr_type['vals'],$concr_type['name']);
			$MyData->setSerieWeight($concr_type['name'],1); 
		}
		$MyData->setAxisName(0,"показатели");		
		$MyData->addPoints($chart_dates,"Даты");
		$MyData->setAbscissa("Даты");
		$MyData->setXAxisName("дата");
		//$MyData->setXAxisDisplay(AXIS_FORMAT_DATE,"d/m/Y");
		/* Create the pChart object */
		$myPicture = new pImage(1099,500,$MyData);

		/* Turn of AAliasing */
		$myPicture->Antialias = TRUE;
		/* Draw the border */
		$myPicture->drawRectangle(0,0,1100,499,array("R"=>0,"G"=>0,"B"=>0));

		$myPicture->setFontProperties(array("FontName"=>FONT_FILE,"FontSize"=>6));
		
		$myPicture->drawText(30,20,
			$cond->getVal('date_time','ge').'-'.$cond->getVal('date_time','le'),
			array("FontSize"=>12));
		
		/* Define the chart area */
		$myPicture->setGraphArea(25,15,1180,450);//170
		/* Draw the scale */
		//$scaleSettings = array("XMargin"=>0,"YMargin"=>0,"Floating"=>TRUE,"GridR"=>200,"GridG"=>200,"GridB"=>200,"DrawSubTicks"=>TRUE,"CycleBackground"=>TRUE);
		//$myPicture->drawScale($scaleSettings);
		$AxisBoundaries = array(0=>array("Min"=>0,"Max"=>$max_val+20));
		$ScaleSettings  = array("Mode"=>SCALE_MODE_MANUAL,
			"ManualScale"=>$AxisBoundaries,
			"DrawSubTicks"=>TRUE,"DrawArrows"=>TRUE,
			"ArrowSize"=>6
			);//"LabelSkip"=>1
		$myPicture->drawScale($ScaleSettings); 		

		/* Draw the step chart */
		//$myPicture->drawStepChart();
		$Config = array("BreakVoid"=>FALSE);
		$myPicture->drawLineChart($Config);
		//array("DisplayColor"=>DISPLAY_MANUAL,"DisplayR"=>0,"DisplayG"=>0,"DisplayB"=>0)

		/* Write the chart legend */
		$myPicture->drawLegend(590,17,array("Style"=>LEGEND_NOBORDER,"Mode"=>LEGEND_HORIZONTAL));

		/* Render the picture (choose the best way) */
		ob_start();
		$myPicture->stroke();
		$contents = ob_get_contents();
		ob_end_clean();				
		
		$this->addModel(new ModelVars(
			array('name'=>'image',
				'id'=>'Chart_Model',
				'values'=>array(
					new Field('mime',DT_STRING,
						array('value'=>'image/png')),				
					new Field('img',DT_STRING,
						array('value'=>base64_encode($contents)))
					)
				)
			)
		);
		
		//$myPicture->render('d:\test.jpg');
		
	}	
	public function lab_avg_report($pm){
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		$this->lab_avg_report_table($cond);
		/*
		if ($cond->getVal('report_type','e')=='table'){
			$this->lab_avg_report_table($cond);
		}
		else if ($cond->getVal('report_type','e')=='chart'){
			$this->lab_avg_report_chart($cond);
		}
		else{
			throw new Exception("Unknown report type!");
		}
		*/
	}
	
	public function chart_rep_init($pm){
		$date_from = Beton::shiftStart(time());
		$date_to = Beton::shiftEnd($date_from);
		$ar = $this->getDbLink()->query_first("SELECT concrete_types_ref(t) AS concrete_types_ref FROM concrete_types AS t WHERE t.name = 'М350'");
		$concrete_types_ref = NULL;
		if($ar && count($ar)){
			$concrete_types_ref = $ar['concrete_types_ref'];
		}
	
		//нинициализационные данные отчета
		$this->addModel(new ModelVars(
			array('name'=>'image',
				'id'=>'Init_Model',
				'values' => array(
						new Field('dateFrom', DT_STRING, array('value' => date('Y-m-d H:i:s',$date_from)))
						,new Field('dateTo',DT_STRING, array('value' => date('Y-m-d H:i:s',$date_to)))
						,new Field('concrete_types_ref', DT_STRING, array('value' => $concrete_types_ref))
				)
			)
		));
	}
	
}
?>