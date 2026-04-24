<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Driver'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
require_once(FRAME_WORK_PATH.'basic_classes/CondParamsSQL.php');
class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);<xsl:apply-templates/>
	}
	
	public function driver_cheat_report($pm){
		$cond = new CondParamsSQL($pm,$this->getDbLink());
		$vehicle_id = ($cond->paramExists('vehicle_id','e'))?
			$cond->getValForDb('vehicle_id','e',DT_INT) : 0;
		$this->addNewModel(
		sprintf('SELECT * FROM driver_cheat_report(
			%s::timestamp without time zone,
			%s::timestamp without time zone,
			%s::timestamp without time zone,
			%s::interval,
			%d,%d)',
		$cond->getValForDb('date_time','ge',DT_DATETIME),
		$cond->getValForDb('date_time','le',DT_DATETIME),
		$cond->getValForDb('cheat_end_date_time','e',DT_DATETIME),
		$cond->getValForDb('stop_duration','e',DT_TIME),
		$cond->getValForDb('stop_spot_offset','e',DT_INT),
		$vehicle_id),
		'driver_cheat_report');
	}

	public function work_time_report($pm){
		$month_date = $this->getExtVal($pm, 'month_date');
		if(!isset($month_date)){
			$month_date = time();
		}

		$vehicle_id = $this->getExtVal($pm, 'vehicle_id');
		$driver_id = $this->getExtVal($pm, 'driver_id');

		$this->addNewModel(
			sprintf("SELECT * FROM drivers_work_time_report('%s', %d, %d)",
				date("Y-m-d", $month_date),
				$vehicle_id, 
				$driver_id
			),
		'WorkTimeReport_Model');
	}
}

<![CDATA[?>]]>
</xsl:template>
	
</xsl:stylesheet>

