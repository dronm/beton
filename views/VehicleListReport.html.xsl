<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
 xmlns:html="http://www.w3.org/TR/REC-html40"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="html"/> 
<!-- Main template-->
<xsl:template match="/">
	<xsl:apply-templates select="document/model[@id='ModelServResponse']"/>	
	<xsl:apply-templates select="document/model[@id='ModelVars']"/>	
	<xsl:apply-templates select="document/model[@id='VehicleListReport_Model']"/>		
</xsl:template>

<!-- Error -->
<xsl:template match="model[@id='ModelServResponse']">
	<xsl:if test="not(row[1]/result='0')">
	<div class="error">
		<xsl:value-of select="row[1]/descr"/>
	</div>
	</xsl:if>
</xsl:template>

<!-- table -->
<xsl:template match="model[@id='VehicleListReport_Model']">
	<xsl:variable name="model_id" select="@id"/>	
	<table id="{$model_id}" class="table table-bordered table-responsive table-striped">
		<thead>
			<tr>
				<th rowspan="2">Марка</th>
				<th rowspan="2">VIN</th>
				<th rowspan="2">Гос.номер</th>
				<th rowspan="2">Владелец</th>
				<th rowspan="2">Водитель</th>
				<th colspan="3">Лизинг</th>
				<th colspan="3">ОСАГО</th>
				<th colspan="3">КАСКО</th>
			</tr>
			<tr>
				<th>Лизингодатель</th>
				<th>Реквизиты договора</th>
				<th>Сумма по договору, руб.</th>
				<th>Страховщик</th>
				<th>Сумма, руб.</th>
				<th>Период страхования</th>
				<th>Страховщик</th>
				<th>Сумма, руб.</th>
				<th>Период страхования</th>
			</tr>
		</thead>
		<tbody>
			<xsl:apply-templates />
		</tbody>
	</table>
</xsl:template>

<!-- table header -->
<xsl:template match="model[@id='ModelVars']/row">
	<div class="rep_head">
		<div>Период с:<xsl:value-of select="date_from"/> по <xsl:value-of select="date_to"/></div>
	</div>
</xsl:template>

<!-- header field -->

<!-- table row -->
<xsl:template match="row">
	<tr>
		<xsl:apply-templates/>
	</tr>
</xsl:template>

<xsl:template match="row/plate">
	<td align="center">
		<xsl:value-of select="node()"/>
	</td>
</xsl:template>

<xsl:template match="row/leasing_total">
	<td align="right">
		<xsl:value-of select="node()"/>
	</td>
</xsl:template>

<xsl:template match="row/ins_osago_total">
	<td align="right">
		<xsl:value-of select="node()"/>
	</td>
</xsl:template>

<xsl:template match="row/ins_kasko_total">
	<td align="right">
		<xsl:value-of select="node()"/>
	</td>
</xsl:template>

<!-- table cell -->
<xsl:template match="row/*">
	<td align="left">
		<xsl:value-of select="node()"/>
	</td>
</xsl:template>

</xsl:stylesheet>

