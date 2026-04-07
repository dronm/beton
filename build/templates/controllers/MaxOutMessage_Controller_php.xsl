<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'MaxOutMessage'"/>
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
		
		$tel_ar = $this->getDbLink()->query_first("SELECT tel FROM contacts WHERE id = %d", [ $contact_id ]);
		if(!is_array($tel_ar) || !count($tel_ar) || !isset($tel_ar['tel'])){
			throw new Exception('Объект не найден!');
		}

		add_notification_from_contact($this->getDbLinkMaster(), $tel_ar['tel'], $this->getExtVal($pm, 'message'), 'custom', NULL, $contact_id);
	}

	private function register($contactId){
		$link = $this->getDbLinkMaster();

		try{
			$link->query("BEGIN");

			// check latest token
			$ar = $link->query_first(
				"SELECT
					(created_at + interval '30 minutes') &lt;= now() AS sms_allowed,
					GREATEST(
						EXTRACT(EPOCH FROM ((created_at + interval '30 minutes') - now())),
						0
					)::int AS sms_allowed_in_sec,
					expires_at > now() AS not_expired,
					used_at
				FROM notifications.max_user_activation_tokens
				WHERE contact_id = $1
				ORDER BY created_at DESC
				LIMIT 1",
				[$contactId]
			);

			// already sent, still active, resend cooldown not passed
			if (
				is_array($ar)
				&amp;&amp; $ar["used_at"] === null
				&amp;&amp; $ar["not_expired"] === "t"
				&amp;&amp; $ar["sms_allowed"] !== "t"
			) {
				throw new Exception(sprintf(
					"Код уже отправлен, повторно можно отправить через %d сек.",
					(int)$ar["sms_allowed_in_sec"]
				));
			}

			// 6 digits
			$activationCode = str_pad((string)mt_rand(0, 999999), 6, '0', STR_PAD_LEFT);

			$link->query(
				"INSERT INTO notifications.max_user_activation_tokens (
					contact_id,
					token
				)
				VALUES ($1, $2)",
				[
					$contactId,
					$activationCode
				]
			);

			$sms_ar = $link->query_first(
				"SELECT * FROM sms_max_invite_contact_new($1, $2, $3)",
				[
					$contactId,
					MAX_BOT_ID,
					$activationCode
				]
			);

			add_notification_from_contact_sms(
				$link,
				$sms_ar['phone_cel'],
				$sms_ar['message'],
				'max_invite',
				null,
				$contactId
			);

			$link->query("COMMIT");
		}catch(Exception $e){
			$link->query("ROLLBACK");
			throw $e;
		}
	}

	/**
	 * Теперь всегда только contacts
	 */
	public function invite($pm){
		$recipient = $this->getExtVal($pm, 'recipient');
		$recipient_ref = json_decode($recipient, TRUE);
		$contact_id = intval($recipient_ref['keys']['id']);		
		$this->register($contact_id);
	}

	public function invite_contact($pm){
		$this->register($this->getExtVal($pm, 'contact_id'));
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
