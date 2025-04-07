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



require_once('common/downloader.php');

class Attachment_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		$pm = new PublicMethod('delete_file');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('ref',$opts));
	
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('content_id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('get_file');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('ref',$opts));
	
				
	$opts=array();
	
		$opts['length']=36;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('content_id',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('inline',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('add_file');
		
				
	$opts=array();
	
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('ref',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('content_data',$opts));
	
				
	$opts=array();
	
		$opts['length']=500;
		$opts['required']=TRUE;				
		$pm->addParam(new FieldExtString('content_info',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	

	public function add_file($pm){
		if (
			isset($_FILES['content_data']) 
			&& is_array($_FILES['content_data']['name']) 
			&& count($_FILES['content_data']['name'])
		){

			$link = $this->getDbLinkMaster();

			$pm->setParamValue('content_data', pg_escape_bytea($link->link_id,file_get_contents($_FILES['content_data']['tmp_name'][0])) );
			$pm->setParamValue('content_info',
				sprintf('{"name":"%s","id":"1","size":"%s"}',
				$_FILES['content_data']['name'][0],
				filesize($_FILES['content_data']['tmp_name'][0])
				)
			);			
			$link->query("BEGIN");
			try{

				$ref = json_decode($this->getExtVal($pm, 'ref'), TRUE);
				$contentInfo = json_decode($this->getExtVal($pm, 'content_info'), TRUE);
				$query = sprintf(
					"DELETE FROM attachments
					WHERE (ref->'keys'->>'id')::int = %d AND content_info->>'id' = '%s'"
					,$ref["keys"]["id"]
					,$contentInfo["id"]
				);
				$arDel = $link->query_first($query);
				if(is_array($arDel) && isset($arDel["id"])){
					self::delete_tmp_file_name($arDel["id"]);
				}

				$link->query($query);
				$query = sprintf(
					"INSERT INTO attachments
					(ref, content_info, content_data)
					VALUES (%s, %s, %s)"
					,$this->getExtDbVal($pm, 'ref')
					,$this->getExtDbVal($pm, 'content_info')
					,$this->getExtDbVal($pm, 'content_data')
				);
				$link->query($query);
				$link->query("COMMIT");

			}catch(Exception $e){
				$link->query("ROLLBACK");
				throw $e;
			}
		}
	}

	public function get_file($pm){
		$link = $this->getDbLinkMaster();
		$ref = json_decode($this->getExtVal($pm, 'ref'), TRUE);
		$query = sprintf(
			"SELECT content_info, content_data 
			FROM attachments
			WHERE (ref->'keys'->>'id')::int = %d AND content_info->>'id' = %s"
			,$ref["keys"]["id"]
			,$this->getExtDbVal($pm, 'content_id')
		);
		$ar = $link->query_first($query);
		if(!is_array($ar) || !count($ar) || !isset($ar["content_info"])){
			throw new Exception("attachment not found");
		}
		$fl = OUTPUT_PATH.uniqid();
		file_put_contents($fl, pg_unescape_bytea($ar['content_data']));

		try{
			$attType = ($this->getExtVal($pm, 'inline') == 1)? "inline;": "attachment;";
			$fl_n = json_decode($ar['content_info'])->name;
			$fl_mime = getMimeTypeOnExt($fl_n);
			ob_clean();
			downloadFile(
				$fl,
				$fl_mime,
				$attType,
				$fl_n
			);
		}finally{
			unlink($fl);
		}
		return TRUE;
	}

	public function delete_file($pm){
		$link = $this->getDbLinkMaster();
		$ref = json_decode($this->getExtVal($pm, 'ref'), TRUE);
		$query = sprintf(
			"DELETE FROM attachments
			WHERE (ref->'keys'->>'id')::int = %d AND content_info->>'id' = '%s'
			RETURNING id"
			,$ref["keys"]["id"]
			,$this->getExtVal($pm, 'content_id')
		);
		$ar = $link->query_first($query);

		if(is_array($ar) && isset($ar["id"])){
			self::delete_tmp_file_name($arr["id"]);
		}
	}

	private static function get_tmp_file_name($attId){
		return OUTPUT_PATH. md5('attachment_'. $attId);
	}

	public static function save_to_tmp($dbLink, $attId){
		$tmplFile = self::get_tmp_file_name($attId);
		if(file_exists($tmplFile)){
			//check for zero length
			if(filesize($tmplFile) != 0){
				return $tmplFile;
			}
			unlink($tmplFile);
		}

		$query = sprintf(
			"SELECT content_data 
			FROM attachments
			WHERE id = %d"
				,$attId
		);
		$ar = $dbLink->query_first($query);
		if(!is_array($ar) || !isset($ar["content_data"])){
			throw new Exception("attachment not found");
		}
		file_put_contents($tmplFile, pg_unescape_bytea($ar['content_data']));

		return $tmplFile;
	}

	private static function delete_tmp_file_name($attId){
		$tmpFile = self::get_tmp_file_name($attId);
		if(file_exists($tmpFile)){
			unlink($tmpFile);
		}
	}


}
?>
