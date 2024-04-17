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
	<xsl:apply-templates select="document/model[@id='MaterialActionList1_Model']"/>
	<br></br>
	<xsl:apply-templates select="document/model[@id='MaterialActionList2_Model']"/>								
	<br></br>
	<xsl:apply-templates select="document/model[@id='MaterialActionList3_Model']"/>									
</xsl:template>

<!-- Head -->
<xsl:template match="model[@id='Head_Model']">
	<h3>Отчет по материалам за период <xsl:value-of select="row/period_descr"/></h3>
	
</xsl:template>

<xsl:template match="model[@id='MaterialActionList1_Model']">
	<xsl:variable name="model_id" select="@id"/>
	
	<div class="panel panel-default">
		<div class="panel-heading">
			<h6 class="panel-title">Утяшево
			</h6>
			<div class="heading-elements">
				<ul class="icons-list">
		        		<li>
		        			<a data-action="collapse" class="">
		        			</a>
		        		</li>
		        	</ul>
			</div>				
		</div>
		
		<div class="panel-body">
			<table id="{$model_id}" class="table table-bordered table-responsive table-striped" style="width:60%;">
				<thead>
					<tr align="center">
						<td rowspan="2">Материал</td>
						<td rowspan="2">Начальный остаток</td>
						<td rowspan="2">Приход</td>
						<td colspan="4">Расход</td>
						<td rowspan="2">Корректировка (- не хватило, + излишки)</td>
						<td rowspan="2">Конечный остаток</td>
					</tr>
					<tr align="center">
						<td>Завод 1</td>
						<td>Завод 2</td>
						<td>Завод 3</td>
						<td>Итого</td>
					</tr>
					
				</thead>
			
				<tbody>
					<xsl:apply-templates/>
				</tbody>
				
			</table>
		</div>
	</div>
</xsl:template>

<xsl:template match="model[@id='MaterialActionList2_Model']">
	<xsl:variable name="model_id" select="@id"/>
	
	<div class="panel panel-default">
		<div class="panel-heading">
			<h6 class="panel-title">Ветеранов труда
			</h6>
			<div class="heading-elements">
				<ul class="icons-list">
		        		<li>
		        			<a data-action="collapse" class="">
		        			</a>
		        		</li>
		        	</ul>
			</div>				
		</div>
		
		<div class="panel-body">
			
			<table id="{$model_id}" class="table table-bordered table-responsive table-striped" style="width:60%;">
				<thead>
					<tr align="center">
						<td rowspan="2">Материал</td>
						<td rowspan="2">Начальный остаток</td>
						<td rowspan="2">Приход</td>
						<td colspan="2">Расход</td>
						<td rowspan="2">Корректировка (- не хватило, + излишки)</td>
						<td rowspan="2">Конечный остаток</td>
					</tr>
					<tr align="center">
						<td>Завод 1</td>
						<td>Итого</td>
					</tr>
					
				</thead>
			
				<tbody>
					<xsl:apply-templates/>
				</tbody>				
			</table>
		</div>
	</div>
</xsl:template>

<xsl:template match="model[@id='MaterialActionList3_Model']">
	<xsl:variable name="model_id" select="@id"/>
	
	<div class="panel panel-default">
		<div class="panel-heading">
			<h6 class="panel-title">Республики
			</h6>
			<div class="heading-elements">
				<ul class="icons-list">
		        		<li>
		        			<a data-action="collapse" class="">
		        			</a>
		        		</li>
		        	</ul>
			</div>				
		</div>
		
		<div class="panel-body">
			
			<table id="{$model_id}" class="table table-bordered table-responsive table-striped" style="width:60%;">
				<thead>
					<tr align="center">
						<td rowspan="2">Материал</td>
						<td rowspan="2">Начальный остаток</td>
						<td rowspan="2">Приход</td>
						<td colspan="2">Расход</td>
						<td rowspan="2">Корректировка (- не хватило, + излишки)</td>
						<td rowspan="2">Конечный остаток</td>
					</tr>
					<tr align="center">
						<td>Завод 1</td>
						<td>Итого</td>
					</tr>
					
				</thead>
			
				<tbody>
					<xsl:apply-templates/>
				</tbody>				
			</table>
		</div>
	</div>
</xsl:template>

<xsl:template match="model[@id='MaterialActionList1_Model']/row">
	<tr>
		<td><xsl:value-of select="material_name"/></td>		
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_start"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_deb"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="pr1_quant_kred"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="pr2_quant_kred"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="pr3_quant_kred"/>
			</xsl:call-template>																									
		</td>				
		
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_correction"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_end"/>
			</xsl:call-template>																									
		</td>				
		
	</tr>
</xsl:template>

<xsl:template match="model[@id='MaterialActionList2_Model']/row">
	<tr>
		<td><xsl:value-of select="material_name"/></td>		
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_start"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_deb"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="pr1_quant_kred"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_correction"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_end"/>
			</xsl:call-template>																									
		</td>				
		
	</tr>
</xsl:template>

<xsl:template match="model[@id='MaterialActionList3_Model']/row">
	<tr>
		<td><xsl:value-of select="material_name"/></td>		
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_start"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_deb"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="pr1_quant_kred"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_kred"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_correction"/>
			</xsl:call-template>																									
		</td>				
		<td align="right">
			<xsl:call-template name="format_quant">
				<xsl:with-param name="val" select="quant_end"/>
			</xsl:call-template>																									
		</td>				
		
	</tr>
</xsl:template>

</xsl:stylesheet>
