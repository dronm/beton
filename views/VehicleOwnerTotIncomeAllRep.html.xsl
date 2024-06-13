<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
 xmlns:html="http://www.w3.org/TR/REC-html40"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="html"/> 

<xsl:key name="mon" match="row" use="mon/."/>
<xsl:key name="it_com_name_out" match="row" use="it_com_name_out/."/>
	<xsl:key name="it_com_name_in" match="row" use="it_com_name_in/."/>
<!-- <xsl:key name="it_com_name_in" match="row" use="it_com_name_in/."/> -->

<xsl:template name="format_money">
	<xsl:param name="val"/>
	<xsl:choose>
		<xsl:when test="$val='0'">
			<xsl:text>&#160;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="format-number($val,'###,##0.00')"/>
		</xsl:otherwise>		
	</xsl:choose>
</xsl:template>


<!-- Main template-->
<xsl:template match="/">
	<xsl:choose>
		<xsl:when test="not(document/model[@id='ModelServResponse']/row[1]/result='0')">
		<xsl:apply-templates select="document/model[@id='ModelServResponse']"/>	
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="document/model[@id='VehicleOwnerList_Model']"/>	
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Error -->
<xsl:template match="model[@id='ModelServResponse']">
	<div class="error">
		<xsl:value-of select="row[1]/descr"/>
	</div>
</xsl:template>

<!-- table -->
<xsl:template match="model[@id='VehicleOwnerList_Model']">
	<xsl:variable name="model_id" select="@id"/>	
	<table id="{@model_id}" class="table table-bordered table-responsive table-striped">
		<thead>
			<tr>

				<th>Владельцы</th>
				<th>Обмем, м3</th>
				<th>Остаток, руб</th>
				<xsl:for-each select="//row[generate-id() =
				generate-id(key('mon', mon/.)[1])]">
					<xsl:sort select="mon/."/>
					<th align="center">
						<span class="mon_descr" style="margin-right:3px;"><xsl:value-of select="mon/."/></span>
					</th>
				</xsl:for-each>
				<xsl:for-each select="//row[generate-id() =
				generate-id(key('it_com_name_in', it_com_name_in/.)[1])]">
					<xsl:sort select="it_com_name_in/."/>
					<th align="center">
						<span class="it_com_name_in" style="margin-right:3px;"><xsl:value-of select="it_com_name_in/."/></span>
					</th>
				</xsl:for-each>
				<xsl:for-each select="//row[generate-id() =
				generate-id(key('it_com_name_out', it_com_name_out/.)[1])]">
					<xsl:sort select="it_com_name_out/."/>
					<th align="center">
						<span class="it_com_name_out" style="margin-right:3px;"><xsl:value-of select="it_com_name_out/."/></span>
					</th>
				</xsl:for-each>
				<th>Остаток, руб</th>
			</tr>
		</thead>
	
		<tbody>
			<!-- <xsl:apply-templates/> -->
		</tbody>
	</table>
</xsl:template>

<!-- table header -->

<!-- header field -->

<!-- table row -->
<xsl:template match="row">

	<!-- <xsl:variable name="ship_tot" select="number(ship_cost) + number(pumps_cost) +  number(ship_demurrage_cost)"/> -->
	<!-- <xsl:variable name="client_ship_tot" select="number(client_ships_concrete_cost) + number(client_ships_shipment_cost)  + number(client_ships_other_owner_pump_cost)  + number(demurrage_cost)"/> -->
	<!-- <xsl:variable name="tot" select="$ship_tot - $client_ship_tot"/> -->
	<!-- <xsl:variable name="tot_class"> -->
	<!-- 	<xsl:choose> -->
	<!-- 		<xsl:when test="$tot &gt;0">success</xsl:when> -->
	<!-- 		<xsl:otherwise>danger</xsl:otherwise> -->
	<!-- 	</xsl:choose> -->
	<!-- </xsl:variable> -->
	<!--  -->
	<!-- <tr> -->
	<!-- 	<td align="right"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="ship_cost"/> -->
	<!-- 		</xsl:call-template>								 -->
	<!-- 	</td> -->
	<!-- 	<td align="right"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="pumps_cost"/> -->
	<!-- 		</xsl:call-template>											 -->
	<!-- 	</td> -->
	<!-- 	<td align="right"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="ship_demurrage_cost"/> -->
	<!-- 		</xsl:call-template>											 -->
	<!-- 	</td> -->
	<!-- 	 -->
	<!-- 	<td align="right" class="bg-info"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="$ship_tot"/> -->
	<!-- 		</xsl:call-template>								 -->
	<!-- 	</td> -->
	<!-- 	<td align="right"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="client_ships_concrete_cost"/> -->
	<!-- 		</xsl:call-template>								 -->
	<!-- 	</td> -->
	<!-- 	<td align="right"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="client_ships_shipment_cost"/> -->
	<!-- 		</xsl:call-template>								 -->
	<!-- 	</td> -->
	<!-- 	<td align="right"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="client_ships_other_owner_pump_cost"/> -->
	<!-- 		</xsl:call-template>								 -->
	<!-- 	</td> -->
	<!-- 	<td align="right"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="demurrage_cost"/> -->
	<!-- 		</xsl:call-template>								 -->
	<!-- 	</td> -->
	<!-- 	 -->
	<!-- 	<td align="right" class="bg-info"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="$client_ship_tot"/> -->
	<!-- 		</xsl:call-template>								 -->
	<!-- 	</td> -->
	<!-- 	<td align="right" class="bg-{$tot_class}"> -->
	<!-- 		<xsl:call-template name="format_money"> -->
	<!-- 			<xsl:with-param name="val" select="$tot"/> -->
	<!-- 		</xsl:call-template>								 -->
	<!-- 	</td> -->
	<!-- 	 -->
	<!-- </tr> -->
</xsl:template>

</xsl:stylesheet>
