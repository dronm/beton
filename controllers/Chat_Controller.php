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



require_once(ABSOLUTE_PATH.'Config.uniq.php');

class Chat_Controller extends ControllerSQL{

	const MSG_COUNT = 10;

	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		$pm = new PublicMethod('get_history');
		
				
	$opts=array();
	
		$opts['length']=500;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('recipient',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

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

}
?>