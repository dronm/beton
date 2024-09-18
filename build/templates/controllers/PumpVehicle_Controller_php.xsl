<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'PumpVehicle'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function get_work_list($pm){
		$this->setListModelId("PumpVehicleWorkList_Model");
		parent::get_list($pm);
	}
	
	private static function min_vals_enabled(){
		return ($_SESSION['role_id']=='owner' || $_SESSION["role_id"]=="admin" || $_SESSION["role_id"]=="boss");
	}

	private static function before_write_check($pm){
		//some attrs are not allowed to be changed: min_order_quant, min_order_time_interval
		if(!self::min_vals_enabled()){
			$min_order_quant = $pm->getParamValue('min_order_quant');
			$min_order_time_interval = $pm->getParamValue('min_order_time_interval');
			if($min_order_time_interval || $min_order_quant){
				throw new Exception("Запрещено менять минтмальное количество и интервал для заявки!");
			}
		}
	}

	public function insert($pm){
		self::before_write_check($pm);
		parent::insert($pm);
	}
	public function update($pm){
		self::before_write_check($pm);
		parent::update($pm);
	}

	public function get_contact_refs($pm){
		$this->addNewModel(sprintf(
			"SELECT
				client_tels_ref_on_tel(format_cel_standart(sub.tels->'fields'->>'tel')) AS ref
			FROM (
				SELECT jsonb_array_elements(phone_cels->'rows') AS tels
				FROM pump_vehicles
				WHERE id = %d
			) AS sub"
			,$this->getExtDbVal($pm, 'id')
		), 'Ref_Model');		
	}

	public function check_order_min_vals($pm){
		$this->addNewModel(sprintf(
			"SELECT * FROM pump_vehicles_check_order_min_vals(%d, %f, %s, %s) AS (passed bool, min_quant numeric(19,2), min_time_interval interval)"
			,$this->getExtDbVal($pm, 'pump_vehicle_id')
			,$this->getExtDbVal($pm, 'order_quant')
			,$this->getExtDbVal($pm, 'order_date_time')
			,$pm->getParamValue('order_id')? $this->getExtDbVal($pm, 'order_id'):'null'
		), 'CheckResult_Model'
		);		
	}
	
</xsl:template>

</xsl:stylesheet>
