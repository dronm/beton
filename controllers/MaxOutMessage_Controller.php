<?php
require_once(FRAME_WORK_PATH.'basic_classes/ControllerSQL.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInt.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtFloat.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtEnum.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtText.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDate.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtTime.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtPassword.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBool.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtInterval.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtDateTimeTZ.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSON.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtJSONB.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtArray.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldExtBytea.php');

/**
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_php.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */



require_once(ABSOLUTE_PATH.'functions/notifications.php');

class MaxOutMessage_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		/* get_list */
		$pm = new PublicMethod('get_list');
		
		$pm->addParam(new FieldExtInt('count'));
		$pm->addParam(new FieldExtInt('from'));
		$pm->addParam(new FieldExtString('cond_fields'));
		$pm->addParam(new FieldExtString('cond_sgns'));
		$pm->addParam(new FieldExtString('cond_vals'));
		$pm->addParam(new FieldExtString('cond_ic'));
		$pm->addParam(new FieldExtString('ord_fields'));
		$pm->addParam(new FieldExtString('ord_directs'));
		$pm->addParam(new FieldExtString('field_sep'));
		$pm->addParam(new FieldExtString('lsn'));

		$this->addPublicMethod($pm);
		
		$this->setListModelId('MaxOutMessageList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('MaxOutMessageList_Model');		

			
		$pm = new PublicMethod('send');
		
				
	$opts=array();
	
		$opts['length']=500;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('recipient',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('message',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('send_media');
		
				
	$opts=array();
	
		$opts['length']=500;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('recipient',$opts));
	
				
	$opts=array();
	
		$opts['length']=1000;				
		$pm->addParam(new FieldExtString('caption',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('media_file',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('invite');
		
				
	$opts=array();
	
		$opts['length']=500;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('recipient',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('invite_contact');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtInt('contact_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_recipient_inf');
		
				
	$opts=array();
	
		$opts['length']=500;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('recipient',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

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
					(created_at + interval '30 minutes') <= now() AS sms_allowed,
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
				&& $ar["used_at"] === null
				&& $ar["not_expired"] === "t"
				&& $ar["sms_allowed"] !== "t"
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


}
?>
