<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Connect1c'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>

require_once(ABSOLUTE_PATH.'functions/exch1c.php');

class <xsl:value-of select="@id"/>_Controller extends <xsl:value-of select="@parentId"/>{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);<xsl:apply-templates/>
	}	
	<xsl:call-template name="extra_methods"/>
}
<![CDATA[?>]]>
</xsl:template>

<xsl:template name="extra_methods">
	public function complete_user($pm){		
		$search = $this->getExtVal($pm, "search");
		$users = Exch1c::catalogByAttr('users', $search);
		$model = new Model(array("id"=>"User1cList_Model"));
		foreach($users as $user){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $user["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $user["name"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
		<!-- ob_clean(); -->
		<!-- header('Content-Type: application/json; charset=utf-8'); -->
		<!-- echo json_encode($resp, JSON_UNESCAPED_UNICODE); -->
		<!-- return true; -->
	}

	public function complete_item($pm){		
		$search = $this->getExtVal($pm, "search");
		$users = Exch1c::catalogByAttr('items', $search);
		$model = new Model(array("id"=>"Item1cList_Model"));
		foreach($users as $user){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $user["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $user["name"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
	}

	private function add_result_model($res){		
		$res_json = json_encode($res, JSON_UNESCAPED_UNICODE);

		$model = new Model(array("id"=>"Result1c_Model"));
		$fields = [ new Field('obj',DT_STRING,array('value'=>(string) $res_json)) ];
		$model->insert($fields);
		$this->addModel($model);
	}

	public function service_stop($pm){		
		$res = Exch1c::stop();
		$this->add_result_model($res);
	}

	public function service_start($pm){		
		$res = Exch1c::start();
		$this->add_result_model($res);
	}

	public function service_status($pm){		
		$res = Exch1c::status();
		$this->add_result_model($res);
	}

	public function service_health($pm){		
		$res = Exch1c::health(); //returns string!
		$this->add_result_model(['response' => $res]);
	}

	public function production_report_export($pm){		
		$id = $this->getExtDbVal($pm, 'id');
		$link = $this->getDbLinkMaster();
		$res = self::exportProductionReport($link, $id);
		$this->add_result_model($res);
	}

	public static function exportProductionReport($dbLink, $id){		
		$ar = $dbLink->query_first(
			"SELECT 
				t.data_for_1c_current AS params
			FROM production_reports_dialog AS t
			WHERE t.id = $1", [$id]
		);
		if(!is_array($ar) || !count($ar)){
			throw new Exception("document not found");
		}
		$res = Exch1c::newProductionReport(json_decode($ar["params"], TRUE));

		$dbLink->query(
			"UPDATE production_reports SET 
				data_for_1c = $1,
				ref_1c = $2
			WHERE id = $3", 
			[ json_encode($ar["params"]), json_encode($res), $id ]
		);

		return $res;
	}

</xsl:template>

</xsl:stylesheet>
