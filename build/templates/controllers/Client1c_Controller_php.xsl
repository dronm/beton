<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Client1c'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(ABSOLUTE_PATH.'functions/exch1c.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function complete($pm){		
		$search = $this->getExtVal($pm, "search");
		$clients = Exch1c::catalogByAttr('clients', $search);
		$model = new Model(array("id"=>"Client1cList_Model"));
		foreach($clients as $client){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $client["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $client["name"])));
			array_push($fields, new Field('inn',DT_STRING,array('value'=>(string) $client["inn"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
		<!-- //return as is -->
		<!-- ob_clean(); -->
		<!-- header('Content-Type: application/json; charset=utf-8'); -->
		<!-- echo json_encode($resp, JSON_UNESCAPED_UNICODE); -->
		<!-- return true; -->
	}

	public function get_leasor_on_pp($pm){
		throw new Exception("Not implemented");
		<!-- $resp = ExtProg::getClientOnPP($this->getExtVal($pm, "pp_num")); -->
		<!-- file_put_contents('output/qres.txt', $resp); -->
		<!-- ob_clean(); -->
		<!-- header('Content-Type: application/json; charset=utf-8'); -->
		<!-- echo json_encode($resp, JSON_UNESCAPED_UNICODE); -->
		<!-- return true; -->
	}
</xsl:template>

</xsl:stylesheet>
