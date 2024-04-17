<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'QualityPassport'"/>
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
	
	const COMPLETE_LIMIT = 10;
	
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function get_object_or_last($pm){
		$shipment_id = 0;
		if($pm->getParamValue('shipment_id')){
			$shipment_id = $this->getExtDbVal($pm,"shipment_id");
		}
		$this->addNewModel(
			sprintf("SELECT * FROM quality_passports_object_or_last(%d)", $shipment_id),		
			'QualityPassport_Model'		
		);
	}
	
	//no search
	private static function get_complete_query_for_field($fieldId){
		return sprintf(
			"SELECT
				DISTINCT %s
			FROM quality_passports
			ORDER BY %s
			LIMIT %d",
			$fieldId,
			$fieldId,
			self::COMPLETE_LIMIT
		);		
	}

	//with serach
	private static function get_complete_search_query_for_field($fieldId, $searchValForDb, $rightLeft){
		return sprintf(
			"SELECT
				DISTINCT %s
			FROM quality_passports
			WHERE %s::text ilike ". ($rightLeft? "'%%'||" : "") ."%s||'%%'
			ORDER BY %s
			LIMIT %d",
			$fieldId,
			$fieldId,
			$searchValForDb,
			$fieldId,
			self::COMPLETE_LIMIT
		);								
	}
	
	//*******************
	
	//
	private function complete_for_field($pm, $fieldId, $rightLeft){
		$s = $pm->getParamValue($fieldId);
		if($s &amp;&amp; strlen($s) &amp;&amp; $s != 'null'){
			$q = self::get_complete_search_query_for_field($fieldId, $this->getExtDbVal($pm, $fieldId), $rightLeft);			
		}else{
			$q = self::get_complete_query_for_field($fieldId);			
		}
		$this->addNewModel($q, 'QualityPassport_Model');
	}
	
	public function complete_vid_smesi_gost($pm){
		$this->complete_for_field($pm,'vid_smesi_gost', TRUE);
	}
	
	public function complete_uklad($pm){
		$this->complete_for_field($pm,'uklad', TRUE);
	}

	public function complete_sohran_udobouklad($pm){
		$this->complete_for_field($pm,'sohran_udobouklad', FALSE);
	}

	public function complete_kf_prochnosti($pm){
		$this->complete_for_field($pm,'kf_prochnosti', TRUE);
	}

	public function complete_prochnost($pm){
		$this->complete_for_field($pm,'prochnost', FALSE);
	}

	public function complete_naim_dobavki($pm){
		$this->complete_for_field($pm,'naim_dobavki', TRUE);
	}

	public function complete_aeff($pm){
		$this->complete_for_field($pm,'aeff', TRUE);
	}
	public function complete_reg_nomer_dekl($pm){
		$this->complete_for_field($pm,'reg_nomer_dekl', TRUE);
	}
	
	public function complete_krupnost($pm){
		$this->complete_for_field($pm,'krupnost', FALSE);
	}
	
</xsl:template>

</xsl:stylesheet>
