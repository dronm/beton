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



require_once(ABSOLUTE_PATH.'functions/exch1c.php');

class Connect1c_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL,$dbLink=NULL){
		parent::__construct($dbLinkMaster,$dbLink);
			
		$pm = new PublicMethod('complete_user');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('search',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_warehouse');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('search',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('complete_item');
		
				
	$opts=array();
			
		$pm->addParam(new FieldExtText('search',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('ic',$opts));
	
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('mid',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('service_stop');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('service_start');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('service_health');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('service_status');
		
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('production_report_export');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('production_report_mat_export');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtInt('id',$opts));
	
			
		$this->addPublicMethod($pm);

			
		$pm = new PublicMethod('export_shipments');
		
				
	$opts=array();
					
		$pm->addParam(new FieldExtText('ids',$opts));
	
			
		$this->addPublicMethod($pm);

		
	}	
	
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
	}

	public function complete_warehouse($pm){		
		$search = $this->getExtVal($pm, "search");
		$catItems = Exch1c::catalogByAttr('warehouses', $search);
		$model = new Model(array("id"=>"Warehouse1cList_Model"));
		foreach($catItems as $cat){
			$fields = array();
			array_push($fields, new Field('ref',DT_STRING,array('value'=>(string) $cat["ref"])));
			array_push($fields, new Field('name',DT_STRING,array('value'=>(string) $cat["name"])));
			array_push($fields, new Field('search',DT_STRING,array('value'=>(string) $search)));
			$model->insert($fields);
		}
		$this->addModel($model);
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
		$res = self::exportProductionReport($link, $id, $_SESSION["user_id"]);
		$this->add_result_model($res);
	}

	public function production_report_mat_export($pm){
		$id = $this->getExtDbVal($pm, 'id');
		$link = $this->getDbLinkMaster();
		$res = self::exportProductionReportMat($link, $id, $_SESSION["user_id"]);
		$this->add_result_model($res);
	}

	public static function exportProductionReport($dbLink, $id, $userId){		
		$ar = $dbLink->query_first(
			"SELECT 
				t.data_for_1c_current AS params,
				(SELECT ref_1c->'keys'->>'ref_1c' FROM users WHERE id = $1) AS user_ref
			FROM production_reports_dialog AS t
			WHERE t.id = $2", [ $userId, $id ]
		);
		if(!is_array($ar) || !count($ar)){
			throw new Exception("document not found");
		}

		$data_for_1c = json_decode($ar["params"], TRUE);
		$data_for_1c['user_ref'] = $ar['user_ref'];
		$data_for_1c['materials'] = NULL; // do need it for production
		$res = Exch1c::newProductionReport($data_for_1c);

		$dbLink->query(
			"UPDATE production_reports SET 
				data_for_1c = $1,
				ref_1c = $2
			WHERE id = $3", 
			[ json_encode($ar["params"]), json_encode($res), $id ]
		);

		return $res;
	}

	public static function exportProductionReportMat($dbLink, $id, $userId){		
		$ar = $dbLink->query_first(
			"SELECT 
				t.data_for_1c_current AS params,
				(SELECT ref_1c->'keys'->>'ref_1c' FROM users WHERE id = $1) AS user_ref
			FROM production_reports_dialog AS t
			WHERE t.id = $2", [ $userId, $id ]
		);
		if(!is_array($ar) || !count($ar)){
			throw new Exception("document not found");
		}
		$data_for_1c = json_decode($ar["params"], TRUE);
		$data_for_1c['user_ref'] = $ar['user_ref'];
		/*
			reconstruct materials ()
				wareshouse_ref_1c text,
				wareshouse_name text,
				production_site_name text,
				name text,
				ref_1c text,
				ref_1c_descr text,
				quant numeric
			to warehouses
				ref_1c,
				materials (ref_1c, quant)
		*/
		$data_for_1c['warehouses'] = [];
		$whRef = NULL;
		$wh = NULL;
		foreach($data_for_1c['materials'] as $mat){
			if(is_null($whRef) || $whRef != $mat["wareshouse_ref_1c"]){
				// new warehouse
				if(!is_null($wh)){
					array_push($data_for_1c['warehouses'], $wh);
				}
				$whRef = $mat["wareshouse_ref_1c"];
				$wh = [
					'ref_1c' => $whRef,
					'materials' => []
				];
			}
			array_push(
				$wh["materials"],
				[ 
					"ref_1c" => $mat["ref_1c"],
					"quant" => $mat["quant"]
				]
			);
		}
		if(!is_null($wh)){
			array_push($data_for_1c['warehouses'], $wh);
		}
		$data_for_1c['materials'] = NULL;
/* file_put_contents(OUTPUT_PATH.'extch.txt', var_export(json_encode($data_for_1c), TRUE)); */
/* file_put_contents(OUTPUT_PATH.'extch.txt', var_export($data_for_1c, TRUE)); */
/* throw new Exception("stop"); */
		$res = Exch1c::newProductionReportMat($data_for_1c);

		$dbLink->query(
			"UPDATE production_reports SET 
				data_for_1c = $1,
				material_ref_1c = $2
			WHERE id = $3", 
			[ json_encode($ar["params"]), json_encode($res), $id ]
		);

		return $res;
	}

	public function export_shipments($pm){
		$link = $this->getDbLink();
		$shipmentsList = [];
		$shIds = json_decode("[".$this->getExtVal($pm, 'ids')."]", TRUE);
		foreach ($shIds as $id) {
			$oId = intval($id);
			if($oId){
				array_push($shipmentsList, $oId); 
			}
		}
/* throw new Exception("shipmentsList:".count($shipmentsList)); */

		$ar = $link->query_first(
			sprintf(
				"SELECT 
					sh.upd_ref_1c->'keys'->>'ref_1c' AS ref_1c,
					cl.ref_1c->'keys'->>'ref_1c' AS client_ref,
					sp.client_contract_1c_ref AS dogovor_ref,
					o.date_time AS date,
					%d AS shipment_count,
					'%s' AS shipment_nums,
					(SELECT 
						u.ref_1c->'keys'->>'ref_1c' 
					FROM users AS u 
					WHERE u.id = %d) AS user_ref,

					sh.demurrage_cost,

					--items
					ct.code_1c AS item_code_1c,
					o.quant,
					sp.price,

					o.pump_vehicle_id IS NOT NULL AS pump_exists,

					coalesce(ship.demurrage_cost,0) AS demurrage_cost,

					CASE 
						--all shipped
						WHEN coalesce(ship.quant, 0) = o.quant THEN
							ship.cost 
						ELSE
							round(coalesce(o_dlg.destination_price::numeric, 0::numeric) * o.quant::numeric, 2) --virtual
					END AS ship_cost,

					CASE
							--no pump
						WHEN o.pump_vehicle_id IS NULL THEN 
							0

							--all shipped
						WHEN coalesce(ship.quant, 0) = o.quant THEN
							ship.pump_cost 
						ELSE
							--virtual price
							0
					END AS pump_cost

				FROM shipments_list AS sh 
				LEFT JOIN orders AS o ON o.id = sh.order_id
				LEFT JOIN orders_dialog AS o_dlg ON o_dlg.id = o.id
				LEFT JOIN orders_list AS ol ON ol.id = o.id
				LEFT JOIN pump_prices_values AS ppr ON ppr.pump_price_id = (o_dlg.pump_prices_ref->'keys'->>'id')::int
				LEFT JOIN clients AS cl ON cl.id = o.client_id
				LEFT JOIN client_specifications AS sp ON sp.id = coalesce(sh.client_specification_id, o.client_specification_id)
				LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id
				LEFT JOIN 

				WHERE sh.id IN (%s)", 
				count($shipmentsList),
				implode(", ", $shipmentsList),
				intval($_SESSION["user_id"]),
				implode(",", $shipmentsList)
			)
		);
		if(!isset($ar["quant"])){
			throw new Exception("не установлено количество");
		}
		if(!is_array($ar) || !count($ar)){
			throw new Exception("Документ не найден");
		}
		//checkings
		if(!isset($ar["client_ref"])){
			throw new Exception("Клиент не связан с 1с");
		}
		if(!isset($ar["dogovor_ref"])){
			throw new Exception("Договор не связан с 1с");
		}
		//generate all items/services
		$res = Exch1c::newShipment(json_decode($ar["params"], TRUE));
	}


}
?>
