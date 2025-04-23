<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Shipment'"/>
<!-- -->

<xsl:output method="text" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
			
<xsl:template match="/">
	<xsl:apply-templates select="metadata/controllers/controller[@id=$CONTROLLER_ID]"/>
</xsl:template>

<xsl:template match="controller"><![CDATA[<?php]]>
<xsl:call-template name="add_requirements"/>
require_once(USER_MODELS_PATH.'ShipmentRep_Model.php');
require_once(USER_MODELS_PATH.'ShipmentOperator_Model.php');
require_once(USER_MODELS_PATH.'ShipmentForOrderList_Model.php');
require_once(USER_MODELS_PATH.'ShipmentPumpList_Model.php');
require_once(USER_MODELS_PATH.'ShipmentTimeList_Model.php');
require_once(USER_MODELS_PATH.'ShipmentForDocList_Model.php');

require_once(USER_CONTROLLERS_PATH.'Graph_Controller.php');

require_once(FRAME_WORK_PATH.'basic_classes/FieldSQLString.php');
require_once(FRAME_WORK_PATH.'basic_classes/FieldSQL.php');

require_once('common/barcode.php');
require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGFontFile.php');
require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGColor.php');
require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGDrawing.php');
require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGean13.barcode.php');
//require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGcodabar.barcode.php');
//require_once('common/barcodegen.1d-php5.v5.2.1/class/BCGcode128.barcode.php');

require_once(ABSOLUTE_PATH.'functions/notifications.php');

require_once(USER_CONTROLLERS_PATH.'ExcelTemplate_Controller.php');
require_once(USER_CONTROLLERS_PATH.'Order_Controller.php');

require_once(ABSOLUTE_PATH.'functions/checkPmPeriod.php');
require_once(ABSOLUTE_PATH.'functions/ExtProg.php');

//for zip archiving
set_time_limit(120);
ini_set('memory_limit', '-1');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{
	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);<xsl:apply-templates/>
	}
	
	public function shipment_report($pm){
		$model = new ShipmentRep_Model($this->getDbLink());
		
		$from = null; $count = null;
		$limit = $this->limitFromParams($pm,$from,$count);
		$calc_total = ($count>0);
		if ($from){
			$model->setListFrom($from);
		}
		if ($count){
			$model->setRowsPerPage($count);
		}
		
		$order = $this->orderFromParams($pm,$model);
		$where = $this->conditionFromParams($pm,$model);
		$fields = $this->fieldsFromParams($pm);		
		$grp_fields = $this->grpFieldsFromParams($pm);		
		$agg_fields = $this->aggFieldsFromParams($pm);		
			
		$model->select(false,$where,$order,
			$limit,$fields,$grp_fields,$agg_fields,
			$calc_total,TRUE);
		//
		$this->addModel($model);		
	}
	
	public function insert($pm){
		$pm->setParamValue("user_id",$_SESSION['user_id']);
		
		$inserted_id_ar = parent::insert($pm);
		
		//Вставка производства в Elkon, запуск скрипта из под php5.6
		//$script = FUNC_PATH.'elkon_production_insert.php';
		//exec("php5.6 ".$script." ".$inserted_id_ar['id']." > /dev/null 2>&amp;1 &amp;");
	}
	
	public function delete($pm){
		Graph_Controller::clearCacheOnShipId($this->getDbLink(),$pm->getParamValue("id"));
		parent::delete($pm);		
	}
	
	public function shipment_invoice($pm){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array("id"=>"ShipmentInvoice_Model"));
		$model->addField(new FieldSQL($link,null,null,"number",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"month_str",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"day",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"year",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"time",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"client_descr",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"client_tel",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"concrete_type_descr",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"quant",DT_FLOAT));
		$model->addField(new FieldSQL($link,null,null,"destination_descr",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"driver_descr",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"vehicle_descr",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"vehicle_plate",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"vehicle_ord_num",DT_STRING));		
		$model->addField(new FieldSQL($link,null,null,"quant_ordered",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"quant_shipped",DT_STRING));
		$model->addField(new FieldSQL($link,null,null,"concrete",DT_STRING));
				
		$model->setSelectQueryText(
		sprintf(
		"SELECT order_num(o) AS number,
			get_month_rus(sh.date_time::date) AS month_str,
			EXTRACT(DAY FROM sh.date_time::date) AS day,
			EXTRACT(YEAR FROM sh.date_time::date) AS year,
			CASE WHEN
				date_part('hour',sh.date_time) &lt; 10 THEN 
				'0' || date_part('hour',sh.date_time)::text
				ELSE date_part('hour',sh.date_time)::text
			END || '-' ||
			CASE WHEN
				date_part('minute',sh.date_time) &lt; 10 THEN 
				'0' || date_part('minute',sh.date_time)::text
				ELSE date_part('minute',sh.date_time)::text
			END AS time,
			
			CASE
				WHEN ct.name ilike '%%вода%%' THEN ''
				ELSE substring(COALESCE(ct.official_name, ct.name), 1, position(' ' in COALESCE(ct.official_name, ct.name)))
			END AS concrete_type_descr1,
			
			CASE
				WHEN ct.name ilike '%%вода%%' THEN COALESCE(ct.official_name, ct.name)
				ELSE substring(COALESCE(ct.official_name, ct.name), position(' ' in COALESCE(ct.official_name, ct.name)) + 1)
			END AS concrete_type_descr2,
			
			CASE
				WHEN substring(ct.name, 1, 2) = 'ПБ' THEN 'Пескобетон'
				WHEN substring(ct.name, 1, 2) = 'РР' THEN 'Раствор'
				WHEN ct.name ilike '%%вода%%' THEN ''
				ELSE ''
			END AS concrete1,
			CASE
				WHEN substring(ct.name, 1, 2) = 'ПБ' THEN '(БСМ)'
				WHEN substring(ct.name, 1, 2) = 'РР' THEN ''
				WHEN ct.name ilike '%%вода%%' THEN 'Вода'
				ELSE 'Бетон (БСТ)'
			END AS concrete2,
			
			cl.name_full AS client_descr,
			format_cel_phone(o.phone_cel) AS client_tel,
			sh.quant AS quant,
			dest.name AS destination_descr,
			dr.name AS driver_descr,
			coalesce(vh.make || ' ','') || vh.plate AS vehicle_descr,
			vh.plate AS vehicle_plate,
			vh.ord_num AS vehicle_ord_num,
			o.quant AS quant_ordered,
			coalesce((SELECT
				sum(t_sh.quant)
			FROM shipments AS t_sh
			WHERE t_sh.order_id=o.id
				AND t_sh.shipped
				AND t_sh.ship_date_time&lt;=sh.ship_date_time
			),0) AS quant_shipped
			
		FROM shipments AS sh
		LEFT JOIN orders AS o ON o.id = sh.order_id
		LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id
		LEFT JOIN destinations AS dest ON dest.id = o.destination_id
		LEFT JOIN clients AS cl ON cl.id = o.client_id
		LEFT JOIN vehicle_schedules AS vs ON vs.id = sh.vehicle_schedule_id
		LEFT JOIN drivers AS dr ON dr.id = vs.driver_id
		LEFT JOIN vehicles AS vh ON vh.id = vs.vehicle_id
		WHERE sh.id=%d"
		,$this->getExtDbVal($pm,'id')
		));
		
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		//
		$this->addModel($model);			
		
		//barcode
		$shipment_id = $this->getExtVal($pm,'id');
		$barcode_descr = '0'.substr('000000000000',1,12-strlen($shipment_id)-1).$shipment_id;
		$barcode_descr = $barcode_descr.EAN_check_sum($barcode_descr,13);
		//**** Генерация баркода ****
		$colorFont = new BCGColor(0, 0, 0);
		$colorBack = new BCGColor(255, 255, 255);		
		
		$code = new BCGean13(); // Or another class name from the manual
		//$code = new BCGcodabar();
		
		$code->setScale(1); // Resolution
		$code->setThickness(30); // Thickness
		$code->setForegroundColor($colorFont); // Color of bars
		$code->setBackgroundColor($colorBack); // Color of spaces
		$code->setFont(0); // Font (or 0) $font
		$code->parse($barcode_descr); // Text
		$drawing = new BCGDrawing('', $colorBack);
		$drawing->setBarcode($code);
		$drawing->draw();
		ob_start();
		$drawing->finish(BCGDrawing::IMG_FORMAT_PNG);
		$contents = ob_get_contents();
		ob_end_clean();
		//**** Генерация баркода ****
		
		$fields = array();		
		array_push($fields,new Field('descr',DT_STRING,array('value'=>$barcode_descr)));
		array_push($fields,new Field('mime',DT_STRING,array('value'=>'image/png')));
		array_push($fields,new Field('img',DT_STRING,array('value'=>base64_encode($contents))));
		
		$this->addModel(new ModelVars(
			array('id'=>'Barcode_Model',
				'values'=>$fields)
			)
		);
		
	}
	
	public function set_blanks_exist($pm){
		$barcode = $pm->getParamValue("barcode");
		$shipment_id = 0;
		if (strlen($barcode)==13 &amp;&amp; substr($barcode,0,1)=='0'){
			//by barcode
			$shipment_id = intval(substr($barcode,1,11));
		}
		else if (strlen($barcode)==12 &amp;&amp; substr($barcode,0,1)=='0'){
			//by barcode
			$shipment_id = intval(substr($barcode,1,10));
		}		
		else{
			//by shipment id
			$shipment_id = intval($barcode);
		}
		
		if (!$shipment_id){
			throw new Exception('Документ '.$barcode.' не найден!');
		}
		
		
		$ar = $this->getDbLinkMaster()->query_first(
			sprintf(
			"UPDATE shipments
			SET
				blanks_exist=true
			WHERE id=%d
			RETURNING id",
			$shipment_id)
		);
		if (!is_array($ar) || !count($ar)){
			throw new Exception('Документ '.$barcode.' не найден!');
		}
		
	}
	
	private static function get_operator_query($date_from_db,$date_to_db,&amp;$operator_cond_tot){
		$operator_cond = '';
		$operator_cond_tot = '';
		$operator_with = '';
		$extra_cols_str = '';
		if($_SESSION['role_id']=='operator'){
			//Опеатор и так привязан к заводу
			$operator_with = sprintf("prod_site AS (SELECT (u_op.production_sites_ref->'keys'->>'id')::int AS production_site_id FROM user_operator_list AS u_op WHERE u_op.id = %d),", $_SESSION['user_id']);
			$operator_cond = ' AND sh.production_site_id = (SELECT prod_site.production_site_id FROM prod_site)';
			$operator_cond_tot = sprintf(" AND sh.production_site_id = (SELECT (u_op.production_sites_ref->'keys'->>'id')::int AS production_site_id FROM user_operator_list AS u_op WHERE u_op.id = %d)", $_SESSION['user_id']);
			$extra_join = '';
			
		}else{
			$extra_cols_str =
			",shipment_time_norm(sh.quant::numeric) AS ship_norm_min
			,(CASE
				WHEN sh.shipped THEN
					EXTRACT(EPOCH FROM
						sh.ship_date_time-vs2.date_time
					)/60
				ELSE 0
			END)::int AS ship_fact_min
			,CASE
				WHEN sh.shipped THEN
					(EXTRACT(EPOCH FROM
						sh.ship_date_time-vs2.date_time
					)/60)::int - 
					shipment_time_norm(sh.quant::numeric)
				ELSE 0
			END AS ship_bal_min";
			$extra_join = "LEFT JOIN (SELECT t.shipment_id,t.date_time FROM vehicle_schedule_states t WHERE t.state='assigned' GROUP BY t.shipment_id,t.date_time) vs2 ON vs2.shipment_id = sh.id";
			
			if(isset($_SESSION['production_site_id']) &amp;&amp; intval($_SESSION['production_site_id']) &gt; 0){
				$operator_with = sprintf('prod_site AS (SELECT %d AS production_site_id),', $_SESSION['production_site_id']);
				$operator_cond = ' AND sh.production_site_id = (SELECT prod_site.production_site_id FROM prod_site)';
				$operator_cond_tot = sprintf(' AND sh.production_site_id = %d', $_SESSION['production_site_id']);			
			}
		}
		
		return sprintf(
		"WITH
		%s
		ships AS (
		SELECT
			sh.id,
			clients_ref(cl) AS clients_ref,
			destinations_ref(dest) AS destinations_ref, 
			concrete_types_ref(ct) AS concrete_types_ref, 
			vehicles_ref(v)::text AS vehicles_ref, 
			drivers_ref(d) AS drivers_ref,
			sh.date_time,
			sh.quant,
			sh.shipped,
			sh.ship_date_time,
			o.comment_text,
			sh.production_site_id,
			production_sites_ref(ps) AS production_sites_ref,
			users_ref(op_u) AS operators_ref,
			(SELECT json_agg(row_to_json(productions)) FROM productions WHERE productions.shipment_id=sh.id) AS production_list,
			coalesce((SELECT sum(concrete_quant) FROM productions WHERE productions.shipment_id=sh.id),0) AS production_quant
			%s
		FROM shipments AS sh
		LEFT JOIN orders o ON o.id = sh.order_id
		LEFT JOIN clients cl ON cl.id = o.client_id
		LEFT JOIN vehicle_schedules vs ON vs.id = sh.vehicle_schedule_id
		LEFT JOIN drivers d ON d.id = vs.driver_id
		LEFT JOIN vehicles v ON v.id = vs.vehicle_id
		LEFT JOIN destinations dest ON dest.id = o.destination_id
		LEFT JOIN concrete_types ct ON ct.id = o.concrete_type_id
		LEFT JOIN production_sites ps ON ps.id = sh.production_site_id
		LEFT JOIN users AS op_u ON op_u.id=sh.operator_user_id
		%s
		WHERE (sh.shipped = FALSE OR (sh.ship_date_time BETWEEN %s AND %s))".$operator_cond."
		)
		--Все неотгруженные
		(SELECT sh.*
		FROM ships AS sh
		WHERE (sh.shipped = FALSE)".$operator_cond."
		ORDER BY sh.date_time)
	
		UNION ALL
	
		--Все отгруженные за сегодня
		(SELECT sh.*
		FROM ships AS sh
		WHERE (sh.shipped = TRUE)".$operator_cond."
		ORDER BY sh.ship_date_time DESC)",
		$operator_with,
		$extra_cols_str,
		$extra_join,
		$date_from_db,
		$date_to_db
		);	
	}
	
	public static function addOperatorModels(&amp;$controller,$dateFromForDb,$dateToForDb){
	
		$operator_cond_tot = '';
		$q = self::get_operator_query($dateFromForDb,$dateToForDb,$operator_cond_tot);
		$m = new ModelSQL($controller->getDbLink(),array('id'=>"OperatorList_Model"));
		$m->setCalcHash(TRUE);
		$m->query($q,TRUE);
		$controller->addModel($m);
		
		//totals
		$controller->addNewModel(
			sprintf(
				"SELECT
					coalesce((SELECT sum(sh.quant) FROM shipments AS sh WHERE sh.ship_date_time BETWEEN %s AND %s AND sh.shipped".$operator_cond_tot."),0) AS quant_shipped,
					coalesce((SELECT sum(quant) FROM orders WHERE date_time BETWEEN %s AND %s),0) AS quant_ordered",
				$dateFromForDb,
				$dateToForDb,
				$dateFromForDb,
				$dateToForDb		
			),
			'OperatorTotals_Model'
		);
		
		//production site(s)
		if($_SESSION['role_id']=='operator'){
			//Если это оператор - отобразим завод в соответствии с user_operator_list
			$prod_site_q = sprintf(
				"SELECT
					production_sites_ref->'descr' AS name
				FROM user_operator_list
				WHERE id = %d",
				$_SESSION['user_id']
			);
			
		}else if(isset($_SESSION['production_site_id']) &amp;&amp; intval($_SESSION['production_site_id']) > 0){
			//Если есть привязка к заводу - только его
			$prod_site_q = sprintf(
				'SELECT ps.name
				FROM production_sites ps
				WHERE ps.id=(SELECT u.production_site_id FROM users u WHERE u.id=%d)',
				$_SESSION['user_id']
			);
			
		}else{
			//все заводы
			$prod_site_q = 'SELECT ps.name FROM production_sites ps';
		}
		$controller->addNewModel($prod_site_q,'OperatorProductionSite_Model');				
	}
	
	public function get_operator_list($pm){
	
		$dt = (!$pm->getParamValue('date'))? time() : ($this->getExtVal($pm,'date')+Beton::shiftStartTime());
		$date_from = Beton::shiftStart($dt);
		$date_to = Beton::shiftEnd($date_from);
		$date_from_db = "'".date('Y-m-d H:i:s',$date_from)."'";
		$date_to_db = "'".date('Y-m-d H:i:s',$date_to)."'";
		
		self::addOperatorModels($this,$date_from_db,$date_to_db);
		
		if($_SESSION['role_id'] == 'operator'){
			//one plant only
			if(!isset($_SESSION['production_site_id']) || intval($_SESSION['production_site_id']) == 0){
				$ar = $this->getDbLinkMaster()->query_first(
					sprintf("SELECT (u_op.production_sites_ref->'keys'->>'id')::int AS production_site_id FROM user_operator_list AS u_op WHERE u_op.id = %d", $_SESSION['user_id'])
				);
				if (!is_array($ar) || !count($ar)){
					throw new Exception('operator user_operator_list query failed');
				}
				$_SESSION['production_site_id'] = $ar['production_site_id'];
			}
			if(!isset($_SESSION['production_base_id']) || intval($_SESSION['production_base_id']) == 0){
				$ar = $this->getDbLinkMaster()->query_first(
					sprintf("select production_base_id from production_sites where id=%d", $_SESSION['production_site_id'])
				);
				if (!is_array($ar) || !count($ar)){
					throw new Exception('operator production_sites query failed');
				}
				$_SESSION['production_base_id'] = $ar['production_base_id'];				
			}
			$this->addNewModel(
				sprintf("SELECT * FROM production_bases WHERE id = %d", $_SESSION['production_base_id']),
				'ProductionBase_Model'
			);	
						
			$this->addNewModel(
				sprintf("SELECT * FROM cement_silos_for_order_list
					WHERE (production_sites_ref->'keys'->>'id')::int = %d", $_SESSION['production_site_id']
				),
				'CementSiloForOrderList'.$_SESSION['production_base_id'].'_Model'
			);
			
			//material stores list
			$this->addNewModel(
				sprintf("SELECT * FROM material_store_for_order_list
					WHERE (production_sites_ref->'keys'->>'id')::int = %d
					ORDER BY id",
					$_SESSION['production_site_id']
				),
				'MaterialStoreForOrderList'.$_SESSION['production_base_id'].'_Model'
			);
			
		}else{
			$this->addNewModel(
				"SELECT * FROM production_bases",
				'ProductionBase_Model'
			);
			$link = $this->getDbLinkMaster();
			Order_Controller::add_production_bases($link);
			if(isset($_SESSION['production_bases']) &amp;&amp; count($_SESSION['production_bases'])){
				foreach($_SESSION['production_bases'] as $prod_id){
					$this->addNewModel(
						"SELECT * FROM cement_silos_for_order_list
						WHERE production_base_id = ".$prod_id,
						'CementSiloForOrderList'.$prod_id.'_Model'
					);
					
					//material stores list
					$this->addNewModel(
						"SELECT * FROM material_store_for_order_list
						WHERE production_base_id = ".$prod_id."
						ORDER BY id",
						'MaterialStoreForOrderList'.$prod_id.'_Model'
					);									
				}
			}
				
			/*
			$this->addNewModel(
				"SELECT * FROM cement_silos_for_order_list
				WHERE production_base_id = 1",
				'CementSiloForOrderList1_Model'
			);
			$this->addNewModel(
				"SELECT * FROM cement_silos_for_order_list
				WHERE production_base_id = 2",
				'CementSiloForOrderList2_Model'
			);		
			
			//material stores list
			$this->addNewModel(
				"SELECT * FROM material_store_for_order_list
				WHERE production_base_id = 1
				ORDER BY id",
				'MaterialStoreForOrderList1_Model'
			);
			$this->addNewModel(
				"SELECT * FROM material_store_for_order_list
				WHERE production_base_id = 2
				ORDER BY id",
				'MaterialStoreForOrderList2_Model'
			);
			*/
		}
				
		//init date
		$this->addModel(new ModelVars(
			array('id'=>'InitDate',
				'values'=>array(
					new Field('dt',DT_DATETIME,
						array('value'=>date('Y-m-d H:i:s',$date_from)))
				)
			)
		));						
	}
		
	public static function sendShipSMS($dbLinkMaster,$dbLink,$idForDb,$smsResOk,$smsResStr,$interactiveMode){
		//Может не быть изменений order_id на слейве после update!!!
		$ar = $dbLinkMaster->query_first(sprintf(
		"SELECT
			orders.id AS order_id,
			orders.phone_cel,
			coalesce(shipments.quant) AS quant,
			concrete_types.official_name AS concrete,
			d.name AS d_name,
			format_cel_standart(coalesce(d.phone_cel,'')) AS d_phone,
			v.plate AS v_plate,
			(SELECT pattern FROM sms_patterns
				WHERE sms_type='ship'::sms_types
				AND lang_id= orders.lang_id
			) AS text,
			coalesce( (
				SELECT sum(sh.quant)
				FROM shipments AS sh
				WHERE sh.order_id=orders.id AND sh.shipped
				)
			,0) AS quant_shipped,
			coalesce(orders.quant,0) AS quant_ordered,
			shipments_ref(shipments) AS doc_ref,
			
			CASE WHEN (SELECT const_self_ship_dest_val()->'keys'->>'id')::int = orders.destination_id THEN FALSE
			ELSE coalesce(dest.send_route_sms,FALSE)
				--тот же день, тот же миксер?
				AND
				(coalesce(
					(SELECT
						count(*)
					FROM shipments AS d_sh
					LEFT JOIN vehicle_schedules AS d_vs ON d_vs.id=d_sh.vehicle_schedule_id
					LEFT JOIN orders AS d_o ON d_o.id = d_sh.order_id
					WHERE d_sh.ship_date_time::date = shipments.ship_date_time::date
					AND d_vs.vehicle_id = vs.vehicle_id
					AND d_sh.id &lt;&gt; shipments.id
					AND d_o.destination_id = orders.destination_id
					)
				,0)=0)				
			END AS send_route_sms,
			
			CASE WHEN coalesce(v.tracker_id,'') = '' THEN FALSE
			ELSE
				(SELECT
					(now() - (tr.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)) ) &lt; '00:30:00'::interval
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC
				LIMIT 1)
			END AS tracker_exists,
			
			CASE
				WHEN e_user.tm_id IS NOT NULL THEN ct.id
				ELSE NULL
			END AS ext_contact_id,

			e_user.ext_contact_id AS ext_contact_id,				
			e_user_d.ext_contact_id AS dr_ext_contact_id,

			orders.pump_vehicle_id IS NOT NULL as pump_exists
			
		FROM orders
		LEFT JOIN shipments ON shipments.order_id=orders.id
		LEFT JOIN concrete_types ON concrete_types.id=orders.concrete_type_id
		LEFT JOIN vehicle_schedules AS vs ON vs.id=shipments.vehicle_schedule_id
		LEFT JOIN drivers AS d ON d.id=vs.driver_id
		LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
		LEFT JOIN destinations AS dest ON dest.id=orders.destination_id
		
		LEFT JOIN contacts AS ct ON coalesce(orders.phone_cel,'')&lt;&gt;'' AND ct.tel = orders.phone_cel
		LEFT JOIN notifications.ext_users_list AS e_user ON e_user.app_id = 1 AND e_user.ext_contact_id = ct.id
		
		LEFT JOIN contacts AS ct_d ON coalesce(d.phone_cel,'')&lt;&gt;'' AND ct_d.tel = d.phone_cel
		LEFT JOIN notifications.ext_users_list AS e_user_d ON e_user_d.app_id = 1 AND e_user_d.ext_contact_id = ct_d.id
		
		WHERE shipments.id=%d",
		$idForDb
		));
		
		$d_phone_exists = (strlen($ar['d_phone'])==10);
		
		//responsible person notification through TM
		if (strlen($ar['phone_cel']) &amp;&amp; isset($ar['ext_contact_id'])){
			$text = $ar['text'];
			$text = str_replace('[quant]',$ar['quant'],$text);
			$text = str_replace('[concrete]',$ar['concrete'],$text);
			$text = str_replace('[car]',$ar['v_plate'],$text);				
			$text = str_replace('[quant_shipped]', $ar['quant_shipped'], $text);
			$text = str_replace('[quant_ordered]', $ar['quant_ordered'], $text);
			
			$driver = $ar['d_name'];
			$driver.= $d_phone_exists? ' +7'.$ar['d_phone'] : '';				
			$text = str_replace('[driver]', $driver, $text);

			//route href если нет данных от миксера - не отправлять маршрут
			if ($ar['tracker_exists']=='t'){
				$text.= ' '.ROUTE_HREF.$idForDb;
			}
					
			//Только телеграм
			add_notification_from_contact_tm($dbLinkMaster, $ar['phone_cel'], $text, 'ship', $ar['doc_ref'], $ar['ext_contact_id']);
		}

		//notify pump driver if there is a pump in this order
		/*
		    Removed thid notification with 1.00330 build on 2024-05-29
		if($ar['pump_exists'] == 't'){
			//Вызываем новые SQL функции *_ct(), которые используют контакты, а не телефоны из таблиц!
			$pump_sms_q_id = $dbLinkMaster->query(sprintf(
				"SELECT * FROM sms_pump_order_ship_ct(%d)"
				,$ar['order_id']
			));
			while($pump_sms_ar = $dbLinkMaster->fetch_array($pump_sms_q_id)){
				$pump_sms_mes = $pump_sms_ar['message'];
				add_notification_from_contact($dbLinkMaster, $pump_sms_ar['phone_cel'], $pump_sms_mes, 'ship', $ar['doc_ref'], $pump_sms_ar['ext_contact_id']);
			}
		}*/
		
		//СМС миксеристу с маршрутом
		//Если в этот день на этот объект уже отправляли - не отправлять!
		if(isset($ar['send_route_sms'])
		&amp;&amp; $ar['send_route_sms']=='t'
		&amp;&amp; $d_phone_exists
		&amp;&amp; $ar['tracker_exists']=='t'
		&amp;&amp; isset($ar['dr_ext_contact_id'])
		){
			$mix_pat = $dbLink->query_first(
				"SELECT pattern FROM sms_patterns WHERE sms_type='mixer_route'::sms_types LIMIT 1"
			);
			if(!is_array($mix_pat) || !isset($mix_pat['pattern'])){
				return;
			}
			$text = str_replace('[href]', ROUTE_HREF.'m'.$idForDb, $mix_pat['pattern']);
			
			//Только телеграм
			add_notification_from_contact_tm($dbLinkMaster, $ar['d_phone'], $text, 'mixer_route', $ar['doc_ref'], $ar['dr_ext_contact_id']);
		}
	}
	
	public static function setShipped($dbLinkMaster,$dbLink,$idForDb,$operatorUserId,$smsResOk,$smsResStr,$interactiveMode){
		try{
			$dbLinkMaster->query("BEGIN");
			
			//RETURNING order_id,date_time::date AS date
			//$upd_res = $dbLinkMaster->query_first(
			
			$dbLinkMaster->query(
				sprintf(
				"UPDATE shipments
				SET
					shipped=TRUE,
					operator_user_id=%d
				WHERE id=%d",
				$_SESSION["user_id"],
				$idForDb
				)
			);
		
			$dbLinkMaster->query("COMMIT");
		}
		catch (Exception $e){
			$dbLinkMaster->query("ROLLBACK");
			throw $e;
		}		
	
		Graph_Controller::clearCacheOnShipId($dbLink,$idForDb);		
		self::sendShipSMS($dbLinkMaster,$dbLink,$idForDb,$smsResOk,$smsResStr,$interactiveMode);	
	}
	
	public function set_shipped($pm){
		$sms_res_ok = 0;
		$sms_res_str = '';
		
		self::setShipped(
			$this->getDbLinkMaster(),
			$this->getDbLink(),
			$this->getExtDbVal($pm,"id"),
			$_SESSION["user_id"],
			$sms_res_ok,
			$sms_res_str,
			FALSE
		);
		
		$this->addModel(new ModelVars(
			array('id'=>'SMSSend',
				'values'=>array(
					new Field('sent',DT_INT,
						array('value'=>$sms_res_ok))
					,					
					new Field('resp',DT_STRING,
						array('value'=>$sms_res_str))
					)
				)
			)
		);				
		
	}
	public function unset_shipped(){
		$pm = $this->getPublicMethod("unset_shipped");
		$dbLink = $this->getDbLink();
		$id = $this->getExtDbVal($pm,"id");			
		
		$ar = $dbLink->query_first(
			sprintf("SELECT ship_date_time
			FROM shipments WHERE id=%d",
				$id)
			);
		if (is_array($ar)){
			Graph_Controller::clearCacheOnDate(
				$dbLink,strtotime($ar['ship_date_time']));		
		}	
				
		$this->getDbLinkMaster()->query(
			sprintf("UPDATE shipments SET
				shipped=false
			WHERE id=%d",$id)
		);
	}

	//this method is callled from gui orders list. So no date check is needed.
	public function get_list_for_order(){
		$this->modelGetList(new ShipmentForOrderList_Model($this->getDbLink()),
			$this->getPublicMethod('get_list_for_order')
		);
	}

	private function get_list_query(){
		return 
			"SELECT
				shipments.id,
				shipments.ship_date_time,
				shipments.quant,
		
				shipments_cost(dest,o.concrete_type_id,o.date_time::date,shipments,TRUE) AS cost,
		
				shipments.shipped,
				concrete_types_ref(concr) AS concrete_types_ref,
				o.concrete_type_id,		
				v.owner,
		
				vehicles_ref(v) AS vehicles_ref,
				vs.vehicle_id,
		
				drivers_ref(d) AS drivers_ref,
				vs.driver_id,
		
				destinations_ref(dest) As destinations_ref,
				o.destination_id,
		
				clients_ref(cl) As clients_ref,
				o.client_id,
		
				shipments_demurrage_cost(shipments.demurrage::interval) AS demurrage_cost,
				shipments.demurrage,
		
				shipments.client_mark,
				shipments.blanks_exist,
		
				users_ref(u) As users_ref,
				o.user_id,
		
				production_sites_ref(ps) AS production_sites_ref,
				shipments.production_site_id,
		
				vehicle_owners_ref(v_own) AS vehicle_owners_ref,
		
				shipments.acc_comment,
				v_own.id AS vehicle_owner_id,
		
				shipments_pump_cost(shipments,o,dest,pvh,TRUE) AS pump_cost,
		
				pump_vehicles_ref(pvh,pvh_v) AS pump_vehicles_ref,
				pvh.vehicle_id AS pump_vehicle_id,
				pvh_v.vehicle_owner_id AS pump_vehicle_owner_id,
				shipments.owner_agreed,
				shipments.owner_agreed_date_time,
				shipments.owner_pump_agreed,
				shipments.owner_pump_agreed_date_time,
		
				vehicle_owners_ref(pvh_own) AS pump_vehicle_owners_ref,
		
				CASE
					WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date&lt;=o.date_time::date AND sh_p.distance_to>=dest.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(dest.price,0))			
				END AS ship_price,
		
				coalesce(shipments.ship_cost_edit,FALSE) AS ship_cost_edit,
				coalesce(shipments.pump_cost_edit,FALSE) AS pump_cost_edit
		
			FROM shipments
			LEFT JOIN orders o ON o.id = shipments.order_id
			LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
			LEFT JOIN clients cl ON cl.id = o.client_id
			LEFT JOIN vehicle_schedules vs ON vs.id = shipments.vehicle_schedule_id
			LEFT JOIN destinations dest ON dest.id = o.destination_id
			LEFT JOIN drivers d ON d.id = vs.driver_id
			LEFT JOIN vehicles v ON v.id = vs.vehicle_id
			LEFT JOIN users u ON u.id = shipments.user_id
			LEFT JOIN production_sites ps ON ps.id = shipments.production_site_id
			LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
			LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
			LEFT JOIN vehicles pvh_v ON pvh_v.id = pvh.vehicle_id
			LEFT JOIN vehicle_owners pvh_own ON pvh_own.id = pvh_v.vehicle_owner_id";	
	}

	private function get_list_for_veh_owner_query(){
		return 
			"SELECT
				shipments.id,
				shipments.ship_date_time,
				shipments.quant,
				shipments_cost(dest,o.concrete_type_id,o.date_time::date,sh,TRUE) AS cost,
				concrete_types_ref(concr) AS concrete_types_ref,
				o.concrete_type_id,				
				vehicles_ref(v) AS vehicles_ref,
				vs.vehicle_id,
				destinations_ref(dest) AS destinations_ref,
				o.destination_id,
				shipments_demurrage_cost(shipments.demurrage::interval) AS demurrage_cost,
				shipments.demurrage,
				vehicle_owners_ref(v_own) AS vehicle_owners_ref,		
				shipments.acc_comment,
				v_own.id AS vehicle_owner_id,		
				shipments.owner_agreed,
				shipments.owner_agreed_date_time
				coalesce(shipments.ship_cost_edit,FALSE) AS ship_cost_edit		
			FROM shipments
			LEFT JOIN orders o ON o.id = sh.order_id
			LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
			LEFT JOIN vehicle_schedules vs ON vs.id = shipments.vehicle_schedule_id
			LEFT JOIN destinations dest ON dest.id = o.destination_id
			LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id";	
	}

	public function get_list($pm){
		checkPublicMethodPeriod($pm, new ShipmentList_Model($this->getDbLink()), "ship_date_time", 370);
		$this->modelGetList(new ShipmentList_Model($this->getDbLink()),$pm);
	}	

	public function get_list_for_veh_owner($pm){	
		checkPublicMethodPeriod($pm, new ShipmentForVehOwnerList_Model($this->getDbLink()), "ship_date_time", 370);
		$this->modelGetList(new ShipmentForVehOwnerList_Model($this->getDbLink()),$pm);
	}
	
	public function get_pump_list($pm){
		checkPublicMethodPeriod($pm, new ShipmentPumpList_Model($this->getDbLink()), "date_time", 370);
		$this->modelGetList(new ShipmentPumpList_Model($this->getDbLink()),$pm);
	}

	public function get_pump_list_for_veh_owner($pm){
		checkPublicMethodPeriod($pm, new ShipmentPumpForVehOwnerList_Model($this->getDbLink()), "date_time", 370);
		$this->modelGetList(new ShipmentPumpForVehOwnerList_Model($this->getDbLink()),$pm);
	}
	
	public function get_shipment_date_list($pm){
		checkPublicMethodPeriod($pm, new ShipmentDateList_Model($this->getDbLink()), "ship_date", 370);
		$this->modelGetList(new ShipmentDateList_Model($this->getDbLink()),$pm);
	}
	public function get_time_list($pm){
		/*
		$where = $this->conditionFromParams($pm,$model);
		if(!$where){
			$date_from = Beton::shiftStart(time());
			$date_to = Beton::shiftEnd($date_from);		
		}
		else{
			$date_from = $where->getFieldsById('ship_date_time','>=');
			if(!isset($date_from)){
			
			}
			
			$date_to = $where->getFieldsById('ship_date_time','&lt;=');
		}
		*/
		$this->modelGetList(new ShipmentTimeList_Model($this->getDbLink()),$pm);
	}
	
	public static function getAssigningModel($dbLink, $prodSiteId=0, $prodBaseId=0){
		$model = new ModelSQL($dbLink,array('id'=>'AssignedVehicleList' .(($prodBaseId>0)? $prodBaseId : ''). '_Model'));
		$cond = '';
		if($prodSiteId){
			$cond = sprintf(' WHERE production_site_id=%d',$prodSiteId);
						
		}else if($prodBaseId){
			$cond = sprintf(' WHERE production_base_id=%d', $prodBaseId);			
		}
		$model->query("SELECT * FROM assigned_vehicles_list".$cond,TRUE);
		return $model;	
	
	}
	
	public function get_assigned_vehicle_list($pm){
		$this->addModel(self::getAssigningModel($this->getDbLink()), $this->getExtDbVal($pm,'production_site_id'), $this->getExtDbVal($pm,'production_base_id'));
		$this->modelGetList(new ShippedVehicleList_Model($this->getDbLink()), $pm);
	}
	
	public function delete_shipped($pm){
		$l = $this->getDbLinkMaster();		
		try{
			$l->query("BEGIN");

			$l->query(
				sprintf(
					"INSERT INTO shipment_cancelations
					(order_id,vehicle_schedule_id,comment_text,user_id,date_time,ship_date_time,assign_date_time,quant)
					(SELECT
						sh.order_id,
						sh.vehicle_schedule_id,
						%s,
						%d,
						now(),
						sh.ship_date_time,
						sh.date_time,
						sh.quant
						
					FROM shipments AS sh
					WHERE sh.id=%d
					)",
					$this->getExtDbVal($pm,"comment_text"),
					$_SESSION['user_id'],					
					$this->getExtDbVal($pm,"shipment_id")
				)
			);

			self::do_delete_shipment($l,$this->getExtDbVal($pm,"shipment_id"));
			
			$l->query("COMMIT");
		}
		catch (Exception $e){
			$l->query("ROLLBACK");
			throw $e;
	
		}
	}
	
	public static function do_delete_shipment($link,$shipmentId){
		
		$link->query(
			sprintf(
				"DELETE FROM vehicle_schedule_states WHERE shipment_id=%d",
				$shipmentId
			)
		);		
		
		$link->query(
			sprintf(
				"DELETE FROM shipments WHERE id=%d",
				$shipmentId
			)
		);		
		
	}
	
	public function delete_assigned($pm){
		$l = $this->getDbLinkMaster();		
		try{
			$l->query("BEGIN");

			self::do_delete_shipment($l,$this->getExtDbVal($pm,"shipment_id"));
			
			$l->query("COMMIT");
		}
		catch (Exception $e){
			$l->query("ROLLBACK");
			throw $e;
		}		
	}

	private function update_owner_agreed_field($shipmentId,$isPump){
	
		if($_SESSION['role_id']=='vehicle_owner'){
			//а можно ли 			
			
			//check
			if($isPump){
				$q = "SELECT
						sh.pump_vehicle_owner_id AS vehicle_owner_id,
						(
							SELECT (now()::date BETWEEN d_from AND d_to) FROM shipment_accord_allowed(sh.date_time::date)	
						) AS acc_allowed
					FROM shipments_pump_list AS sh
					WHERE sh.last_ship_id=%d";			
			}
			else{
				$q = "SELECT
						v.vehicle_owner_id,
						(
							SELECT (now()::date BETWEEN d_from AND d_to) FROM shipment_accord_allowed(sh.ship_date_time::date)
						) AS acc_allowed
					FROM shipments AS sh
					LEFT JOIN vehicle_schedules AS sch ON sch.id=sh.vehicle_schedule_id
					LEFT JOIN vehicles AS v ON v.id=sch.vehicle_id
					WHERE sh.id=%d";
			}			
			$ar = $this->getDbLinkMaster()->query_first(
				sprintf($q,$shipmentId)
			);
			if(!is_array($ar) || !count($ar) || $ar['vehicle_owner_id']!=$_SESSION['global_vehicle_owner_id']
			||$ar['acc_allowed']!='t'
			){
				throw new Exception('Permission denied!');
			}
		}
		else if($_SESSION['role_id']!='owner'){
			throw new Exception('Permission denied!');
		}
		
		$set_field_id = $isPump? 'owner_pump_agreed':'owner_agreed';
		$this->getDbLinkMaster()->query(
			sprintf(
				"UPDATE shipments
				SET
					%s=TRUE,
					%s_date_time=now()
				WHERE id=%d",
				$set_field_id,$set_field_id,				
				$shipmentId
			)
		);
	}
	
	function owner_set_agreed($pm){
		$this->update_owner_agreed_field($this->getExtDbVal($pm,'shipment_id'),FALSE);
	}
	
	function owner_set_pump_agreed($pm){
		$this->update_owner_agreed_field($this->getExtDbVal($pm,'shipment_id'),TRUE);
	}
	
	public function get_list_for_client_veh_owner($pm){	
		checkPublicMethodPeriod($pm, new ShipmentForClientVehOwnerList_Model($this->getDbLink()), "ship_date", 370);
		$this->modelGetList(new ShipmentForClientVehOwnerList_Model($this->getDbLink()),$pm);
	}

	public function owner_set_agreed_all($pm){	
		$this->getDbLink()->query(
			"UPDATE shipments
				SET
					owner_agreed=TRUE,
					owner_agreed_date_time=now(),
					owner_agreed_auto=FALSE
			FROM (				
			WITH
				mon AS (
					SELECT
						CASE WHEN extract('month' FROM now())=1 THEN 12
							ELSE extract('month' FROM now())-1
						END AS v
				),
				d_from AS (
					SELECT (
						(CASE WHEN (SELECT v FROM mon)=12 THEN extract('year' FROM now())-1 ELSE extract('year' FROM now()) END)::text
						||'-'|| (CASE WHEN (SELECT v FROM mon)&lt;10 THEN '0' ELSE '' END )||(SELECT v FROM mon) ||'-01'
					)::date+
					const_first_shift_start_time_val()
					AS v
				),
				per AS (SELECT	
					(SELECT v FROM d_from) AS d_from,
					get_shift_end(
						((SELECT v FROM d_from) + '1 month'::interval -'1 day'::interval)::date+
						const_first_shift_start_time_val()
					)
					AS d_to
				)
			SELECT shipments.id AS ship_id
			FROM shipments
			WHERE 
				extract('day' FROM now())>const_vehicle_owner_accord_to_day_val()
				AND coalesce(owner_agreed,FALSE)=FALSE
				AND ship_date_time BETWEEN (SELECT d_from FROM per) AND (SELECT d_to FROM per)
			) AS sub
			WHERE sub.ship_id = shipments.id"
		);
	
	}

	public function owner_set_pump_agreed_all($pm){	
		$dbLink->query(
			"UPDATE shipments
				SET
					owner_pump_agreed=TRUE,
					owner_pump_agreed_date_time=now(),
					owner_pump_agreed_auto=TRUE
			FROM (				
			WITH
				mon AS (
					SELECT
						CASE WHEN extract('month' FROM now())=1 THEN 12
							ELSE extract('month' FROM now())-1
						END AS v
				),
				d_from AS (
					SELECT (
						(CASE WHEN (SELECT v FROM mon)=12 THEN extract('year' FROM now())-1 ELSE extract('year' FROM now()) END)::text
						||'-'|| (CASE WHEN (SELECT v FROM mon)&lt;10 THEN '0' ELSE '' END )||(SELECT v FROM mon) ||'-01'
					)::date+
					const_first_shift_start_time_val()
					AS v
				),
				per AS (SELECT	
					(SELECT v FROM d_from) AS d_from,
					get_shift_end(
						((SELECT v FROM d_from) + '1 month'::interval -'1 day'::interval)::date+
						const_first_shift_start_time_val()
					)
					AS d_to
				)
			SELECT shipments.id AS ship_id
			FROM shipments
			WHERE 
				extract('day' FROM now())>const_vehicle_owner_accord_to_day_val()
				AND coalesce(owner_pump_agreed,FALSE)=FALSE
				AND ship_date_time BETWEEN (SELECT d_from FROM per) AND (SELECT d_to FROM per)
			) AS sub
			WHERE sub.ship_id = shipments.id"
		);
	
	}
	
	public function get_shipped_vihicles_list($pm){	
		$this->modelGetList(new ShippedVehicleList_Model($this->getDbLink()),$pm);
	}
	
	public function update($pm){
		$l = $this->getDbLinkMaster();		
		try{
			$l->query("BEGIN");
			parent::update($pm);
			
			$quant_shipped = 0;
			if($pm->getParamValue("order_id")){
				$ar = $l->query_first(sprintf(
					"SELECT sum(sh.quant) AS quant_shipped
					FROM shipments AS sh
					WHERE sh.order_id=%d"
					,$pm->getParamValue("order_id")
				));
				$quant_shipped = $ar['quant_shipped'];
			}
						
			$l->query("COMMIT");
		}
		catch (Exception $e){
			$l->query("ROLLBACK");
			throw $e;
		}		
		
		/*
		if($pm->getParamValue("order_id")){
			//сменили заявку???
			$sms_res_ok = 0;
			$sms_res_str = '';
			self::sendShipSMS(
				$this->getDbLinkMaster(),
				$this->getDbLink(),
				$this->getExtDbVal($pm,"old_id"),
				$sms_res_ok,
				$sms_res_str,
				FALSE
			);
		}
		*/
	}
	
	public function get_list_for_client($pm){	
		checkPublicMethodPeriod($pm, new ShipmentForClientList_Model($this->getDbLink()), "ship_date", 370);
		$this->modelGetList(new ShipmentForClientList_Model($this->getDbLink()),$pm);
	}

	public function shipment_putevoi_list($pm){
		return ExcelTemplate_Controller::downloadFilledTemplate(
			$this->getDbLink()
			,'Путевой лист'
			,array($this->getExtDbVal($pm, 'id'))
			,'Отгрузка не найдена!'
			,'Путевой лист'
		);
	}

	private function check_client_rekv($cl) {
		if(!isset($cl["inn"]) || !isset($cl["address_fact"])
			|| !isset($cl["name_full"])
		){
			//retrieve data from 1c
			if(gettype($cl["ref_1c"]) == "string"){
				$ref1c = json_decode($cl["ref_1c"], TRUE);
			}else {
				$ref1c = $cl["ref_1c"];
			}
			$resp = ExtProg::getClient($ref1c["keys"]["ref_1c"]);
			$rows = $resp["models"]["Client1c_Model"]["rows"];
			/* file_put_contents(OUTPUT_PATH."getClient.data", var_export($rows, true)); */
			$this->getDbLinkMaster()->query(
				sprintf(
					"UPDATE clients 
					SET
						name_full = '%s',
						address_fact = '%s',
						address_legal = '%s',
						inn = '%s',
						kpp = '%s',
						tels_1c = '%s'
					WHERE id = %d"
					,$rows["name_full"]
					,$rows["address_fact"]
					,$rows["address_legal"]
					,$rows["inn"]
					,$rows["kpp"]
					,$rows["tels"]
					,$cl["id"]
				)
			);
		}
	}

	//all shipments, background operation 
	//returns zip file name with all shipments
	public function shipment_transp_nakl_all_operation($anyDocId, $faksim){
		$this->check_1c_attrs_for_tn($anyDocId);
		$link = $this->getDbLink();
		//all shipments of an order
		$queryId = $link->query(
			sprintf(
				"SELECT
					sh.id
				FROM shipments AS sh
				LEFT JOIN orders AS o ON o.id = sh.order_id
				WHERE o.id = (SELECT order_id FROM shipments WHERE id = %d)"
				,$anyDocId
			)
		);
		$fileList = array();
		$templateName = $faksim? "Транспортная накладная (факсимиле)" : "Транспортная накладная";
		$erEmpty = 'Отгрузка не найдена!';
		$zipFileName = OUTPUT_PATH. md5(uniqid()).'.zip';
		$zip = new ZipArchive();
		if ($zip->open($zipFileName, ZIPARCHIVE::CREATE)!==TRUE) {
			throw new Exception("cannot open ".$zipFileName);
		}

		while($shAr = $link->fetch_array($queryId)){
			$outFile = '';
			$fileName = '';
			ExcelTemplate_Controller::genFilledTemplate($link, $templateName, array($shAr["id"]), $erEmpty, $outFile, $fileName);		
			$fileNameParts = pathinfo($fileName,  PATHINFO_EXTENSION);
			$fileExt = '';
			if(is_array($fileNameParts) &amp;&amp; isset($fileNameParts['extension'])){
				$fileExt = $fileNameParts['extension'];
			}else if (gettype($fileNameParts) == "string"){
				$fileExt = $fileNameParts;
			}
			if(!strlen($fileExt)){
				$fileExt = '.xlsx';
			}else if($fileExt[0] != '.'){
				$fileExt = '.'.$fileExt;
			}
			$zip->addFile($outFile, $shAr["id"].'.xls');
			array_push($fileList, $outFile);
			usleep(500000);
		}

		$zip->close();

		//delete files, as they are already in a zip
		foreach($fileList as $fl){
			unlink($fl);
		}

		return $zipFileName;
	}

	//all shipments
	public function shipment_transp_nakl_all($pm){
		$docId = $this->getExtDbVal($pm, 'id');
		$faksim = ($pm->getParamValue("faksim") == "1");
		try{
			$outFile = $this->shipment_transp_nakl_all_operation($docId, $faksim);
			$fileName = "ТН.zip";
			$flMime = getMimeTypeOnExt($fileName);
			ob_clean();
			downloadFile(
				$outFile,
				$flMime,
				'attachment;',
				$fileName
			);
			
			return TRUE;
		}finally{
			if(file_exists($outFile)){
				unlink($outFile);
			}
		}
	}

	//one shipment
	public function shipment_transp_nakl($pm){
		$docId = $this->getExtDbVal($pm, 'id');
		$this->check_1c_attrs_for_tn($docId);

		$tmplName = ($this->getExtVal($pm, 'faksim') == "1")? "Транспортная накладная (факсимиле)" : "Транспортная накладная";
		return ExcelTemplate_Controller::downloadFilledTemplate(
			$this->getDbLink()
			,$tmplName
			,array($docId)
			,'Отгрузка не найдена!'
			,'Транспортная накладная'
		);
	}

	public function check_1c_attrs_for_tn($docId){
		//get client data from 1c
		$link = $this->getDbLink();
		$cl = $link->query_first(
			sprintf(
				"WITH 
				data AS (SELECT 
						o.client_id, 
						o.id AS order_id,
						sh.date_time::date AS ship_date,
						(SELECT  
							json_build_object(
								'id', vh_cl.id,
								'ref_1c', vh_cl.ref_1c,
								'inn', vh_cl.inn,
								'name_full', vh_cl.name_full,
								'address_fact', vh_cl.address_fact
							)
						FROM vehicle_owners AS vh_own 
						LEFT JOIN clients AS vh_cl ON vh_cl.id = vh_own.client_id
						WHERE vh_own.id = vh.official_vehicle_owner_id
						) AS veh_owner_client,
						json_build_object(
							'no_sig', transp_nakl_operator_sgn(sh.id) IS NULL,
							'name', op.users_ref->>'descr'
						) AS operator,
						json_build_object(
							'no_sig', transp_nakl_driver_sgn(sh.id) IS NULL,
							'name', dr.name
						) AS driver
					FROM shipments AS sh
					LEFT JOIN orders AS o ON o.id = sh.order_id
					LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
					LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
					LEFT JOIN drivers dr ON dr.id = vh.driver_id
					LEFT JOIN operators_for_transp_nakls_list op ON (op.production_sites_ref->'keys'->>'id')::int = sh.production_site_id
					WHERE sh.id = %d
				)
				SELECT 
					cl.id,
					cl.name,
					cl.name_full,
					cl.inn,
					cl.kpp,
					cl.ref_1c,
					cl.address_fact,
					(SELECT order_id FROM data) AS order_id,
					(SELECT veh_owner_client FROM data) AS veh_owner_client,
					(SELECT ship_date FROM data) AS ship_date,
					(SELECT ref_1c FROM buh_docs WHERE order_id =(SELECT order_id FROM data)) AS doc_ref_1c,
					(SELECT bool_and((data.operator->>'no_sig')::bool) FROM data) AS operators_no_sig,
					(SELECT string_agg(data.operator->>'name',',') FROM data WHERE (data.operator->>'no_sig')::bool) AS operators_no_sig_names,
					(SELECT bool_and((data.driver->>'no_sig')::bool) FROM data) AS drivers_no_sig,
					(SELECT string_agg(data.driver->>'name',',') FROM data WHERE (data.driver->>'no_sig')::bool) AS drivers_no_sig_names
				FROM clients AS cl
				WHERE cl.id = (SELECT client_id FROM data)"
				,$docId
			)
		);
		if(!is_array($cl) || !count($cl)) {
			throw new Exception(sprintf("document not found by id %d", $docId));
		}
		if(!isset($cl["ref_1c"])) {
			throw new Exception(sprintf("Контрагент %s не связан с 1с", $cl["name"]));
		}

		$vehOwnerClient = json_decode($cl["veh_owner_client"], TRUE);
		if(!isset($vehOwnerClient["ref_1c"])) {
			throw new Exception(sprintf("Перевозчик %s не связан с 1с", $cl["name"]));
		}

		if($cl["drivers_no_sig"] == "t" || $cl["operators_no_sig"] == "t") {
			$errText = "";
			if($cl["drivers_no_sig"] == "t") {
				$errText = "Водители без подписи: ".$cl["drivers_no_sig_names"];
			}
			if($cl["operators_no_sig"] == "t") {
				if($errText != ""){
					$errText.= ". ";
				}
				$errText.= "Операторы без подписи: ".$cl["operators_no_sig_names"];
			}
			throw new Exception($errText);
		}

		$this->check_client_rekv($cl);
		$this->check_client_rekv($vehOwnerClient);

		//documents: nakl, schet-faktura
		if(!isset($cl["doc_ref_1c"]) ){
			//retrieve data from 1c
			$ref1c = json_decode($cl["ref_1c"], TRUE);
			$resp = ExtProg::getShipment($ref1c["keys"]["ref_1c"], $cl["ship_date"]);
			$rows = $resp["models"]["ShipmentDoc_Model"]["rows"];
			if(!isset($rows["ref"]) || !strlen($rows["ref"])){
				throw new Exception("УПД не найдена в 1с");
			}
			$this->getDbLinkMaster()->query(
				sprintf(
					"INSERT INTO buh_docs (order_id, nomer, data, faktura_nomer, faktura_data, ref_1c) 
					VALUES (
						%d, '%s', '%s', '%s', '%s', '%s' 
					)"
					,$cl["order_id"]
					,$rows["nomer"]
					,$rows["data"]
					,$rows["faktura_nomer"]
					,$rows["faktura_data"]
					,$rows["ref"]
				)
			);
		}
	}
		
	public function shipment_ttn($pm){
		return ExcelTemplate_Controller::downloadFilledTemplate(
			$this->getDbLink()
			,'ТТН'
			,array($this->getExtDbVal($pm, 'id'))
			,'Отгрузка не найдена!'
			,'ТТН'
		);
	}
	
	public function get_passport_all($pm){
		$file_name = self::get_passport_file_name($this->getExtDbVal($pm, 'id'), $this->getDbLink(), TRUE);
		return ExcelTemplate_Controller::downloadFilledTemplateAsPDF(
			$this->getDbLink()
			,'ПаспортБезПечати'
			,array($this->getExtDbVal($pm, 'id'), 'TRUE')
			,'Отгрузка не найдена!'
			,$file_name
		);
	}
	public function get_passport_ship($pm){
		$file_name = self::get_passport_file_name($this->getExtDbVal($pm, 'id'), $this->getDbLink(), FALSE);
		return ExcelTemplate_Controller::downloadFilledTemplateAsPDF(
			$this->getDbLink()
			,'ПаспортБезПечати'
			,array($this->getExtDbVal($pm, 'id'), 'FALSE')
			,'Отгрузка не найдена!'
			,$file_name
		);
	}
	public function get_passport_stamp_all($pm){
		$file_name = self::get_passport_file_name($this->getExtDbVal($pm, 'id'), $this->getDbLink(), TRUE);
		return ExcelTemplate_Controller::downloadFilledTemplateAsPDF(
			$this->getDbLink()
			,'Паспорт'
			,array($this->getExtDbVal($pm, 'id'), 'TRUE')
			,'Отгрузка не найдена!'
			,$file_name
		);
	}
	public function get_passport_stamp_ship($pm){
		$file_name = self::get_passport_file_name($this->getExtDbVal($pm, 'id'), $this->getDbLink(), FALSE);
		return ExcelTemplate_Controller::downloadFilledTemplateAsPDF(
			$this->getDbLink()
			,'Паспорт'
			,array($this->getExtDbVal($pm, 'id'), 'FALSE')
			,'Отгрузка не найдена!'
			,$file_name
		);
	}
	
	//generates passport file name.
	public static function get_passport_file_name($shipmentId, $link, $all) {
		if($all){
			$ar = $link->query_first(sprintf(
				"SELECT		
					CASE WHEN EXTRACT(DAY FROM o.date_time)&lt;10 THEN
						'0' || EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
					ELSE
						EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
					END AS num
				FROM orders AS o
				WHERE o.id = (SELECT sh.order_id FROM shipments AS sh WHERE sh.id = %d)"
				,$shipmentId
			));
		}else{
			$ar = $link->query_first(sprintf(
				"WITH
				order_t AS (SELECT sh.order_id FROM shipments AS sh WHERE sh.id = %d),
				ship_num AS (
					SELECT
						ROW_NUMBER() OVER() AS num,
						sh.id
					FROM shipments AS sh
					WHERE sh.order_id = (SELECT order_t.order_id FROM order_t)
					ORDER BY sh.ship_date_time		
				)
				SELECT		
					CASE WHEN EXTRACT(DAY FROM o.date_time)&lt;10 THEN
						'0' || EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
					ELSE
						EXTRACT(DAY FROM o.date_time)::varchar || '-' || trim(to_char(o.number,'000'))
					END ||'/'|| (SELECT ship_num.num::text FROM ship_num WHERE ship_num.id = %d)
					AS num
				FROM orders AS o
				WHERE o.id = (SELECT order_t.order_id FROM order_t)"
				,$shipmentId
				,$shipmentId
			));
		}
		if(!is_array($ar) || !count($ar) || !isset($ar['num'])){
			throw new Exception("query_first() failed: id not found");
		}
		return 'Паспорт №'.$ar['num'].'.pdf';
	}
	
	public function get_list_for_doc($pm){	
		$this->modelGetList(new ShipmentForDocList_Model($this->getDbLink()), $pm);
	}

	private function check_shipment_for_tn($shipmentId, $faksim){
		$link = $this->getDbLink();
		$cl = $link->query_first(
			sprintf(
				"WITH 
				data AS (SELECT 
						o.client_id, 
						o.id AS order_id,
						sh.date_time::date AS ship_date,
						(SELECT  
							json_build_object(
								'id', vh_cl.id,
								'ref_1c', vh_cl.ref_1c,
								'inn', vh_cl.inn,
								'name_full', vh_cl.name_full,
								'address_fact', vh_cl.address_fact
							)
						FROM vehicle_owners AS vh_own 
						LEFT JOIN clients AS vh_cl ON vh_cl.id = vh_own.client_id
						WHERE vh_own.id = vh.official_vehicle_owner_id
						) AS veh_owner_client,
						json_build_object(
							'no_sig', transp_nakl_operator_sgn(sh.id) IS NULL,
							'name', op.users_ref->>'descr'
						) AS operator,
						json_build_object(
							'no_sig', transp_nakl_driver_sgn(sh.id) IS NULL,
							'name', dr.name
						) AS driver,
						json_build_object(
							'no_driver', vh.driver_id IS NULL,
							'plate', vh.plate
						) AS veh_drivers
					FROM shipments AS sh
					LEFT JOIN orders AS o ON o.id = sh.order_id
					LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
					LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
					LEFT JOIN drivers dr ON dr.id = vh.driver_id
					LEFT JOIN operators_for_transp_nakls_list op ON (op.production_sites_ref->'keys'->>'id')::int = sh.production_site_id
					WHERE sh.id = %d
				)
				SELECT 
					cl.id,
					cl.name,
					cl.name_full,
					cl.inn,
					cl.kpp,
					cl.ref_1c,
					cl.address_fact,
					(SELECT order_id FROM data) AS order_id,
					(SELECT veh_owner_client FROM data) AS veh_owner_client,
					(SELECT ship_date FROM data) AS ship_date,
					(SELECT ref_1c FROM buh_docs WHERE order_id =(SELECT order_id FROM data)) AS doc_ref_1c,
					(SELECT bool_and((data.operator->>'no_sig')::bool) FROM data) AS operators_no_sig,
					(SELECT string_agg(data.operator->>'name',',') FROM data WHERE (data.operator->>'no_sig')::bool) AS operators_no_sig_names,
					(SELECT bool_and((data.driver->>'no_sig')::bool) FROM data) AS drivers_no_sig,
					(SELECT string_agg(data.driver->>'name',',') FROM data WHERE (data.driver->>'no_sig')::bool) AS drivers_no_sig_names,
					(SELECT bool_and((data.veh_drivers->>'no_driver')::bool) FROM data) AS veh_no_drivers,
					(SELECT string_agg(data.veh_drivers->>'plate',',') FROM data WHERE (data.veh_drivers->>'no_driver')::bool) AS veh_no_drivers_plates
				FROM clients AS cl
				WHERE cl.id = (SELECT client_id FROM data)"
				,$shipmentId
			)
		);
		if(!is_array($cl) || !count($cl)) {
			throw new Exception(sprintf("document not found by id %d", $shipmentId));
		}
		if(!isset($cl["ref_1c"])) {
			throw new Exception(sprintf("Контрагент %s не связан с 1с", $cl["name"]));
		}

		$vehOwnerClient = json_decode($cl["veh_owner_client"], TRUE);
		if(!isset($vehOwnerClient["ref_1c"])) {
			throw new Exception(sprintf("Перевозчик %s не связан с 1с", $cl["name"]));
		}

		if($cl["veh_no_drivers"] == "t" || $cl["drivers_no_sig"] == "t" || $cl["operators_no_sig"] == "t") {
			$errText = "";
			if($cl["veh_no_drivers"] == "t") {
				if($errText != ""){
					$errText.= ". ";
				}
				$errText = "ТС без водителей: ".$cl["veh_no_drivers_plates"];
			}
			if($cl["drivers_no_sig"] == "t" &amp;&amp; strlen($cl["drivers_no_sig_names"]) &amp;&amp; $faksim) {
				if($errText != ""){
					$errText.= ". ";
				}
				$errText.= "Водители без подписи: ".$cl["drivers_no_sig_names"];
			}
			if($cl["operators_no_sig"] == "t" &amp;&amp; $faksim) {
				if($errText != ""){
					$errText.= ". ";
				}
				$errText.= "Операторы без подписи: ".$cl["operators_no_sig_names"];
			}
			if(strlen($errText)){
				throw new Exception($errText);
			}
		}

		$this->check_client_rekv($cl);
		$this->check_client_rekv($vehOwnerClient);
	}

	//print transp nakl on list on shipments
	public function shipment_transp_nakl_on_list($pm){	
		$docList = []; //shipments

		$link = $this->getDbLinkMaster();

		//from selected shipments
		if($pm->getParamValue("shipment_ids")){
			$shIds = json_decode("[".$this->getExtVal($pm, 'shipment_ids')."]", TRUE);
			if(!count($shIds)){
				throw new Exception("no ids found");
			}
			foreach ($shIds as $id) {
				$shId = intval($id);
				if($shId){
					array_push($docList, $shId); 
				}
			}
		}

		if(!count($docList)){
			throw new Exception("no doc found");
		}

		//must be one client!!!
		$arId = $link->query(sprintf(
			"SELECT 
				o.client_id,
				count(*) AS cnt
		   	FROM shipments AS sh 
			LEFT JOIN orders AS o ON o.id = sh.order_id
			WHERE sh.id IN (%s)
			GROUP BY o.client_id",
			implode(",", $docList)
		));
		$cnt = 0;
		while($ar = $link->fetch_array($arId)){
			$cnt++;
		}
		if(!$cnt){
			throw new Exception("docs not found");
		}
		if($cnt > 1){
			throw new Exception("Документы принадлежат разным контрагентам");
		}

		$faksim = ($pm->getParamValue("faksim") == "1");
		$buhDoc = $this->getExtDbVal($pm, "buh_doc");

		//all shipments on order
		$queryId = $link->query(
			sprintf(
				"SELECT
					sh.id
				FROM shipments AS sh
				WHERE sh.id IN (%s)
				ORDER BY sh.date_time"
				,implode(",", $docList)
			)
		);

		$templateName = $faksim? "Транспортная накладная (факсимиле)" : "Транспортная накладная";
		$erEmpty = 'Отгрузка не найдена!';

		$multiFile = (count($docList) &gt; 1);

		if($multiFile) {
			//many files: pack to zip
			$fileList = array();
			$outFileName = "ТН.zip";
			$outFile = OUTPUT_PATH. md5(uniqid()).'.zip';
			$zip = new ZipArchive();
			if ($zip->open($outFile, ZIPARCHIVE::CREATE)!==TRUE) {
				throw new Exception("cannot open ".$outFile);
			}
		}else{
			$outFileName = "ТН.xlsx";
			$outFile = OUTPUT_PATH. md5(uniqid()).'.zip';
		}

		$ind = 0;
		while($shAr = $link->fetch_array($queryId)){
			$ind++;
			$this->check_shipment_for_tn($shAr["id"], $faksim? TRUE:FALSE);

			$tFile = '';
			$fileName = '';
			ExcelTemplate_Controller::genFilledTemplate($link, $templateName, array($shAr["id"], $ind, $buhDoc), $erEmpty, $tFile, $fileName);		
			$fileNameParts = pathinfo($fileName,  PATHINFO_EXTENSION);
			$fileExt = '';
			if(is_array($fileNameParts) &amp;&amp; isset($fileNameParts['extension'])){
				$fileExt = $fileNameParts['extension'];
			}else if (gettype($fileNameParts) == "string"){
				$fileExt = $fileNameParts;
			}
			if(!strlen($fileExt)){
				$fileExt = '.xlsx';
			}else if($fileExt[0] != '.'){
				$fileExt = '.'.$fileExt;
			}

			if($multiFile) {
				$zip->addFile($tFile, $shAr["id"].'.xls');
				array_push($fileList, $tFile);

				usleep(500000);

			}else{
				$outFile = $tFile;
			}
		}

		if($multiFile) {
			$zip->close();

			//delete files, as they are already in a zip
			foreach($fileList as $fl){
				unlink($fl);
			}
		}

		try{
			$flMime = getMimeTypeOnExt($outFileName);
			ob_clean();
			downloadFile(
				$outFile,
				$flMime,
				'attachment;',
				$outFileName
			);
		}finally{
			unlink($outFile);
		}
	}
}
<![CDATA[?>]]>
</xsl:template>

</xsl:stylesheet>

