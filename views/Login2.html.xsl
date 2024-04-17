<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="ViewBase.html.xsl"/>

<xsl:template match="/document">
<html>
	<head>
		<xsl:call-template name="initHead"/>		
		
		<script>		
			function pageLoad(){
			
				<xsl:call-template name="initApp"/>
				
				var view = new Login_View("Login");
				view.toDOM();
			}
		</script>		
		
	</head>
	<body onload="pageLoad();" class="login-container">

	<!--<xsl:call-template name="page_header"/>-->

	<!-- Page container -->
	<div class="page-container">

		<!-- Page content -->
		<div class="page-content">

			<!-- Main content -->
			<div class="content-wrapper">

				<!-- Content area -->
				<div class="content">

					<div id="loginForm">					
					
						<a class="login-navbar-brand" href="#">
							<img class="logotype" src="img/logo.png"></img>
						</a>
					
						<div class="login-form">
							<input id="Login:user" type="text" class="form-control" placeholder="Логин"/>
							<input id="Login:pwd" type="password" class="form-control" placeholder="Пароль"/>

							<div class="form-group">
								<div id="Login:submit_login" class="btn bg-{$COLOR_PALETTE} btn-block">Войти <i class="icon-arrow-right14 position-right"></i></div>
							</div>

							<div class="login-options">
								<div class="row">
									<!--
									<div class="col-sm-6">
										<label class="checkbox-inline">
										<input id="Login:rememberMe" type="checkbox" class="styled" checked="checked"/>
										Запомнить</label>
									</div>
									-->
									<div class="col-sm-6 text-right">
										<a href="index.php?v=PasswordRecovery">Забыли пароль?</a>
									</div>
								</div>
							</div>
							
							<div class="col-lg-12">
								<div id="Login:error"></div>
							</div>

							
							<!-- IE8 condition -->
							<xsl:comment><![CDATA[[if IE 8]>
							<div class="alert alert-danger alert-styled-left alert-bordered">К сожалению, работа в личном кабинете с данным браузером невозможна!
							</div>
							<![endif]]]></xsl:comment>
							
						</div>
					</div>
					<!-- /advanced login -->


					<!-- Footer -->
					<div class="footer text-muted text-center">
						2013г - 2021г <a href="#">Катрэн+</a>
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
		
	<script>
			var n = document.getElementById("Login:user");
			if (n){
				if (document.activeElement &amp;&amp; document.activeElement.id!="Login:pwd"){
					n.focus();
				}
			}
	</script>
		
		<xsl:call-template name="initJS"/>
	</body>
</html>		
</xsl:template>

</xsl:stylesheet>
