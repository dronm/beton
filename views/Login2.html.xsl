<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="ViewBase.html.xsl"/>

<xsl:template match="/document">
<html>
	<head>
		<xsl:call-template name="initHead"/>		

		<style>
			html,
			body.login-container {
				min-height: 100vh;
			}

			body.login-container {
				margin: 0;
				background:
					linear-gradient(135deg, #f4f7fb 0%, #eef3ff 45%, #f9fbff 100%);
			}

			.page-container,
			.page-content,
			.content-wrapper,
			.content {
				min-height: 100vh;
			}

			.content {
				display: flex;
				align-items: center;
				justify-content: center;
				padding: 24px 16px;
			}

			#Login {
				width: 100%;
				max-width: 430px;
			}

			.login-form {
				padding: 32px 28px 24px;
				border: 1px solid #e7ecf3;
				border-radius: 20px;
				background: #ffffff;
				box-shadow:
					0 20px 60px rgba(30, 42, 64, 0.10),
					0 4px 18px rgba(30, 42, 64, 0.06);
			}

			.logotype {
				display: block;
				margin: 0 auto 12px;
				max-width: 180px;
				height: auto;
			}

			.content-group {
				margin-bottom: 18px;
			}

			#Login\:error {
				margin-top: 12px;
				padding: 10px 12px;
				border-radius: 10px;
				background: #fff2f2;
				color: #b42318;
				font-size: 13px;
				line-height: 1.4;
			}

			.footer {
				margin-top: 18px;
				font-size: 12px;
			}
		</style>
		
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

					<form id="Login">
						<div class="panel panel-body login-form">
							<div class="text-center">
								<img class="logotype" src="img/logo.png">
								</img>

								<h5 class="content-group">
									<small class="display-block">Авторизация
									</small>									
								</h5>

								<div id="Login:error" class="hidden">
								</div>								
							</div>

							<input id="Login:user" type="text" class="form-control" placeholder="Логин" 
								style="margin-bottom: 5px;"
							/>
							<input id="Login:pwd" type="password" class="form-control" placeholder="Пароль"
								style="margin-bottom: 15px;"
							/>

							<div class="form-group">
								<div id="Login:submit_login" class="btn bg-{$COLOR_PALETTE} btn-block">
									Войти
								</div>
							</div>

						</div>
					</form>

					<!-- /advanced login -->


					<!-- Footer -->
					<div class="footer text-muted text-center">
						2013г - 2026г <a href="#">Катрэн+</a>
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
