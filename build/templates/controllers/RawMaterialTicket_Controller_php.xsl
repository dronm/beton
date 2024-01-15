<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'RawMaterialTicket'"/>
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

	public static function getCarrierAggModel($dbLink){
		$model = new ModelSQL($dbLink,array('id'=>'RawMaterialTicketCarrierAggList_Model'));
		$model->addField(new FieldSQLString($dbLink,null,null,"date",DT_DATE));
		$model->query("SELECT * FROM raw_material_ticket_carrier_agg_list", TRUE);
		return $model;		
	}

	public function get_carrier_agg_list($pm){
		$this->setListModelId('RawMaterialTicketCarrierAggList_Model');
		parent::get_list($pm);
	}

	public function close_ticket($pm){		
		$code = intval($this->getExtDbVal($pm, 'barcode'));
		$ar = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT
				barcode,
				close_date_time
			FROM raw_material_tickets
			WHERE barcode = '%s'"
			,$code
		));
		if(!is_array($ar) || !count($ar) || !isset($ar['barcode'])){
			throw new Exception('Талон не найден!@1000');
		}
		
		if(isset($ar['close_date_time'])){
			throw new Exception('Талон уже погашен!@1001');
		}

		$this->getDbLinkMaster()->query(sprintf(
			"UPDATE raw_material_tickets
			SET
				close_date_time = now()
				,close_user_id = %d				
			WHERE barcode = '%s'"
			,$_SESSION['user_id']
			,$code
		));
	}

	public function generate($pm){		
		try{
			$this->getDbLinkMaster()->query(sprintf(
				"INSERT INTO raw_material_tickets
				(carrier_id, raw_material_id, barcode, quant, expire_date, issue_date_time, issue_user_id)
				SELECT
					%d,
					%d,
					code,
					%d,
					%s,
					now(),
					%d
				FROM generate_series(%d, %d) AS code"
				,$this->getExtDbVal($pm, 'carrier_id')
				,$this->getExtDbVal($pm, 'raw_material_id')
				,$this->getExtDbVal($pm, 'quant')
				,$this->getExtDbVal($pm, 'expire_date')
				,$_SESSION['user_id']
				,$this->getExtDbVal($pm, 'barcode_from')
				,$this->getExtDbVal($pm, 'barcode_to')				
			));
		}catch(Exception $e){
			if(strpos($e->getMessage(), "SQL: 23505")!==FALSE){
				throw new Exception('Есть пересекающиеся номера!');
			}else{
				throw $e;
			}
		}
	}

</xsl:template>

</xsl:stylesheet>
