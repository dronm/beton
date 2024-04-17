<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="ViewBase.html.xsl"/>

<xsl:template match="/document">
<html>
	<head>
		<xsl:call-template name="initHead"/>		
		<!--
				var view = new Login_View("Login");
				view.toDOM();
		
		-->
		<script>		
			function pageLoad(){
			
				<xsl:call-template name="initApp"/>
								
				var n = document.getElementById("Login:submit_login_tm");
				if(n){
					EventHelper.add(n, "click", function(){
						//mode: tel or code
						var tm_tel = CommonHelper.getCookie("tm_tel");
						if(tm_tel &amp;&amp; tm_tel.length==10){
							UserTel.setTel(tm_tel);
						}else{
							UserTel.show();
						}
					});
					
					var tm_first_name = CommonHelper.getCookie("tm_first_name");
					if(tm_first_name){
						DOMHelper.setText(n, " Сообщение в Telegram для "+tm_first_name)
					}else{
						DOMHelper.setText(n, " Войти через Telegram")
					}
				}			
				
			}
		</script>		
		
	</head>
	<body onload="pageLoad();" class="login-container">

	<xsl:call-template name="page_header"/>

	<!-- Page container -->
	<div class="page-container">

		<!-- Page content -->
		<div class="page-content">

			<!-- Main content -->
			<div class="content-wrapper">

				<!-- Content area -->
				<div class="content">

					<!-- Advanced login -->
					<form id="Login">
						<div class="panel panel-body login-form">
							<!--<div class="form-group has-feedback has-feedback-left">
								<input id="Login:user" type="text" class="form-control" placeholder="Логин"/>
								<div class="form-control-feedback">
									<i class="icon-user text-muted"></i>
								</div>
								<div id="Login:user:error"/>
							</div>

							<div class="form-group has-feedback has-feedback-left">
								<input id="Login:pwd" type="password" class="form-control" placeholder="Пароль"/>
								<div class="form-control-feedback">
									<i class="icon-lock2 text-muted"></i>
								</div>
								<div id="Login:pwd:error"/>
							</div>
							-->
							<div>
								<div id="Login:error"></div>
							</div>

							<!--<div class="form-group">
								<div id="Login:submit_login" class="btn bg-{$COLOR_PALETTE} btn-block">Войти <i class="icon-arrow-right14 position-right"></i></div>
							</div>
							-->
							<!--
							<div class="form-group login-options">
								<div class="row">
									
									<div class="col-sm-6">
										<label class="checkbox-inline">
										<input id="Login:rememberMe" type="checkbox" class="styled" checked="checked"/>
										Запомнить</label>
									</div>
									
									<div class="col-sm-6 text-right">
										<a href="index.php?v=PasswordRecovery">Забыли пароль?</a>
									</div>
								</div>
							</div>
							-->
							<div class="form-group">
								<div id="Login:submit_login_tm" class="btn bg-{$COLOR_PALETTE} btn-block" title="Войти через Telegram">
									<i class="glyphicon glyphicon-send"></i>
								</div>
							</div>
							
							<!--
							<script src="https://telegram.org/js/telegram-widget.js?18" data-telegram-login="eurobeton_crm_bot"
								data-size="large" data-onauth="onTelegramAuth(user)" data-request-access="write"></script>
							<script type="text/javascript">
								function onTelegramAuth(authData) {
									var pm = (new User_Controller()).getPublicMethod("login_tm");
									pm.setFieldValue("width_type", window.getWidthType());
									pm.setFieldValue("auth_data", CommonHelper.serialize(authData));
									pm.run({
										"ok":function(){
											document.location.href = window.location.href;
										}
										,"fail":function(resp,errCode,errStr){
											var n =document.getElementById("Login:error");
											if(!n)return;
											n.value = errStr;
											DOMHelper.delClass(n, DOMHelper.INVIS_CLASS);
										}
										
									});
								}
							</script>
							-->						
							<!-- IE8 condition -->
							<xsl:comment><![CDATA[[if IE 8]>
							<div class="alert alert-danger alert-styled-left alert-bordered">К сожалению, работа в личном кабинете с данным браузером невозможна!
							</div>
							<![endif]]]></xsl:comment>
							
							<!--
							<div class="content-divider text-muted form-group"><span>или авторизуйтесь через</span></div>
							<ul class="list-inline form-group list-inline-condensed text-center">
								<li><a href="#" class="btn border-indigo text-indigo btn-flat btn-icon btn-rounded"><i class="icon-facebook"></i></a></li>
								<li><a href="#" class="btn border-pink-300 text-pink-300 btn-flat btn-icon btn-rounded"><i class="icon-dribbble3"></i></a></li>
								<li><a href="#" class="btn border-slate-600 text-slate-600 btn-flat btn-icon btn-rounded"><i class="icon-github"></i></a></li>
								<li><a href="#" class="btn border-info text-info btn-flat btn-icon btn-rounded"><i class="icon-twitter"></i></a></li>
							</ul>
							-->
						</div>
					</form>
					<!-- /advanced login -->


					<!-- Footer -->
					<div class="footer text-muted text-center">
						2013г - 2022г <a href="#">Катрэн+</a>
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
	<!--	
	<script>
			var n = document.getElementById("Login:user");
			if (n){
				if (document.activeElement &amp;&amp; document.activeElement.id!="Login:pwd"){
					n.focus();
				}
			}
	</script>
		-->
		<xsl:call-template name="initJS"/>
	</body>
</html>		
</xsl:template>

</xsl:stylesheet>
