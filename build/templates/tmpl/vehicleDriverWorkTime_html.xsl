<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" indent="yes"/>
<xsl:template match="/">
	<div id="{{{{id}}}}">
		<h1 class="page-header">Табель водителей по отгрузкам</h1>
		<div class="panel panel-default">
			<div class="panel-body">
				<div class="row">
					<div id="{{{{id}}}}:month_date"></div>
				</div>
				<div class="row">
					<div id="{{{{id}}}}:cmdBuildReport"></div>
					<div id="{{{{id}}}}:cmdPrint"></div>
					<div id="{{{{id}}}}:cmdExport"></div>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-body">
				<div class="row" data-report-content="" aria-live="polite"></div>
			</div>
		</div>
	</div>
</xsl:template>
</xsl:stylesheet>
