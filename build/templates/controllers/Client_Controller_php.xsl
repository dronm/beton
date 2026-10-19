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
require_once(USER_MODELS_PATH.'ClientMergeList_Model.php');
require_once(USER_MODELS_PATH.'ClientMergeSelectedList_Model.php');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL){
		parent::__construct($dbLinkMaster);<xsl:apply-templates/>
	}
<![CDATA[
	private function mergeUserId(){
		$user_id = isset($_SESSION['user_id']) ? (string)$_SESSION['user_id'] : '';
		if (!preg_match('/^[1-9][0-9]{0,9}$/D', $user_id) || (float)$user_id > 2147483647){
			throw new Exception('Для выбора клиентов необходимо войти в систему.');
		}
		return (int)$user_id;
	}
	private function mergePositiveId($pm, $field){
		$id = (string)$pm->getParamValue($field);
		if (!preg_match('/^[1-9][0-9]{0,9}$/D', $id) || (float)$id > 2147483647){
			throw new Exception('Некорректный код клиента.');
		}
		return (int)$id;
	}
	private function mergeList($model, $pm, $selected, $user_id){
		$is_insert = NULL;
		$client_where = NULL;
		$order = NULL;
		$limit = NULL;
		$fields = NULL;
		$group_fields = NULL;
		$aggregate_fields = NULL;
		$calc_total = NULL;
		$this->setQueryOptionsFromParams($model, $pm, $is_insert, $client_where, $order,
			$limit, $fields, $group_fields, $aggregate_fields, $calc_total);
		$where = new ModelWhereSQL();
		if ($client_where !== NULL && $client_where->getFieldCount()){
			// Group client filters before adding the mandatory server-side user scope.
			$where->addExpression('merge_filters', '('.$client_where->getSQL(FALSE).')');
		}
		$where->addExpression('merge_user_scope', sprintf(
			'%sEXISTS (SELECT 1 FROM public.client_merge_selections AS selection WHERE selection.user_id = %d AND selection.client_id = client_merge_list.id)',
			$selected ? '' : 'NOT ', $user_id));
		if ($selected && !$pm->getParamValue('ord_fields')){
			$order = new ModelOrderSQL();
			$order->addField($model->getFieldById('orders_count'), 'DESC');
			$order->addField($model->getFieldById('name'), 'ASC');
			$order->addField($model->getFieldById('id'), 'ASC');
		}
		// Use the regular select path so filtering, ordering, pagination and count share scope.
		$model->select(FALSE, $where, $order, $limit, $fields, $group_fields,
			$aggregate_fields, $calc_total, TRUE);
		$this->addModel($model);
		$this->afterSelect();
	}
	public function get_merge_list($pm){
		$user_id = $this->mergeUserId();
		$model = new ClientMergeList_Model($this->getDbLinkMaster());
		$this->mergeList($model, $pm, FALSE, $user_id);
	}
	public function get_merge_selected($pm){
		$user_id = $this->mergeUserId();
		// The basket is capped at 100; return all of it regardless of requested paging.
		$pm->setParamValue('from', 0);
		$pm->setParamValue('count', 100);
		$model = new ClientMergeSelectedList_Model($this->getDbLinkMaster());
		$this->mergeList($model, $pm, TRUE, $user_id);
	}
	public function merge_select($pm){
		$this->getDbLinkMaster()->query('SELECT public.clients_merge_select($1::integer, $2::integer)',
			array($this->mergeUserId(), $this->mergePositiveId($pm, 'client_id')));
	}
	public function merge_unselect($pm){
		$this->getDbLinkMaster()->query('SELECT public.clients_merge_unselect($1::integer, $2::integer)',
			array($this->mergeUserId(), $this->mergePositiveId($pm, 'client_id')));
	}
	public function merge_clear_selection($pm){
		$this->getDbLinkMaster()->query('SELECT public.clients_merge_clear($1::integer)',
			array($this->mergeUserId()));
	}
	private function mergeExpectedIds($pm){
		$ids = explode(',', (string)$pm->getParamValue('client_ids'));
		if (count($ids) > 100){
			throw new Exception('Выберите не более 100 клиентов.');
		}
		foreach ($ids as &$id){
			$id = trim($id);
			if (!preg_match('/^[1-9][0-9]{0,9}$/D', $id) || (float)$id > 2147483647){
				throw new Exception('Некорректный список выбранных клиентов.');
			}
		}
		unset($id);
		return '{'.implode(',', array_values(array_unique($ids))).'}';
	}
	public function merge_selected($pm){
		// The locked saved basket is authoritative; expected IDs detect stale browser tabs.
		$this->getDbLinkMaster()->query('SELECT public.clients_merge_selected($1::integer, $2::integer, $3::integer[])',
			array($this->mergeUserId(), $this->mergePositiveId($pm, 'main_client_id'), $this->mergeExpectedIds($pm)));
	}
	public function merge($pm){
		$params = new ParamsSQL($pm, $this->getDbLinkMaster());
		$params->addAll();
		$main_id = (string)$params->getVal('main_client_id');
		$raw_ids = (string)$params->getVal('client_ids');
		if (!preg_match('/^[1-9][0-9]{0,9}$/D', $main_id) || (float)$main_id > 2147483647){
			throw new Exception('Некорректный код главного клиента.');
		}
		$ids = explode(',', $raw_ids);
		if (count($ids) > 100){
			throw new Exception('Выберите не более 100 клиентов.');
		}
		foreach ($ids as &$id){
			$id = trim($id);
			if (!preg_match('/^[1-9][0-9]{0,9}$/D', $id) || (float)$id > 2147483647){
				throw new Exception('Список клиентов должен содержать положительные целые коды через запятую.');
			}
		}
		unset($id);
		$ids = array_values(array_unique($ids));
		if (count($ids) < 2 || !in_array($main_id, $ids, TRUE)){
			throw new Exception('Выберите не менее двух клиентов и главного клиента из этого списка.');
		}
		// A single PostgreSQL statement: every update and deletion succeeds or rolls back.
		$this->getDbLinkMaster()->query(
			'SELECT public.clients_merge($1::integer, $2::integer[])',
			array($main_id, '{'.implode(',', $ids).'}')
		);
	}
	public function union($pm){
		// Preserve the old API while using the same validation and merge rules.
		$this->merge($pm);
	}
]]>
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
