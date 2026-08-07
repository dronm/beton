<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 xmlns:html="http://www.w3.org/TR/REC-html40"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:fo="http://www.w3.org/1999/XSL/Format">
 
<xsl:import href="ModelsToHTML.html.xsl"/>
<xsl:import href="functions.xsl"/>

<xsl:template match="/">
	<xsl:apply-templates select="document/model[@id='ModelServResponse']"/>
	<xsl:apply-templates select="document/model[@id='Head_Model']"/>
	<xsl:apply-templates select="document/model[@id='VehicleFuelReport_Model']"/>
</xsl:template>

<!-- Head -->
<xsl:template match="model[@id='Head_Model']">
	<h3>Отчет по движению топлива за период <xsl:value-of select="row/period_descr"/></h3>
	
</xsl:template>

<xsl:template match="model[@id='VehicleFuelReport_Model']">
	<xsl:variable name="model_id" select="@id"/>
	
	<table id="{$model_id}" class="table table-bordered table-responsive table-striped" style="width:60%;">
		<thead>
			<tr align="center">
				<td>ТС</td>
				<td>Начальный остаток</td>
				<td>Приход</td>
				<td>Расход</td>
				<td>Конечный остаток</td>
			</tr>
		</thead>
	
		<tbody>
			<xsl:apply-templates/>
		</tbody>
		
	</table>
</xsl:template>

<xsl:template match="model[@id='VehicleFuelReport_Model']/row">
	<tr>

		<td><xsl:value-of select="vehicle_plate"/></td>		

		<td align="right"><xsl:value-of select="quant_beg"/></td>		
		<td align="right"><xsl:value-of select="quant_deb"/></td>		
		<td align="right"><xsl:value-of select="quant_kred"/></td>		
		<td align="right"><xsl:value-of select="quant_end"/></td>		
		
	</tr>
</xsl:template>

</xsl:stylesheet>

