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

require_once(ABSOLUTE_PATH.'functions/ExtProg.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">

	public function check_contract($pm){
		if($pm->getParamValue("client_contract_1c_ref")){
			$ar = $this->getDbLink()->query_first(sprintf(
				"SELECT id FROM client_contracts_1c WHERE ref_1c->>'ref_1c'=%s"
				,$this->getExtDbVal($pm, 'client_contract_1c_ref')
			));
			if(!is_array($ar) || !count($ar) || !isset($ar["id"])){
				$client_id = NULL;
				if($pm->getParamValue("client_id")){
					$client_id = $this->getExtDbVal($pm, 'client_id');
				}else{
					$ar = $this->getDbLink()->query_first(sprintf(
						"SELECT client_id FROM client_specifications WHERE id=%d"
						,$this->getExtDbVal($pm, 'old_id')
					));
					$client_id = $ar["client_id"];
				}

				$resp = ExtProg::getClientContract($this->getExtVal($pm, "client_contract_1c_ref"));
				/* $name = $resp["models"]["Contract1cList_Model"]["rows"][0]["name"]; */
				$name = $resp["models"]["Contract1cList_Model"]["rows"][0]["name"];
				$ar = $this->getDbLinkMaster()->query(sprintf(
					"INSERT INTO client_contracts_1c (ref_1c, client_id)
					VALUES (jsonb_build_object('ref_1c', %s, 'descr', '%s'), %d)
					RETURNING id"
					,$this->getExtDbVal($pm, 'client_contract_1c_ref')
					,$name
					,$client_id
				));
				$client_contract_id = $ar["id"];

			}else {
				$client_contract_id = $ar["id"];
			}

			$pm->setParamValue("client_contract_id", $client_contract_id);
		}
	}

	public function update($pm){
		$this->check_contract($pm);
		parent::update($pm);
	}

	public function insert($pm){
		$this->check_contract($pm);
		parent::insert($pm);
	}

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
