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
					
				var view = new LoginTM("Login");
				view.toDOM(document.body);
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

					<!-- Advanced login -->
					<form id="Login">
						<div class="panel panel-body login-form">
							<div class="text-center">
								<img class="logotype" src="img/logo.png">
								</img>
								<h5 class="content-group">
									<small class="display-block">Авторизация
									</small>									
								</h5>
								<div id="Login:error">
								</div>								
							</div>
							
							<div class="form-group has-feedback has-feedback-left">
								<div id="Login:tel" />
								<div class="form-control-feedback">
									<i class="icon-mobile3 text-muted"/>
								</div>
							</div>

							<div class="form-group tmData">
								<img id="Login:userPhoto" class="userPhoto hidden">
								</img>
								<div id="Login:userData">
								</div>
							</div>
							
							<div id="Login:codeInput" class="form-group hidden">
								<div class="text-center">
									<small class="display-block">Введите код
									</small>
									<div class="form-group">									
										<input id="tm_сode1" code_ind="1" type="number" class="form-control form-control tmCode" min="0" max="9"/>
										<input id="tm_сode2" code_ind="2" type="number" class="form-control form-control tmCode" min="0" max="9"/>
										<input id="tm_сode3" code_ind="3" type="number" class="form-control form-control tmCode" min="0" max="9"/>
									</div>
								</div>
							</div>
							
							<div class="form-group">
								<div id="Login:check_code" class="btn bg-{$COLOR_PALETTE} btn-block"
									title="Отправить сообщение в Телеграм">Отправить код
								</div>
							</div>
							
						</div>
					</form>
					<!-- /advanced login -->


					<!-- Footer -->
					<div class="footer text-muted text-center">
						2013г - 2024г <a href="#">Катрэн+</a>
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

</xsl:stylesheet>
