<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Chat'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(ABSOLUTE_PATH.'Config.uniq.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{

	const MSG_COUNT = 10;

	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">

	public function get_history($pm){
		$recipient = json_decode($this->getExtVal($pm, 'recipient'), TRUE);
		$this->addNewModel(sprintf(
			"SELECT * FROM notifications.chat(
				%d,
				(SELECT
					(u.tm_user->>'id')::bigint
				FROM notifications.ext_users AS u
				WHERE u.ext_contact_id = %d
				LIMIT 1),
				%d
			)"
			,MS_APP_ID
			,intval($recipient['keys']['id'])
			,self::MSG_COUNT
		), 'Chat_Model');		
	}
</xsl:template>

</xsl:stylesheet>
