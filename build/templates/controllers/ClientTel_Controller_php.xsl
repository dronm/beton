<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ClientTel'"/>
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

	public function get_ref($pm){
		$this->addNewModel(sprintf(
			"SELECT client_tels_ref_on_tel(%s) AS ref"
			,$this->getExtDbVal($pm, 'tel')
		), 'Ref_Model');		
	}

	public function upsert($pm){
		$this->addNewModel(sprintf(
			"SELECT client_tels_upsert(%d, %s, %s) AS ref"
			,$this->getExtDbVal($pm, 'client_id')
			,$this->getExtDbVal($pm, 'name')
			,$this->getExtDbVal($pm, 'tel')
		), 'Ref_Model');
	}

	public function complete_tel($pm){
		$cond = '';
		$tm_exists = $this->getExtVal($pm, 'tm_exists');		
		if($tm_exists){
			$cond = ' AND tl.tm_exists';
		}
		$this->addNewModel(sprintf(
			"SELECT
				tl.*
			FROM client_tels_list AS tl
			WHERE lower(tl.search) LIKE '%%'||lower(%s)||'%%'%s
			ORDER BY search
			LIMIT 10"
			,$this->getExtDbVal($pm, 'search')
			,$cond
		), 'ClientTelList_Model');		
	}

</xsl:template>

</xsl:stylesheet>
