<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Model_php.xsl"/>

<!-- -->
<xsl:variable name="MODEL_ID" select="'OrderList'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
<xsl:template match="/">
	<xsl:apply-templates select="metadata/models/model[@id=$MODEL_ID]"/>
</xsl:template>
	
<xsl:template name="user_functions">
	public function selectQuery($query,$calcTotalCount,$modelWhere,$modelJoinCount,$toXML){
		if(isset($modelWhere)){
			$from_date = NULL;
			$to_date = NULL;
			$from = $modelWhere->getFieldsById('date_time','&gt;=');
			if(isset($from) &amp;&amp; is_array($from) &amp;&amp; count($from)){
				$from_date = $from[0]->getValue();
			}
			
			$to = $modelWhere->getFieldsById('date_time','&lt;=');
			if(isset($to) &amp;&amp; is_array($to) &amp;&amp; count($to)){
				$to_date = $to[0]->getValue();
			}
			if($from_date &amp;&amp; $to_date &amp;&amp; !Beton::viewRestricted($from_date, $to_date)){
				throw new Exception('Запрещено просматривать период!');
			}
			
		}
		if ($calcTotalCount){
			$this->updateTotalCount($modelWhere,$modelJoinCount);
		}
		$this->query($query,$toXML);
	}

</xsl:template>
		
</xsl:stylesheet>
