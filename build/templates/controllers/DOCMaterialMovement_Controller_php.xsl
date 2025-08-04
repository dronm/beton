<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'DOCMaterialMovement'"/>
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

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>

	}	

	public function insert($pm){
		//doc owner
		if(!$pm->getParamValue('date_time')){
			$pm->setParamValue('date_time',date('Y-m-d H:i:s'));
		}
		if(!$pm->getParamValue('user_id') || $_SESSION['role_id']!='owner'){
			$pm->setParamValue('user_id',$_SESSION['user_id']);
		}

		material_period_check($this->getDbLink(), $_SESSION["user_id"], $this->getExtDbVal($pm, 'date_time'));

		$pm->setParamValue('last_modif_user_id',$_SESSION['user_id']);
		$pm->setParamValue('last_modif_date_time',date('Y-m-d H:i:s'));

		return parent::insert($pm);		
	}

	public function update($pm){
		if(!$pm->getParamValue('date_time')){
			//retrieve date from db
			$ar = $this->getDbLink()->query_first(
				sprintf("SELECT date_time FROM doc_material_movements WHERE id = %d"
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
		$pm->setParamValue('last_modif_date_time',date('Y-m-d H:i:s'));

		parent::update($pm);
	}

	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
</xsl:template>

</xsl:stylesheet>
