<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
 xmlns:html="http://www.w3.org/TR/REC-html40"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="html"/> 

<xsl:decimal-format name="num_money" decimal-separator="," grouping-separator=" "/>
<xsl:decimal-format name="num_quant" decimal-separator="," grouping-separator=" "/>

<xsl:key name="concrete_types" match="row" use="concrete_type_id/."/>

<xsl:template name="format_quant">
	<xsl:param name="val"/>
	<xsl:choose>
		<xsl:when test="$val='0' or string(number($val))='NaN'">
			<xsl:text>&#160;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="format-number( round(10000*$val) div 10000 ,'##0,0000','num_quant')"/>
		</xsl:otherwise>		
	</xsl:choose>
</xsl:template>

<!-- Main template-->
<xsl:template match="/">
	<xsl:apply-templates select="document/model[@id='ModelServResponse']"/>	
	<xsl:apply-templates select="document/model[@id='ShipProdQuantDif_Model']"/>
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
<xsl:template match="model[@id='ShipProdQuantDif_Model']">
	<xsl:variable name="model_id" select="@id"/>	
	
	<table class="table table-bordered table-responsive table-striped">
		<thead>
			<th>Марка
			</th>
			<th>Отгружено, м3
			</th>
			<th>По данным производства, м3
			</th>
		</thead>	
		
		<tbody>		
			<xsl:for-each select="//row[generate-id() =
			generate-id(key('concrete_types',concrete_type_id/.)[1])]">
				<xsl:sort select="concrete_type_name/."/>
				<xsl:variable name="concrete_type_id" select="concrete_type_id/."/>
				<xsl:variable name="row_class">
					<xsl:choose>
						<xsl:when test="position() mod 2">odd</xsl:when>
						<xsl:otherwise>even</xsl:otherwise>													
					</xsl:choose>
				</xsl:variable>
				<tr class="{$row_class}">					
					<td><xsl:value-of select="concrete_type_name/."/></td>					

					<td align="right" nowrap="nowrap">
						<xsl:call-template name="format_quant">
							<xsl:with-param name="val" select="quant/."/>
						</xsl:call-template>
					</td>
				
					<xsl:variable name="concrete_quant_class">
						<xsl:choose>
							<xsl:when test="concrete_quant != quant">factQuantViolation</xsl:when>
							<xsl:otherwise></xsl:otherwise>													
						</xsl:choose>
					</xsl:variable>
				
					<td align="right" nowrap="nowrap" class="{$concrete_quant_class}">
						<xsl:call-template name="format_quant">
							<xsl:with-param name="val" select="concrete_quant/."/>
						</xsl:call-template>
					</td>
				
				</tr>
			</xsl:for-each>		
		</tbody>
		
		<tfoot>			
			<tr>
				<td>Итого</td>
				<td align="right" nowrap="nowrap">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(//row/quant/.)"/>
					</xsl:call-template>
				</td>
				<td align="right" nowrap="nowrap">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(//row/concrete_quant/.)"/>
					</xsl:call-template>
				</td>
			</tr>
		</tfoot>
	</table>
</xsl:template>


<!-- header field -->

<!-- table row -->
<xsl:template match="row">
	<tr>
		<xsl:apply-templates/>
	</tr>
</xsl:template>

<!-- table cell -->
<xsl:template match="row/*">
	<td align="center">
		<xsl:value-of select="node()"/>
	</td>
</xsl:template>

<xsl:template match="row/concrete_type_descr">
	<td align="left">
		<xsl:value-of select="node()"/>
	</td>
</xsl:template>

<xsl:template match="row/concrete_type_id">
</xsl:template>

</xsl:stylesheet>
