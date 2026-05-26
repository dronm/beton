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
	

	public function add_file($pm) {
		if (
			!isset($_FILES['content_data']) ||
			!is_array($_FILES['content_data']['name']) ||
			!count($_FILES['content_data']['name'])
		) {
			return;
		}

		$origContentInfo = json_decode($this->getExtVal($pm, 'content_info'), TRUE);
		$ref = json_decode($this->getExtVal($pm, 'ref'), TRUE);

		$uploadedName = $_FILES['content_data']['name'][0];
		$uploadedTmpName = $_FILES['content_data']['tmp_name'][0];

		$link = $this->getDbLinkMaster();

		$contentData = pg_escape_bytea(
			$link->link_id,
			file_get_contents($uploadedTmpName)
		);

		$contentPreview = NULL;

		try {
			$contentPreview = $this->gen_thumbnail_bytea(
				$uploadedTmpName,
				$uploadedName,
				$link->link_id
			);
		} catch (Exception $e) {
			error_log($e->getMessage());
			$contentPreview = NULL;
		}

		$contentInfo = json_encode(
			[
				'name' => $uploadedName,
				'id' => $origContentInfo['id'],
				'size' => filesize($uploadedTmpName),
			],
			JSON_UNESCAPED_UNICODE
		);

		$link->query("BEGIN");

		try {
			$arDel = $link->query_first(
				"DELETE FROM attachments
				WHERE (ref->'keys'->>'id')::int = $1
					AND content_info->>'id' = $2
				RETURNING id",
				[
					$ref['keys']['id'],
					$origContentInfo['id'],
				]
			);

			if (is_array($arDel) && isset($arDel['id'])) {
				self::delete_tmp_file_name($arDel['id']);
			}

			$link->query(
				"INSERT INTO attachments
				(ref, content_info, content_data, content_preview)
				VALUES ($1, $2, $3, $4)",
				[
					$this->getExtVal($pm, 'ref'),
					$contentInfo,
					$contentData,
					$contentPreview,
				]
			);

			$link->query("COMMIT");
		} catch (Exception $e) {
			$link->query("ROLLBACK");
			throw $e;
		}
	}

	public function get_file($pm){
		$link = $this->getDbLinkMaster();
		$ref = json_decode($this->getExtVal($pm, 'ref'), TRUE);

		$ar = $link->query_first(
			"SELECT content_info, content_data 
			FROM attachments
			WHERE (ref->'keys'->>'id')::int = $1 AND content_info->>'id' = $2",
			[ $ref["keys"]["id"] ,$this->getExtVal($pm, 'content_id') ]
		);
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
		$ar = $link->query_first(
			"DELETE FROM attachments
			WHERE (ref->'keys'->>'id')::int = $1 AND content_info->>'id' = $2 
			RETURNING id",
			[ $ref["keys"]["id"], $this->getExtVal($pm, 'content_id') ]
		);

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

	private static function run_cmd(array $cmd, ?string $cwd = NULL, array $env = []): void {
		$descriptorSpec = [
			0 => ['pipe', 'r'],
			1 => ['pipe', 'w'],
			2 => ['pipe', 'w'],
		];

		$process = proc_open($cmd, $descriptorSpec, $pipes, $cwd, $env);

		if (!is_resource($process)) {
			throw new Exception('Failed to start command: ' . implode(' ', $cmd));
		}

		fclose($pipes[0]);

		$stdout = stream_get_contents($pipes[1]);
		$stderr = stream_get_contents($pipes[2]);

		fclose($pipes[1]);
		fclose($pipes[2]);

		$exitCode = proc_close($process);

		if ($exitCode !== 0) {
			throw new Exception(
				'Command failed: ' . implode(' ', $cmd) .
				"\nExit code: " . $exitCode .
				"\nSTDOUT: " . $stdout .
				"\nSTDERR: " . $stderr
			);
		}
	}

	private static function remove_dir_recursive(string $dir): void {
		if (!is_dir($dir)) {
			return;
		}

		$items = scandir($dir);

		foreach ($items as $item) {
			if ($item === '.' || $item === '..') {
				continue;
			}

			$path = $dir . DIRECTORY_SEPARATOR . $item;

			if (is_dir($path)) {
				self::remove_dir_recursive($path);
			} else {
				@unlink($path);
			}
		}

		@rmdir($dir);
	}

	private static function gen_thumbnail_bytea(string $sourceTmpPath, string $realName, $pgLink): ?string {
		$ext = strtolower(pathinfo($realName, PATHINFO_EXTENSION));

		if ($ext === '') {
			return NULL;
		}

		$officeExts = ['doc', 'docx', 'xls', 'xlsx', 'odt', 'ods'];
		$pdfExts = ['pdf'];

		$workDir = sys_get_temp_dir() . DIRECTORY_SEPARATOR . 'att_thumb_' . bin2hex(random_bytes(8));

		if (!mkdir($workDir, 0700, TRUE) && !is_dir($workDir)) {
			throw new Exception('Failed to create thumbnail temp dir');
		}

		try {
			$srcPath = $workDir . DIRECTORY_SEPARATOR . 'source.' . $ext;
			$previewPrefix = $workDir . DIRECTORY_SEPARATOR . 'preview';
			$previewPath = $workDir . DIRECTORY_SEPARATOR . 'preview.jpg';

			if (!copy($sourceTmpPath, $srcPath)) {
				throw new Exception('Failed to copy uploaded file for thumbnail generation');
			}

			if (in_array($ext, $officeExts, TRUE)) {
				self::run_cmd(
					[
						'soffice',
						'--headless',
						'--convert-to',
						'pdf:writer_pdf_Export',
						'--outdir',
						$workDir,
						$srcPath,
					],
					$workDir,
					[
						'HOME' => $workDir,
					]
				);

				$pdfPath = $workDir . DIRECTORY_SEPARATOR . 'source.pdf';

				if (!file_exists($pdfPath)) {
					throw new Exception('LibreOffice did not create PDF file');
				}

				$this->run_cmd(
					[
						'pdftoppm',
						'-l',
						'1',
						'-scale-to',
						'300',
						'-jpeg',
						$pdfPath,
						$previewPrefix,
					],
					$workDir
				);

				$generatedPreviewPath = $previewPrefix . '-1.jpg';

				if (!file_exists($generatedPreviewPath)) {
					throw new Exception('pdftoppm did not create thumbnail');
				}

				$previewPath = $generatedPreviewPath;
			} elseif (in_array($ext, $pdfExts, TRUE)) {
				$this->run_cmd(
					[
						'pdftoppm',
						'-l',
						'1',
						'-scale-to',
						'300',
						'-jpeg',
						$srcPath,
						$previewPrefix,
					],
					$workDir
				);

				$generatedPreviewPath = $previewPrefix . '-1.jpg';

				if (!file_exists($generatedPreviewPath)) {
					throw new Exception('pdftoppm did not create thumbnail');
				}

				$previewPath = $generatedPreviewPath;
			} else {
				self::run_cmd(
					[
						'convert',
						'-define',
						'jpeg:size=500x180',
						$srcPath,
						'-auto-orient',
						'-thumbnail',
						'250x100',
						'-unsharp',
						'0x.5',
						$previewPath,
					],
					$workDir
				);

				if (!file_exists($previewPath)) {
					throw new Exception('ImageMagick did not create thumbnail');
				}
			}

			$previewData = file_get_contents($previewPath);

			if ($previewData === FALSE || $previewData === '') {
				return NULL;
			}

			return pg_escape_bytea($pgLink, $previewData);
		} finally {
			self::remove_dir_recursive($workDir);
		}
	}

}
?>
