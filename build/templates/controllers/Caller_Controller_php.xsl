<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Caller'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

//Asterisk
require_once 'common/Caller.php';

require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

require_once(ABSOLUTE_PATH.'domru/DOMRuIntegration.php');

require_once(FRAME_WORK_PATH.'basic_classes/ModelVars.php');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function call($pm){
	
		$asterisk = (defined('AST_SERVER')&amp;&amp;defined('AST_PORT')&amp;&amp;defined('AST_USER')&amp;&amp;defined('AST_PASSWORD'));
		$dom_ru = (defined('DOMRU_URL')&amp;&amp;defined('DOMRU_TOKEN'));

		$ext = $_SESSION['tel_ext'];
		$tel = $this->getExtVal($pm,'tel');
		
		if(isset($ext) &amp;&amp; $asterisk){			
			$caller = new Caller(AST_SERVER,AST_PORT,AST_USER,AST_PASSWORD);
			$caller->call($ext,$tel);	
		
		}else if(isset($ext) &amp;&amp; $dom_ru){
			$caller = new DOMRuIntegration(DOMRU_TOKEN, DOMRU_URL);
			$call_id = $caller->makeCall($ext, $tel);
			
			if($call_id &amp;&amp; strlen($call_id)){
				$this->addModel(new ModelVars(
					array('name'=>'Vars',
						'id'=>'Call_Model',
						'values'=>[new Field('call_id',DT_STRING,array('value'=>$call_id))]
						)
					)
				);		
			}
		}else{
			throw new Exception('Нет настроек телефонии!');
		}
	
	}
</xsl:template>

</xsl:stylesheet>
