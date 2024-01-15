<?php

require_once('common/decodePolylineToArray.php');
require_once('common/OSRMV5.php');
require_once('common/decodePolylineToArray.php');

class VehicleRoute {
	
	const ER_OSRM_ROUTE_QUERY = 'Ошибка получения данных с сервера OSRM!';
	
	public static function getSessCond(){
		$cond = '';
		if (isset($_SESSION) && isset($_SESSION['role_id']) && isset($_SESSION['global_vehicle_owner_id'])){
			$cond = ($_SESSION['role_id']=='vehicle_owner')? sprintf(' AND vs.vehicle_id IN (SELECT vv.id FROM vehicles vv WHERE vv.id=%d)',$_SESSION['global_vehicle_owner_id']):'';
		}
		return $cond;
	}

	public static function getZoneListQuery($vehicleId){
			
		$cond = self::getSessCond();
			
		//Вернем несколько строк - все зоны заводы + клиент
		/*
		(SELECT
			replace(replace(st_astext(d.zone),
			'POLYGON(('::text, ''::text), '))'::text, ''::text)
		FROM destinations AS d
		WHERE d.id=constant_base_geo_zone_id()
		) AS base_zone,			
		*/
		return sprintf(
			"(SELECT
				replace(replace(st_astext(d.zone), 'POLYGON(('::text, ''::text), '))'::text, ''::text) AS base_zone,
				NULL AS dest_zone
			FROM production_bases AS b
			LEFT JOIN destinations AS d ON d.id = b.destination_id)			

			UNION ALL
			
			(SELECT 			
				NULL AS base_zone,					
				CASE 		
				--'at_dest'::vehicle_states,
				WHEN st.state IN ('left_for_base'::vehicle_states) THEN
					(SELECT
						replace(replace(st_astext(d.zone),
						'POLYGON(('::text, ''::text), '))'::text, ''::text)
					FROM destinations AS d
					WHERE d.id=st.destination_id
					)	
				
				WHEN st.state ='busy'::vehicle_states THEN
					(SELECT
						replace(replace(st_astext(d.zone),
						'POLYGON(('::text, ''::text), '))'::text, ''::text)
					FROM destinations AS d
					LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
					LEFT JOIN orders AS o ON o.id=sh.order_id
					WHERE d.id=o.destination_id
					)
				ELSE null
				END AS dest_zone
			
			FROM vehicle_schedule_states AS st
			LEFT JOIN vehicle_schedules AS vs ON vs.id=st.schedule_id
			WHERE vs.vehicle_id=%d AND st.date_time < now()".$cond."
			ORDER BY st.date_time DESC
			LIMIT 1)"
			,$vehicleId		
		);	
	}
	
	public static function getLastPosQuery($vehicleId){
		return sprintf(
			"SELECT * FROM vehicles_last_pos
			WHERE id=%d",
			$vehicleId
		);
	}
	
	/**
	 * returns matched geometry
	 */
	private static function matchRouteToRoad(&$osrm, $encodedPoliline){	
		$route_points = decodePolylineToArray($encodedPoliline);		
		$osrm_points = array();
		//convert to [string lon,lat] array FROM [lon,lat]
		foreach($route_points as $pt){
			array_push($osrm_points,str_replace(',','.',($pt[1]*10)).','.str_replace(',','.',($pt[0]*10)));
		}
		$osrm_route = $osrm->matchRoute(
			$osrm_points
			,'driving'
			,array("geometries=polyline","overview=full","tidy=true")									
		);
		//overview = simplified (default), full, false
		//tidy: true/false
		//radius miters
		if (!$osrm_route->matchings || !count($osrm_route->matchings) || !$osrm_route->matchings[count($osrm_route->matchings)-1]->geometry){
			throw new Exception(self::ER_OSRM_ROUTE_QUERY);
		}
		return $osrm_route->matchings[count($osrm_route->matchings)-1]->geometry;						
	}
	
	/**
	 * Перестроение маршрута
	 * для маршрута на базу надо найти все производственные зоны, их геозоны, близлежащие дороги
	 * и выбрать зону, которая ближе к текущему положению ТС, эта зона и будет назнчением
	 */ 
	public static function rebuildRoute($trackerId, $shipmentId, $vehicleState, $dbLink, &$routeRestLen){
		$osrm = new OSRMV5(OSRM_PROTOCOLE,OSRM_HOST,OSRM_PORT);
		
		$to_dest = ($vehicleState=='busy' || $vehicleState=='left_for_dest');
		if($to_dest){
			//путь до клиента
			$dest_q = sprintf(
				"(SELECT o.destination_id
				FROM shipments AS sh
				LEFT JOIN orders AS o ON o.id=sh.order_id
				WHERE sh.id = %d)"
			,$shipmentId);
			
		}else{
			//путь до производственной зоны
			$dest_q = "(SELECT const_base_geo_zone_id_val())";
		}
		
		$cashe_ar = $dbLink->query_first(sprintf(
			"WITH
			zone_data AS (
				SELECT
					dest.near_road_lon
					,dest.near_road_lat
				FROM destinations AS dest
				WHERE dest.id=".$dest_q."					
			)			
			,veh_last_points AS (
				SELECT
					json_agg(
						json_build_object(
							'lon',sub.lon
							,'lat',sub.lat
						)
					) AS pos
				FROM (				
					SELECT
						tr.lon
						,tr.lat
					FROM car_tracking AS tr
					WHERE tr.car_id = '%s' AND tr.gps_valid = 1
					ORDER BY tr.period DESC
					LIMIT (const_deviation_for_reroute_val()->>'points_cnt')::int
				) AS sub
			)
			".($to_dest? sprintf(",client_zone AS (
				SELECT
					cl_dest.lon
					,cl_dest.lat
				FROM client_destinations AS cl_dest
				WHERE cl_dest.client_id = (
						SELECT o.client_id
						FROM orders AS o
						WHERE o.id=(SELECT sh.order_id FROM shipments AS sh WHERE id=%d)
					)
					AND cl_dest.destination_id = ".$dest_q."
				)",$shipmentId)
				: ""
			).
			"SELECT
				".($to_dest? 
					"(SELECT coalesce( (SELECT lon FROM client_zone), (SELECT near_road_lon FROM zone_data) ) ) AS zone_near_road_lon
					,(SELECT coalesce( (SELECT lat FROM client_zone), (SELECT near_road_lat FROM zone_data) ) ) AS zone_near_road_lat"
					: "(SELECT near_road_lon FROM zone_data) AS zone_near_road_lon
					,(SELECT near_road_lat FROM zone_data) AS zone_near_road_lat"
				)
				.",(SELECT pos FROM veh_last_points) AS cur_pos
			
			"
			,$trackerId)
		);
		
		$route = NULL;
		
		$cur_pos = json_decode($cashe_ar['cur_pos']);
		if(is_array($cur_pos) && count($cur_pos)
		 &&isset($cashe_ar['zone_near_road_lon'])  && isset($cashe_ar['zone_near_road_lat'])
		){
			//routing
			$osrm_route = $osrm->getRoute(
				array(
					str_replace(',','.',$cur_pos[0]->lon).','.str_replace(',','.',$cur_pos[0]->lat)
					,str_replace(',','.',$cashe_ar['zone_near_road_lon']).','.str_replace(',','.',$cashe_ar['zone_near_road_lat'])
				)
				,'json'
				,NULL
				,array("geometries=polyline")									
			);
			if (!$osrm_route->routes || !count($osrm_route->routes) || !$osrm_route->routes[count($osrm_route->routes)-1]->geometry){
				throw new Exception(self::ER_OSRM_ROUTE_QUERY);
			}
			$osrm_route_geom = $osrm_route->routes[count($osrm_route->routes)-1]->geometry;
			$route_for_db = "'".json_encode($osrm_route)."'";
			try{
				$osrm_route_geom = self::matchRouteToRoad($osrm, $osrm_route_geom);
			}catch(Exception $e){				
				error_log($e->getMessage());
			}
			
			//rebuild route in cashe
			$route_ar = $dbLink->query_first(sprintf(
				"UPDATE vehicle_route_cashe
				SET
					update_dt = now()
					,route = %s
					,route_line = ST_LineFromEncodedPolyline('%s')
				WHERE tracker_id = '%s'
					AND shipment_id = %d
					AND vehicle_state = '%s'::vehicle_states
				RETURNING
					ST_AsText(ST_LineFromEncodedPolyline('%s')) AS route_rest
					,ST_Length(ST_Transform(ST_LineFromEncodedPolyline('%s'),3857)) AS route_rest_len"
				,$route_for_db
				,$osrm_route_geom
				,$trackerId
				,$shipmentId
				//$vehicleState=='at_dest'||
				,($vehicleState=='left_for_base')? 'left_for_base':'left_for_dest'
				,$osrm_route_geom
				,$osrm_route_geom
			));
			if(is_array($route_ar) && count($route_ar) && isset($route_ar['route_rest'])){
				$route = $route_ar['route_rest'];
				$routeRestLen = $route_ar['route_rest_len'];
			}
		}
		
		if($route){
			$route = str_replace('LINESTRING(','',$route);
			$route = str_replace('MULTI(','',$route);
			$route = str_replace('GEOMETRYCOLLECTION(','',$route);
			$route = str_replace('(','',$route);
			$route = str_replace(')','',$route);
		}
		return $route;
	}
	
	/**
	 * БЫЛО так:routes[0]->geometry OSRM encoded(5) polyline
	 * По новому: text(array(lon lat)) только остаток пути
	 */
	public static function getRoute($vehicleId, $dbLink, &$routeRestLen){
		/**
		 * Если текущий статус at_dest/assigned/busy/left_for_dest - нужно вернуть предполагаемый маршрут до объекта
		 * Если текущий статус left_for_base - нужно вернуть предполагаемый маршрут до базы
		 * Сначала проверить в кэше, проверить последние Х точек на соответствие маршруту, если надо - перестроить
		 * если нет маршрута в кэше- построить
		 * Ну и вернуть клиенту маршрут
		 *
		 *  const_deviation_for_reroute_val() points,distance_m
		 */
		
		$cond = self::getSessCond();

		//Исходные данные, не только кэш... 
		$cashe_ar = $dbLink->query_first(sprintf(
			"WITH			
			--current vehicle state
			vh_st AS (
				SELECT
					st.state
					,st.shipment_id
					,st.date_time
					,CASE WHEN st.destination_id IS NOT NULL THEN st.destination_id ELSE
						(SELECT
							o.destination_id
						FROM orders AS o
						WHERE o.id=(SELECT sh.order_id FROM shipments AS sh WHERE sh.id=st.shipment_id)
						)
					END AS destination_id
					,vh.tracker_id
					,o.client_id
				FROM vehicle_schedule_states AS st
				LEFT JOIN vehicle_schedules AS vs ON vs.id=st.schedule_id
				LEFT JOIN vehicles AS vh ON vh.id=vs.vehicle_id
				LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
				LEFT JOIN orders AS o ON o.id=sh.order_id
				WHERE vs.vehicle_id=%d AND st.date_time < now()".$cond."
				ORDER BY st.date_time DESC
				LIMIT 1				
			)
			
			--cashe data on current shipment
			,cashe_data AS (
				SELECT
					t.tracker_id
					,t.route_line route_geom
					,ST_Length(ST_Transform(t.route_line,3857)) AS route_geom_len
				FROM vehicle_route_cashe AS t
				WHERE
					t.shipment_id=(SELECT shipment_id FROM vh_st)
					AND (
						(t.vehicle_state = 'left_for_dest' AND (SELECT state FROM vh_st) IN ('at_dest','assigned','busy','left_for_dest') )
						OR 
						(t.vehicle_state = 'left_for_base' AND (SELECT state FROM vh_st) IN ('left_for_base') )
					)
					AND t.tracker_id=(SELECT tracker_id FROM vh_st)			
			)
			
			,client_zone AS (
				SELECT
					cl_dest.lon
					,cl_dest.lat
				FROM client_destinations AS cl_dest
				WHERE cl_dest.client_id = (SELECT client_id FROM vh_st)
					AND cl_dest.destination_id = (SELECT destination_id FROM vh_st)
			)
			
			--zone data: base or client destination zone based on state, near route coords if any, zone center
			,zone_data AS (
				SELECT
					dest.id
					,dest.near_road_lon
					,dest.near_road_lat
					,(SELECT
						(vh_st.state = 'left_for_base'
						AND
						(now() - vh_st.date_time) > (
								(SELECT d.time_route
								FROM destinations AS d
								WHERE d.id=(SELECT destination_id FROM vh_st)
								)
								*2
							)
						)
					FROM vh_st
					) AS out_of_work
					,replace(replace(st_astext(st_centroid(dest.zone)), 'POINT('::text, ''::text), ')'::text, ''::text) AS zone_center_str
				FROM destinations AS dest
				WHERE dest.id=
					(CASE
						WHEN (SELECT state FROM vh_st) = 'left_for_base' THEN
							(SELECT
								coalesce(pr_st.destination_id, const_base_geo_zone_id_val())
							FROM shipments AS sh
							LEFT JOIN production_sites AS pr_st ON pr_st.id = sh.production_site_id
							WHERE sh.id=(SELECT shipment_id FROM vh_st)
							)
						ELSE (SELECT destination_id FROM vh_st) 	
					END	
					)					
			)

			--last X vehicle positions
			,veh_last_points AS (
				SELECT
					tr.lon
					,tr.lat
					,tr.period
					,CASE
						WHEN (SELECT route_geom FROM cashe_data) IS NULL THEN NULL
						ELSE
							st_transform(
								st_buffer(
									st_transform(
								    		st_geomFromText('POINT('||tr.lon::text||' '||tr.lat::text||')', 4326), 
								    		900913
								    	)
								  	,(SELECT (const_deviation_for_reroute_val()->>'distance_m')::int)
								),4326
							)													
					END AS pt_geom
				FROM car_tracking AS tr
				WHERE tr.car_id=(SELECT tracker_id FROM vh_st) AND tr.gps_valid = 1
				ORDER BY tr.period DESC
				LIMIT (const_deviation_for_reroute_val()->>'points_cnt')::int
			)
			
			SELECT
				CASE
					WHEN (SELECT route_geom FROM cashe_data) IS NOT NULL THEN
						--last X points belongs to route?
						(SELECT
							bool_and(sub.pt_on_route) AS veh_on_route
						FROM (
							SELECT 
								ST_Intersects(
									(SELECT route_geom FROM cashe_data)
									,veh_last_points.pt_geom
								) AS pt_on_route
							FROM veh_last_points
						) AS sub
						)
					ELSE NULL
				END AS veh_on_route
				
				,(SELECT shipment_id FROM vh_st) AS shipment_id
				,(SELECT tracker_id FROM vh_st) AS tracker_id
				
				,(SELECT
					CASE WHEN cashe_data.route_geom IS NULL THEN NULL
					ELSE
						ST_AsText(ST_LineSubstring(
							cashe_data.route_geom
							,ST_LineLocatePoint(
								cashe_data.route_geom,
								ST_ClosestPoint(
								 	cashe_data.route_geom,
								 	ST_GeomFromText('POINT('|| (SELECT lon FROM veh_last_points ORDER BY period DESC LIMIT 1) ||' '|| (SELECT lat FROM veh_last_points ORDER BY period DESC LIMIT 1) ||')', 4326)
								)							 
							)
							,1
						))
					END	
				FROM cashe_data
				) AS route_rest
				
				,(SELECT route_geom_len FROM cashe_data) AS route_rest_len
				,(SELECT state FROM vh_st) AS cur_state
				,(SELECT out_of_work FROM zone_data) AS out_of_work
				,(SELECT id FROM zone_data) AS zone_id
				
				,CASE WHEN (SELECT state FROM vh_st) = 'left_for_base' THEN (SELECT near_road_lon FROM zone_data)
				ELSE (SELECT coalesce( (SELECT lon FROM client_zone), (SELECT near_road_lon FROM zone_data) ) )
				END AS zone_near_road_lon
				
				,CASE WHEN (SELECT state FROM vh_st) = 'left_for_base' THEN (SELECT near_road_lat FROM zone_data)
				ELSE (SELECT coalesce( (SELECT lat FROM client_zone), (SELECT near_road_lat FROM zone_data) ) )
				END AS zone_near_road_lat
				
				,(SELECT zone_center_str FROM zone_data) AS zone_center_str
				,(SELECT 
					json_agg(
						json_build_object(
							'lon',veh_last_points.lon
							,'lat',veh_last_points.lat
						)
					) AS pos
				FROM veh_last_points	
				) AS cur_pos"
			,$vehicleId
		));
		$route = NULL;
//file_put_contents(OUTPUT_PATH.'veh_route.txt',var_export($cashe_ar,TRUE));
		// Есть случаи когда остался left_for_base а по факту уже поехал по своим делам,
		// так что в этом случае как то по времени прекращать отслеживание		
		// out_of_work=TRUE
		if(is_array($cashe_ar) && count($cashe_ar) && (!isset($cashe_ar['route_rest']) || $cashe_ar['veh_on_route']!='t') && $cashe_ar['out_of_work']!='t'){
			//reroute 
			$osrm = new OSRMV5(OSRM_PROTOCOLE,OSRM_HOST,OSRM_PORT);

			$route_points = array();
			//former track of other vehicles from base to object
			/*if(!isset($cashe_ar['route_rest']) && ($cashe_ar['cur_state'] == 'busy'||$cashe_ar['cur_state'] == 'assigned'||$cashe_ar['cur_state'] == 'at_dest') ){
			throw new Exception('ID='.$cashe_ar['zone_id']);
				$former_route_id = $dbLink->query(sprintf(
				//throw new Exception(sprintf(
					"WITH
					veh_data AS (
						SELECT
							sched.vehicle_id
							,(SELECT
								st2.date_time
							FROM vehicle_schedule_states AS st2
							WHERE st2.schedule_id = st.schedule_id AND st2.state='busy'
							ORDER BY st2.date_time DESC
							LIMIT 1
							) AS date_from
							,st.date_time AS date_to
							,st.tracker_id
						FROM vehicle_schedule_states AS st
						LEFT JOIN vehicle_schedules AS sched ON sched.id = st.schedule_id
						WHERE st.destination_id=%d AND st.state='at_dest' AND coalesce(st.tracker_id,'')<>''
						ORDER BY st.date_time DESC
						LIMIT 1
					)
					SELECT
						lon,lat
					FROM car_tracking
					WHERE car_id=(SELECT tracker_id FROM veh_data) AND speed>0
						AND period+'5 hours'>=(SELECT date_from FROM veh_data)
						AND period+'5 hours'<(SELECT date_to FROM veh_data)
					ORDER BY period
					LIMIT 1000"			
				,$cashe_ar['zone_id']
				));
				
				while($former_route_ar = $dbLink->fetch_array($former_route_id)){
					array_push($route_points, $former_route_ar['lon'].','.$former_route_ar['lat']);
				}
				
				if(count($route_points)){
					try{
						$osrm_route = $osrm->matchRoute(
							$route_points
							,'driving'
							,array("geometries=polyline","overview=full","tidy=true")									
						);
						//overview = simplified (default), full, false
						//tidy: true/false
						//radius miters
						if (!$osrm_route->matchings || !count($osrm_route->matchings) || !$osrm_route->matchings[count($osrm_route->matchings)-1]->geometry){
							throw new Exception(self::ER_OSRM_ROUTE_QUERY);
						}
						$osrm_route_geom = $osrm_route->matchings[count($osrm_route->matchings)-1]->geometry;					
					}catch(Exception $e){
					
					}
				}
				
			}
			*/

			if(!isset($osrm_route)){			
				//get near road coords
//throw new Exception($cashe_ar['zone_near_road_lon']);
				if(!isset($cashe_ar['zone_near_road_lon']) || !isset($cashe_ar['zone_near_road_lat'])
				||$cashe_ar['zone_near_road_lon']==0
				||$cashe_ar['zone_near_road_lat']==0){
					//no near road, make it from szone center
					$z_coords = explode(' ',$cashe_ar['zone_center_str']);
					if(count($z_coords)==2){
						$lat_pos = str_replace(',','.',$z_coords[1]);
						$lon_pos = str_replace(',','.',$z_coords[0]);
						
						$cashe_ar['zone_near_road_lon'] = NULL;
						$cashe_ar['zone_near_road_lat'] = NULL;
						$osrm->getNearestRoadCoord(
							$lat_pos, $lon_pos,
							$cashe_ar['zone_near_road_lat'],$cashe_ar['zone_near_road_lon']
						);
						$dbLink->query(sprintf(
							"UPDATE destinations
							SET
								near_road_lon=%f
								,near_road_lat=%f
							WHERE id=%d"
							,$cashe_ar['zone_near_road_lon']
							,$cashe_ar['zone_near_road_lat']
							,$cashe_ar['zone_id']
						));
					}
				}
				$cur_pos = json_decode($cashe_ar['cur_pos']);
				if(is_array($cur_pos) && count($cur_pos)
				 &&isset($cashe_ar['zone_near_road_lon'])  && isset($cashe_ar['zone_near_road_lat'])
				){
					array_push($route_points, str_replace(',','.',$cur_pos[0]->lon).','.str_replace(',','.',$cur_pos[0]->lat));
					array_push($route_points, str_replace(',','.',$cashe_ar['zone_near_road_lon']).','.str_replace(',','.',$cashe_ar['zone_near_road_lat']));
				}
				
				if(count($route_points)){
					$osrm_route = $osrm->getRoute(
						$route_points
						,'json'
						,'driving'
						,array("geometries=polyline")
						//,"generate_hints=false"
					);
					
					if (!$osrm_route->routes || !count($osrm_route->routes) || !$osrm_route->routes[count($osrm_route->routes)-1]->geometry){
						throw new Exception(self::ER_OSRM_ROUTE_QUERY);
					}
					$route_cnt = count($osrm_route->routes);
					$osrm_route_geom = $osrm_route->routes[$route_cnt-1]->geometry;
				}
			}
				
			//routing
			if(isset($osrm_route)){
				
				//$route = $osrm_route->routes[0]->geometry;
				
				$route_for_db = "'".json_encode($osrm_route)."'";
				try{
					$osrm_route_geom = self::matchRouteToRoad($osrm, $osrm_route_geom);
				}catch(Exception $e){				
					error_log($e->getMessage());
				}
				//route to cashe
				$route_ar = $dbLink->query_first(sprintf(
					"INSERT INTO vehicle_route_cashe
					(tracker_id, shipment_id,vehicle_state,update_dt,route,route_line)
					values ('%s',%d,'%s',now(),%s,ST_LineFromEncodedPolyline('%s'))
					ON CONFLICT (tracker_id, shipment_id,vehicle_state) DO UPDATE SET
						update_dt = now()
						,route = %s
						,route_line = ST_LineFromEncodedPolyline('%s')
					RETURNING
						ST_AsText(ST_LineFromEncodedPolyline('%s')) AS route_rest
						,ST_Length(ST_Transform(ST_LineFromEncodedPolyline('%s'),3857)) AS route_rest_len"
					,$cashe_ar['tracker_id']
					,$cashe_ar['shipment_id']
					//$cashe_ar['cur_state']=='at_dest'||
					,($cashe_ar['cur_state']=='left_for_base')? 'left_for_base':'left_for_dest'
					,$route_for_db
					,$osrm_route_geom
					,$route_for_db
					,$osrm_route_geom
					,$osrm_route_geom
					,$osrm_route_geom
				));
				
				if(is_array($route_ar) && count($route_ar) && isset($route_ar['route_rest'])){
					$route = $route_ar['route_rest'];
					$routeRestLen = $cashe_ar['route_rest_len'];
				}
			}
		}
		// && $cashe_ar['cur_state'] != 'at_dest'
		else if (is_array($cashe_ar) && count($cashe_ar) && $cashe_ar['cur_state'] != 'free'){
			$route = $cashe_ar['route_rest'];
			$routeRestLen = $cashe_ar['route_rest_len'];
		}
		
		if($route){
			$route = str_replace('LINESTRING(','',$route);
			$route = str_replace('MULTI(','',$route);
			$route = str_replace('GEOMETRYCOLLECTION(','',$route);
			$route = str_replace('(','',$route);
			$route = str_replace(')','',$route);
		}
		return $route;
	}
}

?>
