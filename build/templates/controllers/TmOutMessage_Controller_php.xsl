<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'TmOutMessage'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(ABSOLUTE_PATH.'functions/notifications.php');

//require_once(FRAME_WORK_PATH.'basic_classes/ModelWhereSQL.php');
//require_once(USER_MODELS_PATH.'TmOutMessageList_Model.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	
	public function send($pm){
		$recipient = $this->getExtVal($pm, 'recipient');		
		$recipient_ref = json_decode($recipient, TRUE);
		$contact_id = intval($recipient_ref['keys']['id']);
		
		$tel_ar = $this->getDbLink()->query_first(sprintf("SELECT tel FROM contacts WHERE id = %d", $contact_id));
		if(!is_array($tel_ar) || !count($tel_ar) || !isset($tel_ar['tel'])){
			throw new Exception('Объект не найден!');
		}
		
		add_notification_from_contact($this->getDbLinkMaster(), $tel_ar['tel'], $this->getExtVal($pm, 'message'), 'custom', NULL, $contact_id);
	}

	private function tm_register($contactId){
		$ext_user_ar = $this->getDbLinkMaster()->query_first(sprintf(
			"SELECT add_contact(%d, %d) AS activation_code"
			,MS_APP_ID
			,$contactId
		));
		if(!is_array($ext_user_ar) || !count($ext_user_ar) || !isset($ext_user_ar['activation_code'])){
			throw new Exception('Ошибка регистрации!');
		}
		
		$sms_ar = $this->getDbLink()->query_first(sprintf(
			"SELECT * FROM sms_tm_invite_contact_new(%d, '%d')"
			,$contactId
			,$ext_user_ar['activation_code']
		));
		add_notification_from_contact_sms($this->getDbLinkMaster(), $sms_ar['phone_cel'], $sms_ar['message'], 'tm_invite', NULL, $contactId);
	}
	
	/**
	 * Теперь всегда только contacts
	 */
	public function tm_invite($pm){
		$recipient = $this->getExtVal($pm, 'recipient');
		$recipient_ref = json_decode($recipient, TRUE);
		$contact_id = intval($recipient_ref['keys']['id']);		
		$this->tm_register($contact_id);
	}

	public function tm_invite_contact($pm){
		$this->tm_register($this->getExtVal($pm, 'contact_id'));
	}

	/**
	 * recipient - ContactRef
	 */
	public function get_recipient_inf($pm){
		$recipient_ref = json_decode($this->getExtVal($pm, 'recipient'), TRUE);
		$contact_id = intval($recipient_ref['keys']['id']);		
		$this->addNewModel(
			sprintf(
				"SELECT *
				FROM contacts_dialog
				WHERE id = %d"
				,$contact_id
			)		
			,'ContactDialog_Model'
		);		
	}
	
</xsl:template>

</xsl:stylesheet>
