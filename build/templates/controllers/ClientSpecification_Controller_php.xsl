<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ClientSpecification'"/>
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

	public function complete_for_client($pm){
		$client_id = $this->getExtDbVal($pm, 'client_id');
		$concrete_type_id = $this->getExtDbVal($pm, 'concrete_type_id');
		$destination_id = $this->getExtDbVal($pm, 'destination_id');
		$cond = '';
		if($this->getExtVal($pm, 'search')){
			$search = $this->getExtDbVal($pm, 'search');
			$cond = " AND ((contract ilike '%%'||".$search."||'%%') OR (specification ilike '%%'||".$search."||'%%'))";
		}
		
		$this->addNewModel(sprintf(
			"SELECT * FROM client_specifications_list
			WHERE
				client_id = %d
				AND destination_id = %d
				AND concrete_type_id = %d".$cond."
				ORDER BY specification_date DESC"
			,$client_id
			,$destination_id
			,$concrete_type_id
		),'ClientSpecificationList_Model'
		);
	}

</xsl:template>

</xsl:stylesheet>
