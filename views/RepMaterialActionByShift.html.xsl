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
	<xsl:apply-templates select="document/model[@id='MaterialActionByShiftList_Model']"/>
</xsl:template>

<!-- Head -->
<xsl:template match="model[@id='Head_Model']">
	<h3>Движение материала по дням за период <xsl:value-of select="row/period_descr"/></h3>
	<h5>Материал: <xsl:value-of select="row/material_descr"/></h5>
</xsl:template>

<xsl:template match="model[@id='MaterialActionByShiftList_Model']">
	<table class="table table-bordered table-responsive table-striped" style="width:60%;">
		<thead>
			<tr align="center">
				<td rowspan="2">Дата</td>
				<td rowspan="2">Остаток на начало</td>
				<td rowspan="2">Приход</td>
				<td colspan="8">Расход</td>
				<td rowspan="2">Остаток на конец</td>
			</tr>
			<tr align="center">
				<td>Завод 1</td>
				<td>Завод 2</td>
				<td>Завод 3</td>
				<td>Завод 4</td>
				<td>Завод 5</td>
				<td>Итого по заводам</td>
				<td>Корректировка</td>
				<td>Итого с корректировкой</td>
			</tr>
			
		</thead>
	
		<tbody>
			<xsl:apply-templates/>
		</tbody>				
		
		<tfoot>
			<tr>
				<td>Итого</td>
				<td></td>
				
				<!-- prohod-->
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_deb)"/>
					</xsl:call-template>
				</td>
				
				<!-- rashod on production site -->
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_kred_pr1)"/>
					</xsl:call-template>
				</td>
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_kred_pr2)"/>
					</xsl:call-template>
				</td>
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_kred_pr3)"/>
					</xsl:call-template>
				</td>
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_kred_pr4)"/>
					</xsl:call-template>
				</td>
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_kred_pr5)"/>
					</xsl:call-template>
				</td>
				
				<!-- rashod on all production sites -->
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_kred_pr)"/>
					</xsl:call-template>
				</td>

				<!-- correct -->
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_correct)"/>
					</xsl:call-template>
				</td>

				<!-- total rashod -->
				<td align="right">
					<xsl:call-template name="format_quant">
						<xsl:with-param name="val" select="sum(row/quant_kred)"/>
					</xsl:call-template>
				</td>
				
				<td></td>
			</tr>
		</tfoot>
	</table>
</xsl:template>

<xsl:template match="model[@id='MaterialActionByShiftList_Model']/row">
	<tr>
		<td><xsl:value-of select="day"/></td>		
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_running_bal_beg"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_deb"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred_pr1"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred_pr2"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred_pr3"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred_pr4"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred_pr5"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred_pr"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_correct"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_running_bal_end"/>
			</xsl:call-template>																									
		</td>				
	</tr>
</xsl:template>

</xsl:stylesheet>
