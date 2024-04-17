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
require_once(ABSOLUTE_PATH.'Config.uniq.php');
require_once('common/telegram.php');

//require_once(FRAME_WORK_PATH.'basic_classes/ModelWhereSQL.php');
//require_once(USER_MODELS_PATH.'TmOutMessageList_Model.php');

class TmOutMessage_Controller extends ControllerSQL{
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
		
		$this->setListModelId('TmOutMessageList_Model');
		
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('TmOutMessageList_Model');		

			
		$pm = new PublicMethod('send');
		
				
	$opts=array();
	
		$opts['length']=500;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('recipient',$opts));
	
				
	$opts=array();
	
		$opts['length']=1000;
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

			
		$pm = new PublicMethod('tm_invite');
		
				
	$opts=array();
	
		$opts['length']=500;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('recipient',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('tm_invite_contact');
		
				
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
	
	

	public function send_media($pm){
		$recipient = $this->getExtVal($pm, 'recipient');		
		$recipient_ref = json_decode($recipient, TRUE);
		$contact_id = intval($recipient_ref['keys']['id']);
		
		$tm_ar = $this->getDbLink()->query_first(sprintf(
			"SELECT
				tm_user->>'id' AS tm_id
			FROM notifications.ext_users
			WHERE ext_contact_id = %d AND app_id = %d"
			,$contact_id
			,MS_APP_ID
		));
		if(!is_array($tm_ar) || !count($tm_ar) || !isset($tm_ar['tm_id'])){
			throw new Exception('Telegram ID not defined!');
		}

		if(!isset($_FILES["media_file"]) ||
		!isset($_FILES["media_file"]["tmp_name"])
		){
			throw new Exception("Файл не найден");
		}
		if(is_array($_FILES["media_file"]["tmp_name"])){
			$tmp_name = $_FILES["media_file"]["tmp_name"][0];
			$name = basename($_FILES["media_file"]["tmp_name"][0]);
			$user_name = $_FILES["media_file"]["name"][0];
		}else{	
			$tmp_name = $_FILES["media_file"]["tmp_name"];
			$name = basename($_FILES["media_file"]["tmp_name"]);
			$user_name = $_FILES["media_file"]["name"];
		}
		$uniq_name = TM_STORE.DIRECTORY_SEPARATOR.$name;
		move_uploaded_file($tmp_name, $uniq_name);

		$mime = mime_content_type($uniq_name);
		if($mime === FALSE){
			throw new Exception("mime_content_type failed()");
		}
		$tm_mime = get_tm_mime_type($mime);
		if(is_null($tm_mime)){
			throw new Exception("Unknown mime tipe: ".$mime);
		}

		$capt = $pm->getParamValue('caption');
		$capt = (!isset($capt) || $capt=='NULL')? NULL : $this->getExtVal($pm, 'caption');
		send_file_to_user(
			$this->getDbLinkMaster(),
			$tm_ar['tm_id'],
			$capt,
			$uniq_name,
			$tm_mime,
			$user_name,
			$contact_id,
		);
	}
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
		

}
?>
