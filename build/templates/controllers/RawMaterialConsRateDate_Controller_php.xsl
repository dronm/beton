<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'RawMaterialConsRateDate'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(ABSOLUTE_PATH.'functions/material_period_check.php');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);<xsl:apply-templates/>
	}
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
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
</xsl:template>

</xsl:stylesheet>
