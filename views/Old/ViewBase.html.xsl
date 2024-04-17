<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<xsl:variable name="BASE_PATH" select="/document/model[@id='ModelVars']/row[1]/basePath"/>
<xsl:variable name="VERSION" select="/document/model[@id='ModelVars']/row[1]/scriptId"/>
<xsl:variable name="COLOR_PALETTE" select="/document/model[@id='Page_Model']/row[1]/DEFAULT_COLOR_PALETTE"/>
<xsl:variable name="TOKEN">
	<xsl:choose>
		<xsl:when test="not(/document/model[@id='ModelVars']/row[1]/token='')"><xsl:value-of select="concat('&amp;token=',/document/model[@id='ModelVars']/row[1]/token)"/></xsl:when>
		<xsl:otherwise></xsl:otherwise>
	</xsl:choose>
</xsl:variable>
	
	
<!--************* Main template ******************** -->		
<xsl:template match="/document">
<html>
	<head>
		<xsl:call-template name="initHead"/>
		
		<script>
			<xsl:call-template name="modelFromTemplate"/>
			function pageLoad(){							
				<xsl:call-template name="initApp"/>
				
				<xsl:call-template name="checkForError"/>
								
				showView();
			}
		</script>
	</head>
	<body onload="pageLoad();">
	
		<xsl:call-template name="page_header"/>
		
		<!-- Page container -->
		<div class="page-container">

			<!-- Page content -->
			<div class="page-content">

				<!-- Main content -->
				<div class="content-wrapper">

					<!-- Content area -->
					<div class="content">
						<div id="windowData">
							<xsl:apply-templates select="model[@htmlTemplate='TRUE']"/>
						</div>

						<div class="windowMessage hidden">
						</div>
						<!--waiting  -->
						<div id="waiting">
							<div>Обработка...</div>
							<img src="img/loading.gif"/>
						</div>
						
						<!-- Footer -->
						<div class="footer text-muted text-center">
							2019. <a href="#">Катрэн+</a>
						</div>
						<!-- /footer -->

					</div>
					<!-- /content area -->

				</div>
				<!-- /main content -->

			</div>
			<!-- /page content -->

		</div>
		<!-- /page container -->
	    
		<xsl:call-template name="initJS"/>
	</body>
</html>		
</xsl:template>


<!--************* Javascript files ******************** -->
<xsl:template name="initJS">
	<!-- bootstrap resolution-->
	<div id="users-device-size">
	  <div id="sm" class="visible-sm"></div>
	  <div id="md" class="visible-md"></div>
	  <div id="lg" class="visible-lg"></div>
	</div>

	<!--ALL js modules -->
	<xsl:apply-templates select="model[@id='ModelJavaScript']/row"/>
	<!--<script src="http://localhost:1337/vorlon.js"></script>-->
	<script>
		$("#waiting").hide();
	</script>
</xsl:template>


<!--************* Application instance ******************** -->
<xsl:template name="initApp">
	var serv_vars = {
		<xsl:for-each select="model[@id='ModelVars']/row/*">
		<xsl:if test="position() &gt; 1">,</xsl:if>"<xsl:value-of select="local-name()"/>":'<xsl:value-of select="node()"/>'
		</xsl:for-each>
	};
	serv_vars.color_palette = (!serv_vars.color_palette||serv_vars.color_palette=='')? '<xsl:value-of select="$COLOR_PALETTE"/>':serv_vars.color_palette;
	var application = new AppBeton({
		servVars:serv_vars
		<xsl:if test="model[@id='ConstantValueList_Model']">
		,"constantXMLString":CommonHelper.longString(function () {/*
				<xsl:copy-of select="model[@id='ConstantValueList_Model']"/>
		*/})
		</xsl:if>
		<!--	
		<xsl:if test="not(/document/model[@id='ModelServResponse']/row/result='0')">
			,
			"error":"<xsl:value-of select="/document/model[@id='ModelServResponse']/row/descr"/>"
		</xsl:if>	
		-->
	});
	
	<xsl:call-template name="initAppWin"/>	
		
	<!-- [@default='FALSE']-->
	<xsl:variable name="def_menu_item" select="//menuitem[@default='true']"/>
	<xsl:if test="$def_menu_item">
	if(window.location.href.indexOf("?") &lt; 0 || window.location.href.indexOf("token=") &gt;=0 || window.location.href.indexOf("?sid") &gt;=0) {
		var iRef = DOMHelper.getElementsByAttr("true", CommonHelper.nd("side-menu"), "defaultItem",true,"A")[0];
		application.showMenuItem(iRef,'<xsl:value-of select="$def_menu_item/@c"/>','<xsl:value-of select="$def_menu_item/@f"/>','<xsl:value-of select="$def_menu_item/@t"/>',null,'<xsl:value-of select="$def_menu_item/@viewdescr"/>');
	}
	</xsl:if>
	
	<xsl:if test="not(/document/model[@id='ModelVars']/row/role_id='')">
	if (document.getElementById("weather")){
		application.m_weather = new Weather("weather",{"refreshInterval":600});
		application.m_weather.toDOM();
	}	
	<xsl:if test="count(/document/model[@id='AstCallCurrent_Model']/row) &gt;0">
	if(window.getWidthType()!="sm"){
	//ВХОДЯЩИЙ ЗВОНОК!
	var view_opts = {};
	view_opts.models = {};
	view_opts.models.AstCallCurrent_Model = new AstCallCurrent_Model({"data":CommonHelper.longString(function () {/*
			<xsl:copy-of select="/document/model[@id='AstCallCurrent_Model']"/>
	*/})});
	<xsl:if test="count(/document/model[@id='AstCallClientCallHistoryList_Model']/row) &gt;0">
	view_opts.models.AstCallClientCallHistoryList_Model = new AstCallClientCallHistoryList_Model({"data":CommonHelper.longString(function () {/*
			<xsl:copy-of select="/document/model[@id='AstCallClientCallHistoryList_Model']"/>
	*/})});	
	</xsl:if>
	<xsl:if test="count(/document/model[@id='AstCallClientShipHistoryList_Model']/row) &gt;0">
	view_opts.models.AstCallClientShipHistoryList_Model = new AstCallClientShipHistoryList_Model({"data":CommonHelper.longString(function () {/*
			<xsl:copy-of select="/document/model[@id='AstCallClientShipHistoryList_Model']"/>
	*/})});	
	</xsl:if>
	
	view_opts.onMakeOrder = function(){				
		var order_make_grid = window.getApp().getCurrentView().getElement("order_make_grid");
		var calc_v = window.call_view.getElement("calc");
		var m = new OrderDialog_Model();
		m.setFieldValue("destinations_ref",calc_v.getElement("destination").getValue());		
		m.setFieldValue("clients_ref",window.call_view.getElement("client").getValue());
		m.setFieldValue("quant",calc_v.getElement("quant").getValue());
		m.setFieldValue("concrete_types_ref",calc_v.getElement("concrete_type").getValue());
		m.setFieldValue("destination_cost",calc_v.getElement("destination_cost").getValue());
		m.setFieldValue("destination_price",calc_v.m_destinationPrice);
		m.setFieldValue("destination_distance",calc_v.m_destinationDistance);
		m.setFieldValue("concrete_cost",calc_v.getElement("concrete_cost").getValue());
		m.setFieldValue("concrete_price",calc_v.m_concretePrice);
		m.setFieldValue("unload_cost",calc_v.getElement("unload_cost").getValue());
		m.setFieldValue("total",calc_v.getElement("total").getValue());
		m.setFieldValue("pay_cash",true);
		m.setFieldValue("descr",window.call_view.getElement("contact_name").getValue());
		m.setFieldValue("phone_cel",window.call_view.getElement("contact_tel").getValue());
		m.setFieldValue("users_ref",new RefType({"keys":{"id":window.getApp().getServVar("user_id")},"descr":window.getApp().getServVar("user_name"),"dataType":"users"}));
		m.setFieldValue("unload_type",calc_v.getElement("unload_type").getValue());
		m.setFieldValue("pump_vehicles_ref",calc_v.getElement("pump_vehicle").getValue());
		m.recInsert();
		order_make_grid.edit("insert",{
			"models":{
				"OrderDialog_Model":m
			}
		});
		
		window.call_form.close();		
		delete window.call_view;
		delete window.call_form;
		
	}
	
	window.showClientCallForm = function(viewOpts){
		window.call_view = new AstIncomeCall_View("CallForm:body:v",viewOpts);
		window.call_form = new WindowFormModalBS({
			"id":"CallForm",
			"contentHead":"Входящий звонок",
			"content":window.call_view,
			"cmdClose":true,
			"cmdCancel":true
		});
		window.call_form.open();			
	}
	
	if(view_opts.models.AstCallCurrent_Model.getNextRow()){
		if (view_opts.models.AstCallCurrent_Model.getFieldValue("client_id")){
			window.showClientCallForm(view_opts);
			//if (view_opts.models.AstCallCurrent_Model.getFieldValue("client_kind")=="buyer"){				
			//}
		}
		else{
			view_opts.onSetClientBuyer = function(viewOpts){
				window.call_form.close();
				delete window.call_view;
				delete window.window.call_form;
				
				if(viewOpts.models.AstCallCurrent_Model.getFieldValue("client_kind")=="buyer")
					window.showClientCallForm(viewOpts);
			}
			window.call_view = new AstIncomeUnknownCall_View("CallForm:body:v",view_opts);
			window.call_form = new WindowFormModalBS({
				"id":"CallForm",
				"contentHead":"Входящий звонок",
				"content":window.call_view,
				"cmdClose":false,
				"cmdCancel":false
			});
			window.call_form.open();		
		}
	}
	}
	</xsl:if>
	
	</xsl:if>
		
</xsl:template>

<!--************* Window instance ******************** -->
<xsl:template name="initAppWin">
	var applicationWin = new AppWin({
		"widthType":$("#users-device-size").find("div:visible").first().attr("id"),
		"app":application
		<!--
		<xsl:if test="not(/document/model[@id='ModelServResponse']/row/result='0')">
			,"error":"<xsl:value-of select="/document/model[@id='ModelServResponse']/row/descr"/>"
		</xsl:if>	
		-->
	});
	
	<xsl:if test="not(/document/model[@id='ModelVars']/row/role_id='')">

	//Extending DateHelper
	DateHelper.getEndOfShift = function(d){
		var constants = {"shift_length_time":null};
		window.getApp().getConstantManager().get(constants);
	
		var dd = DateHelper.getStartOfShift(d);
		return new Date(dd.getTime()+DateHelper.timeToMS(constants.shift_length_time.getValue())/60*60-1000);
	}
	DateHelper.getStartOfShift = function(d){					
		var constants = {"first_shift_start_time":null};
		window.getApp().getConstantManager().get(constants);
		
		d = d? d:DateHelper.time();		
		
		var dd = DateHelper.dateStart(d);
		dd = new Date(dd.getTime() + DateHelper.timeToMS(constants.first_shift_start_time.getValue()));
		
		if(dd.getTime()>d.getTime()){
			dd = new Date(dd.getTime() - 24*60*60*1000);
		}
		
		return dd;
	}
	</xsl:if>
		
</xsl:template>

<!--************* Page head ******************** -->
<xsl:template name="initHead">
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<!--<link href="https://fonts.googleapis.com/css?family=Roboto:400,300,100,500,700,900" rel="stylesheet" type="text/css" />-->
	
	<xsl:apply-templates select="model[@id='ModelVars']"/>
	<xsl:apply-templates select="model[@id='ModelStyleSheet']/row"/>
	<link rel="icon" type="image/png" href="img/favicon.ico"/>
	
	<title>Евробетон</title>
</xsl:template>


<!-- ************** Main Menu ******************** -->
<xsl:template name="initMenu">
	<xsl:if test="model[@id='MainMenu_Model'] or /document/model[@id='ModelVars']/row/role_id='owner'">
	<!-- Main navigation -->
	<ul class="nav navbar-nav">

				<!-- Main  -->				
				<xsl:apply-templates select="/document/model[@id='MainMenu_Model']/menu/*"/>
				
				<xsl:if test="/document/model[@id='ModelVars']/row/role_id='owner'">
				<!-- service -->
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown">
						<i class="icon-stack2"></i> Сервис
						<i class="caret"></i>
					</a>
					<ul class="dropdown-menu">
						<li>
							<a href="index.php?c=View_Controller&amp;f=get_list&amp;t=ViewList"
							onclick="window.getApp().showMenuItem(this,'View_Controller','get_list','ViewList',null,'Все формы');return false;">
							Все формы
							</a>
						</li>		        				
				
						<li>
							<a href="index.php?c=Constant_Controller&amp;f=get_list&amp;t=ConstantList"
							onclick="window.getApp().showMenuItem(this,'Constant_Controller','get_list','ConstantList',null,'Константы');return false;">
							Константы
							</a>
						</li>		        				
				
						<li>
							<a href="index.php?c=MainMenuConstructor_Controller&amp;f=get_list&amp;t=MainMenuConstructorList"
							onclick="window.getApp().showMenuItem(this,'MainMenuConstructor_Controller','get_list','MainMenuConstructorList',null,'Конструктор меню');return false;">
							Конструктор меню
							</a>
						</li>		        				
						<li>
							<a href="#" onclick="window.getApp().showAbout();return false;">
							О программе
							</a>
						</li>
					</ul>
				</li>
				
				</xsl:if>
	</ul>
	</xsl:if>
</xsl:template>


<!--************* Menu item ******************-->
<xsl:template match="menuitem">
	<xsl:choose>
		<xsl:when test="menuitem">
			<!-- multylevel @isgroup='1'-->			
			<li class="dropdown">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown">
					<xsl:choose>
					<xsl:when test="@glyphclass and string-length(@glyphclass) &gt; 0 and not(@glyphclass='null')">
						<i class="{@glyphclass}"></i> <xsl:value-of select="concat(' ',@descr)"/>						
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="@descr"/>
					</xsl:otherwise>
					</xsl:choose>
					<i class="caret"></i>
				</a>
				<ul class="dropdown-menu">
					<xsl:apply-templates/>
				</ul>						
			</li>
		</xsl:when>
		<xsl:otherwise>
			<!-- one level-->
			<li>
			    <a href="index.php?c={@c}&amp;f={@f}&amp;t={@t}{$TOKEN}"
			    onclick="window.getApp().showMenuItem(this,'{@c}','{@f}','{@t}{$TOKEN}',null,'{@viewdescr}');return false;"
			    defaultItem="{@default='true'}">
				<xsl:choose>
				<xsl:when test="@glyphclass and string-length(@glyphclass) &gt; 0 and not(@glyphclass='null')">
					<i class="{@glyphclass}"></i> <xsl:value-of select="@descr"/>						
				</xsl:when>
				<xsl:otherwise>
					<i class="{@glyphclass}"></i> <xsl:value-of select="@descr"/>
				</xsl:otherwise>
				</xsl:choose>
			    </a>
			</li>			
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--*************** templates ********************* -->
<xsl:template match="model[@templateId]">
<xsl:copy-of select="*"/>
</xsl:template>

<xsl:template name="modelFromTemplate">
	function showView(){
		<!-- All data models to object -->
		var models;
		var editViewOptions = window.getParam? (window.getParam("editViewOptions")||{}) : {};
		if (window.getParam){
			editViewOptions.cmd = window.getParam("cmd");
		}
		else{
			var s_str = window.location.toString();
			var par_start = s_str.indexOf("?");
			if (par_start>=0){
				var par_list = s_str.substr(par_start).split("&amp;");
				for (var i=0;i&lt;par_list.length;i++){
					var v_sep = par_list[i].indexOf("=");
					if (v_sep>=0){
						var n = par_list[i].substr(0,v_sep);
						var v = par_list[i].substr(v_sep+1);
						if (n=="mode"){
							editViewOptions.cmd = v;
							break;
						}
					}
				}
			}
		}
		editViewOptions.cmd = editViewOptions.cmd || "edit";
		editViewOptions.models = editViewOptions.models || {};
		
		<xsl:for-each select="model[not(@sysModel='1')]">
		<xsl:variable name="m_id" select="@id"/>
		var m_data = CommonHelper.longString(function () {/*
				<xsl:copy-of select="/document/model[@id=$m_id]"/>
			*/});		
		if(window["<xsl:value-of select="$m_id"/>"]){
			editViewOptions.models.<xsl:value-of select="$m_id"/> = editViewOptions.models.<xsl:value-of select="$m_id"/>
				|| new <xsl:value-of select="$m_id"/>({"data":m_data});
		}
		else{
			editViewOptions.models.<xsl:value-of select="$m_id"/> = editViewOptions.models.<xsl:value-of select="$m_id"/>
				|| new ModelXML("<xsl:value-of select="$m_id"/>",{"data":m_data});			
		}
		</xsl:for-each>
	
		<xsl:for-each select="model[@templateId]">
			var v_opts = CommonHelper.clone(editViewOptions);
			v_opts.template = CommonHelper.longString(function () {/*
			<xsl:copy-of select="./*"/>
			*/});
			//encoded curly braces
			v_opts.template = v_opts.template.replace("%7B%7B","{{");
			v_opts.template = v_opts.template.replace("%7D%7D","}}");
			v_opts.variantStorage = {
				"name":"<xsl:value-of select="@templateId"/>"
				<xsl:if test="/document/model[@id='VariantStorage_Model']">
				,"model":editViewOptions.models.VariantStorage_Model
				</xsl:if>			
			};	
			if(v_opts.variantStorage.model)
				v_opts.variantStorage.model.getRow(0);	
			var v_<xsl:value-of select="@templateId"/> = new <xsl:value-of select="@templateId"/>_View("<xsl:value-of select="@templateId"/>",v_opts);
			v_<xsl:value-of select="@templateId"/>.toDOM(document.getElementById("windowData"));
		</xsl:for-each>
	}
</xsl:template>


<!-- ERROR 
<xsl:template match="model[@id='ModelServResponse']/row/result &lt;&gt;'0'">
throw Error(CommonHelper.longString(function () {/*
<xsl:value-of select="descr"/>
*/}));
</xsl:template>
-->

<!--System variables -->
<xsl:template match="model[@id='ModelVars']/row">
	<xsl:if test="author">
		<meta name="Author" content="{author}"></meta>
	</xsl:if>
	<xsl:if test="keywords">
		<meta name="Keywords" content="{keywords}"></meta>
	</xsl:if>
	<xsl:if test="description">
		<meta name="Description" content="{description}"></meta>
	</xsl:if>
	
</xsl:template>

<!-- CSS -->
<xsl:template match="model[@id='ModelStyleSheet']/row">	
	<link rel="stylesheet" href="{concat(href,'?',$VERSION)}" type="text/css"/>
</xsl:template>

<!-- Javascript -->
<xsl:template match="model[@id='ModelJavaScript']/row">
	<script src="{concat(href,'?',$VERSION)}"></script>
</xsl:template>

<!-- Error
<xsl:template match="model[@id='ModelServResponse']/row">
	<xsl:if test="result/node()='1'">
	<div class="error"><xsl:value-of select="descr"/></div>
	</xsl:if>
</xsl:template>
 -->

<xsl:template name="checkForError">
	<xsl:variable name="er_num" select="/document/model[@id='ModelServResponse']/row/result"/>
	<xsl:choose>
	<!--$er_num='100' or -->
	<xsl:when test="$er_num='101' or $er_num='102'">
		if (CommonHelper.isIE()){
			throw new Error('<xsl:value-of select="/document/model[@id='ModelServResponse']/row/descr"/>');
		}
		else{
			throw new FatalException({
				"code":<xsl:value-of select="$er_num"/>
				,"message":'<xsl:value-of select="/document/model[@id='ModelServResponse']/row/descr"/>'
			});
		}
	</xsl:when>
	<xsl:when test="$er_num='105'">
		if (CommonHelper.isIE()){
			throw new Error('<xsl:value-of select="/document/model[@id='ModelServResponse']/row/descr"/>');
		}
		else{
	
			throw new DbException({
				"code":<xsl:value-of select="$er_num"/>
				,"message":'<xsl:value-of select="/document/model[@id='ModelServResponse']/row/descr"/>'
			});
		}
	</xsl:when>
	
	<xsl:when test="not($er_num='0') and not(/document/model[@id='ModelVars']/row/role_id='')">		
		throw new Error(CommonHelper.escapeDoubleQuotes(CommonHelper.longString(function () {/*
			<xsl:value-of select="/document/model[@id='ModelServResponse']/row/descr"/>
			*/}))
		);
	</xsl:when>
	<xsl:when test="not($er_num='0')">
		throw new FatalException({
			"code":<xsl:value-of select="$er_num"/>
			,"message":CommonHelper.escapeDoubleQuotes(CommonHelper.longString(function () {/*
			<xsl:value-of select="/document/model[@id='ModelServResponse']/row/descr"/>
			*/}))
		});
	</xsl:when>
	<xsl:otherwise/>
	</xsl:choose>	
</xsl:template>

<xsl:template name="page_header">
	<!-- Main navbar -inverse-->
	<div class="navbar navbar">
	<div class="container-fluid">
	
		<xsl:choose>
		<xsl:when test="/document/model[@id='ModelVars']/row/role_id=''">
		<div class="navbar-header">
			<a class="navbar-brand" href="index.php">
				<img class="logotype" src="img/logo.png"></img>
			</a>
		</div>
		</xsl:when>
		<xsl:otherwise>
		<div class="navbar-header">
			<a class="navbar-brand" href="index.php">
				<img class="logotype" src="img/logo.png"></img>
			</a>
		</div>
				
			
			<xsl:call-template name="initMenu"/>	
			<ul class="nav navbar-nav navbar-right">			
			
				<li class="dropdown">
					<a id="weather">
					</a>
				</li>			
			
				<!-- USER DATA -->
				<li class="dropdown dropdown-user">
					<a class="dropdown-toggle" data-toggle="dropdown">
						<img src="js20/assets/images/placeholder.jpg" alt=""/>
						<span>
						<xsl:choose>
						<xsl:when test="/document/model[@id='ModelVars']/row/user_name_full!=''">
						<xsl:apply-templates select="/document/model[@id='ModelVars']/row/user_name_full"/>
						</xsl:when>
						<xsl:otherwise>
						<xsl:apply-templates select="/document/model[@id='ModelVars']/row/user_name"/>
						</xsl:otherwise>
						</xsl:choose>
						</span>
						<i class="caret"></i>
					</a>

					<ul class="dropdown-menu dropdown-menu-right">
						<li>
							<a href="index.php?c=User_Controller&amp;f=get_profile&amp;t=UserProfile{$TOKEN}"
							onclick="window.getApp().showMenuItem(this,'User_Controller','get_profile','UserProfile{$TOKEN}',null,'Профиль');return false;">
							<i class="icon-user-plus"></i> Профиль
							</a>
						</li>					        
						
						<li class="divider"></li>
						<!-- index.php?c=User_Controller&amp;f=logout_html{$TOKEN} -->
						<li><a href="#" onclick="window.getApp().quit()"><i class="icon-switch2"></i> Выход</a></li>
					</ul>
				</li>				
			</ul>
		</xsl:otherwise>
		</xsl:choose>
	</div>
	</div>
	<!-- /main navbar -->
</xsl:template>

</xsl:stylesheet>
