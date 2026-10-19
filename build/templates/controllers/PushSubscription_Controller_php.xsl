<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'PushSubscription'"/>
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
	private function getLoginContactId(){
		if(
			!isset($_SESSION['login_contact_id'])
			|| intval($_SESSION['login_contact_id']) &lt;= 0
		){
			throw new Exception(
				'У текущего пользователя не задан контакт.'
			);
		}

		return intval($_SESSION['login_contact_id']);
	}

	private function validateSubscriptionValue($value, $fieldName, $maxLength){
		$value = trim((string)$value);

		if($value === ''){
			throw new Exception(
				sprintf(
					'Параметр %s не задан.',
					$fieldName
				)
			);
		}

		if(strlen($value) &gt; $maxLength){
			throw new Exception(
				sprintf(
					'Параметр %s слишком длинный.',
					$fieldName
				)
			);
		}

		return $value;
	}

	private function addStateModel($subscribed, $subscriptionId=NULL){
		$this-&gt;addModel(
			new ModelVars(
				array(
					'id' =&gt; 'PushSubscriptionState_Model',
					'values' =&gt; array(
						new Field(
							'subscribed',
							DT_BOOL,
							array(
								'value' =&gt; $subscribed
							)
						),

						new Field(
							'subscription_id',
							DT_INT,
							array(
								'value' =&gt; $subscriptionId
							)
						)
					)
				)
			)
		);
	}

	public function get_vapid_public_key($pm){
		if(
			!defined('PUSH_VAPID_PUBLIC_KEY')
			|| PUSH_VAPID_PUBLIC_KEY === ''
		){
			throw new Exception(
				'PUSH_VAPID_PUBLIC_KEY is not configured.'
			);
		}

		$this-&gt;addModel(
			new ModelVars(
				array(
					'id' =&gt; 'PushSubscriptionVapidKey_Model',
					'values' =&gt; array(
						new Field(
							'public_key',
							DT_STRING,
							array(
								'value' =&gt; PUSH_VAPID_PUBLIC_KEY
							)
						)
					)
				)
			)
		);
	}

	public function get_status($pm){
		$contactId = $this-&gt;getLoginContactId();

		$endpoint = $this-&gt;validateSubscriptionValue(
			$this-&gt;getExtVal($pm, 'endpoint'),
			'endpoint',
			4096
		);

		$link = $this-&gt;getDbLinkMaster();

		$ar = $link-&gt;query_first(
			"SELECT
				id
			FROM notifications.push_subscriptions
			WHERE app_id = $1
				AND ext_contact_id = $2
				AND endpoint = $3
				AND disabled_at IS NULL
			LIMIT 1",
			array(
				MS_APP_ID,
				$contactId,
				$endpoint
			)
		);

		$subscribed = (
			is_array($ar)
			&amp;&amp; isset($ar['id'])
		);

		$subscriptionId = $subscribed
			? intval($ar['id'])
			: NULL;

		/*
		 * This also works as a lightweight heartbeat:
		 * the browser still knows about this subscription.
		 */
		if($subscribed){
			$link-&gt;query(
				"UPDATE notifications.push_subscriptions
				SET
					last_seen_at = now(),
					updated_at = now()
				WHERE id = $1",
				array(
					$subscriptionId
				)
			);
		}

		$this-&gt;addStateModel(
			$subscribed,
			$subscriptionId
		);
	}

	public function subscribe($pm){
		$contactId = $this-&gt;getLoginContactId();

		$endpoint = $this-&gt;validateSubscriptionValue(
			$this-&gt;getExtVal($pm, 'endpoint'),
			'endpoint',
			4096
		);

		$p256dh = $this-&gt;validateSubscriptionValue(
			$this-&gt;getExtVal($pm, 'p256dh'),
			'p256dh',
			1024
		);

		$auth = $this-&gt;validateSubscriptionValue(
			$this-&gt;getExtVal($pm, 'auth'),
			'auth',
			512
		);

		/*
		 * Push-service endpoints should be HTTPS.
		 * localhost applies to your application URL, not to
		 * the endpoint returned by PushManager.
		 */
		if(
			strtolower(
				(string)parse_url(
					$endpoint,
					PHP_URL_SCHEME
				)
			) !== 'https'
		){
			throw new Exception(
				'Некорректный push endpoint.'
			);
		}

		/*
		 * p256dh/auth returned by PushSubscription are
		 * base64url values.
		 */
		if(
			!preg_match(
				'/^[A-Za-z0-9_-]+$/',
				$p256dh
			)
		){
			throw new Exception(
				'Некорректный ключ p256dh.'
			);
		}

		if(
			!preg_match(
				'/^[A-Za-z0-9_-]+$/',
				$auth
			)
		){
			throw new Exception(
				'Некорректный ключ auth.'
			);
		}

		$userAgent = isset($_SERVER['HTTP_USER_AGENT'])
			? substr(
				(string)$_SERVER['HTTP_USER_AGENT'],
				0,
				1000
			)
			: NULL;

		$link = $this-&gt;getDbLinkMaster();

		$link-&gt;query('BEGIN');

		try{
			/*
			 * Do not use ON CONFLICT here.
			 * notifications.push_subscriptions can be an FDW
			 * foreign table, and your project already has
			 * cases where ON CONFLICT is unsuitable for FDW.
			 */
			$ar = $link-&gt;query_first(
				"SELECT
					id
				FROM notifications.push_subscriptions
				WHERE app_id = $1
					AND endpoint = $2
				LIMIT 1",
				array(
					MS_APP_ID,
					$endpoint
				)
			);

			if(
				is_array($ar)
				&amp;&amp; isset($ar['id'])
			){
				$subscriptionId = intval(
					$ar['id']
				);

				/*
				 * Rebind the endpoint to the currently
				 * authenticated contact.
				 *
				 * This is useful when another user later
				 * signs in on the same browser/device.
				 */
				$link-&gt;query(
					"UPDATE notifications.push_subscriptions
					SET
						ext_contact_id = $2,
						p256dh = $3,
						auth = $4,
						user_agent = $5,
						updated_at = now(),
						last_seen_at = now(),
						disabled_at = NULL,
						last_error = NULL
					WHERE id = $1",
					array(
						$subscriptionId,
						$contactId,
						$p256dh,
						$auth,
						$userAgent
					)
				);

			}else{
				$link-&gt;query(
					"INSERT INTO notifications.push_subscriptions
						(
							app_id,
							ext_contact_id,
							endpoint,
							p256dh,
							auth,
							user_agent,
							created_at,
							updated_at,
							last_seen_at
						)
					VALUES
						(
							$1,
							$2,
							$3,
							$4,
							$5,
							$6,
							now(),
							now(),
							now()
						)",
					array(
						MS_APP_ID,
						$contactId,
						$endpoint,
						$p256dh,
						$auth,
						$userAgent
					)
				);

				$ar = $link-&gt;query_first(
					"SELECT
						id
					FROM notifications.push_subscriptions
					WHERE app_id = $1
						AND endpoint = $2
					LIMIT 1",
					array(
						MS_APP_ID,
						$endpoint
					)
				);

				if(
					!is_array($ar)
					|| !isset($ar['id'])
				){
					throw new Exception(
						'Не удалось сохранить push subscription.'
					);
				}

				$subscriptionId = intval(
					$ar['id']
				);
			}

			$link-&gt;query('COMMIT');

		}catch(Throwable $e){
			$link-&gt;query('ROLLBACK');

			throw $e;
		}

		$this-&gt;addStateModel(
			TRUE,
			$subscriptionId
		);
	}

	public function unsubscribe($pm){
		$contactId = $this-&gt;getLoginContactId();

		$endpoint = $this-&gt;validateSubscriptionValue(
			$this-&gt;getExtVal($pm, 'endpoint'),
			'endpoint',
			4096
		);

		/*
		 * Soft-disable instead of DELETE.
		 *
		 * That keeps useful diagnostics and allows the same
		 * endpoint to be reactivated by subscribe().
		 */
		$this-&gt;getDbLinkMaster()-&gt;query(
			"UPDATE notifications.push_subscriptions
			SET
				disabled_at = now(),
				updated_at = now()
			WHERE app_id = $1
				AND ext_contact_id = $2
				AND endpoint = $3
				AND disabled_at IS NULL",
			array(
				MS_APP_ID,
				$contactId,
				$endpoint
			)
		);

		/*
		 * Idempotent: unsubscribing something that is already
		 * disabled still reports the desired final state.
		 */
		$this-&gt;addStateModel(
			FALSE,
			NULL
		);
	}
</xsl:template>

</xsl:stylesheet>
