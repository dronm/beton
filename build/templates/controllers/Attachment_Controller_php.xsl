<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Attachment'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>


<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once('common/downloader.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">

	public function add_file($pm){
		if (
			isset($_FILES['content_data']) 
			&amp;&amp; is_array($_FILES['content_data']['name']) 
			&amp;&amp; count($_FILES['content_data']['name'])
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
				if(is_array($arDel) &amp;&amp; isset($arDel["id"])){
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
			WHERE (ref->'keys'->>'id')::int = %d AND content_info->>'id' = '%s'"
			,$ref["keys"]["id"]
			,$this->getExtVal($pm, 'content_id')
		);
		$ar = $link->query_first($query);

		if(is_array($ar) &amp;&amp; isset($ar["id"])){
			self::delete_tmp_file_name($arr["id"]);
		}
	}

	private static function get_tmp_file_name($attId){
		return OUTPUT_PATH. md5('attachment_'. $attId);
	}

	public static function save_to_tmp($dbLink, $attId): string{
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
		$tmplFile = self::get_tmp_file_name($attId);
		file_put_contents($tmplFile, pg_unescape_bytea($ar['file_data']));

		return $tmplFile;
	}

	private static function delete_tmp_file_name($attId){
		$tmpFile = self::get_tmp_file_name($attId);
		if(file_exists($tmpFile)){
			unlink($tmpFile);
		}
	}

</xsl:template>

</xsl:stylesheet>
