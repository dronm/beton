<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'UserChatMessageView'"/>
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

	public function set_all_viewed($pm){
		$with_user_id = $this->getExtDbVal($pm, 'user_id');
		$this->getDbLinkMaster()->query("BEGIN");
		try{
			$this->getDbLinkMaster()->query(sprintf(
				"INSERT INTO notifications.user_chat_message_views
				(user_id, user_chat_id)

				SELECT
					%d, m.id
				FROM notifications.user_chat AS m
				LEFT JOIN notifications.user_chat_message_views AS v ON v.user_id = %d AND v.user_chat_id = m.id
				WHERE
					-- not from me
					m.from_user_id &lt;&gt; %d
					
					-- if with particular user
					AND (%s IS NULL OR m.from_user_id = %s)
					
					-- to all for common chat or to me for private chat
					AND ( (%s IS NULL AND m.to_user_id IS NULL) OR (%s IS NOT NULL AND m.to_user_id = %d) )
					
					-- unseen
					AND coalesce(v.user_chat_id IS NOT NULL, FALSE) = FALSE
					
				ON CONFLICT (user_id, user_chat_id) DO NOTHING"
				,$_SESSION["user_id"]
				,$_SESSION["user_id"]
				,$_SESSION["user_id"]
				,$with_user_id
				,$with_user_id
				,$with_user_id
				,$with_user_id
				,$_SESSION["user_id"]
			));
			
			$this->getDbLinkMaster()->query(sprintf(
				"INSERT INTO notifications.user_chat_last_open
				(user_id, with_user_id)
				VALUES (%d, %d)
				ON CONFLICT (user_id, with_user_id) DO UPDATE
				SET date_time = now()"
				,$_SESSION["user_id"]
				,($with_user_id == "null")? 0 : $with_user_id
			));			
			$this->getDbLinkMaster()->query("COMMIT");
		}catch(Exception $e){
			$this->getDbLinkMaster()->query("ROLLBACK");
			throw new Exception($e);
		}
	}
	
</xsl:template>

</xsl:stylesheet>
