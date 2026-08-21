<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ShipmentWeight'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(USER_MODELS_PATH.'ShipmentWeightSelfShipList_Model.php');
require_once(USER_MODELS_PATH.'ShipmentWeightRedirectionList_Model.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function get_self_ship_list($pm){
		$this->setListModelId("ShipmentWeightSelfShipList_Model");
		$model = new ShipmentWeightSelfShipList_Model($this->getDbLink());
		$this->modelGetList($model, $pm);
	}

	public function get_redirection_list($pm){
		$this->setListModelId("ShipmentWeightRedirectionList_Model");
		$model = new ShipmentWeightRedirectionList_Model($this->getDbLink());
		$this->modelGetList($model, $pm);
	}

</xsl:template>

</xsl:stylesheet>
