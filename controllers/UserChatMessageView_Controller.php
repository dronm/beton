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


class UserChatMessageView_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		$pm = new PublicMethod('set_all_viewed');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('user_id',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

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
					m.from_user_id <> %d
					
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
	

}
?>