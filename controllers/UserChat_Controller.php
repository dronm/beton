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



require_once(USER_MODELS_PATH.'UserChatUserList_Model.php');
require_once(FRAME_WORK_PATH.'basic_classes/ModelWhereSQL.php');
require_once(ABSOLUTE_PATH.'functions/notifications.php');
require_once(ABSOLUTE_PATH.'functions/thumbnail.php');
require_once(ABSOLUTE_PATH.'functions/tm_sync_files.php');

class UserChat_Controller extends ControllerSQL{

	const MSG_COUNT = 10;

	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		/* get_object */
		$pm = new PublicMethod('get_object');
		$pm->addParam(new FieldExtString('mode'));
		
		$pm->addParam(new FieldExtInt('id'
		));
		
		$pm->addParam(new FieldExtString('lsn'));
		$this->addPublicMethod($pm);
		$this->setObjectModelId('UserChat_Model');		

			
		$pm = new PublicMethod('get_user_list');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('send');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('recipient',$opts));
	
				
	$opts=array();
	
		$opts['length']=1000;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('message',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('send_media');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('recipient',$opts));
	
				
	$opts=array();
	
		$opts['length']=1000;				
		$pm->addParam(new FieldExtString('caption',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('media_file',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_history');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('recipient',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	private static function send_message($link, $fromUserId, $toUserId, $msgType, $msg){
		//$toUserId can be null
		$link->query(sprintf("INSERT INTO
			notifications.user_chat (from_user_id, to_user_id, media_type, message)
			VALUES (
				%d,
				%s,
				'%s',
				'%s'::jsonb
			)"
			,$fromUserId
			,$toUserId
			,$msgType
			,$msg
		));
	}
	
	public function send($pm){
		$msg = $this->getExtVal($pm, 'message');
		$msg = str_replace('"', '\"', $msg);
		$msg_for_db = $this->getDbLinkMaster()->escape_string($msg);
		$user_id = $this->get_user_id_from_recipient($pm);
		self::send_message(
			$this->getDbLinkMaster(),
			$_SESSION['user_id'],
			$user_id,
			"text",
			sprintf('{"text": "%s"}', $msg_for_db)
		);
	}

	public function send_media($pm){
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
		$uniq_name = USER_CHAT_STORE.DIRECTORY_SEPARATOR.$name;
		move_uploaded_file($tmp_name, $uniq_name);
		//copy to other servers
		syncStore($uniq_name);
		

		$user_id = $this->get_user_id_from_recipient($pm);
		try{
			$mime = mime_content_type($uniq_name);
			if($mime === FALSE){
				throw new Exception("mime_content_type failed()");
			}
			$msg_mime = get_tm_mime_type($mime);
			if(is_null($msg_mime)){
				throw new Exception("Unknown mime tipe: ".$mime);
			}

			$capt = $pm->getParamValue('caption');
			$capt = (!isset($capt) || $capt=='NULL')? NULL : $this->getExtVal($pm, 'caption');

			//for deleting in case of error
			$thumb_file = NULL;

			//user chat file to server
			$ext = pathinfo($user_name, PATHINFO_EXTENSION);
			$msg = NULL;
			if($msg_mime == "document"){
				$msg = array(
					'document' => array(
						'file_id' => $name,
						'file_unique_id' => $name,
						'file_name' => $user_name,
						'file_size' => filesize($uniq_name),
						'mime_type' => $msg_mime,
					)
				);
			
				//preview generation, might fail for certain file formats 
				$thumb_res = NULL;
				try{
					gen_thumbnail($uniq_name, $ext, $thumb_res);
					$thumb_file = $thumb_res["preview_file"];
					syncStore($thumb_file);
					$thumb_file_name = basename($thumb_res["preview_file"]);
					
					$msg['document']['thumb'] = array(
						'width' => $thumb_res["width"],
						'height' => $thumb_res["height"],
						'file_id' => $thumb_file_name,
						'file_unique_id' => $thumb_file_name,
						'file_size' => filesize($thumb_res["preview_file"])
					);

					
				}catch(Exception $e){				
				}
				if(!is_null($capt)){
					$msg['caption'] = $capt;
				}

			}else if($msg_mime == "photo"){
				$msg = array('photo' => array());
				
				$photo_dimen = NULL;
				get_image_dimensions($uniq_name, $photo_dimen);
				
				//preview generation, might fail for certain file formats 				
				$thumb_res = NULL;
				try{
					gen_thumbnail($uniq_name, $ext, $thumb_res);
					$thumb_file = $thumb_res["preview_file"];
					syncStore($thumb_file);
					$thumb_file_name = basename($thumb_res["preview_file"]);
					array_push($msg['photo'],
						array(
							'file_id' => $thumb_file_name,
							'file_unique_id' => $thumb_file_name,
							'width' => $thumb_res["width"],
							'height' => $thumb_res["height"],
							'file_size' => filesize($thumb_res["preview_file"]),
							'mime_type' => $msg_mime
						)
					
					);
					
				}catch(Exception $e){				
				}
				
				//main photo
				array_push($msg['photo'],
					array(
						'file_id' => $name,
						'file_unique_id' => $name,
						'width' => $photo_dimen["width"],
						'height' => $photo_dimen["height"],
						'file_size' => filesize($uniq_name),
						'mime_type' => $msg_mime
					)
				
				);
				
				if(!is_null($capt)){
					$msg['caption'] = $capt;
				}

			}else if($tm_mime == "audio"){
				//no preview here
				$msg = array(
					'audio' => array(
						'file_id' => $name,
						'file_unique_id' => $name,
						'file_name' => $user_name,
						'file_size' => filesize($uniq_name),
						'mime_type' => $msg_mime
					)
				);
				if(!is_null($capt)){
					$msg['audio']['track'] = $capt;
				}

			}else if($tm_mime == "video"){
				//no preview here
				$msg = array(
					'video' => array(
						'file_id' => $name,
						'file_unique_id' => $name,
						'file_name' => $user_name,
						'file_size' => filesize($uniq_name),
						'mime_type' => $msg_mime
					)
				);
				if(!is_null($capt)){
					$msg['caption'] = $capt;
				}
			}
			
			self::send_message(
				$this->getDbLinkMaster(),
				$_SESSION['user_id'],
				$user_id,
				$msg_mime,
				json_encode($msg)
			);
		}catch(Exception $e){
			//TODO: delete file from remote server
			if(file_exists($uniq_name)){
				unlink($uniq_name);
			}
			if(isset($thumb_file) && file_exists($thumb_file)){
				unlink($thumb_file);
			}
			throw new Exception($e);
		}
	}

	//override, do not show current user
	public function get_user_list($pm){
		$this->addNewModel(sprintf("SELECT * FROM notifications.user_chat_user_list(%d)", $_SESSION["user_id"]), "UserChatUserList_Model");
	}

	private function get_user_id_from_recipient($pm){
		$rec = $this->getExtVal($pm, 'recipient');
		if(is_null($rec)){
			return "NULL";
		}
		$recipient = json_decode($rec, TRUE);
		if(!isset($recipient['keys']) || !isset($recipient['keys']['id'])){
			return "NULL";
		}
		return intval($recipient['keys']['id']);
	}

	public function get_history($pm){
		$user_id = $this->get_user_id_from_recipient($pm);
		
		$this->addNewModel(sprintf(
			"SELECT * FROM notifications.user_chat_history(%d, %s, %d)"
			,$_SESSION['user_id']
			,$user_id
			,self::MSG_COUNT
		), 'UserChatHistory_Model');		
	}
	

}
?>
