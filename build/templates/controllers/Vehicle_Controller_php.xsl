<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="Controller_php.xsl"/>

<!-- -->
<xsl:variable name="CONTROLLER_ID" select="'Vehicle'"/>
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
require_once('common/SMSService.php');

require_once(FUNC_PATH.'VehicleRoute.php');

class <xsl:value-of select="@id"/>_Controller extends ControllerSQL{

	public function __construct($dbLinkMaster=NULL, $dbLink=NULL){
		parent::__construct($dbLinkMaster, $dbLink);<xsl:apply-templates/>
	}
	
	public function get_vehicle_statistics($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->setValidated('date',DT_DATE);
		$this->addNewModel(vsprintf(
			'SELECT * FROM get_vehicle_statistics(%s)',
			$params->getArray()),
			'get_vehicle_statistics'
		);
	}
	public function check_for_broken_trackers(){
		$dbLink = $this->getDbLink();
		$ar = $dbLink->query_first(
			'SELECT * FROM check_for_broken_trackers()'
		);
		if ($ar){			
			$sms_service = new SMSService(SMS_LOGIN, SMS_PWD);
			$sms_id_resp = $sms_service->send($ar['cel_phone'],
				$ar['sms_text'],SMS_SIGN,SMS_TEST);
			$sms_id = NULL;
			FieldSQLString::formatForDb($this->getDbLinkMaster(),$sms_id_resp,$sms_id);
			$dbLink->query(sprintf(
			'INSERT INTO sms_trackers_service (mes_id,mes_text,date_time)
				VALUES(%s,%s,now())',
			$sms_id,$ar['sms_text']
			));
		}
	}
	public function complete_owners($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->setValidated('owner',DT_STRING);
		$this->addNewModel(vsprintf(
			"SELECT * FROM vehicle_owner_list_view
			WHERE lower(owner) LIKE '%%'||%s||'%%'",
			$params->getArray()),
			'VehicleOwnerList_Model'
		);
	}
	public function complete_features($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->setValidated('feature',DT_STRING);
		$this->addNewModel(vsprintf(
			"SELECT * FROM vehicle_feature_list_view
			WHERE lower(feature) LIKE '%%'||%s||'%%'",
			$params->getArray()),
			'VehicleFeatureList_Model'
		);	
	}
	public function complete_makes($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->setValidated('make',DT_STRING);
		$this->addNewModel(vsprintf(
			"SELECT * FROM vehicle_make_list_view
			WHERE lower(make) LIKE '%%'||%s||'%%'",
			$params->getArray()),
			'VehicleMakeList_Model'
		);	
	}
	public function vehicles_with_trackers($pm){
		$this->addNewModel(
			sprintf(
				"SELECT
					0 AS id
					,'*** ВСЕ ***' AS plate
					,'NULL' AS tracker_id
				UNION ALL
				(SELECT
					id
					,plate
					,tracker_id
				FROM vehicles
				WHERE tracker_id IS NOT NULL AND tracker_id &lt;&gt;''%s
				ORDER BY plate)",
				($_SESSION['role_id']=='vehicle_owner')? sprintf(' AND vehicles.vehicle_owner_id=%d',$_SESSION['global_vehicle_owner_id']):''
			),
			'vehicles_with_trackers'
		);		
	}
	public function get_tracker_inf($pm){
		$params = new ParamsSQL($pm,$this->getDbLink());
		$params->setValidated('id',DT_INT);	
		
		$cond = ($_SESSION['role_id']=='vehicle_owner')? sprintf(' AND vehicles.vehicle_owner_id=%d',$_SESSION['global_vehicle_owner_id']):'';
		$this->addNewModel(
			vsprintf(
				"SELECT
				date5_time5_descr(recieved_dt+age(now(),now() at time zone 'UTC')) AS recieved_dt_str
				FROM car_tracking
				LEFT JOIN vehicles ON vehicles.tracker_id=car_tracking.car_id
				WHERE vehicles.id=%d".$cond."
				ORDER BY period DESC LIMIT 1",
				$params->getArray()				
			),
			'get_tracker_inf'
		);		
	}
	
	/**
	 * Returns existing route and current position
	 */
	public function get_route($pm){
		$route_ar = $this->getDbLink()->query_first(sprintf(
			"SELECT
				CASE
					WHEN t.route->'routes' IS NOT NULL AND jsonb_array_length(t.route->'routes')>=1 THEN
						ST_AsText(ST_LineFromEncodedPolyline(t.route->routes[0]->geometry))
					ELSE NULL
				END AS route_rest
				
			FROM vehicle_route_cashe AS t
			WHERE
				t.tracker_id = %s
				AND t.shipment_id = %d
				AND t.vehicle_state = %s"				
			,$this->getExtDbVal($pm,'tracker_id')
			,$this->getExtDbVal($pm,'shipment_id')
			,$this->getExtDbVal($pm,'vehicle_state')
		));
		if(is_array($route_ar) &amp;&amp; count($route_ar)){
			$this->addModel(new ModelVars(
				array('id'=>'Route_Model',
					'values'=>array(
						new Field('route_rest',DT_STRING,
							array('value'=>$route_ar['route_rest']))
					)
				)
			));	
		}
		
		//position
		$this->addNewModel(
			VehicleRoute::getLastPosQuery($this->getExtDbVal($pm,'vehicle_id'))
			,'VehicleLastPos_Model'
		);
		
	}
	
	public function get_current_position($pm){
		
		$vehicle_id = $this->getExtDbVal($pm,'id');
		if($_SESSION['role_id']=='vehicle_owner'){
			$ar = $this->getDbLink()->query_first(sprintf(
				"SELECT vehicle_owner_id FROM vehicles WHERE id=%d",$vehicle_id
			));
			if(!is_array($ar) ||!count($ar) || $ar['vehicle_owner_id']!=$_SESSION['global_vehicle_owner_id']){
				throw new Exception('Permission denied!');
			}
		}
		
		//zones
		$this->addNewModel(
			VehicleRoute::getZoneListQuery($vehicle_id)
			,'ZoneList_Model'
		);
		
		//position
		$this->addNewModel(
			VehicleRoute::getLastPosQuery($vehicle_id)
			,'VehicleLastPos_Model'
		);
		
		$route_rest_len = NULL;
		
		//Если нет трэкера или статус=на базе, маршрут не строим!
		$ar_st = $this->getDbLink()->query_first(sprintf(
			"SELECT
				(SELECT
					state IN ('assigned','busy','left_for_dest','left_for_base','shift_added')
				FROM vehicle_schedule_states
				WHERE schedule_id=(
					SELECT
						id
					FROM vehicle_schedules
					WHERE schedule_date=now()::date and vehicle_id=%d
				)
				ORDER BY date_time DESC
				LIMIT 1) As do_route,
				
				(SELECT v.tracker_id FROM vehicles AS v WHERE v.id=%d) AS tracker_id",
			$vehicle_id,
			$vehicle_id
		));
		
		if(is_array($ar_st) &amp;&amp; count($ar_st)
		&amp;&amp; isset($ar_st['tracker_id']) &amp;&amp; strlen($ar_st['tracker_id'])
		&amp;&amp; isset($ar_st['do_route']) &amp;&amp; $ar_st['do_route']=='t'){			
		
			$route_rest = VehicleRoute::getRoute($vehicle_id, $this->getDbLinkMaster(), $route_rest_len);
			
			if($route_rest &amp;&amp; strlen($route_rest)){
				$this->addModel(new ModelVars(
					array('id'=>'Route_Model',
						'values'=>array(
							new Field('route_rest',DT_STRING,
								array('value'=>$route_rest))
							,new Field('route_rest_len',DT_STRING,
								array('value'=>$route_rest_len))
								
						)
					)
				));
			}
		}
	}
	public function get_current_position_all($pm){
		//zones
		$this->addNewModel(
		"SELECT 
			replace(
				replace(st_astext(d.zone), 'POLYGON(('::text, ''::text), '))'::text, ''::text
			) AS base_zone
		FROM destinations AS d
		WHERE d.id=constant_base_geo_zone_id()",
		'ZoneList_Model');
		
		//position
		if($_SESSION['role_id']=='vehicle_owner'){
			$q = sprintf(
				"SELECT * FROM vehicles_last_pos WHERE id IN (SELECT t.id FROM vehicles t WHERE t.vehicle_owner_id=%d)",
				$_SESSION['global_vehicle_owner_id']
			);
		}
		else{
			$q = "SELECT * FROM vehicles_last_pos";
		}
		
		$this->addNewModel($q,'VehicleLastPos_Model');		
	}
	
	public function get_track($pm){
		$link = $this->getDbLink();
		
		if($_SESSION['role_id']=='vehicle_owner'){
			$ar = $link->query_first(sprintf("SELECT vehicle_owner_id FROM vehicles WHERE id=%d",$this->getExtDbVal($pm,'id')));
			if(!is_array($ar) ||!count($ar) || $ar['vehicle_owner_id']!=$_SESSION['global_vehicle_owner_id']){
				throw new Exception('Permission denied!');
			}
		}
		
		$this->addNewModel(sprintf(
			"SELECT
				(
					SELECT
					replace(replace(st_astext(zone), 'POLYGON(('::text, ''::text), '))'::text, ''::text) AS coords
					FROM destinations
					WHERE id=constant_base_geo_zone_id()
				) AS base_zone,
				NULL AS dest_zone
			UNION ALL
			SELECT
				NULL AS base_zone,
				replace(replace(st_astext(zone), 'POLYGON(('::text, ''::text), '))'::text, ''::text) AS dest_zone
			FROM vehicle_schedule_states AS st
			LEFT JOIN vehicle_schedules AS vs ON vs.id=st.schedule_id
			LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
			LEFT JOIN destinations AS dest ON dest.id=st.destination_id
			WHERE v.id=%d
			AND st.date_time BETWEEN %s AND %s
			AND st.state='busy'::vehicle_states",
			$this->getExtDbVal($pm,'id'),
			$this->getExtDbVal($pm,'dt_from'),
			$this->getExtDbVal($pm,'dt_to')
			)
			,'ZoneList_Model'
		);
		//track
		$this->addNewModel(sprintf(
			"SELECT * FROM vehicles_get_track(%d,%s,%s,%s)",
			$this->getExtDbVal($pm,'id'),
			$this->getExtDbVal($pm,'dt_from'),
			$this->getExtDbVal($pm,'dt_to'),
			$this->getExtDbVal($pm,'stop_dur')
			),
			'TrackData_Model'
		);				
	}
	public function get_tool_tip($pm){
		$link = $this->getDbLink();
		
		$ar = $link->query_first(sprintf(
		"SELECT
			date8_time5_descr(current_coord_date_time::timestamp without time zone) AS dt,
			current_coord[1] AS cur_lat,
			current_coord[2] AS cur_lon,		
			coord[1][1] AS lat_min,coord[1][2] AS lat_max,
			coord[2][1] AS lon_min,coord[2][2] AS lon_max,
			descr
		FROM vehicle_current_heading(%d)
		AS (current_coord float[],current_coord_date_time timestamp,
		coord float[],descr text)",
		$this->getExtDbVal($pm,'id')
		));
		$res = '';
		if ($ar){
			$res = '&lt;div&gt;трэкер:'.$ar['dt'].'&lt;/div&gt;';
			if ($ar['descr']=='to_base' ||
			$ar['descr']=='to_dest'){
				$km = 'xx';
				$t = ($ar['descr']=='to_base')? 'до базы:':'до объекта:';
				$res.=sprintf('&lt;div&gt;%s%s км.&lt;/div&gt;',$t,$km);
			}
		}
		echo $res;
	}
	public function get_stops_at_dest($pm){
		$link = $this->getDbLink();
		$model = new ModelSQL($link,array("id"=>"get_stops_at_dest"));
		$model->addField(new FieldSQLDateTime($link,null,null,"date_time",DT_DATETIME));
		$model->addField(new FieldSQLInt($link,null,null,"destination_id",DT_INT));
		$model->addField(new FieldSQLInt($link,null,null,"vehicle_id",DT_INT));
		$model->addField(new FieldSQLString($link,null,null,"stop_dur",DT_TIME));
		
		$where = $this->conditionFromParams($pm,$model);
		$from = null;
		$to = null;
		$destination_id = 0;
		$vehicle_id = 0;
		$vehicle_owner_id = 0;
		$stop_dur = "'00:05'";
		
		foreach($where->fields as $w_field){
			$id = $w_field['field']->getId();
			if ($id=='date_time'){
				if ($w_field['signe']=='&gt;='){
					$from = $w_field['field']->getValueForDb();
				}
				else{
					$to = $w_field['field']->getValueForDb();
				}
			}
			else if ($id=='destination_id'){
				$destination_id = $w_field['field']->getValueForDb();
			}
			else if ($id=='vehicle_id'){
				$vehicle_id = $w_field['field']->getValueForDb();
			}			
			else if ($id=='stop_dur'){
				$stop_dur = $w_field['field']->getValueForDb();
			}			
		}
		
		if($_SESSION['role_id']=='vehicle_owner' &amp;&amp; $vehicle_id){
			$ar = $link->query_first(sprintf("SELECT vehicle_owner_id FROM vehicles WHERE id=%d",$vehicle_id));
			if(!is_array($ar) ||!count($ar) || $ar['vehicle_owner_id']!=$_SESSION['global_vehicle_owner_id']){
				throw new Exception('Permission denied!');
			}
			$vehicle_owner_id = $_SESSION['global_vehicle_owner_id'];
		}
				
		$model->setSelectQueryText(
		sprintf(
		"SELECT * FROM vehicles_at_destination(%s,%s,%d,%d,%s::interval,%d)",
		$from,$to,$destination_id,$vehicle_id,$stop_dur,$vehicle_owner_id));
		
		$model->select(false,null,null,
			null,null,null,null,null,TRUE);
		//
		$this->addModel($model);				
	}	
	
	public function get_total_shipped($pm){
		$this->addNewModel(
			'SELECT count(*) AS val FROM shipments WHERE shipped',
			'TotalShipped_Model'
		);
		
	}
}
<![CDATA[?>]]>
</xsl:template>

</xsl:stylesheet>
