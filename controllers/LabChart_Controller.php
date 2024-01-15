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

class LabChart_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		$pm = new PublicMethod('get_lab_chart1');
		
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

			
		$pm = new PublicMethod('get_lab_chart2');
		
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

		
	}	
	

	public function get_lab_chart1($pm){
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		$production_site_id = 0;
		if($cond->getVal('production_site_id','e',DT_INT) != 'undefined'){
			$production_site_id = $cond->getValForDb('production_site_id','e',DT_INT);
		}		
		if($cond->getVal('concrete_type_id','e',DT_INT)=='undefined'){
			throw new Exception("Не выбрана марка!");
		}
		
		if($cond->getVal('p_type','e',DT_INT)=='undefined'){
			throw new Exception("Не выбран вид p!");
		}
		if($cond->getVal('date_time','ge',DT_DATETIME)=='undefined'
		||$cond->getVal('date_time','le',DT_DATETIME)=='undefined'){
			throw new Exception("Не выбран период!");
		}
		$q = sprintf(
			"SELECT
				get_shift_start(sh.date_time)::date AS shift,
				round(avg(det.mpa_percent)) AS mpa_percent
			FROM shipments AS sh
			LEFT JOIN (
				SELECT
					d.shipment_id,
					round(avg(d.p%d)) AS mpa_percent	
				FROM lab_entry_detail_list AS d
				GROUP BY d.shipment_id
			) AS det ON det.shipment_id = sh.id
			LEFT JOIN orders AS o ON o.id = sh.order_id
			WHERE sh.date_time BETWEEN get_shift_start(%s) AND get_shift_end(get_shift_start(%s))
				AND coalesce(det.mpa_percent,0) > 0
				AND o.concrete_type_id = %d
				AND (%d = 0 OR sh.production_site_id = %d)
			GROUP BY get_shift_start(sh.date_time)"
			,$cond->getValForDb('p_type','e',DT_INT)
			,$cond->getValForDb('date_time','ge',DT_DATETIME)
			,$cond->getValForDb('date_time','le',DT_DATETIME)
			,$cond->getValForDb('concrete_type_id','e',DT_INT)
			,$production_site_id
			,$production_site_id
		);
		$dates = [];
		$vals = [];
		$q_id = $this->getDbLink()->query($q);
		while($ar = $this->getDbLink()->fetch_array($q_id)){
			array_push($dates, date("d/m/y", strtotime($ar['shift'])));
			array_push($vals, intval($ar['mpa_percent']));
		}
		$this->addModel(new ModelVars(			
			array(
				'id'=>'LabChart1_Model',
				'values'=>array(
					new Field('dates',DT_STRING,
						array('value' => json_encode($dates))),
					new Field('vals',DT_STRING,
						array('value'=>json_encode($vals)))
				)
			)
		));
	}

	public function get_lab_chart2($pm){
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		if($cond->getVal('concrete_type_id','e',DT_INT)=='undefined'){
			throw new Exception("Не выбрана марка!");
		}
		$production_site_id = 0;
		if($cond->getVal('production_site_id','e',DT_INT) != 'undefined'){
			$production_site_id = $cond->getValForDb('production_site_id','e',DT_INT);
		}		
		if($cond->getVal('p_type','e',DT_INT)=='undefined'){
			throw new Exception("Не выбран вид p!");
		}
		if($cond->getVal('date_time','ge',DT_DATETIME)=='undefined'
		||$cond->getVal('date_time','le',DT_DATETIME)=='undefined'){
			throw new Exception("Не выбран период!");
		}
		
		$q = sprintf(
			"SELECT
				get_shift_start(sh.date_time)::date AS shift,
				det.ok,
				round(avg(det.mpa_percent)) AS mpa_percent
			FROM shipments AS sh
			LEFT JOIN (
				SELECT
					d.shipment_id,
					max(coalesce(d.ok,0)) AS ok,
					round(avg(d.p%d)) AS mpa_percent	
				FROM lab_entry_detail_list AS d
				GROUP BY d.shipment_id
			) AS det ON det.shipment_id = sh.id
			LEFT JOIN orders AS o ON o.id = sh.order_id
			WHERE sh.date_time BETWEEN get_shift_start(%s) AND get_shift_end(get_shift_start(%s))
				AND coalesce(det.ok,0)>0 AND coalesce(det.mpa_percent,0)>0
				AND o.concrete_type_id = %d
				AND (%d = 0 OR sh.production_site_id = %d)
			GROUP BY get_shift_start(sh.date_time), det.ok
			ORDER BY get_shift_start(sh.date_time), ok"
			,$cond->getValForDb('p_type','e',DT_INT)
			,$cond->getValForDb('date_time','ge',DT_DATETIME)
			,$cond->getValForDb('date_time','le',DT_DATETIME)
			,$cond->getValForDb('concrete_type_id','e',DT_INT)
			,$production_site_id
			,$production_site_id
		);
		$dates = [];
		$vals_tmp = [];
		$oks = [];
		$q_id = $this->getDbLink()->query($q);
		while($ar = $this->getDbLink()->fetch_array($q_id)){
			$ok = intval($ar['ok']);
			if(in_array($ok, $oks) === FALSE){
				array_push($oks, $ok);
			}
			$d = date("d/m/y", strtotime($ar['shift']));
			if(!array_key_exists($d, $dates)){
				array_push($dates, $d);
			}
			$vals_tmp[$d.$ok] = intval($ar['mpa_percent']);
		}
		$vals = [];
		foreach($oks as $ok){
			$vals["ok_".$ok] = [];			
			foreach($dates as $d){
				$k = $d.$ok;
				$v = null;
				if(isset($vals_tmp[$k])){
					$v = $vals_tmp[$k];
				}else{
					//previous
					if(count($vals["ok_".$ok]) > 0){
						$v = $vals["ok_".$ok][count($vals["ok_".$ok])-1];
					}
				}
				array_push($vals["ok_".$ok], $v);
			}
		}
		sort($oks);
		$this->addModel(new ModelVars(			
			array(
				'id'=>'LabChart1_Model',
				'values'=>array(
					new Field('oks',DT_STRING,
						array('value' => json_encode($oks))),
					new Field('dates',DT_STRING,
						array('value' => json_encode($dates))),
					new Field('vals',DT_STRING,
						array('value'=>json_encode($vals)))
				)
			)
		));
	}


}
?>