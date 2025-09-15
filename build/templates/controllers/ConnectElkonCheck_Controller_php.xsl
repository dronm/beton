<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ConnectElkonCheck'"/>
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
	public function connected($pm){

		$base_id = $pm->getParamValue('base_id')? $this->getExtDbVal($pm,'base_id'):0;
		$this->addNewModel(
			sprintf("SELECT DISTINCT ON (el.production_site_id) 
				el.production_site_id,
				elkon_connect_err(el.message, el.date_time) AS pong
			FROM elkon_log AS el
			LEFT JOIN production_sites AS ps ON ps.id = el.production_site_id
			WHERE %d = 0 OR ps.production_base_id = %d
			ORDER BY 
				el.production_site_id, 
				el.date_time DESC"
		,$base_id, $base_id)
		,'ConnectElkon_Model'		
		);
	}
</xsl:template>

</xsl:stylesheet>
