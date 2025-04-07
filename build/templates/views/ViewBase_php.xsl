<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
<xsl:template match="/"><![CDATA[<?php]]>
require_once(FRAME_WORK_PATH.'basic_classes/ViewHTMLXSLT.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelStyleSheet.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelJavaScript.php');

require_once(FRAME_WORK_PATH.'basic_classes/ModelTemplate.php');
require_once(USER_CONTROLLERS_PATH.'Constant_Controller.php');
require_once(USER_CONTROLLERS_PATH.'MainMenuConstructor_Controller.php');

require_once(USER_CONTROLLERS_PATH.'AstCall_Controller.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelVars.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelTextOutput.php');

<xsl:apply-templates select="metadata/enums/enum[@id='role_types']"/>
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
		if (!is_null($menu_class) &amp;&amp; !is_null($fl)){
			require_once($fl);
		}
		return $menu_class;
	}
	*/
	protected function addMenu(&amp;$models){
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
	
	protected function addConstants(&amp;$models){
		if (isset($_SESSION['role_id'])){

			if (!$GLOBALS['dbLink']){
				throw new Exception('Db link for addConstants is not defined!');
			}
		
			$contr = new Constant_Controller($GLOBALS['dbLink']);
			$list = array(<xsl:apply-templates select="/metadata/constants/constant[@autoload='TRUE']"/>);
			$models['ConstantValueList_Model'] = $contr->getConstantValueModel($list);						
		}	
	}

	public function __construct($name){
		parent::__construct($name);
		<xsl:apply-templates select="metadata/cssScripts"/>
		if (!DEBUG){
			<xsl:apply-templates select="metadata/jsScripts/jsScript[@standalone='TRUE']"/>
			$this->addJsModel(new ModelJavaScript(USER_JS_PATH.'lib.js', NULL, date("Y-m-dTH:i:s", filemtime(USER_JS_PATH.'<xsl:value-of select="@file"/>')) ));
			$script_id = VERSION;
		} else{		
			<xsl:apply-templates select="metadata/jsScripts"/>			
			if (isset($_SESSION['scriptId'])){
				$script_id = $_SESSION['scriptId'];
			}
			else{
				$script_id = VERSION;
			}			
		}
		<!-- custom vars definitions-->
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
			$this->getVarModel()->addField(new Field('ping_1c',DT_BOOL));			
			
			if(isset($_SESSION['token'])){
				$this->getVarModel()->addField(new Field('token',DT_STRING));
				if(defined('SESSION_EXP_SEC') &amp;&amp; intval(SESSION_EXP_SEC)){
					$this->getVarModel()->addField(new Field('tokenr',DT_STRING));					
				}	
				$this->getVarModel()->addField(new Field('tokenExpires',DT_STRING));
			}
			
		}
		
		<!-- obligatory vars values -->
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
		else if (!isset($_SESSION['locale_id']) &amp;&amp; defined('DEF_LOCALE')){
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
			if(is_array($cnt_ar) &amp;&amp; count($cnt_ar) &amp;&amp;  isset($cnt_ar["cnt"])){
				$this->setVarValue('chat_unviewed_count', $cnt_ar["cnt"]);
			}
			
			$this->setVarValue('ping_1c', defined('HOST_1C'));
			
			$this->setVarValue('app_srv_host',APP_SERVER_HOST);
			$this->setVarValue('app_srv_port', ($is_https&amp;&amp;defined('APP_SERVER_PORT_SECURED'))? APP_SERVER_PORT_SECURED:APP_SERVER_PORT);
			$this->setVarValue('app_id',APP_NAME);
			
			if(isset($_SESSION['token'])){
				$this->setVarValue('token',$_SESSION['token']);
				if(defined('SESSION_EXP_SEC') &amp;&amp; intval(SESSION_EXP_SEC)){
					$this->setVarValue('tokenr',$_SESSION['tokenr']);					
				}
				$this->setVarValue('tokenExpires',date('Y-m-d H:i:s',$_SESSION['tokenExpires']));
			}			
			
		}
		<!-- custom vars values
		if (isset($_SESSION['constrain_to_store'])){
			$this->setVarValue('constrain_to_store',$_SESSION['constrain_to_store']);
		}
		-->
		
		//Global Filters
		<!--
		<xsl:for-each select="/metadata/globalFilters/field">
		if (isset($_SESSION['global_<xsl:value-of select="@id"/>'])){
			$val = $_SESSION['global_<xsl:value-of select="@id"/>'];
			$this->setVarValue('<xsl:value-of select="@id"/>',$val);
		}
		</xsl:for-each>		
		-->
	}
	public function write(ArrayObject &amp;$models,$errorCode=NULL){
		$this->addMenu($models);
		
		<!-- constant autoload -->
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
		if (isset($_SESSION['role_id']) &amp;&amp; isset($_SESSION['tel_ext']) &amp;&amp; isset($GLOBALS['dbLink'])){
			AstCall_Controller::add_active_call($GLOBALS['dbLink'],$models);
		}
		
		parent::write($models,$errorCode);
	}	
}	
<![CDATA[?>]]>
</xsl:template>
			
<xsl:template match="constants/constant[@autoload='TRUE']">
<xsl:if test="position() &gt; 1">,</xsl:if>'<xsl:value-of select="@id"/>'</xsl:template>
			
<xsl:template match="enum/value">
if (file_exists('models/MainMenu_Model_<xsl:value-of select="@id"/>.php')){
require_once('models/MainMenu_Model_<xsl:value-of select="@id"/>.php');
}</xsl:template>

<xsl:template match="jsScripts/jsScript">

<!--
<xsl:variable name="tp">
<xsl:choose>
<xsl:when test="@type"><xsl:value-of select="@type"/></xsl:when>
<xsl:otherwise>text/javascript</xsl:otherwise>
</xsl:choose>
</xsl:variable>
-->

<xsl:choose>
<xsl:when test="@resource">	
	if (
	(isset($_SESSION['locale_id']) &amp;&amp; $_SESSION['locale_id']=='<xsl:value-of select="@resource"/>')
	||
	(!isset($_SESSION['locale_id']) &amp;&amp; DEF_LOCALE=='<xsl:value-of select="@resource"/>')
	){
		$this->addJsModel(new ModelJavaScript('<xsl:value-of select="@file"/>', NULL, date("Y-m-dTH:i:s", filemtime('<xsl:value-of select="@file"/>')) ));
	}
</xsl:when>
<xsl:otherwise>$this->addJsModel(new ModelJavaScript('<xsl:value-of select="@file"/>', NULL, date("Y-m-dTH:i:s", filemtime('<xsl:value-of select="@file"/>')) ));</xsl:otherwise>
</xsl:choose>

</xsl:template>

<xsl:template match="cssScripts/cssScript">$this->addCssModel(new ModelStyleSheet('<xsl:value-of select="@file"/>', date("Y-m-dTH:i:s", filemtime('<xsl:value-of select="@file"/>')) ));</xsl:template>

</xsl:stylesheet>
