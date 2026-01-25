<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ProductionReport'"/>
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
	public static function generateDocs($dbLink, $shiftFrom, $shiftTo){
		$dbLink->query(
			"SELECT production_reports_gen($1, $2)", 
			[$shiftFrom, $shiftTo]
		);
	}

	public function generate_docs($pm){
		$shift_from = $this->getExtDbVal($pm, 'shift_from');
		$shift_to = $this->getExtDbVal($pm, 'shift_to');
		$link = $this->getDbLinkMaster();
		self::generateDocs($link, $shift_from, $shift_to);
	}
</xsl:template>

</xsl:stylesheet>
