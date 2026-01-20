<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ClientContract1c'"/>
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
	public function get_dog_all($pm){		
		$link = $this->getDbLinkMaster();		
		$clientId = $this->getExtVal($pm, "client_id");

		$clAr = $link->query_first(
			sprintf("SELECT ref_1c->'keys'->>'ref_1c' AS ref FROM clients WHERE id = %d", $clientId)
		);
		if(!is_array($clAr) || !count($clAr) || !isset($clAr["ref"])){
			throw new Exception("Client not found");
		}
		$clientRef = $clAr["ref"];

		$dogovors = Exch1c::clientDogovorList($clientRef);

		$queries = array();

		foreach($dogovors as $dog){
			//contract
			$contractAr = $link->query_first(sprintf(
					"SELECT t.id FROM client_contracts_1c AS t WHERE t.ref_1c->>'ref_1c' = '%s'",
					$dog["ref"]
				)
			);
			$contractId = NULL;
			if (!is_array($contractAr) || !count($contractAr) || !isset($contractAr['id'])){
				//add new contract

				$ar = $link->query_first(sprintf(
					"INSERT INTO client_contracts_1c (ref_1c, client_id)
					VALUES (
						jsonb_build_object(
							'ref_1c', '%s',
							'descr', '%s'
						), %d
					)
					RETURNING id"
					,$dog["ref"]
					,$dog["name"]
					,$clientId
				));
				$contractId = $ar["id"];
			}else {
				$contractId = $contractAr["id"];
			}				

			$q = sprintf(
				"INSERT INTO client_specifications (client_id, client_contract_id, client_contract_1c_ref)
				VALUES(%d, %d, '%s')
				ON CONFLICT (client_id, client_contract_id) DO NOTHING"
				,$clientId
				,$contractId
				,$dog["ref"]
			);

			array_push($queries, $q);
		}

		$link->query("BEGIN");
		try{
			foreach($queries as $q){
				$link->query($q);
			}
			$link->query("COMMIT");

		}catch(Exception $e){
			$link->query("ROLLBACK");
			throw $e;
		}
	}

	public function complete_from_1c($pm){		
		$search = $this->getExtVal($pm, "search");
		$clientRef = $this->getExtVal($pm, "client_ref_1c");
		$dogovors = Exch1c::completeClientDogovor($clientRef, $search);
		$model = new Model(array("id"=>"ClientContract1cList_Model"));
		foreach($dogovors as $dog){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $dog["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $dog["name"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
		<!-- ob_clean(); -->
		<!-- header('Content-Type: application/json; charset=utf-8'); -->
		<!-- echo json_encode($resp, JSON_UNESCAPED_UNICODE); -->
		<!-- return true; -->
	}
</xsl:template>

</xsl:stylesheet>
