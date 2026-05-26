<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Client'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(FRAME_WORK_PATH.'basic_classes/ParamsSQL.php');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);<xsl:apply-templates/>
	}
	public function union($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();		
		
		$client_ids = $params->getVal('client_ids');
		//validation
		$ids_ar = split(',',$client_ids);
		foreach($ids_ar as $id){
			if (!ctype_digit($id)){
				throw new Exception('Not int found!');
			}
		}
		
		$this->getDbLinkMaster()->query(sprintf(
		//throw new Exception(sprintf(
			"SELECT clients_union(%d,ARRAY[%s])",
			$params->getParamById('main_client_id'),
			$client_ids
		));
	}
	public function get_duplicates_list($pm){
		$this->addNewModel("SELECT * FROM client_duplicates_list",
			'get_duplicates_list'
		);
	}
	public function set_duplicate_valid($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->addAll();		
		
		$client_ids = $params->getVal('client_ids');
		$tel = $params->getDbVal('tel');
		
		//validation
		$ids_ar = split(',',$client_ids);
		foreach($ids_ar as $id){
			if (!ctype_digit($id)){
				throw new Exception('Not int found!');
			}
		}
		$l = $this->getDbLinkMaster();
		foreach($ids_ar as $id){
			$l->query(sprintf(
				"INSERT INTO client_valid_duplicates
				(tel,client_id)
				VALUES (%s,%d)",
				$tel,
				$id
			));
		}
	}
	public function insert($pm){
		if (!$pm->getParamValue('manager_id')){
			$pm->setParamValue('manager_id',$_SESSION['user_id']);
		}
		parent::insert($pm);
	}
	
	public function insert_from_order($pm){
		$res = $this->getDbLink()->query_first(sprintf("SELECT id FROM clients WHERE name=%s",$this->getExtDbVal($pm,"name")));
		if(!is_array($res) || !count($res)){
			$res = $this->getDbLinkMaster()->query_first(sprintf("INSERT INTO clients (name,name_full) VALUES (%s,%s) RETURNING id",
			$this->getExtDbVal($pm,"name"),
			$this->getExtDbVal($pm,"name")
			));
		}
		$this->addModel(new ModelVars(
			array('id'=>'Client_Model',
				'values'=>array(
					new Field('id',DT_INT,
						array('value'=>$res['id'])
					)
				)
			)
		));		
	}
	
	public function complete_for_order($pm){
	
		$this->addNewModel(sprintf(
			"SELECT
				clients.id,
				clients.name,
				clients.ref_1c,
				clients.inn AS inn,
				o_last.descr,
				o_last.phone_cel,
				concrete_types_ref(ct) AS concrete_types_ref,
				destinations_ref(dest) AS destinations_ref,
				o_last.quant,
				o_last.date_time,
				debts.debt_total AS client_debt,
				debts.update_date AS client_debt_date
			FROM clients
			LEFT JOIN (
				SELECT
					max(orders.date_time) AS date_time,
					orders.client_id
				FROM orders
				WHERE orders.concrete_type_id &lt;&gt; (const_water_val()->'keys'->>'id')::int
				GROUP BY orders.client_id
			) AS o_cl ON o_cl.client_id = clients.id
			LEFT JOIN orders AS o_last ON o_last.client_id = clients.id AND o_last.date_time = o_cl.date_time
			LEFT JOIN concrete_types AS ct ON ct.id=o_last.concrete_type_id
			LEFT JOIN destinations AS dest ON dest.id=o_last.destination_id
			LEFT JOIN (
				SELECT
					d.client_id,
					d.update_date,
					sum(d.debt_total) AS debt_total
				FROM client_debts AS d		
				GROUP BY
					d.client_id,
					d.update_date
			) AS debts ON debts.client_id = clients.id			
			WHERE lower(clients.name) LIKE '%%'||lower(%s)||'%%'
			ORDER BY POSITION(lower(%s) IN lower(clients.name) )
			LIMIT 5",
			$this->getExtDbVal($pm,'name')
			,$this->getExtDbVal($pm,'name')
			),
			'OrderClient_Model', TRUE, TRUE
		);	
	}
	
}
<![CDATA[?>]]>
</xsl:template>

</xsl:stylesheet>
