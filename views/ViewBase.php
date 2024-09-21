<?php
require_once(FRAME_WORK_PATH.'basic_classes/ViewHTMLXSLT.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelStyleSheet.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelJavaScript.php');

require_once(FRAME_WORK_PATH.'basic_classes/ModelTemplate.php');
require_once(USER_CONTROLLERS_PATH.'Constant_Controller.php');
require_once(USER_CONTROLLERS_PATH.'MainMenuConstructor_Controller.php');

require_once(USER_CONTROLLERS_PATH.'AstCall_Controller.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelVars.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelTextOutput.php');


			
if (file_exists('models/MainMenu_Model_admin.php')){
require_once('models/MainMenu_Model_admin.php');
}
			
if (file_exists('models/MainMenu_Model_owner.php')){
require_once('models/MainMenu_Model_owner.php');
}
			
if (file_exists('models/MainMenu_Model_boss.php')){
require_once('models/MainMenu_Model_boss.php');
}
			
if (file_exists('models/MainMenu_Model_operator.php')){
require_once('models/MainMenu_Model_operator.php');
}
			
if (file_exists('models/MainMenu_Model_manager.php')){
require_once('models/MainMenu_Model_manager.php');
}
			
if (file_exists('models/MainMenu_Model_dispatcher.php')){
require_once('models/MainMenu_Model_dispatcher.php');
}
			
if (file_exists('models/MainMenu_Model_accountant.php')){
require_once('models/MainMenu_Model_accountant.php');
}
			
if (file_exists('models/MainMenu_Model_lab_worker.php')){
require_once('models/MainMenu_Model_lab_worker.php');
}
			
if (file_exists('models/MainMenu_Model_supplies.php')){
require_once('models/MainMenu_Model_supplies.php');
}
			
if (file_exists('models/MainMenu_Model_sales.php')){
require_once('models/MainMenu_Model_sales.php');
}
			
if (file_exists('models/MainMenu_Model_plant_director.php')){
require_once('models/MainMenu_Model_plant_director.php');
}
			
if (file_exists('models/MainMenu_Model_supervisor.php')){
require_once('models/MainMenu_Model_supervisor.php');
}
			
if (file_exists('models/MainMenu_Model_vehicle_owner.php')){
require_once('models/MainMenu_Model_vehicle_owner.php');
}
			
if (file_exists('models/MainMenu_Model_client.php')){
require_once('models/MainMenu_Model_client.php');
}
			
if (file_exists('models/MainMenu_Model_weighing.php')){
require_once('models/MainMenu_Model_weighing.php');
}
		
class ViewBase extends ViewHTMLXSLT {	
	/*
	protected static function getMenuClass(){
		//USER_MODELS_PATH
		$menu_class = NULL;
		$fl = NULL;
		if (file_exists($fl = OUTPUT_PATH.'MainMenu_Model_'.$_SESSION['user_id'].'.php')){
			$menu_class = 'MainMenu_Model_'.$_SESSION['user_id'];
		}
		else if (file_exists($fl = OUTPUT_PATH.'MainMenu_Model_'.$_SESSION['role_id'].'_'.$_SESSION['user_id'].'.php')){
			$menu_class = 'MainMenu_Model_'.$_SESSION['role_id'].'_'.$_SESSION['user_id'];
		}
		else if (file_exists($fl = OUTPUT_PATH.'MainMenu_Model_'.$_SESSION['role_id'].'.php')){
			$menu_class = 'MainMenu_Model_'.$_SESSION['role_id'];
		}
		if (!is_null($menu_class) && !is_null($fl)){
			require_once($fl);
		}
		return $menu_class;
	}
	*/
	protected function addMenu(&$models){
		if (isset($_SESSION['role_id'])){
			//USER_MODELS_PATH
			/*
			$menu_class = self::getMenuClass();
			if (is_null($menu_class)){
				//no menu exists yet
				if (!$GLOBALS['dbLink']){
					throw new Exception('Db link for addMenu is not defined!');
				}
				
				$contr = new MainMenuConstructor_Controller($GLOBALS['dbLink']);
				$contr->genMenuForUser($_SESSION['user_id'], $_SESSION['role_id']);
				$menu_class = self::getMenuClass();
				if (is_null($menu_class)){
					throw new Exception('No menu found!');
				}				
			}
			*/
			
			if (!$GLOBALS['dbLink']){
				throw new Exception('Db link for addMenu is not defined!');
			}
			$m_ar = $GLOBALS['dbLink']->query_first(sprintf(
				"SELECT model_content
				FROM (
					SELECT model_content from main_menus WHERE user_id = %d
					UNION ALL
					SELECT model_content from main_menus WHERE role_id='%s' AND user_id IS NULL
				) AS s
				LIMIT 1"
				,$_SESSION['user_id']
				,$_SESSION['role_id']
			));
			$models['mainMenu'] = new ModelTextOutput('MainMenu_Model', $m_ar['model_content']);
		}	
	}
	
	protected function addConstants(&$models){
		if (isset($_SESSION['role_id'])){

			if (!$GLOBALS['dbLink']){
				throw new Exception('Db link for addConstants is not defined!');
			}
		
			$contr = new Constant_Controller($GLOBALS['dbLink']);
			$list = array('doc_per_page_count','grid_refresh_interval','order_grid_refresh_interval','min_quant_for_ship_cost','def_lang','chart_step_quant','chart_max_quant');
			$models['ConstantValueList_Model'] = $contr->getConstantValueModel($list);						
		}	
	}

	public function __construct($name){
		parent::__construct($name);
		
		$this->addCssModel(new ModelStyleSheet('js20/assets/css/icons/icomoon/styles.css', date("Y-m-dTH:i:s", filemtime('js20/assets/css/icons/icomoon/styles.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/assets/css/bootstrap.css', date("Y-m-dTH:i:s", filemtime('js20/assets/css/bootstrap.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/assets/css/core.min.css', date("Y-m-dTH:i:s", filemtime('js20/assets/css/core.min.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/assets/css/components.min.css', date("Y-m-dTH:i:s", filemtime('js20/assets/css/components.min.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/assets/css/colors.min.css', date("Y-m-dTH:i:s", filemtime('js20/assets/css/colors.min.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/assets/css/icons/fontawesome/styles.min.css', date("Y-m-dTH:i:s", filemtime('js20/assets/css/icons/fontawesome/styles.min.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/custom-css/easyTree.css', date("Y-m-dTH:i:s", filemtime('js20/custom-css/easyTree.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/ext/bootstrap-datepicker/bootstrap-datepicker.standalone.min.css', date("Y-m-dTH:i:s", filemtime('js20/ext/bootstrap-datepicker/bootstrap-datepicker.standalone.min.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/ext/chart.js-2.8.0/Chart.min.css', date("Y-m-dTH:i:s", filemtime('js20/ext/chart.js-2.8.0/Chart.min.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/custom-css/style.css', date("Y-m-dTH:i:s", filemtime('js20/custom-css/style.css')) ));
		$this->addCssModel(new ModelStyleSheet('js20/custom-css/print.css', date("Y-m-dTH:i:s", filemtime('js20/custom-css/print.css')) ));
	
		if (!DEBUG){
			$this->addJsModel(new ModelJavaScript('js20/assets/js/core/libraries/jquery.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/core/libraries/jquery.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/assets/js/core/libraries/bootstrap.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/core/libraries/bootstrap.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/assets/js/plugins/loaders/blockui.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/plugins/loaders/blockui.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/assets/js/core/app.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/core/app.js')) ));$this->addJsModel(new ModelJavaScript('js20/assets/js/plugins/forms/styling/switchery.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/plugins/forms/styling/switchery.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/assets/js/plugins/forms/styling/uniform.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/plugins/forms/styling/uniform.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/ext/bootstrap-datepicker/bootstrap-datepicker.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/bootstrap-datepicker/bootstrap-datepicker.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/ext/bootstrap-datepicker/bootstrap-datepicker.ru.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/bootstrap-datepicker/bootstrap-datepicker.ru.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/ext/cleave/cleave.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/cleave/cleave.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/ext/cleave/cleave-phone.ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/cleave/cleave-phone.ru.js')) ));$this->addJsModel(new ModelJavaScript('js20/ext/mustache/mustache.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/mustache/mustache.min.js')) ));$this->addJsModel(new ModelJavaScript('js20/ext/jshash-2.2/md5-min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/jshash-2.2/md5-min.js')) ));$this->addJsModel(new ModelJavaScript('js20/ext/OpenLayers/OpenLayers.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/OpenLayers/OpenLayers.js')) ));$this->addJsModel(new ModelJavaScript('js20/ext/chart.js-2.8.0/Chart.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/chart.js-2.8.0/Chart.min.js')) ));
			$this->addJsModel(new ModelJavaScript(USER_JS_PATH.'lib.js', NULL, date("Y-m-dTH:i:s", filemtime(USER_JS_PATH.'')) ));
			$script_id = VERSION;
		}
		else{		
			
		
		
		$this->addJsModel(new ModelJavaScript('js20/assets/js/core/libraries/jquery.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/core/libraries/jquery.min.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/assets/js/core/libraries/bootstrap.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/core/libraries/bootstrap.min.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/assets/js/plugins/loaders/blockui.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/plugins/loaders/blockui.min.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/assets/js/core/app.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/core/app.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/assets/js/plugins/forms/styling/switchery.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/plugins/forms/styling/switchery.min.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/assets/js/plugins/forms/styling/uniform.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/assets/js/plugins/forms/styling/uniform.min.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/ext/bootstrap-datepicker/bootstrap-datepicker.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/bootstrap-datepicker/bootstrap-datepicker.min.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/ext/bootstrap-datepicker/bootstrap-datepicker.ru.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/bootstrap-datepicker/bootstrap-datepicker.ru.min.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/jquery.maskedinput.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/jquery.maskedinput.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/ext/cleave/cleave.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/cleave/cleave.min.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/ext/cleave/cleave-phone.ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/cleave/cleave-phone.ru.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/ext/mustache/mustache.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/mustache/mustache.min.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/ext/jshash-2.2/md5-min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/jshash-2.2/md5-min.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/ext/DragnDrop/DragMaster.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/DragnDrop/DragMaster.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/ext/DragnDrop/DragObject.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/DragnDrop/DragObject.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/ext/DragnDrop/DropTarget.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/DragnDrop/DropTarget.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/ext/GooglePolylineEncode.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/GooglePolylineEncode.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/core/extend.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/extend.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/App.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/App.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/AppWin.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/AppWin.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/CommonHelper.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/CommonHelper.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/DOMHelper.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/DOMHelper.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/DateHelper.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/DateHelper.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/EventHelper.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/EventHelper.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FatalException.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FatalException.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/DbException.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/DbException.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/VersException.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/VersException.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ConstantManager.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ConstantManager.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/SessionVarManager.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/SessionVarManager.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/CookieManager.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/CookieManager.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ServConnector.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ServConnector.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/AppSrv.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/AppSrv.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/core/AppSrv.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/AppSrv.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/core/Response.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/Response.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ResponseXML.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ResponseXML.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ResponseJSON.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ResponseJSON.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/PublicMethod.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/PublicMethod.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/PublicMethodServer.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/PublicMethodServer.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ControllerObj.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ControllerObj.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ControllerObjServer.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ControllerObjServer.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ControllerObjClient.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ControllerObjClient.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelXML.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelXML.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelObjectXML.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelObjectXML.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelServRespXML.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelServRespXML.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelJSON.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelJSON.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelObjectJSON.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelObjectJSON.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelServRespJSON.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelServRespJSON.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelXMLTree.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelXMLTree.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelJSONTree.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelJSONTree.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/core/Validator.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/Validator.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorString.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorString.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorBool.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorBool.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorDate.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorDate.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorDateTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorDateTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorInterval.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorInterval.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorInt.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorInt.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorFloat.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorFloat.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorEnum.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorEnum.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorJSON.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorJSON.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorArray.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorArray.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorEmail.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorEmail.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ValidatorXML.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ValidatorXML.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/Field.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/Field.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldString.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldString.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldEnum.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldEnum.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldBool.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldBool.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldDate.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldDate.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldDateTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldDateTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldDateTimeTZ.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldDateTimeTZ.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldInt.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldInt.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldBigInt.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldBigInt.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldSmallInt.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldSmallInt.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldFloat.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldFloat.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldPassword.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldPassword.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldText.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldText.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldInterval.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldInterval.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldJSON.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldJSON.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldJSONB.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldJSONB.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldArray.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldArray.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldXML.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldXML.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/FieldBytea.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/FieldBytea.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/ModelFilter.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/ModelFilter.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/core/RefType.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/RefType.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/core/rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/core/rs_ru.js')) ));
	}

		
		$this->addJsModel(new ModelJavaScript('js20/controls/DataBinding.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/DataBinding.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/Command.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/Command.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/CommandBinding.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/CommandBinding.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/Control.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/Control.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/Control.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/Control.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ControlContainer.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ControlContainer.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ControlContainer.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ControlContainer.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/ViewAjx.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewAjx.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewAjx.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewAjx.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewAjxList.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewAjxList.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/Calculator.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/Calculator.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/Calculator.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/Calculator.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/Button.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/Button.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonCtrl.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonCtrl.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonEditCtrl.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonEditCtrl.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonEditCtrl.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonEditCtrl.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonCalc.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonCalc.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonCalc.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonCalc.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonCalendar.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonCalendar.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonCalendar.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonCalendar.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonClear.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonClear.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonClear.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonClear.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonEditPeriodValues.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonEditPeriodValues.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonEditPeriodValues.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonEditPeriodValues.rs_ru.js')) ));
	}

		
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ButtonCmd.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ButtonCmd.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonExpToExcel.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonExpToExcel.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonExpToExcel.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonExpToExcel.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonExpToPDF.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonExpToPDF.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonExpToPDF.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonExpToPDF.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonOpen.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonOpen.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonOpen.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonOpen.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonInsert.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonInsert.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonInsert.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonInsert.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonPrint.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonPrint.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonPrint.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonPrint.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonPrintList.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonPrintList.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonPrintList.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonPrintList.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonSelectRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonSelectRef.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonSelectRef.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonSelectRef.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonSelectDataType.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonSelectDataType.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonSelectDataType.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonSelectDataType.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonMakeSelection.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonMakeSelection.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonMakeSelection.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonMakeSelection.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonToggle.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonToggle.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonCall.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonCall.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonCall.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonCall.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/Label.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/Label.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/Edit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/Edit.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/Edit.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/Edit.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/EditString.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditString.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditText.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditText.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditNum.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditNum.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditInt.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditInt.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditFloat.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditFloat.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditFloatPeriodValue.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditFloatPeriodValue.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditMoney.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditMoney.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditPhone.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditPhone.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditEmail.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditEmail.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditEmail.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditEmail.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/EditPercent.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditPercent.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditDate.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditDate.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditDateTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditDateTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditInterval.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditInterval.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditPassword.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditPassword.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditCheckBox.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditCheckBox.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditSwitcher.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditSwitcher.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditContainer.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditContainer.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditContainer.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditContainer.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/EditRadioGroup.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditRadioGroup.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditRadio.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditRadio.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditSelect.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditSelect.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditSelectRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditSelectRef.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditSelectRef.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditSelectRef.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/EditSelectOption.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditSelectOption.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditSelectOptionRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditSelectOptionRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditRadioGroupRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditRadioGroupRef.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditRadioGroupRef.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditRadioGroupRef.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/PrintObj.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/PrintObj.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditModalDialog.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditModalDialog.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditModalDialog.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditModalDialog.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/EditRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditRefMultyType.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditRefMultyType.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditRefMultyType.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditRefMultyType.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ControlForm.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ControlForm.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/HiddenKey.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/HiddenKey.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/EditJSON.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditJSON.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditFile.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditFile.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditFile.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditFile.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/EditCompound.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditCompound.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditCompound.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditCompound.rs_ru.js')) ));
	}

		
		$this->addJsModel(new ModelJavaScript('js20/controls/ControlDate.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ControlDate.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnBool.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnBool.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnPhone.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnPhone.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnEmail.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnEmail.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnFloat.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnFloat.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnByte.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnByte.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnDate.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnDate.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnDateTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnDateTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnEnum.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnEnum.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridColumnInterval.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridColumnInterval.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCell.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCell.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCellHead.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCellHead.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCellFoot.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCellFoot.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCellPhone.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCellPhone.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCellPhone.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCellPhone.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCellDetailToggle.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCellDetailToggle.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCellDetailToggle.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCellDetailToggle.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridHead.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridHead.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridRow.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridRow.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridFoot.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridFoot.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridBody.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridBody.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/Grid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/Grid.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/Grid.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/Grid.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridSearchInf.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridSearchInf.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridSearchInf.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridSearchInf.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/VariantStorage.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/VariantStorage.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCommands.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCommands.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmd.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmd.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdContainer.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdContainer.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdContainer.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdContainer.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdContainerAjx.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdContainerAjx.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdContainerObj.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdContainerObj.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdInsert.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdInsert.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdInsert.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdInsert.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdEdit.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdEdit.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdEdit.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdCopy.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdCopy.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdCopy.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdCopy.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdDelete.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdDelete.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdDelete.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdDelete.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdColManager.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdColManager.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdColManager.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdColManager.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdPrint.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdPrint.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdPrint.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdPrint.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdRefresh.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdRefresh.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdRefresh.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdRefresh.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdPrintObj.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdPrintObj.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdSearch.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdSearch.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdSearch.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdSearch.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdExport.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdExport.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdExport.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdExport.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdExportExcelLocal.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdExportExcelLocal.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdExportExcelLocal.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdExportExcelLocal.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdAllCommands.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdAllCommands.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdAllCommands.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdAllCommands.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdDOCUnprocess.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdDOCUnprocess.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdDOCUnprocess.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdDOCUnprocess.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdDOCShowActs.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdDOCShowActs.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdDOCShowActs.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdDOCShowActs.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdRowUp.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdRowUp.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdRowUp.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdRowUp.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdRowDown.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdRowDown.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdRowDown.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdRowDown.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdFilter.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdFilter.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdFilter.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdFilter.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdFilterView.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdFilterView.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdFilterView.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdFilterView.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdFilterSave.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdFilterSave.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdFilterSave.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdFilterSave.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCmdFilterOpen.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCmdFilterOpen.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCmdFilterOpen.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCmdFilterOpen.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewGridColManager.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewGridColManager.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewGridColManager.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewGridColManager.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewGridColParam.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewGridColParam.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewGridColParam.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewGridColParam.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewGridColVisibility.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewGridColVisibility.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewGridColVisibility.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewGridColVisibility.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewGridColOrder.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewGridColOrder.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewGridColOrder.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewGridColOrder.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/VariantStorageSaveView.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/VariantStorageSaveView.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/VariantStorageSaveView.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/VariantStorageSaveView.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/VariantStorageOpenView.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/VariantStorageOpenView.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/VariantStorageOpenView.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/VariantStorageOpenView.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridAjx.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridAjx.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridAjx.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridAjx.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridAjxScroll.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridAjxScroll.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/TreeAjx.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/TreeAjx.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridAjxDOCT.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridAjxDOCT.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridAjxMaster.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridAjxMaster.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCommandsAjx.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCommandsAjx.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCommandsAjx.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCommandsAjx.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridCommandsDOC.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCommandsDOC.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridCommandsDOC.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridCommandsDOC.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridPagination.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridPagination.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridPagination.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridPagination.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/GridFilterInfo.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridFilterInfo.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridFilter.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridFilter.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/GridFilter.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/GridFilter.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/EditPeriodDate.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditPeriodDate.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/EditPeriodDate.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/EditPeriodDate.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/EditPeriodDateTime.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/EditPeriodDateTime.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonOK.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonOK.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonOK.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonOK.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonSave.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonSave.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonSave.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonSave.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonCancel.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonCancel.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonCancel.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonCancel.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewObjectAjx.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewObjectAjx.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewObjectAjx.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewObjectAjx.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewGridEditInlineAjx.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewGridEditInlineAjx.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewGridEditInlineAjx.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewGridEditInlineAjx.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewDOC.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewDOC.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewDOC.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewDOC.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/WindowPrint.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowPrint.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/WindowPrint.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/WindowPrint.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/WindowQuestion.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowQuestion.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/WindowQuestion.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/WindowQuestion.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/WindowSearch.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowSearch.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/WindowSearch.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/WindowSearch.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/WindowForm.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowForm.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/WindowForm.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/WindowForm.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/WindowFormObject.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowFormObject.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/WindowFormObject.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/WindowFormObject.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/WindowFormModalBS.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowFormModalBS.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/WindowFormModalBS.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/WindowFormModalBS.rs_ru.js')) ));
	}

		
		$this->addJsModel(new ModelJavaScript('js20/controls/WindowMessage.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowMessage.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/WindowTempMessage.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowTempMessage.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCellHeadDOCProcessed.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCellHeadDOCProcessed.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCellHeadDOCDate.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCellHeadDOCDate.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/GridCellHeadDOCNumber.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/GridCellHeadDOCNumber.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/actb.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/actb.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/actb.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/actb.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/RepCommands.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/RepCommands.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/RepCommands.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/RepCommands.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ViewReport.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewReport.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ViewReport.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ViewReport.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/PopUpMenu.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/PopUpMenu.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/PopOver.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/PopOver.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/PeriodSelect.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/PeriodSelect.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/PeriodSelect.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/PeriodSelect.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/WindowAbout.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WindowAbout.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/WindowAbout.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/WindowAbout.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/MainMenuTree.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/MainMenuTree.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/MainMenuTree.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/MainMenuTree.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ButtonOrgSearch.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ButtonOrgSearch.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ButtonOrgSearch.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ButtonOrgSearch.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/ConstantGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ConstantGrid.js')) ));
			
	if (
	(isset($_SESSION['locale_id']) && $_SESSION['locale_id']=='ru')
	||
	(!isset($_SESSION['locale_id']) && DEF_LOCALE=='ru')
	){
		$this->addJsModel(new ModelJavaScript('js20/controls/rs/ConstantGrid.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/rs/ConstantGrid.rs_ru.js')) ));
	}

		$this->addJsModel(new ModelJavaScript('js20/controls/Captcha.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/Captcha.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/ViewTemplate.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ViewTemplate.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/ToolTip.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/ToolTip.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controls/WaitControl.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controls/WaitControl.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/controllers/User_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/User_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Constant_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Constant_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Enum_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Enum_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Client_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Client_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Supplier_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Supplier_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/DOCMaterialProcurement_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/DOCMaterialProcurement_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ConcreteType_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ConcreteType_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Destination_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Destination_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Driver_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Driver_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Order_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Order_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterial_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterial_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialConsRateDate_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialConsRateDate_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialConsRate_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialConsRate_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Shipment_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Shipment_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Vehicle_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Vehicle_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleSchedule_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleSchedule_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Graph_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Graph_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Shift_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Shift_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Lang_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Lang_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/SMSPattern_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/SMSPattern_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/LabData_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/LabData_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/LabEntry_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/LabEntry_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/LabEntryDetail_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/LabEntryDetail_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialProcurUpload_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialProcurUpload_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RAMaterialConsumption_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RAMaterialConsumption_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/DOCMaterialInventory_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/DOCMaterialInventory_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/DOCMaterialInventoryDOCTMaterial_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/DOCMaterialInventoryDOCTMaterial_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialProcurRate_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialProcurRate_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/OrderFromClient_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/OrderFromClient_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Caller_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Caller_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialStoreUserData_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialStoreUserData_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Employee_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Employee_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/EmployeeWorkTimeSchedule_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/EmployeeWorkTimeSchedule_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/AstCall_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/AstCall_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/UserMacAddress_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/UserMacAddress_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ClientTel_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ClientTel_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ClientType_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ClientType_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ClientComeFrom_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ClientComeFrom_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/PumpVehicle_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/PumpVehicle_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/PumpPrice_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/PumpPrice_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/PumpPriceValue_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/PumpPriceValue_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Quarry_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Quarry_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/SandQuarryVal_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/SandQuarryVal_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/StoneQuarryVal_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/StoneQuarryVal_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/SpecialistRequest_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/SpecialistRequest_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/SiteFeedBack_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/SiteFeedBack_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/EmailTemplate_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/EmailTemplate_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ClientValidDuplicate_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ClientValidDuplicate_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/OrderPump_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/OrderPump_Controller.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/views/Login_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/Login_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/About_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/About_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/PasswordRecovery_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/PasswordRecovery_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ConstantList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ConstantList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ViewList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ViewList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MainMenuConstructorList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MainMenuConstructorList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MainMenuConstructor_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MainMenuConstructor_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LoginList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LoginList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LoginDeviceList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LoginDeviceList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/UserList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/UserList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/UserDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/UserDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/UserProfile_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/UserProfile_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MailForSendingList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MailForSendingList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MailForSending_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MailForSending_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/UserMacAddressList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/UserMacAddressList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/EmployeeList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/EmployeeList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ClientComeFromList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ClientComeFromList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ClientTypeList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ClientTypeList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentTimeNormList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentTimeNormList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DriverList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DriverList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/SupplierDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/SupplierDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/SupplierList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/SupplierList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleScheduleDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleScheduleDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleScheduleList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleScheduleList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/QuarryList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/QuarryList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LangList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LangList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderGarbageList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderGarbageList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderForSelectList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderForSelectList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentForVehOwnerList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentForVehOwnerList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentForClientVehOwnerList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentForClientVehOwnerList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentForClientList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentForClientList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderForClientList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderForClientList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentTimeList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentTimeList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentDateList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentDateList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/AstCallList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/AstCallList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DOCMaterialProcurementList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DOCMaterialProcurementList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DOCMaterialProcurementDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DOCMaterialProcurementDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DOCMaterialProcurementShiftList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DOCMaterialProcurementShiftList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentForOrderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentForOrderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialConsRateDateList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialConsRateDateList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialConsRateList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialConsRateList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderPumpList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderPumpList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderGarbageDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderGarbageDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderMakeList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderMakeList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ClientList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ClientList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ClientDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ClientDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ConcreteTypeList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ConcreteTypeList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DestinationList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DestinationList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DestinationDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DestinationDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/PumpVehicleList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/PumpVehicleList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/PumpVehicleDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/PumpVehicleDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/PumpPriceList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/PumpPriceList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/PumpPriceValueList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/PumpPriceValueList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleScheduleMakeOrderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleScheduleMakeOrderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialProcurUpload_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialProcurUpload_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialProcurRateList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialProcurRateList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/Map_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/Map_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleStopsReport_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleStopsReport_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleScheduleReportAll_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleScheduleReportAll_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ScheduleGen_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ScheduleGen_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DriverCheatReport_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DriverCheatReport_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RouteToDestAvgTimeRep_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RouteToDestAvgTimeRep_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleEfficiency_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleEfficiency_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OperatorList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OperatorList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleRun_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleRun_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ProductionSiteList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ProductionSiteList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ProductionSiteForEditList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ProductionSiteForEditList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ProductionBaseList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ProductionBaseList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipQuantForCostGradeList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipQuantForCostGradeList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/SupplierOrderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/SupplierOrderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialProcurUploadList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialProcurUploadList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RAMaterialConsumptionDateList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RAMaterialConsumptionDateList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RAMaterialConsumptionDocList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RAMaterialConsumptionDocList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/AstIncomeCall_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/AstIncomeCall_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/AstIncomeUnknownCall_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/AstIncomeUnknownCall_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/SMSForSendingList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/SMSForSendingList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/SMSPatternList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/SMSPatternList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/SMSPatternDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/SMSPatternDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/SMSPatternUserPhoneList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/SMSPatternUserPhoneList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/TrackerZoneControlList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/TrackerZoneControlList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/AssignedVehicleList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/AssignedVehicleList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/AstCallClientCallHistoryList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/AstCallClientCallHistoryList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/AstCallClientShipHistoryList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/AstCallClientShipHistoryList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderCalc_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderCalc_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ClientTelList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ClientTelList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/EmployeeWorkTimeScheduleList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/EmployeeWorkTimeScheduleList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ClientValidDuplicateList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ClientValidDuplicateList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LabEntryReportList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LabEntryReportList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/AstCallManagerReport_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/AstCallManagerReport_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/SandQuarryValList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/SandQuarryValList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/StoneQuarryValList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/StoneQuarryValList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LabEntryItemOnRatePeriodReport_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LabEntryItemOnRatePeriodReport_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LabEntryItemReport_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LabEntryItemReport_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LabEntryAvgReport_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LabEntryAvgReport_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentForDriverCostHeaderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentForDriverCostHeaderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentForDriverCostList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentForDriverCostList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentForOwnerCostHeaderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentForOwnerCostHeaderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentForOwnerCostList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentForOwnerCostList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ConcreteCostHeaderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ConcreteCostHeaderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ConcreteCostList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ConcreteCostList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ConcreteCostForOwnerHeaderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ConcreteCostForOwnerHeaderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ConcreteCostForOwnerList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ConcreteCostForOwnerList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleOwnerList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleOwnerList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleOwnerConcretePriceList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleOwnerConcretePriceList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleOwnerClientList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleOwnerClientList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentCancelationList.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentCancelationList.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentPumpList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentPumpList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentPumpForVehOwnerList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentPumpForVehOwnerList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/UserOperatorList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/UserOperatorList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleOwnerTotReport_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleOwnerTotReport_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MatTotalList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MatTotalList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MatCorrectList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MatCorrectList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ConcreteTypeMapToProductionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ConcreteTypeMapToProductionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/UserMapToProductionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/UserMapToProductionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialMapToProductionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialMapToProductionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MaterialFactConsumptionUpload_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MaterialFactConsumptionUpload_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MaterialFactConsumptionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MaterialFactConsumptionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MaterialFactConsumptionRolledList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MaterialFactConsumptionRolledList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MaterialFactConsumptionCorretionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MaterialFactConsumptionCorretionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MaterialFactBalanceCorretionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MaterialFactBalanceCorretionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LabEntryList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LabEntryList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LabEntryDetailList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LabEntryDetailList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderMakeForLabList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderMakeForLabList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderMakeForLabDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderMakeForLabDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/OrderMakeForWeighingList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/OrderMakeForWeighingList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/CementSiloList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/CementSiloList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/CementSiloForOrderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/CementSiloForOrderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/MaterialStoreForOrderList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/MaterialStoreForOrderList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ProductionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ProductionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ProductionVehicleCorrectionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ProductionVehicleCorrectionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ProductionMaterialList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ProductionMaterialList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ELKONLogList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ELKONLogList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/CementSiloBalanceResetList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/CementSiloBalanceResetList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RepMaterialFactConsumption_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RepMaterialFactConsumption_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RepMaterialAction_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RepMaterialAction_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RepMaterialActionByShift_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RepMaterialActionByShift_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RepMaterialConsToleranceViolation_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RepMaterialConsToleranceViolation_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialPriceList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialPriceList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialPriceForNormList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialPriceForNormList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RepMaterialAvgConsumptionOnCtp_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RepMaterialAvgConsumptionOnCtp_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RepShipProdQuantDif_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RepShipProdQuantDif_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ClientSpecificationList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ClientSpecificationList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/GPSTrackerList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/GPSTrackerList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/StoreMapToProductionSiteList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/StoreMapToProductionSiteList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/GornyiCarrierMatchList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/GornyiCarrierMatchList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RoleViewRestrictionList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RoleViewRestrictionList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ExcelTemplateList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ExcelTemplateList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ExcelTemplateDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ExcelTemplateDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/Bank_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/Bank_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/BankList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/BankList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/PeriodValueList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/PeriodValueList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/TmUserList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/TmUserList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/TmUserPhotoList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/TmUserPhotoList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/TmOutMessageList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/TmOutMessageList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/TmInMessageList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/TmInMessageList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/PostList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/PostList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/PostDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/PostDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ContactList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ContactList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ContactDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ContactDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/EntityContactList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/EntityContactList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialTicketList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialTicketList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/RawMaterialTicketClose_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/RawMaterialTicketClose_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LabChart1Rep_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LabChart1Rep_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/LabChart2Rep_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/LabChart2Rep_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DriverDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DriverDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DestinationProdBasePrice_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DestinationProdBasePrice_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/DestinationProdBaseDriverPriceList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/DestinationProdBaseDriverPriceList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleTotRepItemDialog_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleTotRepItemDialog_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleTotRepItemList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleTotRepItemList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleTotRepCommonItemList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleTotRepCommonItemList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleTotRepBalanceList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleTotRepBalanceList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/TaskImportanceLevelList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/TaskImportanceLevelList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ProgUpdateList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ProgUpdateList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ProgUpdateDetailList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ProgUpdateDetailList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/QualityPassport_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/QualityPassport_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/Firm1cList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/Firm1cList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ClientDebtList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ClientDebtList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/QualityPassportList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/QualityPassportList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ShipmentMediaList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ShipmentMediaList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/ChatStatusList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/ChatStatusList_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/VehicleOwnerTotIncomeAllRep_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/VehicleOwnerTotIncomeAllRep_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/CementSiloMaterialList_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/CementSiloMaterialList_View.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/forms/ViewList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ViewList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/MainMenuConstructor_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/MainMenuConstructor_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/User_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/User_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/UserList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/UserList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/DriverDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/DriverDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/SupplierDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/SupplierDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/VehicleDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/VehicleDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/VehicleScheduleDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/VehicleScheduleDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/DriverList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/DriverList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/Driver_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/Driver_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/OrderDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/OrderDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/OrderGarbageDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/OrderGarbageDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/Client_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/Client_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/ClientList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ClientList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/ClientTelList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ClientTelList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/DestinationList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/DestinationList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/Destination_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/Destination_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/PumpVehicleList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/PumpVehicleList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/PumpVehicle_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/PumpVehicle_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/VehicleList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/VehicleList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/Vehicle_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/Vehicle_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/VehicleScheduleMakeOrderList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/VehicleScheduleMakeOrderList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/SupplierList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/SupplierList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/SMSPatternDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/SMSPatternDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/ClientDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ClientDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/ShipmentDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ShipmentDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/QuarryList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/QuarryList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/VehicleOwnerList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/VehicleOwnerList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/OrderList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/OrderList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/ShipmentList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ShipmentList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/RawMaterial_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/RawMaterial_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/RawMaterialConsRateDateList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/RawMaterialConsRateDateList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/DOCMaterialProcurementDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/DOCMaterialProcurementDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/ExcelTemplateDialog_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ExcelTemplateDialog_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/Bank_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/Bank_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/BankList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/BankList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/PostList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/PostList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/Post_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/Post_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/Contact_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/Contact_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/ContactList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ContactList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/ClientSpecificationList_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/ClientSpecificationList_Form.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/forms/VehicleTotRepItem_Form.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/forms/VehicleTotRepItem_Form.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/tmpl/App.templates.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/tmpl/App.templates.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditDateInlineValidation.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditDateInlineValidation.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/App.predefinedItems.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/App.predefinedItems.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ErrorControl.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ErrorControl.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/AppBeton.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/AppBeton.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Pagination.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Pagination.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ViewSectionSelect.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ViewSectionSelect.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/UserEditRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/UserEditRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ViewEditRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ViewEditRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/UserNameEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/UserNameEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/UserPwdEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/UserPwdEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/rs/UserPwdEdit.rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/rs/UserPwdEdit.rs_ru.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/DriverEditRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/DriverEditRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleOwnerEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleOwnerEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/MakeEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/MakeEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/FeatureEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/FeatureEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/TrackerEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/TrackerEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/LangEditRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/LangEditRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/GPSTrackerRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/GPSTrackerRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditPeriodShift.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditPeriodShift.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditPeriodMonth.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditPeriodMonth.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditPeriodWeek.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditPeriodWeek.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditPeriodDateShift.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditPeriodDateShift.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PlantLoadGraphControl.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PlantLoadGraphControl.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ClientTypeEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ClientTypeEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ClientComeFromEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ClientComeFromEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ClientNameEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ClientNameEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ClientNameFullEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ClientNameFullEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ConcreteTypeEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ConcreteTypeEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/DestinationEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/DestinationEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/DestinationForClientEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/DestinationForClientEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/DestinationForOrderEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/DestinationForOrderEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/DestinationSearchEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/DestinationSearchEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ClientEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ClientEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/DriverEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/DriverEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ClientTelEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ClientTelEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PumpVehicleEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PumpVehicleEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleSelect.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleSelect.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleScheduleEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleScheduleEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PumpPriceEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PumpPriceEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/OrderDescrEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/OrderDescrEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/OrderTimeSelect.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/OrderTimeSelect.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/AvailOrderTimeControl.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/AvailOrderTimeControl.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/SupplierEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/SupplierEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleScheduleGridCmdSetFree.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleScheduleGridCmdSetFree.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleScheduleGridCmdSetOut.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleScheduleGridCmdSetOut.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleScheduleGridCmdShowPosition.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleScheduleGridCmdShowPosition.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleScheduleGridCmdShowVehicle.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleScheduleGridCmdShowVehicle.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PrintInvoiceBtn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PrintInvoiceBtn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PrintTTNBtn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PrintTTNBtn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PrintPutevoiListBtn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PrintPutevoiListBtn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentGridCmdPrintInvoice.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentGridCmdPrintInvoice.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentGridCmdPrintPass.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentGridCmdPrintPass.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PrintPassBtn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PrintPassBtn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentGridCmdPrintTTN.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentGridCmdPrintTTN.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentGridCmdPrintPutevoiList.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentGridCmdPrintPutevoiList.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentGridCmdChangeOrder.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentGridCmdChangeOrder.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentGridCmdDelete.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentGridCmdDelete.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RawMaterialConsRateCalcBtn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RawMaterialConsRateCalcBtn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RawMaterialConsRateInsOnBaseBtn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RawMaterialConsRateInsOnBaseBtn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RawMaterialConsRateDateGridCmd.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RawMaterialConsRateDateGridCmd.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RawMaterialConsRateDateGridCmdInsOnBase.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RawMaterialConsRateDateGridCmdInsOnBase.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RawMaterialConsRateGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RawMaterialConsRateGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Statistics_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Statistics_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleRunGridCmdShowMap.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleRunGridCmdShowMap.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditMoneyEditable.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditMoneyEditable.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/OrderMakeGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/OrderMakeGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ProductionSiteEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ProductionSiteEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ProductionBaseEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ProductionBaseEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/DOCMaterialProcurementShiftGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/DOCMaterialProcurementShiftGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/MaterialSelect.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/MaterialSelect.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RAMaterialConsumptionDateGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RAMaterialConsumptionDateGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RAMaterialConsumptionDocGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RAMaterialConsumptionDocGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PeriodSelectBeton.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PeriodSelectBeton.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditColorPalette.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditColorPalette.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/AssignedVehicleGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/AssignedVehicleGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Weather.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Weather.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleDriverForSchedGenGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleDriverForSchedGenGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EmployeeWorkTimeScheduleGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EmployeeWorkTimeScheduleGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/QuarryEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/QuarryEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/OrderEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/OrderEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ConcreteCostForOwnerHeadEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ConcreteCostForOwnerHeadEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentForVehOwnerCmdSetAgreed.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentForVehOwnerCmdSetAgreed.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ShipmentPumpForVehOwnerCmdSetAgreed.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ShipmentPumpForVehOwnerCmdSetAgreed.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/MatTotalGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/MatTotalGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/MatCorrectGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/MatCorrectGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/TelListGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/TelListGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleScheduleMakeOrderGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleScheduleMakeOrderGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/MaterialMakeOrderGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/MaterialMakeOrderGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/OwnerListGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/OwnerListGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ClientLocalListGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ClientLocalListGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PumpVehiclePriceListGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PumpVehiclePriceListGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/CementSiloEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/CementSiloEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ProductionSiteCmdLoadProduction.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ProductionSiteCmdLoadProduction.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ProductionMaterialListGridInsertCmd.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ProductionMaterialListGridInsertCmd.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ProductionMaterialListGridDelCmd.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ProductionMaterialListGridDelCmd.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RawMaterialConsRateDateEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RawMaterialConsRateDateEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ExcelTemplateFieldMatchGrid.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ExcelTemplateFieldMatchGrid.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EditBankAcc.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EditBankAcc.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/BankEditRef.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/BankEditRef.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Chat_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Chat_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/TmChat_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/TmChat_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Notification_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Notification_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/TmNotification_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/TmNotification_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/UserChatNotification_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/UserChatNotification_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/SendNotificationCmd.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/SendNotificationCmd.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/SendNotificationBtn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/SendNotificationBtn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/UserChat_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/UserChat_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/UserChatUserList.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/UserChatUserList.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/UserTel.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/UserTel.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/UserCode.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/UserCode.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/LoginTM.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/LoginTM.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/PostEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/PostEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ContactEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ContactEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Enum_entity_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Enum_entity_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/EnumGridColumn_entity_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/EnumGridColumn_entity_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RawMaterialTicketGridCmdIssue.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RawMaterialTicketGridCmdIssue.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/RawMaterialTicketIssueBtn.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/RawMaterialTicketIssueBtn.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ClientSpecificationEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ClientSpecificationEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleScheduleEdit_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleScheduleEdit_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleOwnerTotIncomeRep_View.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleOwnerTotIncomeRep_View.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/TaskImportanceLevelEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/TaskImportanceLevelEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Client1cEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Client1cEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Firm1cEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Firm1cEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ChatStatusEdit.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ChatStatusEdit.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/rs_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/rs_ru.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/views/rs_common_ru.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/views/rs_common_ru.js')) ));
		
		$this->addJsModel(new ModelJavaScript('js20/ext/OpenLayers/OpenLayers.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/OpenLayers/OpenLayers.js')) ));
		
		
		$this->addJsModel(new ModelJavaScript('js20/ext/chart.js-2.8.0/Chart.min.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/ext/chart.js-2.8.0/Chart.min.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/TrackConstants.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/TrackConstants.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ObjMapLayer.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ObjMapLayer.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/GeoZones.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/GeoZones.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/ZoneDrawingControl.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/ZoneDrawingControl.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/VehicleLayer.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/VehicleLayer.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/Markers.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/Markers.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/TrackLayer.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/TrackLayer.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ShipmentTimeNorm_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ShipmentTimeNorm_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/MainMenu_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/MainMenu_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/MainMenuConstructor_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/MainMenuConstructor_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/MainMenuContent_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/MainMenuContent_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/View_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/View_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VariantStorage_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VariantStorage_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConstantList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConstantList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/View_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/View_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ViewList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ViewList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ViewSectionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ViewSectionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MainMenuConstructor_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MainMenuConstructor_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MainMenuConstructorList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MainMenuConstructorList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MainMenuConstructorDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MainMenuConstructorDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MainMenuContent_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MainMenuContent_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VariantStorage_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VariantStorage_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VariantStorageList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VariantStorageList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/About_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/About_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/User_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/User_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Client_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Client_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Destination_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Destination_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteType_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteType_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Vehicle_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Vehicle_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Driver_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Driver_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterial_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterial_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialProcurRate_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialProcurRate_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialProcurRateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialProcurRateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialProcurUpload_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialProcurUpload_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialProcurUploadView_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialProcurUploadView_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialMinQuant_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialMinQuant_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialConsRateDate_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialConsRateDate_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialConsRate_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialConsRate_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialConsRateDateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialConsRateDateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/PumpPrice_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/PumpPrice_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/PumpPriceValue_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/PumpPriceValue_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/PumpVehicle_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/PumpVehicle_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/PumpVehicleList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/PumpVehicleList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Order_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Order_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderPump_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderPump_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderPumpList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderPumpList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Offer_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Offer_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderMakeList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderMakeList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Shipment_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Shipment_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentForOrderList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentForOrderList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentPumpList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentPumpList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentDateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentDateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentTimeList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentTimeList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentOperator_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentOperator_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleSchedule_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleSchedule_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OutComment_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OutComment_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleScheduleList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleScheduleList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleScheduleComplete_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleScheduleComplete_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleScheduleState_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleScheduleState_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentRep_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentRep_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Supplier_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Supplier_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SupplierList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SupplierList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialProcurement_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialProcurement_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialProcurementList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialProcurementList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialInventory_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialInventory_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialInventoryList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialInventoryList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialInventoryDOCTMaterial_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialInventoryDOCTMaterial_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialInventoryDOCTMaterialList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialInventoryDOCTMaterialList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialInventoryDOCTFMaterial_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialInventoryDOCTFMaterial_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RGMaterialConsuption_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RGMaterialConsuption_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RAMaterialConsumption_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RAMaterialConsumption_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RAMaterialConsumptionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RAMaterialConsumptionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RGMaterial_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RGMaterial_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RAMaterial_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RAMaterial_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Shift_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Shift_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Lang_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Lang_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SMSPattern_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SMSPattern_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SMSPatternList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SMSPatternList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleFeatureList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleFeatureList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleMakeList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleMakeList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleOwnerList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleOwnerList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LabData_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LabData_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LabDataList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LabDataList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LabEntry_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LabEntry_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LabEntryList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LabEntryList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LabEntryDetail_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LabEntryDetail_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LabEntryDetailList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LabEntryDetailList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderFromClient_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderFromClient_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderFromClientList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderFromClientList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SupplierOrder_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SupplierOrder_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialStoreUserData_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialStoreUserData_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialStoreUserDataList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialStoreUserDataList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Employee_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Employee_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/EmployeeWorkTimeSchedule_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/EmployeeWorkTimeSchedule_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/EmployeeWorkTimeScheduleList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/EmployeeWorkTimeScheduleList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AstCall_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AstCall_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AstCallList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AstCallList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AstCallClientHistList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AstCallClientHistList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AstCallClientShipHistList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AstCallClientShipHistList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserMacAddress_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserMacAddress_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserMacAddressList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserMacAddressList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientTel_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientTel_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientType_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientType_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientComeFrom_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientComeFrom_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientDebt_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientDebt_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Quarry_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Quarry_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SandQuarryVal_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SandQuarryVal_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SandQuarryValList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SandQuarryValList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/StoneQuarryVal_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/StoneQuarryVal_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/StoneQuarryValList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/StoneQuarryValList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialObnul_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialObnul_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SpecialistRequest_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SpecialistRequest_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SpecialistRequestList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SpecialistRequestList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SiteFeedBack_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SiteFeedBack_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SiteFeedBackList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SiteFeedBackList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/CarTrackingMalfucntion_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/CarTrackingMalfucntion_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MailForSending_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MailForSending_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SMSForSending_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SMSForSending_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/EmailTemplate_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/EmailTemplate_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/EmailTemplateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/EmailTemplateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientValidDuplicate_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientValidDuplicate_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientValidDuplicateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientValidDuplicateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentTimeNorm_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentTimeNorm_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcretePrice_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcretePrice_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_locales.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_locales.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_locales.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_locales.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_role_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_role_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_role_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_role_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_data_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_data_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_data_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_data_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_role_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_role_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_role_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_role_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_unload_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_unload_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_unload_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_unload_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_vehicle_states.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_vehicle_states.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_vehicle_states.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_vehicle_states.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_sms_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_sms_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_sms_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_sms_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_email_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_email_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_email_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_email_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_doc_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_doc_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_doc_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_doc_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_reg_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_reg_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_reg_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_reg_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_call_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_call_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_call_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_call_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_client_kinds.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_client_kinds.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_client_kinds.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_client_kinds.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_offer_results.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_offer_results.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_offer_results.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_offer_results.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/About_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/About_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MailForSendingAttachment_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MailForSendingAttachment_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MatTotals_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MatTotals_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleScheduleMakeOrderList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleScheduleMakeOrderList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehFeaturesOnDateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehFeaturesOnDateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderClient_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderClient_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderAvailSpots_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderAvailSpots_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderDescr_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderDescr_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OperatorList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OperatorList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleRun_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleRun_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TimeZoneLocale_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TimeZoneLocale_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserProfile_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserProfile_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Captcha_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Captcha_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ProductionSite_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ProductionSite_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionSite_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionSite_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipQuantForCostGrade_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipQuantForCostGrade_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ShipQuantForCostGrade_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ShipQuantForCostGrade_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialProcurementShiftList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialProcurementShiftList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RAMaterialConsumptionDateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RAMaterialConsumptionDateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/SMSForSending_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/SMSForSending_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SMSForSendingList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SMSForSendingList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SMSPatternUserPhone_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SMSPatternUserPhone_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/SMSPatternUserPhone_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/SMSPatternUserPhone_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/SMSPatternUserPhoneList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/SMSPatternUserPhoneList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/TrackerZoneControl_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/TrackerZoneControl_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TrackerZoneControl_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TrackerZoneControl_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TrackerZoneControlList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TrackerZoneControlList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AssignedVehicleList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AssignedVehicleList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Weather_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Weather_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Weather_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Weather_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AstCallActiveList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AstCallActiveList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AstCallClientCallHistoryList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AstCallClientCallHistoryList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AstCallClientShipHistoryList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AstCallClientShipHistoryList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AstCallCurrent_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AstCallCurrent_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientTelList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientTelList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleDriverForSchedGen_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleDriverForSchedGen_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleDriverForSchedGen_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleDriverForSchedGen_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/PumpVehicleWorkList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/PumpVehicleWorkList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentForDriverCostHeader_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentForDriverCostHeader_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentForDriverCost_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentForDriverCost_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentForOwnerCostHeader_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentForOwnerCostHeader_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentForOwnerCost_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentForOwnerCost_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ShipmentForDriverCostHeader_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ShipmentForDriverCostHeader_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ShipmentForDriverCost_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ShipmentForDriverCost_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ShipmentForOwnerCostHeader_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ShipmentForOwnerCostHeader_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ShipmentForOwnerCost_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ShipmentForOwnerCost_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteCostHeader_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteCostHeader_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteCost_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteCost_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ConcreteCostHeader_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ConcreteCostHeader_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ConcreteCost_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ConcreteCost_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteCostList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteCostList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteTypeList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteTypeList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleOwner_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleOwner_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleOwner_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleOwner_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentCancelations_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentCancelations_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ShipmentCancelation_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ShipmentCancelation_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentCancelation_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentCancelation_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentCancelationList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentCancelationList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentPumpForVehOwnerList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentPumpForVehOwnerList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentForVehOwnerList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentForVehOwnerList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserOperatorList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserOperatorList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentForClientVehOwnerList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentForClientVehOwnerList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ConcreteCostForOwnerHeader_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ConcreteCostForOwnerHeader_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ConcreteCostForOwner_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ConcreteCostForOwner_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteCostForOwnerHeader_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteCostForOwnerHeader_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteCostForOwner_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteCostForOwner_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteCostForOwnerList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteCostForOwnerList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleOwnerConcretePrice_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleOwnerConcretePrice_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleOwnerConcretePrice_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleOwnerConcretePrice_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleOwnerConcretePriceList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleOwnerConcretePriceList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleOwnerClient_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleOwnerClient_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleOwnerClient_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleOwnerClient_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleOwnerClientList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleOwnerClientList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Login_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Login_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Login_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Login_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LoginList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LoginList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Session_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Session_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShippedVehicleList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShippedVehicleList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TelList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TelList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RAMaterialConsumptionDocList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RAMaterialConsumptionDocList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/TelList_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/TelList_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteTypeMapToProduction_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteTypeMapToProduction_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialMapToProduction_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialMapToProduction_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialFactConsumption_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialFactConsumption_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ConcreteTypeMapToProduction_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ConcreteTypeMapToProduction_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialMapToProduction_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialMapToProduction_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialMapToProductionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialMapToProductionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteTypeMapToProductionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteTypeMapToProductionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/MaterialFactConsumption_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/MaterialFactConsumption_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialFactConsumptionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialFactConsumptionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialFactConsumptionRolledList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialFactConsumptionRolledList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialConsRateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialConsRateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderMakeForLabList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderMakeForLabList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LabEntry30DaysList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LabEntry30DaysList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/CementSilo_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/CementSilo_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RGCement_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RGCement_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RACement_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RACement_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RGMaterialFact_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RGMaterialFact_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RAMaterialFact_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RAMaterialFact_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/CementSilo_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/CementSilo_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/CementSiloList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/CementSiloList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleOwnerHistory_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleOwnerHistory_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleOwnerHistoryList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleOwnerHistoryList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/OwnerList_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/OwnerList_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OwnerList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OwnerList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/PumpVehiclePriceList_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/PumpVehiclePriceList_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/PumpVehiclePriceList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/PumpVehiclePriceList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/CementSiloForOrderList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/CementSiloForOrderList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ELKONServer_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ELKONServer_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ELKONServer_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ELKONServer_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ELKONLog_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ELKONLog_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ELKONLog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ELKONLog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Production_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Production_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Production_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Production_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionSiteList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionSiteList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionSiteForEditList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionSiteForEditList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionBase_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionBase_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ELKONLogList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ELKONLogList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserMapToProduction_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserMapToProduction_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserMapToProductionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserMapToProductionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/UserMapToProduction_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/UserMapToProduction_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/MaterialFactConsumptionCorretion_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/MaterialFactConsumptionCorretion_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialFactConsumptionCorretion_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialFactConsumptionCorretion_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialFactConsumptionCorretionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialFactConsumptionCorretionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionMaterialList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionMaterialList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialFactBalanceCorretion_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialFactBalanceCorretion_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialFactBalanceCorretionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialFactBalanceCorretionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/MaterialFactBalanceCorretion_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/MaterialFactBalanceCorretion_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/CementSiloBalanceReset_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/CementSiloBalanceReset_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/CementSiloBalanceReset_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/CementSiloBalanceReset_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/CementSiloBalanceResetList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/CementSiloBalanceResetList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialActionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialActionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionVehicleCorrection_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionVehicleCorrection_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ProductionVehicleCorrection_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ProductionVehicleCorrection_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionVehicleCorrectionList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionVehicleCorrectionList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ProductionComment_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ProductionComment_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialConsToleranceViolationList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialConsToleranceViolationList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionComment_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionComment_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ClientLocalList_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ClientLocalList_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientLocalList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientLocalList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentForClientList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentForClientList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderForClientList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderForClientList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialPrice_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialPrice_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialPrice_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialPrice_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialPriceList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialPriceList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialPriceForNorm_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialPriceForNorm_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialPriceForNorm_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialPriceForNorm_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialPriceForNormList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialPriceForNormList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/GPSTracker_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/GPSTracker_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/GPSTracker_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/GPSTracker_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/StoreMapToProductionSite_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/StoreMapToProductionSite_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/StoreMapToProductionSite_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/StoreMapToProductionSite_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/StoreMapToProductionSiteList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/StoreMapToProductionSiteList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MaterialStoreForOrderList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MaterialStoreForOrderList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/SessionVar_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/SessionVar_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationForOrderList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationForOrderList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleRouteCashe_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleRouteCashe_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/LoginDevice_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/LoginDevice_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LoginDeviceList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LoginDeviceList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/LoginDeviceBan_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/LoginDeviceBan_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/LoginDeviceBan_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/LoginDeviceBan_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Event_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Event_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialProcurementDriverList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialProcurementDriverList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialProcurementVehicleList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialProcurementVehicleList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialProcurementStoreList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialProcurementStoreList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ConcreteTypeForSiteList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ConcreteTypeForSiteList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationForSiteList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationForSiteList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTemplateRoute_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTemplateRoute_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientDestination_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientDestination_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_production_plant_type.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_production_plant_type.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_production_plant_type.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_production_plant_type.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_production_plant_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_production_plant_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_production_plant_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_production_plant_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RouteRest_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RouteRest_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/GornyiCarrierMatch_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/GornyiCarrierMatch_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/GornyiCarrierMatch_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/GornyiCarrierMatch_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/GornyiCarrierMatchList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/GornyiCarrierMatchList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AddressDistance_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AddressDistance_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RoleViewRestriction_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RoleViewRestriction_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RoleViewRestriction_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RoleViewRestriction_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ExcelTemplate_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ExcelTemplate_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ExcelTemplate_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ExcelTemplate_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ExcelTemplateList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ExcelTemplateList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ExcelTemplateDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ExcelTemplateDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ExcelTemplateFieldMatch_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ExcelTemplateFieldMatch_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ExcelTemplateFieldMatch_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ExcelTemplateFieldMatch_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Bank_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Bank_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Bank_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Bank_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/BankList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/BankList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionBase_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionBase_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ProductionBase_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ProductionBase_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProductionBaseList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProductionBaseList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/PeriodValue_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/PeriodValue_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_period_value_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_period_value_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_period_value_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_period_value_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/PeriodValue_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/PeriodValue_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationPriceForDriverPeriodValueList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationPriceForDriverPeriodValueList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DemurrageCostPerHourPeriodValueList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DemurrageCostPerHourPeriodValueList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/WaterShipCostPeriodValueList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/WaterShipCostPeriodValueList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/TmUserList_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/TmUserList_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TmUserList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TmUserList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/TmUser_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/TmUser_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/TmOutMessage_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/TmOutMessage_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TmOutMessageList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TmOutMessageList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/EmployeeList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/EmployeeList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/TmInMessage_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/TmInMessage_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TmInMessage_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TmInMessage_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TmInMessageList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TmInMessageList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Chat_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Chat_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Chat_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Chat_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Post_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Post_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Post_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Post_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Contact_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Contact_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ContactList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ContactList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Contact_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Contact_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/EntityContact_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/EntityContact_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/EntityContactList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/EntityContactList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/EntityContact_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/EntityContact_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TmUserPhotoList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TmUserPhotoList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TmUserDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TmUserDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ContactDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ContactDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DriverList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DriverList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialTicket_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialTicket_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/RawMaterialTicket_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/RawMaterialTicket_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialTicketList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialTicketList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialTicketCarrierAggList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialTicketCarrierAggList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TmUser_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TmUser_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/LabChart_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/LabChart_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ClientSpecification_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ClientSpecification_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ClientSpecificationFlow_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ClientSpecificationFlow_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientSpecification_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientSpecification_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientSpecificationList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientSpecificationList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientSpecificationFlow_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientSpecificationFlow_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientSpecificationFlowList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientSpecificationFlowList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MatTotals1_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MatTotals1_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/MatTotals2_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/MatTotals2_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/DestinationProdBasePrice_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/DestinationProdBasePrice_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationProdBasePrice_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationProdBasePrice_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationProdBasePriceList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationProdBasePriceList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/DestinationProdBaseDriverPrice_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/DestinationProdBaseDriverPrice_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationProdBaseDriverPrice_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationProdBaseDriverPrice_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DestinationProdBaseDriverPriceList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DestinationProdBaseDriverPriceList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderMakeForLabDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderMakeForLabDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/UserOperation_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/UserOperation_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserOperation_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserOperation_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTotRepItem_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTotRepItem_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTotRepItemValue_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTotRepItemValue_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleTotRepItem_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleTotRepItem_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleTotRepItemValue_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleTotRepItemValue_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTotRepItemList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTotRepItemList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialProcurementSenderNameList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialProcurementSenderNameList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/TaskImportanceLevel_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/TaskImportanceLevel_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TaskImportanceLevel_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TaskImportanceLevel_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Task_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Task_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/Enum_inform_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/Enum_inform_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/enum_controls/EnumGridColumn_inform_types.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/enum_controls/EnumGridColumn_inform_types.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/custom_controls/App.enums.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/custom_controls/App.enums.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Task_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Task_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/TaskDetail_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/TaskDetail_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Attachment_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Attachment_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/AttachmentList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/AttachmentList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TaskDetail_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TaskDetail_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Attachment_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Attachment_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TaskList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TaskList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/TaskDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/TaskDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProgUpdate_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProgUpdate_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ProgUpdateDetail_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ProgUpdateDetail_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ProgUpdate_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ProgUpdate_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ProgUpdateDetail_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ProgUpdateDetail_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTotRepCommonItem_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTotRepCommonItem_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTotRepCommonItemList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTotRepCommonItemList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTotRepCommonItemValue_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTotRepCommonItemValue_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleTotRepCommonItem_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleTotRepCommonItem_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleTotRepCommonItemValue_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleTotRepCommonItemValue_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/VehicleTotRepBalance_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/VehicleTotRepBalance_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTotRepBalance_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTotRepBalance_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/VehicleTotRepBalanceList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/VehicleTotRepBalanceList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/QualityPassport_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/QualityPassport_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/QualityPassport_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/QualityPassport_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Client1c_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Client1c_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Client1cList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Client1cList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Firm1c_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Firm1c_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/Firm1cList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/Firm1cList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/Firm1c_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/Firm1c_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ClientDebtList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ClientDebtList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ClientDebt_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ClientDebt_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/QualityPassportList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/QualityPassportList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentMedia_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentMedia_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ShipmentMedia_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ShipmentMedia_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ShipmentMediaList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ShipmentMediaList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/ChatStatus_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/ChatStatus_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/ChatStatus_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/ChatStatus_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/UserChatStatus_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/UserChatStatus_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChatStatusSelectList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChatStatusSelectList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChatStatus_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChatStatus_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/UserChat_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/UserChat_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChatList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChatList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChat_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChat_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/UserChatMessage_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/UserChatMessage_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChatMessage_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChatMessage_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChatUserList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChatUserList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChatLastOpen_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChatLastOpen_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChatMessageView_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChatMessageView_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/UserChatLastOpen_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/UserChatLastOpen_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/UserChatMessageView_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/UserChatMessageView_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/UserChatHistory_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/UserChatHistory_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/DOCMaterialProcurementDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/DOCMaterialProcurementDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderGarbage_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderGarbage_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/OrderGarbage_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/OrderGarbage_Controller.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderGarbageList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderGarbageList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/OrderGarbageDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/OrderGarbageDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/RawMaterialTicketDialog_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/RawMaterialTicketDialog_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/CementSiloMaterial_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/CementSiloMaterial_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/models/CementSiloMaterialList_Model.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/models/CementSiloMaterialList_Model.js')) ));
		$this->addJsModel(new ModelJavaScript('js20/controllers/CementSiloMaterial_Controller.js', NULL, date("Y-m-dTH:i:s", filemtime('js20/controllers/CementSiloMaterial_Controller.js')) ));
				
			if (isset($_SESSION['scriptId'])){
				$script_id = $_SESSION['scriptId'];
			}
			else{
				$script_id = VERSION;
			}			
		}
		
		$this->getVarModel()->addField(new Field('role_id',DT_STRING));
		$this->getVarModel()->addField(new Field('user_id',DT_INT));
		$this->getVarModel()->addField(new Field('user_name',DT_STRING));		
		
		if (isset($_SESSION['role_id'])){
			$this->getVarModel()->addField(new Field('tel_ext',DT_STRING));
			
			//app server
			$this->getVarModel()->addField(new Field('app_srv_host',DT_STRING));
			$this->getVarModel()->addField(new Field('app_srv_port',DT_STRING));
			//$this->getVarModel()->addField(new Field('app_srv_protocol',DT_STRING));								
			
			$this->getVarModel()->addField(new Field('app_id',DT_STRING));
			$this->getVarModel()->addField(new Field('tm_photo',DT_STRING));				
			
			$this->getVarModel()->addField(new Field('role_view_restriction',DT_STRING));
			$this->getVarModel()->addField(new Field('allowed_roles',DT_STRING));
			$this->getVarModel()->addField(new Field('chat_statuses_ref',DT_STRING));
			$this->getVarModel()->addField(new Field('chat_private_id',DT_STRING));
			$this->getVarModel()->addField(new Field('chat_out_id',DT_STRING));
			$this->getVarModel()->addField(new Field('chat_unviewed_count',DT_INT));			
			
			if(isset($_SESSION['token'])){
				$this->getVarModel()->addField(new Field('token',DT_STRING));
				if(defined('SESSION_EXP_SEC') && intval(SESSION_EXP_SEC)){
					$this->getVarModel()->addField(new Field('tokenr',DT_STRING));					
				}	
				$this->getVarModel()->addField(new Field('tokenExpires',DT_STRING));
			}
			
		}
		
		
		$this->getVarModel()->insert();
		$this->setVarValue('scriptId',$script_id);
		
		$currentPath = $_SERVER['PHP_SELF'];
		$pathInfo = pathinfo($currentPath);
		$hostName = isset($_SERVER['HTTP_HOST'])? $_SERVER['HTTP_HOST'] : '';
		$is_https = isset($_SERVER['HTTPS']);
		$protocol = $is_https? 'https://':'http://';
		$dir = $protocol.$hostName.$pathInfo['dirname'];
		if (substr($dir,strlen($dir)-1,1)!='/'){
			$dir.='/';
		}
		$this->setVarValue('basePath', $dir);
		
		$this->setVarValue('version',VERSION);		
		$this->setVarValue('debug',DEBUG);
		if (isset($_SESSION['locale_id'])){
			$this->setVarValue('locale_id',$_SESSION['locale_id']);
		}
		else if (!isset($_SESSION['locale_id']) && defined('DEF_LOCALE')){
			$this->setVarValue('locale_id', DEF_LOCALE);
		}		
		
		if (isset($_SESSION['role_id'])){
			$this->setVarValue('role_id',$_SESSION['role_id']);
			$this->setVarValue('user_id',$_SESSION['user_id']);
			$this->setVarValue('user_name',$_SESSION['user_name']);
			$this->setVarValue('curDate',round(microtime(true) * 1000));
			$this->setVarValue('tel_ext',$_SESSION['tel_ext']);
			
			$this->setVarValue('role_view_restriction', isset($_SESSION['role_view_restriction'])? json_encode($_SESSION['role_view_restriction']) : '');
			$this->setVarValue('tm_photo', isset($_SESSION['tm_photo'])? $_SESSION['tm_photo']:'');
			$this->setVarValue('allowed_roles', isset($_SESSION['allowed_roles'])? json_encode($_SESSION['allowed_roles']) : '');
			
			if(isset($_SESSION['chat_statuses_ref'])){
				$this->setVarValue('chat_statuses_ref', $_SESSION['chat_statuses_ref']);
			}
			$this->setVarValue('chat_private_id', md5('fd45g654g5y44_USER_CHAT_PRIVATE_MESSAGE_FOR_'.$_SESSION['user_id']));
			$this->setVarValue('chat_out_id', md5('fd45g654g5y44_USER_CHAT_OUT_MESSAGE_FROM_'.$_SESSION['user_id']));
			
			$cnt_ar = $GLOBALS['dbLink']->query_first(sprintf("SELECT notifications.user_chat_unviewed_count(%d, NULL) AS cnt", $_SESSION['user_id']));
			if(is_array($cnt_ar) && count($cnt_ar) &&  isset($cnt_ar["cnt"])){
				$this->setVarValue('chat_unviewed_count', $cnt_ar["cnt"]);
			}
			
			$this->setVarValue('app_srv_host',APP_SERVER_HOST);
			$this->setVarValue('app_srv_port', ($is_https&&defined('APP_SERVER_PORT_SECURED'))? APP_SERVER_PORT_SECURED:APP_SERVER_PORT);
			$this->setVarValue('app_id',APP_NAME);
			
			if(isset($_SESSION['token'])){
				$this->setVarValue('token',$_SESSION['token']);
				if(defined('SESSION_EXP_SEC') && intval(SESSION_EXP_SEC)){
					$this->setVarValue('tokenr',$_SESSION['tokenr']);					
				}
				$this->setVarValue('tokenExpires',date('Y-m-d H:i:s',$_SESSION['tokenExpires']));
			}			
			
		}
		
		
		//Global Filters
		
	}
	public function write(ArrayObject &$models,$errorCode=NULL){
		$this->addMenu($models);
		
		
		$this->addConstants($models);
		
		//titles form Config
		$models->append(new ModelVars(
			array('name'=>'Page_Model',
				'sysModel'=>TRUE,
				'id'=>'Page_Model',
				'values'=>array(
					new Field('DEFAULT_COLOR_PALETTE', DT_STRING, array('value'=>DEFAULT_COLOR_PALETTE))
					,new Field('PROG_TITLE', DT_STRING, array('value'=>PROG_TITLE))
				)
			)
		));
		
		//active call		
		if (isset($_SESSION['role_id']) && isset($_SESSION['tel_ext']) && isset($GLOBALS['dbLink'])){
			AstCall_Controller::add_active_call($GLOBALS['dbLink'],$models);
		}
		
		parent::write($models,$errorCode);
	}	
}	
?>