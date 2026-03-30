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

			.tmData {
				display: flex;
				align-items: center;
				gap: 12px;
				min-height: 44px;
				margin-bottom: 20px;
				padding: 10px 12px;
				border: 1px solid #edf1f6;
				border-radius: 12px;
				background: #f8fafc;
			}

			.userPhoto {
				width: 44px;
				height: 44px;
				border-radius: 50%;
				object-fit: cover;
				border: 2px solid #ffffff;
				box-shadow: 0 4px 12px rgba(0, 0, 0, 0.10);
			}

			.tmCodeLabel {
				display: block;
				margin-bottom: 10px;
				font-size: 13px;
				font-weight: 600;
				color: #344054;
			}

			.tmCodeRow {
				display: flex;
				justify-content: center;
				gap: 10px;
			}

			.tmCode {
				width: 56px !important;
				height: 56px !important;
				padding: 0 !important;
				border: 1px solid #d8e1ec;
				border-radius: 12px;
				text-align: center;
				font-size: 22px !important;
				font-weight: 700;
				line-height: 56px !important;
				box-shadow: none;
			}

			.tmCode:focus {
				border-color: #7c9cff;
				box-shadow: 0 0 0 4px rgba(124, 156, 255, 0.16);
			}

			.tmCode[disabled] {
				background: #f2f4f7;
				cursor: not-allowed;
			}

			.tmSubmitGroup {
				margin-top: 8px;
			}

			#Login\:check_code {
				display: flex;
				align-items: center;
				justify-content: center;
				min-height: 44px;
				padding: 10px 16px;
				border-radius: 12px;
				font-weight: 600;
				line-height: 1.25;
				text-align: center;
				white-space: normal;
				box-shadow: 0 8px 20px rgba(80, 112, 255, 0.18);
				transition: opacity 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease;
			}

			#Login\:check_code:hover {
				transform: translateY(-1px);
				box-shadow: 0 10px 24px rgba(80, 112, 255, 0.22);
			}

			#Login\:check_code.tm-btn-disabled {
				opacity: 0.55;
				pointer-events: none;
				box-shadow: none;
				transform: none;
			}

			.tmTimer {
				margin-top: 8px;
				min-height: 18px;
				text-align: center;
				font-size: 13px;
				line-height: 1.35;
				color: #667085;
			}

			.footer {
				margin-top: 18px;
				font-size: 12px;
			}
		</style>

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
					<form id="Login" autocomplete="off">
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
									<small class="display-block tmCodeLabel">Введите код</small>
									<div class="form-group tmCodeRow">
										<input
											id="tm_сode1"
											code_ind="1"
											type="text"
											inputmode="numeric"
											autocomplete="one-time-code"
											maxlength="1"
											class="form-control tmCode" />
										<input
											id="tm_сode2"
											code_ind="2"
											type="text"
											inputmode="numeric"
											autocomplete="one-time-code"
											maxlength="1"
											class="form-control tmCode" />
										<input
											id="tm_сode3"
											code_ind="3"
											type="text"
											inputmode="numeric"
											autocomplete="one-time-code"
											maxlength="1"
											class="form-control tmCode" />
									</div>
								</div>
							</div>	

							<div class="form-group tmSubmitGroup">
								<div
									id="Login:check_code"
									class="btn bg-{$COLOR_PALETTE} btn-block"
									title="Отправить сообщение в Телеграм">Отправить код
								</div>
								<div id="Login:timer" class="tmTimer hidden"></div>
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
	
		<xsl:call-template name="initJS"/>
	</body>
</html>		
</xsl:template>

</xsl:stylesheet>

