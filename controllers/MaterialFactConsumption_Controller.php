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



//deprecated!
//require_once('common/ExcelReader/Excel/reader.php');

require_once(FRAME_WORK_PATH.'basic_classes/VariantStorageBeton.php');

require_once(FUNC_PATH.'Ammann.php');

class MaterialFactConsumption_Controller extends ControllerSQL{

	const ER_UPLOAD = 'Ошибка загрузки файла данных';

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
			$param = new FieldExtDateTimeTZ('upload_date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('upload_user_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtDateTimeTZ('date_time'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('concrete_type_production_descr'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('concrete_type_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('raw_material_production_descr'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('raw_material_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('vehicle_production_descr'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('vehicle_schedule_state_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtFloat('concrete_quant'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtFloat('material_quant'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtFloat('material_quant_req'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtInt('cement_silo_id'
				,$f_params);
		$pm->addParam($param);
		
			$f_params = array();
			$param = new FieldExtString('production_id'
				,$f_params);
		$pm->addParam($param);
		
		$pm->addParam(new FieldExtInt('ret_id'));
		
		//default event
		$ev_opts = [
			'dbTrigger'=>FALSE
			,'eventParams' =>['id'
			]
		];
		$pm->addEvent('MaterialFactConsumption.insert',$ev_opts);
		
		$this->addPublicMethod($pm);
		$this->setInsertModelId('MaterialFactConsumption_Model');

			
		/* update */		
		$pm = new PublicMethod('update');
		
		$pm->addParam(new FieldExtInt('old_id',array('required'=>TRUE)));
		
		$pm->addParam(new FieldExtInt('obj_mode'));
		
			$f_params=array();
			$param = new FieldExtInt('id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('production_site_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('upload_date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('upload_user_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtDateTimeTZ('date_time'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('concrete_type_production_descr'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('concrete_type_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('raw_material_production_descr'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('raw_material_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('vehicle_production_descr'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('vehicle_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('vehicle_schedule_state_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtFloat('concrete_quant'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtFloat('material_quant'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtFloat('material_quant_req'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtInt('cement_silo_id'
				,$f_params);
			$pm->addParam($param);
		
			$f_params=array();
			$param = new FieldExtString('production_id'
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
			$pm->addEvent('MaterialFactConsumption.update',$ev_opts);
			
			$this->addPublicMethod($pm);
			$this->setUpdateModelId('MaterialFactConsumption_Model');

			
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
		$pm->addEvent('MaterialFactConsumption.delete',$ev_opts);
		
		$this->addPublicMethod($pm);					
		$this->setDeleteModelId('MaterialFactConsumption_Model');

			
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
		
		$this->setListModelId('MaterialFactConsumptionList_Model');
		
			
		$pm = new PublicMethod('get_rolled_list');
		
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

			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('MaterialFactConsumptionList_Model');		

			
		$pm = new PublicMethod('upload_production_file');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_site_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('production_file',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('upload_production_file_auto');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_site_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('production_file',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_report');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_site_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('production_file',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('delete_material');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('production_site_id',$opts));
	
				
	$opts=array();
	
		$opts['length']=36;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('production_id',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('raw_material_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('cement_silo_id',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	public function get_rolled_list($pm){
		$link = $this->getDbLink();
		
		$list_model_name = $this->getListModelId();
		$list_model = new $list_model_name($this->getDbLink());

		$cond = '';
		if (defined('PARAM_TEMPLATE') && isset($_REQUEST[PARAM_TEMPLATE])){
			$stvar = VariantStorageBeton::restore($_REQUEST[PARAM_TEMPLATE], $this->getDbLink());
			VariantStorageBeton::applyFilters($stvar,$list_model,$where,$_REQUEST[PARAM_TEMPLATE]);
		}
		else{
			$where = $this->conditionFromParams($pm,$list_model);
		}
		if($where){
			$where->setTableName('t');
		}
		
		$oblig_cond = '';//NOT coalesce(t_map.order_id,0)=0
		if($where){
			$where_fields = $where->getFieldIterator();
			while($where_fields->valid()){
				$field = $where_fields->current();
				$cond.=($cond=='')? '':' '.$field['cond'].' ';
				if (!is_null($field['expression'])){
					$cond.= $field['expression'];
				}
				else{
					$pat = ($field['caseInsen'])?
						$where::PAT_CASE_INSEN:$where::PAT_CASE_SEN;
					$f_val = ($field['field']->getSQLExpression())?
							$field['field']->getSQLExpression():
							$field['field']->getValueForDb();
					if ($field['signe']=='LIKE' && strlen($f_val) && $f_val[0]!="'"){
						$f_val = "'".$f_val."'";
					}
					$field['field']->setTableName('t');
					$f_sql = $field['field']->getSQLNoAlias(FALSE);
					$cond.= sprintf($pat,
						$f_sql . ( ($field['signe']=='LIKE')? '::text':'' ),
						$field['signe'],
						$f_val
					);				
				}
				
				$where_fields->next();
			}
			if(strlen($oblig_cond)){
				$cond.= ' AND '.$oblig_cond;
			}
			
		}
		else if(strlen($oblig_cond)){
			$cond = $oblig_cond;
		}
		if(strlen($cond)){
			$cond = 'WHERE '.$cond;
		}
		//||' ('||pr_st.name||')'
		$mat_model = new ModelSQL($link,array('id'=>'MaterialFactConsumptionMaterialList_Model'));
		$mat_model->addField(new FieldSQLString($link,null,null,"raw_material_production_descr"));
		$mat_model->query(sprintf(
			"WITH 
			prod_tot AS (
				SELECT sum(concrete_quant) AS v
				FROM productions
				WHERE id IN (
					SELECT prod.id
					FROM material_fact_consumptions AS t
					LEFT JOIN productions AS prod ON prod.production_site_id=t.production_site_id AND prod.production_id=t.production_id
					%s
				)
			)
			SELECT DISTINCT ON (mat.ord,t.production_site_id,t.raw_material_production_descr)
				t.raw_material_production_descr AS raw_material_production_descr,
				materials_ref(mat) AS raw_materials_ref,
				pr_st.name AS production_name,
				t.production_site_id,
				(SELECT v FROM prod_tot) AS concrete_quant,
				sum(t.material_quant+coalesce(t_cor.quant,0)) AS material_quant,
				sum(t.material_quant_req) AS material_quant_req,
				sum(
					CASE
						WHEN coalesce(sh.quant,0)=0 OR coalesce(t.concrete_quant,0)=0 THEN 0
						ELSE coalesce(ra_mat.quant,0)/coalesce(sh.quant,0) * coalesce(t.concrete_quant,0)
					END				
				) AS material_quant_shipped
			FROM material_fact_consumptions AS t
			LEFT JOIN raw_materials AS mat ON mat.id=t.raw_material_id
			LEFT JOIN production_sites AS pr_st ON pr_st.id=t.production_site_id
			LEFT JOIN productions AS prod ON prod.production_site_id=t.production_site_id AND prod.production_id=t.production_id
			LEFT JOIN shipments AS sh ON sh.id=prod.shipment_id
			LEFT JOIN ra_materials AS ra_mat ON ra_mat.doc_type='shipment' AND ra_mat.doc_id=sh.id AND ra_mat.material_id=t.raw_material_id
			LEFT JOIN material_fact_consumption_corrections AS t_cor ON t_cor.production_site_id=t.production_site_id AND t_cor.production_id=t.production_id
						AND t_cor.material_id=t.raw_material_id
						AND t_cor.cement_silo_id=t.cement_silo_id
			%s
			GROUP BY t.raw_material_production_descr,t.production_site_id,mat.ord,mat.*,pr_st.name
			ORDER BY mat.ord,t.production_site_id",
			$cond,
			$cond
		),
		TRUE);
		$this->addModel($mat_model);			
	
		$this->setListModelId("MaterialFactConsumptionRolledList_Model");
		parent::get_list($pm);
	}

	public function get_list($pm){
		$link = $this->getDbLink();
		
		$list_model_name = $this->getListModelId();
		$list_model = new $list_model_name($this->getDbLink());
		$where = $this->conditionFromParams($pm,$list_model);
		
		$mat_model = new ModelSQL($link,array('id'=>'MaterialFactConsumptionHeader_Model'));
		$mat_model->addField(new FieldSQLString($link,null,null,"raw_material_production_descr"));
		$mat_model->query(sprintf(
			"SELECT
				DISTINCT raw_material_production_descr
			FROM material_fact_consumptions
			%s
			ORDER BY raw_material_production_descr",
			$where? $where->getSQL():''
		),
		TRUE);
		$this->addModel($mat_model);			
		
		parent::get_list($pm);
	}

	public function upload_production_file_auto($pm) {
		$this->upload_production_file_cont($pm, FALSE);
	}

	public function upload_production_file($pm) {
		$this->upload_production_file_cont($pm, TRUE);
	}

	//If $interactive=FALSE, log errors instead of throwing errors!
	public function upload_production_file_cont($pm, $interactive){
		
		$production_site_id = $this->getExtDbVal($pm,"production_site_id");
		$ar = $this->getDbLink()->query_first(sprintf("SELECT production_plant_type FROM production_sites WHERE id=%d",$production_site_id));
		if(!is_array($ar) || !count($ar) || !isset($ar['production_plant_type']) || $ar['production_plant_type']==''){
			throw new Exception('Plant not found!');
		}
		
		if (
		!$_FILES['production_file']
		|| !$_FILES['production_file']['tmp_name']
		|| ( is_array($_FILES['production_file']['tmp_name']) && !count($_FILES['production_file']['tmp_name']) )
		){
			throw new Exception(self::ER_UPLOAD);
		}
		
		$file = is_array($_FILES['production_file']['tmp_name'])? $_FILES['production_file']['tmp_name'][0] : $_FILES['production_file']['tmp_name'];
		if($ar['production_plant_type']=='elkon'){
			$this->upload_production_file_elkon($production_site_id);
		
		}else if($ar['production_plant_type']=='ammann'){
			$db = $this->getDbLinkMaster();
			Ammann::uploadProductionFile($db, $production_site_id, $file, $interactive);
		}
		
	}
	
	private function onFileUploadError($prodSiteId, $error, $interactive){
		if($interactive){
			throw new Exception($error);
		}
		
		//log
		 $this->getDbLinkMaster()->query(sprintf(
		 	"SELECT elkon_log_upsert((NULL,now(),%d,'%s',%d)::elkon_log)",
		 	$prodSiteId,
		 	$error,
		 	0
		 ));	
	}
	
	public function upload_production_file_elkon($production_site_id, $file){
		
		throw new Exception("Method upload_production_file not supported for Elkon plant!");
		
		//file processing
		$data = new Spreadsheet_Excel_Reader();
		$data->setOutputEncoding('utf-8');
		$data->read($file);
		
		$fl = OUTPUT_PATH.'excel_data.txt';
		if(file_exists($fl)){
			unlink($fl);
		}
		
		$HEAD_ROW = 2;//header row
		$MAT_COL_FROM = 9;//
		$DATA_ROW_FROM = 4;//
		
		$COL_CHECK = 2;
		$COL_DATE = 3;
		$COL_CONCRETE_TYPE = 5;
		$COL_TIME = 6;
		$COL_QUANT_V = 7;
		$COL_VEHICLE = 8;
		
		$link = $this->getDbLinkMaster();
		
		$link->query('BEGIN');
		try{
			$materials = [];
			$concrete_types = [];
			$vehicles = [];
			$silo_ids = [];
			
			//materials
			$col = $MAT_COL_FROM;		
			while($col<$data->sheets[0]['numCols']){
				$descr_s = $data->sheets[0]['cells'][$HEAD_ROW][$col];
				$descr = '';
				FieldSQLString::formatForDb($link,$descr_s,$descr);
				$ar = $link->query_first(sprintf('SELECT material_fact_consumptions_add_material(%s) AS material_id',$descr));
				$materials[$descr_s] = is_null($ar['material_id'])? 'NULL':$ar['material_id'];
				$col+= 3;
			}
			
			$errors = FALSE;
			//data
			for ($row = $DATA_ROW_FROM; $row <= $data->sheets[0]['numRows']; $row++) {
				$check  = trim((string) $data->sheets[0]['cells'][$row][$COL_CHECK]);
				if(!strlen($check)){
					break;
				}
				
				$concrete_type_descr = $link->escape_string($data->sheets[0]['cells'][$row][$COL_CONCRETE_TYPE]);
				$quant_v = floatval($link->escape_string($data->sheets[0]['cells'][$row][$COL_QUANT_V]));
				$vehicle_descr = $link->escape_string($data->sheets[0]['cells'][$row][$COL_VEHICLE]);
				
				//build date time
				$data_dt = "'".date('Y-m-d',$data->sheets[0]['cellsInfo'][$row][$COL_DATE]['raw']-24*60*60).' '.trim($data->sheets[0]['cells'][$row][$COL_TIME])."'";
								
				if(!isset($concrete_types[$concrete_type_descr])){
					$ar = $link->query_first(sprintf("SELECT material_fact_consumptions_add_concrete_type('%s') AS concrete_type_id",$concrete_type_descr));
					$concrete_types[$concrete_type_descr] = is_null($ar['concrete_type_id'])? 'NULL':$ar['concrete_type_id'];
				}
				if(!isset($vehicles[$vehicle_descr])){
					$ar = $link->query_first(sprintf("SELECT material_fact_consumptions_add_vehicle('%s') AS vehicle_id",$vehicle_descr));
					$vehicles[$vehicle_descr] = is_null($ar['vehicle_id'])? 'NULL':$ar['vehicle_id'];
				}
				
				//materials
				$col = $MAT_COL_FROM;		
				foreach($materials as $mat_descr=>$mat_id){
					//У нас в программе учет в тоннах!
					$mat_quant = floatval((string) $data->sheets[0]['cells'][$row][$col]) / 1000;
					$mat_quant_req = floatval((string) $data->sheets[0]['cells'][$row][$col+1]) / 1000;
					$col+= 3;
					
					$mat_id = is_null($mat_id)? 'NULL':$mat_id;
					
					if(!$errors){
						$errors = is_null($mat_id) || is_null($concrete_type_id) || is_null($vehicle_id);
					}
					
					$silo_key = $production_site_id.$mat_descr;
					if(!isset($silo_ids[$silo_key])){
						$ar = $link->query_first(sprintf("SELECT id FROM cement_silos WHERE production_site_id=%d AND production_descr='%s'",$production_site_id,$mat_descr));
						$silo_ids[$silo_key] = is_null($ar['id'])? 'NULL':$ar['id'];
					}
					
					//to database
					$link->query(
						sprintf("SELECT material_fact_consumptions_add(ROW(
							nextval(pg_get_serial_sequence('material_fact_consumptions', 'id')),
							%d,
							now(),
							%d,
							%s::timestamp,
							'%s',
							%s,
							'%s',
							%s,
							'%s',
							%s,
							NULL,
							%f,
							%f,
							%f,
							%d
							)::material_fact_consumptions)",
								$production_site_id,
								$_SESSION['user_id'],
								$data_dt,
								$concrete_type_descr,
								$concrete_types[$concrete_type_descr],
								$mat_descr,
								$mat_id,
								$vehicle_descr,
								$vehicles[$vehicle_descr],							
								$quant_v,
								$mat_quant,
								$mat_quant_req,
								$silo_ids[$silo_key]
							)
					);
				}
			}
			
			$link->query('COMMIT');
		}
		catch(Exception $e){
			$link->query('ROLLBACK');
			throw $e;
		}
		
		if($errors){
			throw new Exception('Файл загружен, но есть несопоставленные данные!');
		}
	}
	
	public function get_report($pm){
	}

	public function insert($pm){
		/**
		 * Имеем такие поля:
		 * production_id
		 * production_site_id
		 * cement_silo_id
		 * raw_material_id
		 * material_quant
		 */
		
		$production_site_id = $this->getExtDbVal($pm,'production_site_id');
		$production_id = $this->getExtDbVal($pm,'production_id');
		$raw_material_id = $this->getExtDbVal($pm,'raw_material_id');
		$material_quant = $this->getExtDbVal($pm,'material_quant');
		
		//Берем данные по производству
		$ar_prod = $this->getDbLink()->query_first(sprintf(
			"SELECT
				t.id
				,t.concrete_type_id AS concrete_type_id
				,ct.name AS concrete_type_production_descr
				,t.vehicle_id AS vehicle_id
				,regexp_replace(vh.plate, '\D','','g') AS vehicle_production_descr
				,t.concrete_quant
				,(SELECT m.name FROM raw_materials AS m WHERE m.id=%d) AS raw_material_production_descr
				,t.vehicle_schedule_state_id
				,t.manual_correction
			FROM productions AS t
			LEFT JOIN concrete_types AS ct ON ct.id=t.concrete_type_id
			LEFT JOIN vehicles AS vh ON vh.id=t.vehicle_id
			WHERE t.production_site_id=%d AND t.production_id=%d"
			,$raw_material_id
			,$production_site_id
			,$production_id
		));
		
		if(!is_array($ar_prod) || !count($ar_prod) || !isset($ar_prod['id'])){
			throw new Exception('Производство не найдено!');
		}
		
		try{
			$this->getDbLinkMaster('BEGIN');

			$this->getDbLinkMaster()->query(
				sprintf(
					"INSERT INTO material_fact_consumptions
					(production_site_id
					,production_id
					,cement_silo_id
					,upload_date_time
					,date_time
					,upload_user_id
					,concrete_type_production_descr
					,concrete_type_id
					,raw_material_production_descr
					,raw_material_id
					,vehicle_production_descr
					,vehicle_id
					,vehicle_schedule_state_id
					,concrete_quant
					,material_quant
					,material_quant_req
					)
					VALUES
					(%d
					,%d
					,%s
					,now()
					,now()
					,%d
					,'%s'
					,%d
					,'%s'
					,%d				
					,'%s'
					,%d
					,%d
					,%f
					,%f
					,%f
					)"
					,$this->getExtDbVal($pm,'production_site_id')
					,$this->getExtDbVal($pm,'production_id')
					,$this->getExtDbVal($pm,'cement_silo_id')
					,$_SESSION['user_id']
					,$ar_prod['concrete_type_production_descr']
					,$ar_prod['concrete_type_id']
					,$ar_prod['raw_material_production_descr']
					,$raw_material_id
					,$ar_prod['vehicle_production_descr']
					,$ar_prod['vehicle_id']
					,$ar_prod['vehicle_schedule_state_id']
					,$ar_prod['concrete_quant']
					,$material_quant
					,$material_quant
				)
			);
			
			if($ar_prod['manual_correction']!='t'){
				$this->getDbLinkMaster()->query(
					sprintf(
						"UPDATE productions
						SET manual_correction = TRUE
						WHERE production_site_id=%d AND production_id=%d"
						,$production_site_id
						,$production_id					
					)
				);
			}
						
			$this->getDbLinkMaster('COMMIT');
		}
		catch(Exception $e){
			$this->getDbLinkMaster('ROLLBACK');
			throw $e;
		}
	}	

	public function delete_material($pm){
		$silo_set = ($pm->getParamValue('cement_silo_id')&&$pm->getParamValue('cement_silo_id')!='null');
		$this->getDbLinkMaster()->query(
			sprintf(
				"DELETE FROM material_fact_consumptions
				WHERE production_site_id=%d AND production_id=%d AND raw_material_id=%d%s"
				,$this->getExtDbVal($pm,'production_site_id')
				,$this->getExtDbVal($pm,'production_id')
				,$this->getExtDbVal($pm,'raw_material_id')
				,$silo_set? sprintf(" AND cement_silo_id=%d",$this->getExtDbVal($pm,'cement_silo_id')):''
			)
		);
	}


}
?>