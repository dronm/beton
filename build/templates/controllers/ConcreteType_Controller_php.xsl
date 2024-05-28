<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ConcreteType'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);<xsl:apply-templates/>
	}
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function get_list_for_lab($pm){
		$this->addNewModel('SELECT * FROM concrete_types_for_lab_list',
		'ConcreteType_Model');	
	}

	public function get_for_site_list($pm){
		$this->addNewModel('SELECT * FROM concrete_types_for_site_list',
		'ConcreteTypeForSiteList_Model');	
	}
	
	public function get_for_client_list($pm){
		$this->addNewModel(sprintf(
		"SELECT * FROM concrete_types_list
		WHERE id IN (SELECT DISTINCT o.concrete_type_id FROM orders o WHERE o.client_id=%d %s)
		ORDER BY name"
		,$_SESSION['global_client_id']
		,is_null($_SESSION['global_client_from_date'])? '':sprintf(" AND o.date_time&gt;='%s'",date('Y-m-d',$_SESSION['global_client_from_date']))
		),
		'ConcreteTypeList_Model');	
	}
	
</xsl:template>

</xsl:stylesheet>
