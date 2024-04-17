<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'DOCMaterialProcurement'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
require_once(FRAME_WORK_PATH.'basic_classes/ModelReportSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLInt.php');
class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);<xsl:apply-templates/>
	}
	
	public function insert($pm){
		//doc owner
		if(!$pm->getParamValue('date_time')){
			$pm->setParamValue('date_time',date('Y-m-d H:i:s'));
		}
		if(!$pm->getParamValue('user_id') || $_SESSION['role_id']!='owner'){
			$pm->setParamValue('user_id',$_SESSION['user_id']);
		}
		
		return parent::insert($pm);		
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
		$mat_model->query("SELECT id,name FROM raw_materials WHERE name &lt;&gt;'' ORDER BY ord",
		TRUE);
		$this->addModel($mat_model);			
	}
	
	public function get_shift_list($pm){
		//$link = $this->getDbLink();
		//$this->add_material_model($link);
		
		$list_model = new DOCMaterialProcurementShiftList_Model($this->getDbLink());
		$where = $this->conditionFromParams($pm,$list_model);
		$list_model->addStoredFilter($where);			
		$list_model->addGlobalFilter($where);
		
		$def_date=null;
		FieldSQLDateTime::formatForDb(time(),$def_date);
		
		$cond = '';
		
		$production_base_id = $where->getFieldValueForDb('production_base_id','=',0,0);
		if ($production_base_id != 0){
			$cond = sprintf("production_base_id = %d", $production_base_id);
		}
		
		if($where->getFieldsById('shift_date_time','&gt;=') &amp;&amp; $where->getFieldsById('shift_date_time','&lt;=')){
			if($cond != ""){
				$cond.= " AND ";
			}
			$cond.= sprintf("date_time::date BETWEEN %s AND %s",
				$where->getFieldValueForDb('shift_date_time','&gt;=',0,$def_date),
				$where->getFieldValueForDb('shift_date_time','&lt;=',0,$def_date)			
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
			is_null($where)? '' : 'WHERE '.$cond
			),
		'RawMaterial_Model');
		
		$this->modelGetList($list_model,$pm);
		
		//$this->setListModelId('DOCMaterialProcurementShiftList_Model');		
		//$this->get_list($pm);
	}
	
	/*
	public function get_material_list($pm){
		$link = $this->getDbLink();
		$ar = $link->query_first("SELECT COUNT(*) AS cnt FROM raw_materials WHERE name &lt;&gt;''");
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
		for ($i = 1; $i &lt;= $mat_count; $i++) {
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
		$where->getFieldValueForDb('date_time','&gt;=',0,$def_date),
		$where->getFieldValueForDb('date_time','&lt;=',0,$def_date),
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
<![CDATA[?>]]>
</xsl:template>

</xsl:stylesheet>
