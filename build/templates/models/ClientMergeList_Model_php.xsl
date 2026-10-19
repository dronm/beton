<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Model_php.xsl"/>
<xsl:variable name="MODEL_ID" select="'ClientMergeList'"/>
<xsl:output method="text" encoding="UTF-8"/>
<xsl:template match="/">
	<xsl:apply-templates select="metadata/models/model[@id=$MODEL_ID]"/>
</xsl:template>
</xsl:stylesheet>
