<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'EntityContact'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public static function get_entuty_descr($entityType){
		if($entityType == 'clients'){
			return 'Контрагенты';
		}else if($entityType == 'users'){
			return 'Пользователи';
		}else if($entityType == 'suppliers'){
			return 'Поставщики';			
		}else if($entityType == 'pump_vehicles'){
			return 'Насосы';			
		}
	}
	
	public function check_contact($pm, $oldId){
		$ent_exists = $this->getDbLink()->query_first(sprintf(
			"SELECT
				e_ct.entity_id,
				e_ct.entity_type,
				CASE
					WHEN e_ct.entity_type = 'clients' THEN
						(SELECT t.name FROM clients AS t WHERE t.id = e_ct.entity_id)
					WHEN e_ct.entity_type = 'users' THEN
						(SELECT t.name FROM users AS t WHERE t.id = e_ct.entity_id)
					WHEN e_ct.entity_type = 'suppliers' THEN
						(SELECT t.name_full FROM suppliers AS t WHERE t.id = e_ct.entity_id)
					WHEN e_ct.entity_type = 'pump_vehicles' THEN
						(SELECT
							pump_vehicles_ref(t, v, v_o)->>'descr'
						FROM pump_vehicles AS t
						LEFT JOIN vehicles AS v ON v.id = t.vehicle_id
						LEFT JOIN vehicle_owners AS v_o ON v_o.id = v.vehicle_owner_id
						WHERE t.id = e_ct.entity_id
					)
					ELSE 'Нет представления для '||e_ct.entity_type
				END AS entity_descr
			FROM entity_contacts AS e_ct
			WHERE e_ct.entity_type = %s AND e_ct.entity_id = %d
				AND e_ct.contact_id = %d
				AND (%d = 0 OR e_ct.id &lt;&gt; %d)"
			,$this->getExtDbVal($pm, 'entity_type')
			,$this->getExtDbVal($pm, 'entity_id')
			,$this->getExtDbVal($pm, 'contact_id')
			,$oldId
			,$oldId
		));
		if(is_array($ent_exists) &amp;&amp; count($ent_exists) &amp;&amp; isset($ent_exists['entity_id']) &amp;&amp; intval($ent_exists['entity_id'])){
			throw new Exception(sprintf('Контакт уже существует у "%s": %s (код %d)'
				,self::get_entuty_descr($ent_exists['entity_type'])
				,$ent_exists['entity_descr']
				,$ent_exists['entity_id']				
			));
		}		
	}
	
	public function insert($pm){
		$this->check_contact($pm, 0);
		parent::insert($pm);
	}
	public function update($pm){
		$this->check_contact($pm, $this->getExtDbVal($pm, 'old_id'));
		parent::update($pm);
	}
	
</xsl:template>

</xsl:stylesheet>
