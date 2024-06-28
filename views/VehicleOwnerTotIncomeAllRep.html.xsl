<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
 xmlns:html="http://www.w3.org/TR/REC-html40"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="html"/> 

<xsl:key name="mon" match="row" use="mon/."/>
<xsl:key name="it_name_out" match="row" use="it_name_out/."/>
<xsl:key name="it_name_in" match="row" use="it_name_in/."/>
<xsl:key name="owners" match="row" use="vehicle_owner_name/."/>
<xsl:key name="per_in" match="row" use="concat(mon/., '|', it_name_in/.)"/>
<xsl:key name="per_out" match="row" use="concat(mon/., '|', it_name_out/.)"/>
<xsl:key name="owner_per_in" match="row" use="concat(vehicle_owner_name/., '|', mon/., '|', it_name_in/.)"/>
<xsl:key name="owner_per_out" match="row" use="concat(vehicle_owner_name/., '|', mon/., '|', it_name_out/.)"/>
<xsl:key name="owner_per" match="row" use="concat(vehicle_owner_name/., '|', mon/.)"/>
<!-- <xsl:key name="it_name_in" match="row" use="it_name_in/."/> -->

<xsl:decimal-format name="num_money" decimal-separator="," grouping-separator=" "/>
<xsl:decimal-format name="num_quant" decimal-separator="," grouping-separator=" "/>

<xsl:template name="format_money">
	<xsl:param name="val"/>
	<xsl:choose>
		<xsl:when test="$val='0' or $val='0.00'">
			<xsl:text>&#160;</xsl:text>
		</xsl:when>
		<xsl:when test="string(number($val))='NaN'">
			<xsl:text>&#160;</xsl:text>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="format-number($val,'###,##0.00')"/>
		</xsl:otherwise>		
	</xsl:choose>
</xsl:template>

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
	<xsl:variable name="tot_it_in" select="number(/document/model[@id='Head_Model']/row/tot_it_in)"/>	
	<xsl:variable name="tot_it_out" select="number(/document/model[@id='Head_Model']/row/tot_it_out)"/>	
	<!-- one is for total out sum -->
	<xsl:variable name="tot_it" select="$tot_it_in + $tot_it_out + 1"/>	
	<table id="{$model_id}" class="table table-bordered table-responsive table-striped">
		<thead>
			<tr>
				<th rowspan="2">Владельцы</th>
				<th rowspan="2">Объём, м3</th>
				<th rowspan="2">Остаток, руб</th>
				<xsl:for-each select="//row[generate-id() =
				generate-id(key('mon', mon/.)[1])]">
					<xsl:sort select="mon/."/>
					<th colspan="{$tot_it}" align="center">
						<xsl:value-of select="mon_descr/."/>
					</th>
				</xsl:for-each>
				<th rowspan="2" class="item_in">Доходы, руб</th>
				<th rowspan="2" class="item_out">Расходы, руб</th>
				<th rowspan="2">Остаток, руб</th>
			</tr>
			<tr>
				<xsl:for-each select="//row[generate-id() =
				generate-id(key('mon', mon/.)[1])]">

					<!-- header in -->
					<xsl:for-each select="//row[generate-id() =
					generate-id(key('it_name_in', it_name_in/.)[1])]">
						<xsl:sort select="it_name_in/."/>

						<xsl:if test="string-length(it_name_in/.) &gt; 0">
							<th align="center" class="item_in">
								<xsl:value-of select="it_name_in/."/>
							</th>
						</xsl:if>
					</xsl:for-each>

					<!-- header out -->
					<xsl:for-each select="//row[generate-id() =
					generate-id(key('it_name_out', it_name_out/.)[1])]">
						<xsl:sort select="it_name_out/."/>

						<xsl:if test="string-length(it_name_out/.) &gt; 0">
							<th align="center" class="item_out">
								<xsl:value-of select="it_name_out/."/>
							</th>
						</xsl:if>
					</xsl:for-each>

					<th align="center" class="total_out">Расход за месяц, руб</th>

				</xsl:for-each>
			</tr>
		</thead>
	
		<tbody>
			<xsl:for-each select="//row[generate-id() =
			generate-id(key('owners', vehicle_owner_name/.)[1])]">
				<xsl:sort select="vehicle_owner_name/."/>
				<xsl:variable name="owner" select="vehicle_owner_name/."/>
				<xsl:variable name="balance_start" select="number(balance_start/.)"/>

				<xsl:variable name="row_class">
					<xsl:choose>
						<xsl:when test="position() mod 2">odd</xsl:when>
						<xsl:otherwise>even</xsl:otherwise>													
					</xsl:choose>
				</xsl:variable>

				<tr>
					<th>
						<xsl:value-of select="$owner"/>
					</th>

					<td align="right">
						<xsl:call-template name="format_quant">
							<xsl:with-param name="val" select="quant"/>
						</xsl:call-template>
					</td>

					<td align="right">
						<xsl:call-template name="format_money">
							<xsl:with-param name="val" select="$balance_start"/>
						</xsl:call-template>
					</td>

					<!-- iterate periods -->
					<xsl:for-each select="//row[generate-id() =
					generate-id(key('mon', mon/.)[1])]">
						<xsl:sort select="mon/."/>
						<xsl:variable name="mon" select="mon/."/>

						<!-- all in items -->
						<xsl:for-each select="//row[generate-id() =
						generate-id(key('it_name_in', it_name_in/.)[1])]">
							<xsl:if test="string-length(it_name_in/.) &gt; 0">
								<xsl:variable name="it_row" select="key('owner_per_in', concat($owner, '|', $mon, '|', it_name_in/.))"/>
								<td align="right" class="item_in" >
									<xsl:call-template name="format_money">
										<xsl:with-param name="val" select="$it_row/it_val/."/>
									</xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>

						<!-- all out items -->
						<xsl:for-each select="//row[generate-id() =
						generate-id(key('it_name_out', it_name_out/.)[1])]">
							<xsl:if test="string-length(it_name_out/.) &gt; 0">
								<xsl:variable name="it_row" select="key('owner_per_out', concat($owner, '|', $mon, '|', it_name_out/.))"/>
								<td align="right" class="item_out">
									<xsl:call-template name="format_money">
										<xsl:with-param name="val" select="$it_row/it_val/."/>
									</xsl:call-template>
								</td>
							</xsl:if>
						</xsl:for-each>

						<!-- total period out -->
						<xsl:variable name="tot_row" select="key('owner_per', concat($owner, '|', $mon/.))"/>
						<td align="right" class="total_out">
							<xsl:call-template name="format_money">
									<xsl:with-param name="val" select="sum($tot_row[not(it_is_income='true')]/it_val/.)"/>
							</xsl:call-template>
						</td>
					</xsl:for-each>

					<!-- total in -->
					<xsl:variable name="tot_row" select="key('owners', $owner)"/>
					<td align="right" class="item_in">
						<xsl:call-template name="format_money">
							<xsl:with-param name="val" select="sum($tot_row[it_is_income='true']/it_val/.)"/>
						</xsl:call-template>
					</td>

					<!-- total out -->
					<td align="right" class="item_out">
						<xsl:call-template name="format_money">
							<xsl:with-param name="val" select="sum($tot_row[not(it_is_income='true')]/it_val/.)"/>
						</xsl:call-template>
					</td>

					<!-- balance end -->
					<td align="right">
						<xsl:call-template name="format_money">
							<xsl:with-param name="val" select="$balance_start + sum($tot_row[it_is_income='true']/it_val/.) + sum($tot_row[not(it_is_income='true')]/it_val/.)"/>
						</xsl:call-template>
					</td>
				</tr>

			</xsl:for-each>
		</tbody>

		<tfoot>
			<tr>
				<td>Всего</td>

					<!-- total quant -->
					<td align="right">
						<xsl:call-template name="format_quant">
							<xsl:with-param name="val" select="0"/>
						</xsl:call-template>
					</td>

					<!-- balance_start -->
					<td align="right">
						<xsl:call-template name="format_money">
							<xsl:with-param name="val" select="0"/>
						</xsl:call-template>
					</td>

				<!-- <td colspan="7"></td> -->
				<xsl:for-each select="//row[generate-id() =
				generate-id(key('mon', mon/.)[1])]">
					<xsl:sort select="mon/."/>

					<xsl:variable name="mon" select="mon/."/>

					<!-- income -->
					<xsl:for-each select="//row[generate-id() =
					generate-id(key('it_name_in', it_name_in/.)[1])]">
						<xsl:sort select="it_name_in/."/>

						<xsl:if test="string-length(it_name_in/.) &gt; 0">
							<xsl:variable name="per_it" select="key('per_in',concat($mon,'|',it_name_in/.))"/>
							<td align="right" class="item_in">
								<xsl:call-template name="format_money">
									<xsl:with-param name="val" select="0"/>
								</xsl:call-template>
							</td>
						</xsl:if>
					</xsl:for-each>

					<!-- outcome -->
					<xsl:for-each select="//row[generate-id() =
					generate-id(key('it_name_out', it_name_out/.)[1])]">
						<xsl:sort select="it_name_out/."/>

						<xsl:if test="string-length(it_name_out/.) &gt; 0">
							<xsl:variable name="per_it" select="key('per_out',concat($mon,'|',it_name_out/.))"/>
							<td align="right" class="item_out">
								<xsl:call-template name="format_money">
									<xsl:with-param name="val" select="0"/>
								</xsl:call-template>
							</td>
						</xsl:if>
					</xsl:for-each>

					<!-- total period out -->
					<td align="right" class="total_out">
						<xsl:call-template name="format_money">
							<xsl:with-param name="val" select="0"/>
						</xsl:call-template>
					</td>
				</xsl:for-each>

				<!-- income -->
				<td align="right">
					<xsl:call-template name="format_money">
						<xsl:with-param name="val" select="0"/>
					</xsl:call-template>
				</td>

				<!-- outcome -->
				<td align="right">
					<xsl:call-template name="format_money">
						<xsl:with-param name="val" select="0"/>
					</xsl:call-template>
				</td>

				<!-- balance -->
				<td align="right">
					<xsl:call-template name="format_money">
						<xsl:with-param name="val" select="0"/>
					</xsl:call-template>
				</td>
			</tr>
		</tfoot>
	</table>
</xsl:template>

<!-- table header -->

<!-- header field -->

<!-- table row -->
<xsl:template match="row[@id='VehicleOwnerList_Model']">
	<tr>
		<td>
			<xsl:value-of select="vehicle_owner_name/."/>
		</td>
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant"/>
			</xsl:call-template>
		</td>
		<td align="right">
			<xsl:call-template name="format_money">
				<xsl:with-param name="val" select="balance_start"/>
			</xsl:call-template>
		</td>
	</tr>

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
