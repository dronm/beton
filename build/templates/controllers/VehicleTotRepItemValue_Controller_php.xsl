<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'VehicleTotRepItemValue'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLDate.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">

	/**
	 * updates multiple values
	 */
	public function update_values($pm){
		$values = json_decode($this->getExtVal($pm, 'values'), TRUE);
		$common_values = json_decode($this->getExtVal($pm, 'common_values'), TRUE);
		
		$dbLink = $this->getDbLinkMaster();
		
		$dbLink->query("BEGIN");
		try{
			if(isset($values) &amp;&amp; is_array($values) &amp;&amp; count($values)){
				foreach($values as $v){
					$vehicle_id = intval($v['vehicle_id']);
					$item_id = intval($v['item_id']);
					$val = floatval($v['val']);
					$period = NULL;
					FieldSQLDate::formatForDb(strtotime($v['period']), $period);
					
					if($val == 0){
						$dbLink->query(sprintf(
							"DELETE FROM vehicle_tot_rep_item_vals WHERE vehicle_id = %d AND vehicle_tot_rep_item_id = %d AND period = %s"
							,$vehicle_id
							,$item_id
							,$period
						));
					}else{
						$dbLink->query(sprintf(
							"INSERT INTO vehicle_tot_rep_item_vals
							(vehicle_id, vehicle_tot_rep_item_id, period, value)
							VALUES (%d, %d, %s, %f)
							ON CONFLICT (vehicle_id, vehicle_tot_rep_item_id, period) DO UPDATE SET
								value = %f"
							,$vehicle_id
							,$item_id
							,$period
							,$val
							,$val
						));
					}				
				}
			}
			
			//common item values
			if(isset($common_values) &amp;&amp; is_array($common_values) &amp;&amp; count($common_values)){
				$vehicle_owner_id = $this->getExtDbVal($pm, 'balance_vehicle_owner_id');
				foreach($common_values as $v){					
					$item_id = intval($v['item_id']);
					$val = floatval($v['val']);
					$period = NULL;
					FieldSQLDate::formatForDb(strtotime($v['period']), $period);
					
					if($val == 0){
						$dbLink->query(sprintf(
							"DELETE FROM vehicle_tot_rep_common_item_vals WHERE vehicle_owner_id = %d AND vehicle_tot_rep_common_item_id = %d AND period = %s"
							,$vehicle_owner_id
							,$item_id
							,$period
						));
					}else{
						$dbLink->query(sprintf(
							"INSERT INTO vehicle_tot_rep_common_item_vals
							(vehicle_owner_id, vehicle_tot_rep_common_item_id, period, value)
							VALUES (%d, %d, %s, %f)
							ON CONFLICT (vehicle_owner_id, vehicle_tot_rep_common_item_id, period) DO UPDATE SET
								value = %f"
							,$vehicle_owner_id
							,$item_id
							,$period
							,$val
							,$val
						));
					}
					
				}
			}
			
			$balance_values = json_decode($this->getExtVal($pm, 'balance_values'), TRUE);
			if(isset($balance_values) &amp;&amp; is_array($balance_values) &amp;&amp; count($balance_values)){
				foreach($balance_values as $p=>$v){
					$period = NULL;
					FieldSQLDate::formatForDb(strtotime($p), $period);
					$v_f = floatval($v);
					$dbLink->query(sprintf(
						"INSERT INTO vehicle_tot_rep_balances (vehicle_owner_id, period, value)
						VALUES (%d, %s, %f)
						ON CONFLICT (vehicle_owner_id, period) DO UPDATE
						SET value = %f"
						,$this->getExtDbVal($pm, 'balance_vehicle_owner_id')
						,$period
						,$v_f
						,$v_f
					));
					
				}
			}
			
			$dbLink->query("COMMIT");
			
		}catch (Exception $e){
			$dbLink->query("ROLLBACK");
			throw $e;
		}
	}
	
</xsl:template>

</xsl:stylesheet>
