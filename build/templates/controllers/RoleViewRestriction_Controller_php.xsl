<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'RoleViewRestriction'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(FRAME_WORK_PATH.'basic_classes/SessionVarManager.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">

	public function update_user_restrictions($pm, $oper){
	
		$role_id = $this->getExtVal($pm,'role_id');
		$back_days_allowed = $this->getExtVal($pm,'back_days_allowed');
		$front_days_allowed = $this->getExtVal($pm,'front_days_allowed');
		
		if($oper=='update' &amp;&amp; isset($role_id)){
			//change role - error
			throw new Exception("Сначала удалите правило, потом заведите новое!");
		
		}else if($oper!='insert' &amp;&amp; (!isset($back_days_allowed) || !isset($front_days_allowed)) ){
			//get fields
			$ar_role = $this->getDbLink()->query_first(sprintf(
				"SELECT
					back_days_allowed,
					front_days_allowed
				FROM role_view_restrictions WHERE role_id=%s"
				,($oper=='update')? $this->getExtDbVal($pm,'old_role_id'):$this->getExtDbVal($pm,'role_id')
			));
			if(!is_array($ar_role) || !count($ar_role)){
				throw new Exception('Element not found.');
			}
			if(!isset($back_days_allowed)){
				$back_days_allowed = $ar_role['back_days_allowed'];
			}
			if(!isset($front_days_allowed)){
				$front_days_allowed = $ar_role['front_days_allowed'];
			}
		}
		if($oper=='update'){
			$role_id = $this->getExtVal($pm,'old_role_id');
		}		
	
		$sess_qid = $this->getDbLink()->query(sprintf(
		"SELECT
			sess_enc_read(l.session_id, '%s') AS data,
			l.session_id
			
		FROM logins AS l
		LEFT JOIN users AS u on u.id= l.user_id
		where l.date_time_out is null
		AND u.role_id = '%s'"
		,SESSION_KEY
		,$role_id
		));
		$my_sess = $_SESSION;
		
		if($oper=='delete'){
			$new_val = NULL;
		}else{
			$new_val = json_decode(sprintf('{"back_days_allowed":%s,"front_days_allowed":%s}', is_null($back_days_allowed)? 'null':$back_days_allowed, is_null($front_days_allowed)? 'null':$front_days_allowed));
		}
		try{
			while($sess_ar = $this->getDbLink()->fetch_array($sess_qid)){				
				//put to $_SESSION
				session_decode(base64_decode($sess_ar['data']));
				$old_val = SessionVarManager::getValue('role_view_restriction');
				SessionVarManager::setValue('role_view_restriction', $new_val, TRUE);
				//update
				try{
					$this->getDbLinkMaster()->query(sprintf(
						"SELECT sess_enc_write('%s','%s','%s','%s')"
						,$sess_ar['session_id']
						,base64_encode(session_encode())
						,SESSION_KEY
						,isset($_SERVER["REMOTE_ADDR"])? $_SERVER["REMOTE_ADDR"] : '127.0.0.1'
					));
				}catch(Exception $e) {
					SessionVarManager::setValue('role_view_restriction', $old_val, TRUE);	
				}
			}
		}finally{
			$_SESSION = $my_sess;
		}
	}
	
	public function update($pm){
		$this->update_user_restrictions($pm, 'update');
		parent::update($pm);
	}

	public function insert($pm){
		$this->update_user_restrictions($pm, 'insert');
		parent::insert($pm);
	}

	public function delete($pm){
		$this->update_user_restrictions($pm, 'delete');
		parent::delete($pm);
	}
	

</xsl:template>

</xsl:stylesheet>
