<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'ClientDebt'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(FUNC_PATH.'ExtProg.php');
require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	
	public function update_from_1c($pm){		
		$debt_list = ExtProg::getClientDebtList();
		if(!isset($debt_list['models']['ClientDebt1cList_Model'])){
			throw new Exception('model ClientDebt1cList_Model not found');
		}
		if(!isset($debt_list['models']['ClientDebt1cList_Model']['rows'])){
			throw new Exception('rows of model ClientDebt1cList_Model not found');
		}
		$rows = $debt_list['models']['ClientDebt1cList_Model']['rows'];
		$link = $this->getDbLinkMaster();		
		$par = new ParamsSQL(NULL, $link);
		
		$cur_time_s = date('Y-m-d H:i:s',time());
		
		$firm_ids = array();
		$q = '';
		for($i = 0; $i &lt; count($rows); $i++){	
			$rec = $rows[$i];
			$par->add('client_ref', DT_STRING, $rec['client_ref']);
			
			$debt_total = floatval($rec['debt_total']);
			//client
			$client_ar = $link->query_first(sprintf(
				"SELECT t.id
				FROM clients t WHERE t.ref_1c->'keys'->>'ref_1c' = %s",
				$par->getDbVal('client_ref'))
			);

			if (!is_array($client_ar) || !count($client_ar)){
				continue; //does not exist
			}
			//фирма
			if (!array_key_exists($rec['firm_ref'], $firm_ids)){
				$par->add('firm_ref', DT_STRING, $rec['firm_ref']);
				
				$ar = $link->query_first(sprintf(
						"SELECT t.id FROM firms_1c AS t WHERE t.ref_1c->'keys'->>'ref_1c' = %s",
						$par->getDbVal('firm_ref')					
					)
				);
				if (!is_array($ar) || !count($ar) || !isset($ar['id'])){					
					//нет такой фирмы - добавим
					$par->add('firm', DT_STRING, $rec['firm']);
					$par->add('firm_inn', DT_STRING, $rec['firm_inn']);
					$firm_ar = $link->query_first(sprintf(
						"INSERT INTO firms_1c (ref_1c, inn)
						VALUES (jsonb_build_object('ref_1c', %s, 'descr', %s), %s)
						RETURNING id"
						,$par->getDbVal('firm_ref')
						,$par->getDbVal('firm')
						,$par->getDbVal('firm_inn')
					));
					$firm_ids[$rec['firm_ref']] = $firm_ar['id']; //add id for farther ref
				}				
			}
			$q = sprintf(
				"INSERT INTO client_debts (firm_id, client_id, debt_total, update_date)
				VALUES(%d, %d, %s, now())
				ON CONFLICT (firm_id, client_id) DO UPDATE
				SET
					debt_total = %s,
					update_date = now()"
				,$firm_ids[$rec['firm_ref']]
				,$client_ar['id']
				,$debt_total
				,$debt_total
			);
			$link->query($q);
			//throw new Exception($q);
		}
		$link->query(sprintf("DELETE FROM client_debts WHERE update_date &lt; '%s'", $cur_time_s));
	}
	
</xsl:template>

</xsl:stylesheet>
