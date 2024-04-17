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


class UserChatStatus_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		$pm = new PublicMethod('set');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtInt('chat_status_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_select_list');
		
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

		
	}	
	

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

}
?>
