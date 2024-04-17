<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'UserChatStatus'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">

	public function set($pm){
		$stat = $this->getExtDbVal($pm, 'chat_status_id');
		$this->getDbLink()->query(sprintf(			
			"INSERT INTO user_chat_statuses (user_id, chat_status_id)
			VALUES (%d, %d)
			ON CONFLICT (user_id) DO UPDATE			
			SET chat_status_id = %d
			WHERE user_chat_statuses.user_id = %d"
			,$_SESSION['user_id']
			,$stat
			,$stat
			,$_SESSION['user_id']
		));
	}

	public function get_select_list($pm){
		//fetch current user status
		$this->addNewModel(sprintf(
			"WITH
			user_st AS (SELECT t.chat_status_id AS id FROM user_chat_statuses AS t WHERE t.user_id = %d)
			SELECT
				st.id,
				st.name,
				coalesce((SELECT user_st.id FROM user_st) = st.id, FALSE) AS is_user_chat_status
				
			FROM chat_statuses AS st
			ORDER BY st.name"
			,$_SESSION['user_id']
		), 'UserChatStatusSelectList_Model');
	}
</xsl:template>

</xsl:stylesheet>
