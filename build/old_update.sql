
-- ******************* update 21/04/2021 12:00:16 ******************

		ALTER TABLE public.main_menus ADD COLUMN model_content xml;



-- ******************* update 21/04/2021 16:12:39 ******************
/*DROP FUNCTION const_base_geo_zone_set_val(Int);
DROP FUNCTION const_base_geo_zone_val() CASCADE;

DROP TABLE const_base_geo_zone;
	-- ********** constant value table  base_geo_zone *************
	CREATE TABLE IF NOT EXISTS const_base_geo_zone
	(name text, descr text, val jsonb,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json);
	ALTER TABLE const_base_geo_zone OWNER TO beton;
	INSERT INTO const_base_geo_zone (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Зона завода'
		,''
		,'{"keys" : {"id" : 152}, "descr" : "БАЗА", "dataType" : "destinations"}'
		,'JSONB'
		,'DestinationEdit'
		,NULL
		,NULL
		,NULL
	);
*/	
		--constant get value
	CREATE OR REPLACE FUNCTION const_base_geo_zone_val()
	RETURNS jsonb AS
	$BODY$
		SELECT val FROM const_base_geo_zone LIMIT 1;
	$BODY$
	LANGUAGE sql STABLE COST 100;
	
	ALTER FUNCTION const_base_geo_zone_val() OWNER TO beton;
	--constant set value
	CREATE OR REPLACE FUNCTION const_base_geo_zone_set_val(JSONB)
	RETURNS void AS
	$BODY$
		UPDATE const_base_geo_zone SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;
	ALTER FUNCTION const_base_geo_zone_set_val(JSONB) OWNER TO beton;
	
	/*
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_base_geo_zone_view AS
	SELECT
		'base_geo_zone'::text AS id
		,t.name
		,t.descr
	,const_base_geo_zone_val()::text AS val
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_base_geo_zone AS t
	;
	
	
	ALTER VIEW const_base_geo_zone_view OWNER TO beton;
	
	CREATE OR REPLACE VIEW constants_list_view AS
	SELECT *
	FROM const_doc_per_page_count_view
	UNION ALL
	SELECT *
	FROM const_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_order_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_backup_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_id_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_view
	UNION ALL
	SELECT *
	FROM const_chart_step_min_view
	UNION ALL
	SELECT *
	FROM const_day_shift_length_view
	UNION ALL
	SELECT *
	FROM const_days_allowed_with_broken_tracker_view
	UNION ALL
	SELECT *
	FROM const_def_order_unload_speed_view
	UNION ALL
	SELECT *
	FROM const_demurrage_coast_per_hour_view
	UNION ALL
	SELECT *
	FROM const_first_shift_start_time_view
	UNION ALL
	SELECT *
	FROM const_geo_zone_check_points_count_view
	UNION ALL
	SELECT *
	FROM const_map_default_lat_view
	UNION ALL
	SELECT *
	FROM const_map_default_lon_view
	UNION ALL
	SELECT *
	FROM const_max_hour_load_view
	UNION ALL
	SELECT *
	FROM const_max_vehicle_at_work_view
	UNION ALL
	SELECT *
	FROM const_min_demurrage_time_view
	UNION ALL
	SELECT *
	FROM const_min_quant_for_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_no_tracker_signal_warn_interval_view
	UNION ALL
	SELECT *
	FROM const_ord_mark_if_no_ship_time_view
	UNION ALL
	SELECT *
	FROM const_order_auto_place_tolerance_view
	UNION ALL
	SELECT *
	FROM const_order_step_min_view
	UNION ALL
	SELECT *
	FROM const_own_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_raw_mater_plcons_rep_def_days_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_id_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_view
	UNION ALL
	SELECT *
	FROM const_shift_for_orders_length_time_view
	UNION ALL
	SELECT *
	FROM const_shift_length_time_view
	UNION ALL
	SELECT *
	FROM const_ship_coast_for_self_ship_destination_view
	UNION ALL
	SELECT *
	FROM const_speed_change_for_order_autolocate_view
	UNION ALL
	SELECT *
	FROM const_vehicle_unload_time_view
	UNION ALL
	SELECT *
	FROM const_avg_mat_cons_dev_day_count_view
	UNION ALL
	SELECT *
	FROM const_days_for_plan_procur_view
	UNION ALL
	SELECT *
	FROM const_lab_min_sample_count_view
	UNION ALL
	SELECT *
	FROM const_lab_days_for_avg_view
	UNION ALL
	SELECT *
	FROM const_city_ext_view
	UNION ALL
	SELECT *
	FROM const_def_lang_view
	UNION ALL
	SELECT *
	FROM const_efficiency_warn_k_view
	UNION ALL
	SELECT *
	FROM const_zone_violation_alarm_interval_view
	UNION ALL
	SELECT *
	FROM const_weather_update_interval_sec_view
	UNION ALL
	SELECT *
	FROM const_call_history_count_view
	UNION ALL
	SELECT *
	FROM const_water_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_from_day_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_to_day_view
	UNION ALL
	SELECT *
	FROM const_show_time_for_shipped_vehicles_view
	UNION ALL
	SELECT *
	FROM const_tracker_malfunction_tel_list_view
	UNION ALL
	SELECT *
	FROM const_low_efficiency_tel_list_view
	UNION ALL
	SELECT *
	FROM const_material_closed_balance_date_view
	UNION ALL
	SELECT *
	FROM const_cement_material_view
	UNION ALL
	SELECT *
	FROM const_deviation_for_reroute_view;
	ALTER VIEW constants_list_view OWNER TO beton;
*/


-- ******************* update 21/04/2021 16:12:50 ******************
/*DROP FUNCTION const_base_geo_zone_set_val(Int);
DROP FUNCTION const_base_geo_zone_val() CASCADE;

DROP TABLE const_base_geo_zone;
	-- ********** constant value table  base_geo_zone *************
	CREATE TABLE IF NOT EXISTS const_base_geo_zone
	(name text, descr text, val jsonb,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json);
	ALTER TABLE const_base_geo_zone OWNER TO beton;
	INSERT INTO const_base_geo_zone (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Зона завода'
		,''
		,'{"keys" : {"id" : 152}, "descr" : "БАЗА", "dataType" : "destinations"}'
		,'JSONB'
		,'DestinationEdit'
		,NULL
		,NULL
		,NULL
	);
*/
/*	
		--constant get value
	CREATE OR REPLACE FUNCTION const_base_geo_zone_val()
	RETURNS jsonb AS
	$BODY$
		SELECT val FROM const_base_geo_zone LIMIT 1;
	$BODY$
	LANGUAGE sql STABLE COST 100;
	
	ALTER FUNCTION const_base_geo_zone_val() OWNER TO beton;
	--constant set value
	CREATE OR REPLACE FUNCTION const_base_geo_zone_set_val(JSONB)
	RETURNS void AS
	$BODY$
		UPDATE const_base_geo_zone SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;
	ALTER FUNCTION const_base_geo_zone_set_val(JSONB) OWNER TO beton;
	*/
	
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_base_geo_zone_view AS
	SELECT
		'base_geo_zone'::text AS id
		,t.name
		,t.descr
	,const_base_geo_zone_val()::text AS val
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_base_geo_zone AS t
	;
	
	
	ALTER VIEW const_base_geo_zone_view OWNER TO beton;
	
	CREATE OR REPLACE VIEW constants_list_view AS
	SELECT *
	FROM const_doc_per_page_count_view
	UNION ALL
	SELECT *
	FROM const_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_order_grid_refresh_interval_view
	UNION ALL
	SELECT *
	FROM const_backup_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_id_view
	UNION ALL
	SELECT *
	FROM const_base_geo_zone_view
	UNION ALL
	SELECT *
	FROM const_chart_step_min_view
	UNION ALL
	SELECT *
	FROM const_day_shift_length_view
	UNION ALL
	SELECT *
	FROM const_days_allowed_with_broken_tracker_view
	UNION ALL
	SELECT *
	FROM const_def_order_unload_speed_view
	UNION ALL
	SELECT *
	FROM const_demurrage_coast_per_hour_view
	UNION ALL
	SELECT *
	FROM const_first_shift_start_time_view
	UNION ALL
	SELECT *
	FROM const_geo_zone_check_points_count_view
	UNION ALL
	SELECT *
	FROM const_map_default_lat_view
	UNION ALL
	SELECT *
	FROM const_map_default_lon_view
	UNION ALL
	SELECT *
	FROM const_max_hour_load_view
	UNION ALL
	SELECT *
	FROM const_max_vehicle_at_work_view
	UNION ALL
	SELECT *
	FROM const_min_demurrage_time_view
	UNION ALL
	SELECT *
	FROM const_min_quant_for_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_no_tracker_signal_warn_interval_view
	UNION ALL
	SELECT *
	FROM const_ord_mark_if_no_ship_time_view
	UNION ALL
	SELECT *
	FROM const_order_auto_place_tolerance_view
	UNION ALL
	SELECT *
	FROM const_order_step_min_view
	UNION ALL
	SELECT *
	FROM const_own_vehicles_feature_view
	UNION ALL
	SELECT *
	FROM const_raw_mater_plcons_rep_def_days_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_id_view
	UNION ALL
	SELECT *
	FROM const_self_ship_dest_view
	UNION ALL
	SELECT *
	FROM const_shift_for_orders_length_time_view
	UNION ALL
	SELECT *
	FROM const_shift_length_time_view
	UNION ALL
	SELECT *
	FROM const_ship_coast_for_self_ship_destination_view
	UNION ALL
	SELECT *
	FROM const_speed_change_for_order_autolocate_view
	UNION ALL
	SELECT *
	FROM const_vehicle_unload_time_view
	UNION ALL
	SELECT *
	FROM const_avg_mat_cons_dev_day_count_view
	UNION ALL
	SELECT *
	FROM const_days_for_plan_procur_view
	UNION ALL
	SELECT *
	FROM const_lab_min_sample_count_view
	UNION ALL
	SELECT *
	FROM const_lab_days_for_avg_view
	UNION ALL
	SELECT *
	FROM const_city_ext_view
	UNION ALL
	SELECT *
	FROM const_def_lang_view
	UNION ALL
	SELECT *
	FROM const_efficiency_warn_k_view
	UNION ALL
	SELECT *
	FROM const_zone_violation_alarm_interval_view
	UNION ALL
	SELECT *
	FROM const_weather_update_interval_sec_view
	UNION ALL
	SELECT *
	FROM const_call_history_count_view
	UNION ALL
	SELECT *
	FROM const_water_ship_cost_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_from_day_view
	UNION ALL
	SELECT *
	FROM const_vehicle_owner_accord_to_day_view
	UNION ALL
	SELECT *
	FROM const_show_time_for_shipped_vehicles_view
	UNION ALL
	SELECT *
	FROM const_tracker_malfunction_tel_list_view
	UNION ALL
	SELECT *
	FROM const_low_efficiency_tel_list_view
	UNION ALL
	SELECT *
	FROM const_material_closed_balance_date_view
	UNION ALL
	SELECT *
	FROM const_cement_material_view
	UNION ALL
	SELECT *
	FROM const_deviation_for_reroute_view;
	ALTER VIEW constants_list_view OWNER TO beton;



-- ******************* update 27/04/2021 09:05:56 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=false AND v_point_in_zone=false) THEN
			v_true_point = true;
		ELSE
			v_true_point = false;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = false;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--RAISE EXCEPTION 'v_lon_min=%,v_lon_max=%,v_lat_min=%,v_lat_max=%',v_lon_min,v_lon_max,v_lat_min,v_lat_max;
				--RAISE EXCEPTION 'v_car_rec.lon=%,v_car_rec.lat=%',v_car_rec.lon,v_car_rec.lat;
				
				--v_point_in_zone = (v_car_rec.lon>=v_lon_min) AND (v_car_rec.lon<=v_lon_max) AND (v_car_rec.lat>=v_lat_min) AND (v_car_rec.lat<=v_lat_max);
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=false AND v_point_in_zone=false);
				--RAISE EXCEPTION 'v_point_in_zone=%',v_point_in_zone;
				IF v_true_point = false THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
			INTO
				v_cashe_route
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			v_point_in_zone = FALSE;
			
			IF v_cashe_route IS NOT NULL THEN
				--If state is busy and current point is inside base zone, then skeep all farther checkings!
				IF v_cur_state='busy'::vehicle_states THEN
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
				END IF;
				
				IF v_point_in_zone = FALSE THEN
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
				
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;
					
					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route	
						-- send route from current point to the end with notification
						--Не работает такое ST_AsEncodedPolyline()
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
					END IF;
				END IF;	
			END IF;
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 27/04/2021 09:17:35 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=false AND v_point_in_zone=false) THEN
			v_true_point = true;
		ELSE
			v_true_point = false;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = false;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--RAISE EXCEPTION 'v_lon_min=%,v_lon_max=%,v_lat_min=%,v_lat_max=%',v_lon_min,v_lon_max,v_lat_min,v_lat_max;
				--RAISE EXCEPTION 'v_car_rec.lon=%,v_car_rec.lat=%',v_car_rec.lon,v_car_rec.lat;
				
				--v_point_in_zone = (v_car_rec.lon>=v_lon_min) AND (v_car_rec.lon<=v_lon_max) AND (v_car_rec.lat>=v_lat_min) AND (v_car_rec.lat<=v_lat_max);
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=false AND v_point_in_zone=false);
				--RAISE EXCEPTION 'v_point_in_zone=%',v_point_in_zone;
				IF v_true_point = false THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					--Конец маршрута для клиента
					PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
			INTO
				v_cashe_route
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			v_point_in_zone = FALSE;
			
			IF v_cashe_route IS NOT NULL THEN
				--If state is busy and current point is inside base zone, then skeep all farther checkings!
				IF v_cur_state='busy'::vehicle_states THEN
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
				END IF;
				
				IF v_point_in_zone = FALSE THEN
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
				
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;
					
					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route	
						-- send route from current point to the end with notification
						--Не работает такое ST_AsEncodedPolyline()
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
					END IF;
				END IF;	
			END IF;
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 27/04/2021 10:46:24 ******************

		ALTER TABLE public.ast_calls ADD COLUMN record_link text;



-- ******************* update 27/04/2021 11:33:33 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=false AND v_point_in_zone=false) THEN
			v_true_point = true;
		ELSE
			v_true_point = false;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = false;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--RAISE EXCEPTION 'v_lon_min=%,v_lon_max=%,v_lat_min=%,v_lat_max=%',v_lon_min,v_lon_max,v_lat_min,v_lat_max;
				--RAISE EXCEPTION 'v_car_rec.lon=%,v_car_rec.lat=%',v_car_rec.lon,v_car_rec.lat;
				
				--v_point_in_zone = (v_car_rec.lon>=v_lon_min) AND (v_car_rec.lon<=v_lon_max) AND (v_car_rec.lat>=v_lat_min) AND (v_car_rec.lat<=v_lat_max);
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=false AND v_point_in_zone=false);
				--RAISE EXCEPTION 'v_point_in_zone=%',v_point_in_zone;
				IF v_true_point = false THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					--Конец маршрута для клиента
					PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
			INTO
				v_cashe_route
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			v_point_in_zone = FALSE;
			
			IF v_cashe_route IS NOT NULL THEN
				--If state is busy and current point is inside base zone, then skeep all farther checkings!
				IF v_cur_state='busy'::vehicle_states THEN
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
				END IF;
				
				IF v_point_in_zone = FALSE THEN
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
				
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;
					
					IF coalesce(veh_not_on_route,FALSE)=TRUE
					 AND v_cur_state<>'at_dest'::vehicle_states THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route	
						-- send route from current point to the end with notification
						--Не работает такое ST_AsEncodedPolyline()
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
					END IF;
				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 27/04/2021 14:06:46 ******************

		ALTER TABLE public.users ADD COLUMN domru_user_name  varchar(80);



-- ******************* update 27/04/2021 14:16:42 ******************
		ALTER TABLE public.ast_calls ADD COLUMN call_status text;



-- ******************* update 27/04/2021 14:30:52 ******************
-- Trigger: ast_calls_trigger_before

-- DROP TRIGGER ast_calls_trigger_before ON public.ast_calls;

CREATE TRIGGER ast_calls1_trigger_before
    BEFORE INSERT OR UPDATE 
    ON public.ast_calls1
    FOR EACH ROW
    EXECUTE PROCEDURE public.ast_calls_process();


-- ******************* update 27/04/2021 17:21:10 ******************
-- Function: ast_calls_process()

-- DROP FUNCTION ast_calls_process();

CREATE OR REPLACE FUNCTION ast_calls_process()
  RETURNS trigger AS
$BODY$
DECLARE
	v_search text;
	v_client_repres_name text;
	v_client_repres_post text;
	v_client_name text;
	v_tel_formatted text;
	v_event_id text;
BEGIN
	IF (TG_OP='INSERT') THEN
		NEW.dt = now()::timestamp;
		
		--********* Client ********************
		IF NEW.call_type='in'::call_types THEN			
			IF substring(NEW.caller_id_num from 1 for 2)='+7' THEN
				NEW.caller_id_num = substring(NEW.caller_id_num from 3);
			END IF;
			v_search = NEW.caller_id_num;
		ELSE
			v_search = NEW.ext;
			IF (char_length(v_search)>3 AND char_length(v_search)<10) THEN
				v_search = const_city_ext_val()::text||v_search;
			END IF;
			
		END IF;

		IF (char_length(v_search)>3) THEN
			--!!! v_search = format_cel_phone(RIGHT(v_search,10));
				
			v_tel_formatted = format_cel_phone(RIGHT(v_search,10));
			SELECT
				client_tels.client_id,
				client_tels.name,
				client_tels.post,
				cl.name_full
			INTO
				NEW.client_id,
				v_client_repres_name,
				v_client_repres_post,
				v_client_name
			FROM client_tels
			LEFT JOIN ast_calls ON ast_calls.client_id=client_tels.client_id
			LEFT JOIN clients AS cl ON ast_calls.client_id=cl.id
			WHERE client_tels.tel=v_search OR client_tels.tel=v_tel_formatted
			ORDER BY ast_calls.dt DESC NULLS LAST
			LIMIT 1;
			
			NEW.client_tel = v_search;
			
			--In call for all notification
			IF NEW.call_type='in'::call_types
			AND NEW.end_time IS NULL
			THEN
				IF NEW.ext IS NOT NULL AND LENGTH(NEW.ext)>3 THEN
					v_event_id = 'AstCall.in_call';
				ELSIF NEW.ext IS NOT NULL THEN
					--extension exists!
					v_event_id = 'AstCall.in_call.'||NEW.ext;
				END IF;	
				
				IF v_event_id IS NOT NULL THEN
					PERFORM pg_notify(
						v_event_id
						,json_build_object(
							'params',json_build_object(
								'client_id',NEW.client_id
								,'client_name',v_client_name
								,'tel',v_tel_formatted
								,'client_repres_name',v_client_repres_name
								,'client_repres_post',v_client_repres_post
								,'ext',NEW.ext
								,'unique_id',NEW.unique_id
							)
						)::text
					);
				END IF;
			END IF;			
			
		END IF;
		--********* Client ********************
		
		--grid notification
		PERFORM pg_notify('AstCall.insert', NULL);
		
		
	ELSIF (TG_OP='UPDATE') THEN
		--****** User ****************
		IF NEW.call_type='in'::call_types THEN
			IF substring(NEW.caller_id_num from 1 for 2)='+7' THEN
				NEW.caller_id_num = substring(NEW.caller_id_num from 3);
			END IF;
		
			IF NEW.client_id IS NULL AND OLD.client_id IS NULL THEN
				v_search = NEW.caller_id_num;
				
				IF (char_length(v_search)>3) THEN
					v_tel_formatted = format_cel_phone(RIGHT(v_search,10));
				
					SELECT
						client_tels.client_id,
						client_tels.name,
						client_tels.post,
						cl.name_full
					INTO
						NEW.client_id,
						v_client_repres_name,
						v_client_repres_post,
						v_client_name
					FROM client_tels
					LEFT JOIN ast_calls ON ast_calls.client_id=client_tels.client_id
					LEFT JOIN clients AS cl ON ast_calls.client_id=cl.id
					WHERE client_tels.tel=v_search OR client_tels.tel=v_tel_formatted
					ORDER BY ast_calls.dt DESC NULLS LAST
					LIMIT 1;
					
					IF NEW.ext IS NOT NULL AND LENGTH(NEW.ext)>3 THEN
						v_event_id = 'AstCall.in_call';
					ELSIF NEW.ext IS NOT NULL THEN
						--extension exists!
						v_event_id = 'AstCall.in_call.'||NEW.ext;
					END IF;	
					
					IF v_event_id IS NOT NULL THEN
						PERFORM pg_notify(
							v_event_id
							,json_build_object(
								'params',json_build_object(
									'client_id',NEW.client_id
									,'client_name',v_client_name
									,'tel',v_tel_formatted
									,'client_repres_name',v_client_repres_name
									,'client_repres_post',v_client_repres_post
									,'ext',NEW.ext
									,'unique_id',NEW.unique_id
								)
							)::text
						);
					END IF;
					
				END IF;
				
			END IF;
		
			--notifications
			IF NEW.end_time IS NOT NULL AND OLD.end_time IS NULL AND NEW.ext IS NOT NULL AND LENGTH(NEW.ext)=3 THEN
				PERFORM pg_notify(
					'AstCall.hangup.'||NEW.ext
					,NULL
				);
				PERFORM pg_notify(
					'AstCall.hangup.'||NEW.unique_id
					,NULL
				);
				
			ELSIF NEW.end_time IS NULL AND OLD.start_time IS NULL AND NEW.start_time IS NOT NULL
			 AND NEW.ext IS NOT NULL AND LENGTH(NEW.ext)=3 THEN
				PERFORM pg_notify(
					'AstCall.pickup.'||NEW.ext
					,NULL
				);
				PERFORM pg_notify(
					'AstCall.pickup.'||NEW.unique_id
					,NULL
				);
				
			END IF;
			
		
			v_search = NEW.ext;
		ELSE		
			v_search = NEW.caller_id_num;
		END IF;

		--setting user from logged in
		SELECT
			u.id
		INTO
			NEW.user_id
		FROM users AS u
		WHERE u.tel_ext=v_search
		AND (
			SELECT TRUE
			FROM logins
			WHERE user_id=u.id and date_time_out IS NULL
			ORDER BY date_time_in desc LIMIT 1
		)
		LIMIT 1;
		
		
		--************ USER TO ***************
		/*
		IF NEW.call_type='out'::call_types
		AND char_length(NEW.ext)<=3 THEN
			--Внутренний номер
			NEW.user_id_to = (SELECT id
					FROM users
				WHERE tel_ext=NEW.ext
			);
			
		END IF;
		*/
		
		--grid notification
		PERFORM pg_notify('AstCall.update', NULL);
		
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ast_calls_process()
  OWNER TO beton;



-- ******************* update 03/05/2021 13:00:22 ******************
-- Function: logins_process()

-- DROP FUNCTION logins_process();

CREATE OR REPLACE FUNCTION logins_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF OLD.date_time_out IS NULL AND NEW.date_time_out IS NOT NULL THEN		
			--event
			RAISE EXCEPTION 'pub_key=%',trim(NEW.pub_key);
			PERFORM pg_notify(
				'User.logout'
				,json_build_object(
					'params',json_build_object(
						'pub_key',trim(NEW.pub_key)
					)
				)::text
			);
			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION logins_process()
  OWNER TO beton;



-- ******************* update 03/05/2021 13:00:38 ******************
-- Function: logins_process()

-- DROP FUNCTION logins_process();

CREATE OR REPLACE FUNCTION logins_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF OLD.date_time_out IS NULL AND NEW.date_time_out IS NOT NULL THEN		
			--event
			--RAISE EXCEPTION 'pub_key=%',trim(NEW.pub_key);
			PERFORM pg_notify(
				'User.logout'
				,json_build_object(
					'params',json_build_object(
						'pub_key',trim(NEW.pub_key)
					)
				)::text
			);
			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION logins_process()
  OWNER TO beton;



-- ******************* update 05/05/2021 07:39:31 ******************

	-- ********** Adding new table from model **********
	CREATE TABLE public.client_destinations
	(client_id int NOT NULL REFERENCES clients(id),destination_id int NOT NULL REFERENCES destinations(id),lon  numeric(15,12),lat  numeric(15,12),CONSTRAINT client_destinations_pkey PRIMARY KEY (client_id,destination_id)
	);
	ALTER TABLE public.client_destinations OWNER TO beton;



-- ******************* update 05/05/2021 09:00:30 ******************

		ALTER TABLE public.vehicle_route_cashe ADD COLUMN client_route_done bool DEFAULT FALSE;



-- ******************* update 05/05/2021 09:51:39 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
						AND (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
							> (now() - '00:10:00'::interval)
						
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;

						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF v_point_in_zone = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
					END IF;
					
				END IF;
				
				IF v_point_in_zone = FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 09:58:40 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;

						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF v_point_in_zone = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
					END IF;
					
				END IF;
				
				IF v_point_in_zone = FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:00:56 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;

						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF v_point_in_zone = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
					END IF;
					
				END IF;
				
				IF v_point_in_zone = FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:07:19 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;

						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF v_point_in_zone = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
					END IF;
					
				END IF;
				
				IF v_point_in_zone = FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:14:35 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;

						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:15:52 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:16:26 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:25:14 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			IF NEW.car_id = '4003985644' THEN
				RAISE NOTICE '4003985644';
			END IF;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:27:17 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			IF NEW.car_id = '4003985644' THEN
				RAISE WARNING '4003985644';
			END IF;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:28:10 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING 'v_cur_state=%',v_cur_state;
				END IF;
				
			
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:40:47 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING 'v_cur_state=%, v_cashe_route IS NOT NULL=%',v_cur_state,v_cashe_route IS NOT NULL;
				END IF;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
			
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:44:08 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING 'v_cur_state=%, v_cashe_route IS NOT NULL=%,v_client_route_done=%',v_cur_state,v_cashe_route IS NOT NULL,v_client_route_done;
				END IF;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
			
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:45:26 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING 'v_cur_state=%, v_cashe_route IS NOT NULL=%,v_client_route_done=%',v_cur_state,v_cashe_route IS NOT NULL,v_client_route_done;
				END IF;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING '4003985644';
				END IF;
			
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:45:56 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING 'v_cur_state=%, v_cashe_route IS NOT NULL=%,v_client_route_done=%',v_cur_state,v_cashe_route IS NOT NULL,v_client_route_done;
				END IF;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING '4003985644';
				END IF;
			
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.shipment_id=v_shipment_id;
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:47:58 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING 'v_cur_state=%, v_cashe_route IS NOT NULL=%,v_client_route_done=%',v_cur_state,v_cashe_route IS NOT NULL,v_client_route_done;
				END IF;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				IF NEW.car_id = '4003985644' THEN
					RAISE WARNING '4003985644';
				END IF;
			
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:48:13 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_d.lon::text||' '||cl_d.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:54:29 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id FROM orders AS o WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE csh.shipment_id = v_shipment_id
							AND csh.vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND csh.tracker_id = NEW.car_id;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 10:58:45 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 12:22:03 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
				IF NEW.car_id='3033549689' THEN
					RAISE WARNING 'v_client_route_done=%,v_destination_id=%,v_client_id=%',v_client_route_done,v_destination_id,v_client_id;
				END IF;
				
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 12:25:09 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

				IF NEW.car_id='3033549689' THEN
					RAISE WARNING 'v_client_route_done=%,v_destination_id=%,v_client_id=%',v_client_route_done,v_destination_id,v_client_id;
				END IF;
				
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 12:43:05 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

				/*IF NEW.car_id='3033549689' THEN
					RAISE WARNING 'v_client_route_done=%,v_destination_id=%,v_client_id=%',v_client_route_done,v_destination_id,v_client_id;
				END IF;
				*/
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 12:50:48 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					/*IF NEW.car_id='3033549689' THEN
						RAISE WARNING 'v_client_route_done=%,v_destination_id=%,v_client_id=%',v_client_route_done,v_destination_id,v_client_id;
					END IF;
					*/
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 05/05/2021 12:53:29 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					/*IF NEW.car_id='3033549689' THEN
						RAISE WARNING 'v_client_route_done=%,v_destination_id=%,v_client_id=%',v_client_route_done,v_destination_id,v_client_id;
					END IF;
					*/
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:05:53 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					/*IF NEW.car_id='3033549689' THEN
						RAISE WARNING 'v_client_route_done=%,v_destination_id=%,v_client_id=%',v_client_route_done,v_destination_id,v_client_id;
					END IF;
					*/
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:15:31 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE WARNING 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:21:54 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE EXCEPTION 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:25:29 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN
		IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'FOUND';
		END IF;
		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE EXCEPTION 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:26:07 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
		IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'FOUND 2';
		END IF;
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE EXCEPTION 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:26:30 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_client_route_done=%',v_client_route_done;
		END IF;
			
			IF v_cashe_route IS NOT NULL AND v_client_route_done = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE EXCEPTION 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:27:13 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_client_route_done=%',v_client_route_done;
		END IF;
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE EXCEPTION 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:27:22 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_cashe_route=%',v_cashe_route;
		END IF;
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE EXCEPTION 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:27:41 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%',v_shipment_id;
		END IF;
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE EXCEPTION 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:29:22 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

					IF NEW.car_id='1026605398' THEN
						RAISE EXCEPTION 'v_client_route_done=%,v_destination_id=%,v_client_id=%',
							v_client_route_done,v_destination_id,v_client_id;
					END IF;
					
					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										WHEN v_cur_state='at_dest' OR v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 06/05/2021 13:31:54 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);

						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						--PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id,NULL);
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
						/*
						SELECT
							st_contains(
								st_transform(
								st_buffer(
									st_transform(
										ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
										,3857
									)
									,30
								),4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;
						*/
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',v_hypothetical_route_rest_t
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 11/05/2021 16:03:19 ******************

	-- Adding new type
	CREATE TYPE production_plant_types AS ENUM (
		'elkon'			
	,
		'ammann'			
	);
	ALTER TYPE production_plant_types OWNER TO beton;
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_production_plant_types_val(production_plant_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='elkon'::production_plant_types AND $2='ru'::locales THEN 'Elkon'
		WHEN $1='ammann'::production_plant_types AND $2='ru'::locales THEN 'Ammann'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_production_plant_types_val(production_plant_types,locales) OWNER TO concrete1;		
		

-- ******************* update 11/05/2021 16:10:01 ******************
		ALTER TABLE production_sites ADD COLUMN production_plant_type production_plant_types;



-- ******************* update 17/05/2021 10:27:01 ******************

					ALTER TYPE sms_types ADD VALUE 'mixer_route';
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_sms_types_val(sms_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='order'::sms_types AND $2='ru'::locales THEN 'заявка'
		WHEN $1='ship'::sms_types AND $2='ru'::locales THEN 'отгрузка'
		WHEN $1='remind'::sms_types AND $2='ru'::locales THEN 'напоминание'
		WHEN $1='procur'::sms_types AND $2='ru'::locales THEN 'поставка'
		WHEN $1='order_for_pump_ins'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (новая)'
		WHEN $1='order_for_pump_upd'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (изменена)'
		WHEN $1='order_for_pump_del'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (удалена)'
		WHEN $1='remind_for_pump'::sms_types AND $2='ru'::locales THEN 'напоминание для насоса'
		WHEN $1='client_thank'::sms_types AND $2='ru'::locales THEN 'благодарность клиенту'
		WHEN $1='vehicle_zone_violation'::sms_types AND $2='ru'::locales THEN 'Въезд в запрещенную зону'
		WHEN $1='vehicle_tracker_malfunction'::sms_types AND $2='ru'::locales THEN 'Нерабочий трекер'
		WHEN $1='efficiency_warn'::sms_types AND $2='ru'::locales THEN 'Низская эффективность'
		WHEN $1='material_balance'::sms_types AND $2='ru'::locales THEN 'Остатки материалов'
		WHEN $1='mixer_route'::sms_types AND $2='ru'::locales THEN 'Маршрут для миксериста'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_sms_types_val(sms_types,locales) OWNER TO concrete1;		
		

-- ******************* update 18/05/2021 09:50:03 ******************
DROP FUNCTION public.const_self_ship_dest_val();

CREATE OR REPLACE FUNCTION public.const_self_ship_dest_val(
	)
    RETURNS JSON
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
AS $BODY$
SELECT val::JSON AS val FROM const_self_ship_dest LIMIT 1;
$BODY$;

ALTER FUNCTION public.const_self_ship_dest_val()
    OWNER TO concrete1;



-- ******************* update 19/05/2021 11:39:11 ******************
-- View: ast_calls_new_list

-- DROP VIEW ast_calls_new_list;

CREATE OR REPLACE VIEW ast_calls_new_list AS 
	SELECT
		ac.unique_id,
		
		ac.client_id,
		clients_ref(cl) AS clients_ref,

		ac.user_id,
		users_ref(u) AS users_ref,
		
		ac.call_type,
		ac.dt AS start_time,
		ac.end_time AS end_time,
		ac.end_time - ac.start_time AS dur_time,		
		ac.manager_comment AS manager_comment,
		cl.manager_comment AS client_comment,
		cl.create_date AS client_create_date,
		COALESCE(o.quant, 0::numeric) > 0::numeric AS ours,
		
		cl.client_type_id,
		client_types_ref(clt) AS client_types_ref,

		cl.client_come_from_id,
		client_come_from_ref(clcfr) AS client_come_from_ref,
		
		cl.client_kind,
		
		ac.caller_id_num,
		ac.ext,
		
		CASE
		WHEN ac.call_type = 'in'::call_types THEN (format_cel_phone(ac.caller_id_num) || ' => '::text) || ac.ext::text
		ELSE (format_cel_phone(ac.ext) || ' => '::text) || format_cel_phone(ac.caller_id_num)
		END AS num,
		
		offer.quant AS offer_quant,
		offer.total AS offer_total,
		offer.offer_result,
		
		ac.record_link,
		ac.call_status
		
	FROM ast_calls ac
	LEFT JOIN clients cl ON cl.id = ac.client_id
	LEFT JOIN client_types clt ON clt.id = cl.client_type_id
	LEFT JOIN client_come_from clcfr ON clcfr.id = cl.client_come_from_id
	LEFT JOIN users u ON u.id = ac.user_id
	LEFT JOIN offer ON offer.ast_call_unique_id = ac.unique_id
	LEFT JOIN (
		SELECT
			orders.client_id,
			sum(orders.quant) AS quant
		FROM orders
		GROUP BY orders.client_id
	) o ON o.client_id = cl.id
	ORDER BY ac.dt DESC;

ALTER TABLE ast_calls_new_list
  OWNER TO beton;



-- ******************* update 19/05/2021 11:39:36 ******************
-- View: ast_calls_new_list

 DROP VIEW ast_calls_new_list;

CREATE OR REPLACE VIEW ast_calls_new_list AS 
	SELECT
		ac.unique_id,
		
		ac.client_id,
		clients_ref(cl) AS clients_ref,

		ac.user_id,
		users_ref(u) AS users_ref,
		
		ac.call_type,
		ac.dt AS start_time,
		ac.end_time AS end_time,
		ac.end_time - ac.start_time AS dur_time,		
		ac.manager_comment AS manager_comment,
		cl.manager_comment AS client_comment,
		cl.create_date AS client_create_date,
		COALESCE(o.quant, 0::numeric) > 0::numeric AS ours,
		
		cl.client_type_id,
		client_types_ref(clt) AS client_types_ref,

		cl.client_come_from_id,
		client_come_from_ref(clcfr) AS client_come_from_ref,
		
		cl.client_kind,
		
		ac.caller_id_num,
		ac.ext,
		
		CASE
		WHEN ac.call_type = 'in'::call_types THEN (format_cel_phone(ac.caller_id_num) || ' => '::text) || ac.ext::text
		ELSE (format_cel_phone(ac.ext) || ' => '::text) || format_cel_phone(ac.caller_id_num)
		END AS num,
		
		offer.quant AS offer_quant,
		offer.total AS offer_total,
		offer.offer_result
				
	FROM ast_calls ac
	LEFT JOIN clients cl ON cl.id = ac.client_id
	LEFT JOIN client_types clt ON clt.id = cl.client_type_id
	LEFT JOIN client_come_from clcfr ON clcfr.id = cl.client_come_from_id
	LEFT JOIN users u ON u.id = ac.user_id
	LEFT JOIN offer ON offer.ast_call_unique_id = ac.unique_id
	LEFT JOIN (
		SELECT
			orders.client_id,
			sum(orders.quant) AS quant
		FROM orders
		GROUP BY orders.client_id
	) o ON o.client_id = cl.id
	ORDER BY ac.dt DESC;

ALTER TABLE ast_calls_new_list
  OWNER TO beton;



-- ******************* update 19/05/2021 11:40:55 ******************
-- View: ast_calls_new_list

-- DROP VIEW ast_calls_new_list;

CREATE OR REPLACE VIEW ast_calls_new_list AS 
	SELECT
		ac.unique_id,
		
		ac.client_id,
		clients_ref(cl) AS clients_ref,

		ac.user_id,
		users_ref(u) AS users_ref,
		
		ac.call_type,
		ac.dt AS start_time,
		ac.end_time AS end_time,
		ac.end_time - ac.start_time AS dur_time,		
		ac.manager_comment AS manager_comment,
		cl.manager_comment AS client_comment,
		cl.create_date AS client_create_date,
		COALESCE(o.quant, 0::numeric) > 0::numeric AS ours,
		
		cl.client_type_id,
		client_types_ref(clt) AS client_types_ref,

		cl.client_come_from_id,
		client_come_from_ref(clcfr) AS client_come_from_ref,
		
		cl.client_kind,
		
		ac.caller_id_num,
		ac.ext,
		
		CASE
		WHEN ac.call_type = 'in'::call_types THEN (format_cel_phone(ac.caller_id_num) || ' => '::text) || ac.ext::text
		ELSE (format_cel_phone(ac.ext) || ' => '::text) || format_cel_phone(ac.caller_id_num)
		END AS num,
		
		offer.quant AS offer_quant,
		offer.total AS offer_total,
		offer.offer_result,
		
		ac.record_link,
		ac.call_status
				
	FROM ast_calls ac
	LEFT JOIN clients cl ON cl.id = ac.client_id
	LEFT JOIN client_types clt ON clt.id = cl.client_type_id
	LEFT JOIN client_come_from clcfr ON clcfr.id = cl.client_come_from_id
	LEFT JOIN users u ON u.id = ac.user_id
	LEFT JOIN offer ON offer.ast_call_unique_id = ac.unique_id
	LEFT JOIN (
		SELECT
			orders.client_id,
			sum(orders.quant) AS quant
		FROM orders
		GROUP BY orders.client_id
	) o ON o.client_id = cl.id
	ORDER BY ac.dt DESC;

ALTER TABLE ast_calls_new_list
  OWNER TO concrete1;



-- ******************* update 19/05/2021 12:13:05 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',CASE WHEN length(v_hypothetical_route_rest_t)<7800 THEN v_hypothetical_route_rest_t ELSE NULL END
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 19/05/2021 12:33:15 ******************

	-- ********** Adding new table from model **********
	CREATE TABLE public.route_rests
	(tracker_id  varchar(15),route_rest text
	);
	ALTER TABLE public.route_rests OWNER TO beton;
		

-- ******************* update 19/05/2021 12:37:03 ******************

	-- ********** Adding new table from model **********
	DROP TABLE public.route_rests;



-- ******************* update 19/05/2021 12:39:32 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7800) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		PERFORM pg_notify(
			'Vehicle.position.'||NEW.car_id
			,json_build_object(
				'params',json_build_object(
					'tracker_id',NEW.car_id
					,'lon',NEW.lon
					,'lat',NEW.lat
					,'heading',NEW.heading
					,'speed',NEW.speed
					,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'ns',NEW.ns
					,'ew',NEW.ew
					,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
					,'odometer',NEW.odometer::text
					,'voltage',round(NEW.voltage,0)
					,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
					,'long_route_rest',v_long_route_rest
					,'route_rest_len',v_hypothetical_route_rest_len
				)
			)::text
		);
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO concrete1;



-- ******************* update 19/05/2021 13:21:48 ******************
-- VIEW: shipments_for_veh_owner_list

--DROP VIEW shipments_for_veh_owner_list;

CREATE OR REPLACE VIEW shipments_for_veh_owner_list AS
	SELECT
		sh.id,
		sh.ship_date_time,
		sh.destination_id,
		sh.destinations_ref,
		sh.concrete_type_id,
		sh.concrete_types_ref,
		sh.quant,
		sh.vehicle_id,
		sh.vehicles_ref,
		sh.driver_id,
		sh.drivers_ref,
		sh.vehicle_owner_id,
		sh.vehicle_owners_ref,
		sh.cost,
		sh.ship_cost_edit,
		sh.pump_cost_edit,
		sh.demurrage,
		sh.demurrage_cost,
		sh.acc_comment,
		sh.acc_comment_shipment,
		sh.owner_agreed,
		sh.owner_agreed_date_time,
		
		CASE
		WHEN sh.destination_id = const_self_ship_dest_id_val() THEN 0
		WHEN coalesce(dest.price_for_driver,0)>0 THEN dest.price_for_driver*shipments_quant_for_cost(sh.quant::numeric,dest.distance::numeric)
		ELSE
			(WITH
			act_price AS (
				SELECT h.date AS d
				FROM shipment_for_driver_costs_h h
				WHERE h.date<=sh.ship_date_time::date
				ORDER BY h.date DESC
				LIMIT 1
			)
			SELECT shdr_cost.price
			FROM shipment_for_driver_costs AS shdr_cost
			WHERE
				shdr_cost.date=(SELECT d FROM act_price)
				AND shdr_cost.distance_to>=dest.distance
				/*OR shdr_cost.id=(
					SELECT t.id
					FROM shipment_for_driver_costs t
					WHERE t.date=(SELECT d FROM act_price)
					ORDER BY t.distance_to LIMIT 1
				)
				*/
			ORDER BY shdr_cost.distance_to ASC
			LIMIT 1
			) * shipments_quant_for_cost(sh.quant::numeric,dest.distance::numeric)
		END AS cost_for_driver
		
	FROM shipments_list sh
	LEFT JOIN destinations AS dest ON dest.id=destination_id
	ORDER BY ship_date_time DESC
	;
	
ALTER VIEW shipments_for_veh_owner_list OWNER TO concrete1;


-- ******************* update 19/05/2021 13:33:39 ******************

	-- ********** Adding new table from model **********
	CREATE TABLE public.route_rests
	(tracker_id  varchar(15) NOT NULL,route_rest text,CONSTRAINT route_rests_pkey PRIMARY KEY (tracker_id)
	);
	ALTER TABLE public.route_rests OWNER TO concrete1;
		

-- ******************* update 25/05/2021 13:39:36 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 02/06/2021 14:02:08 ******************
-- VIEW: production_vehicle_corrections_list

--DROP VIEW production_vehicle_corrections_list;

CREATE OR REPLACE VIEW production_vehicle_corrections_list AS
	SELECT
		t.production_site_id
		,production_sites_ref(p_st) AS production_sites_ref
		,t.production_id
		,t.vehicle_id
		,vehicles_ref(v) AS vehicles_ref
		,t.user_id
		,users_ref(u) AS users_ref
		,t.date_time
		
	FROM production_vehicle_corrections t
	LEFT JOIN production_sites AS p_st ON p_st.id=t.production_site_id
	LEFT JOIN vehicles AS v ON v.id=t.vehicle_id
	LEFT JOIN users AS u ON u.id=t.user_id
	ORDER BY date_time DESC
	;
	
ALTER VIEW production_vehicle_corrections_list OWNER TO concrete1;


-- ******************* update 02/06/2021 14:09:47 ******************
-- Function: public.productions_process()

-- DROP FUNCTION public.productions_process();

CREATE OR REPLACE FUNCTION public.productions_process()
  RETURNS trigger AS
$BODY$
BEGIN
	
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF TG_OP='UPDATE' AND OLD.manual_correction=TRUE AND NEW.manual_correction=TRUE THEN
			RETURN OLD;
		END IF;	
	
		IF TG_OP='INSERT' OR
			(TG_OP='UPDATE'
			AND (
				OLD.production_vehicle_descr!=NEW.production_vehicle_descr
				OR OLD.production_dt_start!=NEW.production_dt_start
			)
			)
		THEN		
			SELECT *
			INTO
				NEW.vehicle_id,
				NEW.vehicle_schedule_state_id,
				NEW.shipment_id
			FROM material_fact_consumptions_find_vehicle(
				NEW.production_site_id,
				coalesce(
					(SELECT v.plate::text
					FROM production_vehicle_corrections AS p
					LEFT JOIN vehicles AS v ON v.id=p.vehicle_id
					WHERE p.production_site_id=NEW.production_site_id AND p.production_id=NEW.production_id
					)
					,NEW.production_vehicle_descr
				),
				NEW.production_dt_start::timestamp
			) AS (
				vehicle_id int,
				vehicle_schedule_state_id int,
				shipment_id int
			);		
		END IF;
		
		IF NEW.production_dt_end IS NOT NULL THEN
			NEW.material_tolerance_violated = productions_get_mat_tolerance_violated(
				NEW.production_site_id,
				NEW.production_id
			);
		END IF;
				
		/*
		IF TG_OP='UPDATE'		
			AND (
				(OLD.production_dt_end IS NULL AND NEW.production_dt_end IS NOT NULL)
				OR coalesce(NEW.shipment_id,0)<>coalesce(OLD.shipment_id,0)
				OR coalesce(NEW.vehicle_schedule_state_id,0)<>coalesce(OLD.vehicle_schedule_state_id,0)
				OR coalesce(NEW.concrete_type_id,0)<>coalesce(OLD.concrete_type_id,0)
			)
		THEN			
			NEW.material_tolerance_violated = productions_get_mat_tolerance_violated(
				NEW.production_site_id,
				NEW.production_id
			);			
		END IF;
		*/
		
		RETURN NEW;
		
	ELSEIF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
	
		--закрываем дырку
		-- для Konkred временно убрал
		/*
		IF coalesce(
			(SELECT TRUE
			FROM production_sites
			WHERE id = NEW.production_site_id
			AND NEW.production_id =ANY(missing_elkon_production_ids))
			,FALSE
		) THEN
			UPDATE production_sites
			SET
				missing_elkon_production_ids = array_diff(missing_elkon_production_ids,ARRAY[NEW.production_id])
			WHERE id = NEW.production_site_id
			;
		END IF;
		*/
		PERFORM pg_notify(
			'Production.insert'
			,json_build_object(
				'params',json_build_object(
					'id',NEW.id
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN
		/*
		IF coalesce(NEW.concrete_type_id,0)<>coalesce(OLD.concrete_type_id,0)
		THEN
			UPDATE material_fact_consumptions
			SET
				concrete_type_id = NEW.concrete_type_id
			WHERE production_site_id = NEW.production_site_id AND production_id = NEW.production_id;
		END IF;
		*/
		/* МЕНЯТЬ ТС ПРИ СМЕНЕ shipment_id*/
		IF (coalesce(NEW.shipment_id,0)<>coalesce(OLD.shipment_id,0))
		OR (coalesce(NEW.vehicle_schedule_state_id,0)<>coalesce(OLD.vehicle_schedule_state_id,0))
		OR (coalesce(NEW.vehicle_id,0)<>coalesce(OLD.vehicle_id,0))
		OR (coalesce(NEW.concrete_type_id,0)<>coalesce(OLD.concrete_type_id,0))
		OR (coalesce(NEW.concrete_quant,0)<>coalesce(OLD.concrete_quant,0))
		THEN
			--сменить shipment_id,vehicle_schedule_state_id
			IF (coalesce(NEW.shipment_id,0)<>coalesce(OLD.shipment_id,0)) THEN
				SELECT
					vsch.vehicle_id
					,vschst.id
				INTO
					NEW.vehicle_id
					,NEW.vehicle_schedule_state_id	
				FROM shipments AS sh
				LEFT JOIN vehicle_schedules AS vsch ON vsch.id=sh.vehicle_schedule_id
				LEFT JOIN vehicle_schedule_states AS vschst ON vschst.schedule_id=sh.vehicle_schedule_id AND vschst.shipment_id=sh.id
				WHERE sh.id=NEW.shipment_id	
				;
			END IF;
			
			UPDATE material_fact_consumptions
			SET
				vehicle_schedule_state_id = NEW.vehicle_schedule_state_id,
				vehicle_id = NEW.vehicle_id,
				concrete_type_id = NEW.concrete_type_id,
				concrete_quant = NEW.concrete_quant
			WHERE production_site_id = NEW.production_site_id AND production_id = NEW.production_id;
		END IF;
		
		
		--ЭТО ДЕЛАЕТСЯ В КОНТРОЛЛЕРЕ Production_Controller->check_data!!!
		--IF OLD.production_dt_end IS NULL
		--AND NEW.production_dt_end IS NOT NULL
		--AND NEW.shipment_id IS NOT NULL THEN
		--END IF;
		
		PERFORM pg_notify(
			'Production.update'
			,json_build_object(
				'params',json_build_object(
					'id',NEW.id
				)
			)::text
		);
		
		RETURN NEW;
		
	ELSEIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM material_fact_consumptions WHERE production_site_id = OLD.production_site_id AND production_id = OLD.production_id;
		
		RETURN OLD;

	ELSEIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		
		PERFORM pg_notify(
			'Production.delete'
			,json_build_object(
				'params',json_build_object(
					'id',OLD.id
				)
			)::text
		);
		
		RETURN OLD;
				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.productions_process() OWNER TO concrete1;



-- ******************* update 02/06/2021 14:25:57 ******************
--DROP FUNCTION material_fact_consumptions_add_material(in_production_site_id int, in_material_descr text, in_date_time timestamp without time zone)
CREATE OR REPLACE FUNCTION material_fact_consumptions_add_material(in_production_site_id int, in_material_descr text, in_date_time timestamp without time zone)
RETURNS int as $$
DECLARE
	v_raw_material_id int;
BEGIN
	v_raw_material_id = NULL;
	
	--Берется соответствие с большей датой или по конкретному заводу или по пустому
	SELECT raw_material_id INTO v_raw_material_id
	FROM raw_material_map_to_production
	WHERE	(production_site_id=in_production_site_id OR production_site_id IS NULL)
		AND production_descr = in_material_descr AND date_time<=in_date_time
	ORDER BY date_time DESC
	LIMIT 1;
	
	IF NOT FOUND AND coalesce(in_material_descr,'')<>'' THEN
		SELECT id FROM raw_materials INTO v_raw_material_id WHERE name=in_material_descr;
	
		INSERT INTO raw_material_map_to_production
		(date_time,production_descr,raw_material_id)
		VALUES
		(now(),in_material_descr,v_raw_material_id)
		;
	END IF;
	
	RETURN v_raw_material_id;
END;
$$ language plpgsql;

ALTER FUNCTION material_fact_consumptions_add_material(in_production_site_id int, in_material_descr text, in_date_time timestamp without time zone) OWNER TO concrete1;


-- ******************* update 07/06/2021 12:27:15 ******************

		ALTER TABLE public.doc_material_procurements ADD COLUMN doc_quant_gross  numeric(19,2),ADD COLUMN doc_quant_net  numeric(19,2);
/*
	DROP INDEX IF EXISTS doc_material_procurements_doc_ref_index;
	CREATE UNIQUE INDEX doc_material_procurements_doc_ref_index

*/


-- ******************* update 07/06/2021 12:37:40 ******************
-- Index: doc_material_procurements_doc_ref_index

 DROP INDEX public.doc_material_procurements_doc_ref_index;

CREATE UNIQUE INDEX doc_material_procurements_doc_ref_index
    ON public.doc_material_procurements USING btree
    (doc_ref COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;



-- ******************* update 08/06/2021 07:09:31 ******************

		ALTER TABLE public.vehicles ADD COLUMN ord_num int;



-- ******************* update 08/06/2021 07:10:07 ******************
-- View: public.vehicles_dialog

-- DROP VIEW public.vehicles_dialog;

CREATE OR REPLACE VIEW public.vehicles_dialog AS 
	SELECT
		v.id,
		v.plate,
		v.load_capacity,
		v.make,
		v.owner,
		v.feature,
		v.tracker_id,
		--v.sim_id,
		gps_tr.sim_id AS sim_id,
		--v.sim_number,
		gps_tr.sim_number AS sim_number,
		
		NULL::text AS tracker_last_data_descr,
		CASE
			WHEN v.tracker_id IS NULL OR v.tracker_id::text = ''::text THEN NULL::timestamp without time zone
			ELSE (
				SELECT tr.recieved_dt + (now() - timezone('utc'::text, now())::timestamp with time zone)
				FROM car_tracking tr
				WHERE tr.car_id::text = v.tracker_id::text
				ORDER BY tr.period DESC
				LIMIT 1
			)
		END AS tracker_last_dt,
		
		drivers_ref(dr.*) AS drivers_ref,
		v.vehicle_owners,
		
		vehicle_owners_ref(v_own) AS vehicle_owners_ref,
		/*
		(SELECT 
			r.f_vals->'fields'->'owner'
		FROM (
			SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS f_vals
		) AS r
		ORDER BY r.f_vals->'fields'->'dt_from' DESC
		LIMIT 1
		) AS vehicle_owners_ref,
		*/
		
		v.vehicle_owner_id,
		/*
		(SELECT 
			CASE WHEN r.f_vals->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
				ELSE (r.f_vals->'fields'->'owner'->'keys'->>'id')::int
			END
		FROM (
			SELECT jsonb_array_elements(v.vehicle_owners->'rows') AS f_vals
		) AS r
		ORDER BY r.f_vals->'fields'->'dt_from' DESC
		LIMIT 1
		) AS vehicle_owner_id,
		*/
		
		v.vehicle_owners_ar,
		
		v.ord_num
		
	FROM vehicles v
	LEFT JOIN drivers dr ON dr.id = v.driver_id
	LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
	LEFT JOIN gps_trackers AS gps_tr ON gps_tr.id = v.tracker_id
	ORDER BY v.plate
	;

ALTER TABLE public.vehicles_dialog
  OWNER TO beton;



-- ******************* update 24/06/2021 11:28:29 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN					

		INSERT INTO doc_material_procurements
			(date_time,
			user_id,
			supplier_id,
			carrier_id,
			driver,
			vehicle_plate,
			material_id,
			quant_gross,
			quant_net,
			doc_ref,
			doc_quant_gross,
			doc_quant_net,
			doc_ref_gornyi)
		SELECT
			NEW.date_time,
			NEW.user_id,
			NEW.supplier_id,
			NEW.carrier_id,
			NEW.driver,
			NEW.vehicle_plate,
			NEW.material_id,
			NEW.quant_gross,
			NEW.quant_net,
			NULL,
			NEW.doc_quant_gross,
			NEW.doc_quant_net,
			NEW.doc_ref;
				
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN					

		UPDATE doc_material_procurements
		SET
			date_time = NEW.date_time,
			user_id = NEW.user_id,
			supplier_id = NEW.supplier_id,
			carrier_id = NEW.carrier_id,
			driver = NEW.driver,
			vehicle_plate = NEW.vehicle_plate,
			material_id = NEW.material_id,
			quant_gross = NEW.quant_gross,
			quant_net = NEW.quant_net,
			doc_quant_gross = NEW.doc_quant_gross,
			doc_quant_net = NEW.doc_quant_net
			
		WHERE doc_ref_gornyi = NEW.doc_ref;			
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 11:29:35 ******************
-- Trigger: doc_material_procurements2_after

--DROP TRIGGER doc_material_procurements2_after ON public.doc_material_procurements2;

CREATE TRIGGER doc_material_procurements2_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.doc_material_procurements2
    FOR EACH ROW
    EXECUTE PROCEDURE public.doc_material_procurements2_process();    



-- ******************* update 24/06/2021 11:30:51 ******************
-- Trigger: doc_material_procurements2_after

DROP TRIGGER doc_material_procurements2_after ON public.doc_material_procurements2;
/*
CREATE TRIGGER doc_material_procurements2_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.doc_material_procurements2
    FOR EACH ROW
    EXECUTE PROCEDURE public.doc_material_procurements2_process();    
*/


-- ******************* update 24/06/2021 11:31:51 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		NULL,
		doc_quant_gross,
		doc_quant_net,
		doc_ref
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' AND (NEW.quant_gross>0 OR NEW.quant_net>0)
	AND POSITION('цемент' in lower(NEW.material_name))=0 THEN					

		INSERT INTO doc_material_procurements
			(date_time,
			user_id,
			supplier_id,
			carrier_id,
			driver,
			vehicle_plate,
			material_id,
			quant_gross,
			quant_net,
			doc_ref,
			doc_quant_gross,
			doc_quant_net,
			doc_ref_gornyi)
		SELECT
			NEW.date_time,
			NEW.user_id,
			NEW.supplier_id,
			NEW.carrier_id,
			NEW.driver,
			NEW.vehicle_plate,
			NEW.material_id,
			NEW.quant_gross,
			NEW.quant_net,
			NULL,
			NEW.doc_quant_gross,
			NEW.doc_quant_net,
			NEW.doc_ref;
				
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN					

		UPDATE doc_material_procurements
		SET
			date_time = NEW.date_time,
			user_id = NEW.user_id,
			supplier_id = NEW.supplier_id,
			carrier_id = NEW.carrier_id,
			driver = NEW.driver,
			vehicle_plate = NEW.vehicle_plate,
			material_id = NEW.material_id,
			quant_gross = NEW.quant_gross,
			quant_net = NEW.quant_net,
			doc_quant_gross = NEW.doc_quant_gross,
			doc_quant_net = NEW.doc_quant_net
			
		WHERE doc_ref_gornyi = NEW.doc_ref;			
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 11:32:00 ******************
-- Trigger: doc_material_procurements2_after

--DROP TRIGGER doc_material_procurements2_after ON public.doc_material_procurements2;

CREATE TRIGGER doc_material_procurements2_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.doc_material_procurements2
    FOR EACH ROW
    EXECUTE PROCEDURE public.doc_material_procurements2_process();    



-- ******************* update 24/06/2021 11:35:31 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		NULL,
		doc_quant_gross,
		doc_quant_net,
		doc_ref
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' AND (NEW.quant_gross>0 OR NEW.quant_net>0)
	AND POSITION('цемент' in lower(NEW.material_name))=0
	AND NEW.date_time::date='2021-06-24' THEN					

		INSERT INTO doc_material_procurements
			(date_time,
			user_id,
			supplier_id,
			carrier_id,
			driver,
			vehicle_plate,
			material_id,
			quant_gross,
			quant_net,
			doc_ref,
			doc_quant_gross,
			doc_quant_net,
			doc_ref_gornyi)
		SELECT
			NEW.date_time,
			NEW.user_id,
			NEW.supplier_id,
			NEW.carrier_id,
			NEW.driver,
			NEW.vehicle_plate,
			NEW.material_id,
			NEW.quant_gross,
			NEW.quant_net,
			NULL,
			NEW.doc_quant_gross,
			NEW.doc_quant_net,
			NEW.doc_ref;
				
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN					

		UPDATE doc_material_procurements
		SET
			date_time = NEW.date_time,
			user_id = NEW.user_id,
			supplier_id = NEW.supplier_id,
			carrier_id = NEW.carrier_id,
			driver = NEW.driver,
			vehicle_plate = NEW.vehicle_plate,
			material_id = NEW.material_id,
			quant_gross = NEW.quant_gross,
			quant_net = NEW.quant_net,
			doc_quant_gross = NEW.doc_quant_gross,
			doc_quant_net = NEW.doc_quant_net
			
		WHERE doc_ref_gornyi = NEW.doc_ref;			
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 11:45:09 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		NULL,
		doc_quant_gross,
		doc_quant_net,
		doc_ref
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' AND (NEW.quant_gross>0 OR NEW.quant_net>0)
	AND POSITION('цемент' in lower(NEW.material_name))=0
	AND NEW.date_time::date>='2021-06-24' THEN					

		INSERT INTO doc_material_procurements
			(date_time,
			user_id,
			supplier_id,
			carrier_id,
			driver,
			vehicle_plate,
			material_id,
			quant_gross,
			quant_net,
			doc_ref,
			doc_quant_gross,
			doc_quant_net,
			doc_ref_gornyi)
		SELECT
			NEW.date_time,
			NEW.user_id,
			NEW.supplier_id,
			NEW.carrier_id,
			NEW.driver,
			NEW.vehicle_plate,
			NEW.material_id,
			NEW.quant_gross,
			NEW.quant_net,
			NULL,
			NEW.doc_quant_gross,
			NEW.doc_quant_net,
			NEW.doc_ref;
				
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN					

		UPDATE doc_material_procurements
		SET
			date_time = NEW.date_time,
			user_id = NEW.user_id,
			supplier_id = NEW.supplier_id,
			carrier_id = NEW.carrier_id,
			driver = NEW.driver,
			vehicle_plate = NEW.vehicle_plate,
			material_id = NEW.material_id,
			quant_gross = NEW.quant_gross,
			quant_net = NEW.quant_net,
			doc_quant_gross = NEW.doc_quant_gross,
			doc_quant_net = NEW.doc_quant_net
			
		WHERE doc_ref_gornyi = NEW.doc_ref;			
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 11:45:57 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		NULL,
		doc_quant_gross,
		doc_quant_net,
		doc_ref
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' AND (NEW.quant_gross>0 OR NEW.quant_net>0)
	AND POSITION('цемент' in lower(NEW.material_name))=0
	AND NEW.date_time::date>='2021-06-24' THEN					

		INSERT INTO doc_material_procurements
			(date_time,
			user_id,
			supplier_id,
			carrier_id,
			driver,
			vehicle_plate,
			material_id,
			quant_gross,
			quant_net,
			doc_ref,
			doc_quant_gross,
			doc_quant_net,
			doc_ref_gornyi)
		SELECT
			NEW.date_time,
			NEW.user_id,
			NEW.supplier_id,
			NEW.carrier_id,
			NEW.driver,
			NEW.vehicle_plate,
			NEW.material_id,
			NEW.quant_gross/1000,
			NEW.quant_net/1000,
			NULL,
			NEW.doc_quant_gross/1000,
			NEW.doc_quant_net/1000,
			NEW.doc_ref;
				
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN					

		UPDATE doc_material_procurements
		SET
			date_time = NEW.date_time,
			user_id = NEW.user_id,
			supplier_id = NEW.supplier_id,
			carrier_id = NEW.carrier_id,
			driver = NEW.driver,
			vehicle_plate = NEW.vehicle_plate,
			material_id = NEW.material_id,
			quant_gross = NEW.quant_gross/1000,
			quant_net = NEW.quant_net/1000,
			doc_quant_gross = NEW.doc_quant_gross/1000,
			doc_quant_net = NEW.doc_quant_net/1000
			
		WHERE doc_ref_gornyi = NEW.doc_ref;			
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 11:47:38 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		NULL,
		doc_quant_gross,
		doc_quant_net,
		doc_ref
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' AND (NEW.quant_gross>0 OR NEW.quant_net>0)
	AND POSITION('цемент' in lower(NEW.material_name))=0
	AND NEW.date_time::date>='2021-06-24' THEN					

		INSERT INTO doc_material_procurements
			(date_time,
			user_id,
			supplier_id,
			carrier_id,
			driver,
			vehicle_plate,
			material_id,
			quant_gross,
			quant_net,
			doc_ref,
			doc_quant_gross,
			doc_quant_net,
			doc_ref_gornyi,
			store)
		SELECT
			NEW.date_time,
			NEW.user_id,
			NEW.supplier_id,
			NEW.carrier_id,
			NEW.driver,
			NEW.vehicle_plate,
			NEW.material_id,
			NEW.quant_gross/1000,
			NEW.quant_net/1000,
			NULL,
			NEW.doc_quant_gross/1000,
			NEW.doc_quant_net/1000,
			NEW.doc_ref,
			'БАЗА';
				
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN					

		UPDATE doc_material_procurements
		SET
			date_time = NEW.date_time,
			user_id = NEW.user_id,
			supplier_id = NEW.supplier_id,
			carrier_id = NEW.carrier_id,
			driver = NEW.driver,
			vehicle_plate = NEW.vehicle_plate,
			material_id = NEW.material_id,
			quant_gross = NEW.quant_gross/1000,
			quant_net = NEW.quant_net/1000,
			doc_quant_gross = NEW.doc_quant_gross/1000,
			doc_quant_net = NEW.doc_quant_net/1000
			
		WHERE doc_ref_gornyi = NEW.doc_ref;			
				
		RETURN NEW;
		
	ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	
		DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 11:57:55 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi,
		store)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross/1000,
		quant_net/1000,
		NULL,
		doc_quant_gross/1000,
		doc_quant_net/1000,
		doc_ref,
		'БАЗА'
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' AND (NEW.quant_gross>0 OR NEW.quant_net>0)
	AND POSITION('цемент' in lower(NEW.material_name))=0
	AND NEW.date_time::date>='2021-06-24' THEN					

		INSERT INTO doc_material_procurements
			(date_time,
			user_id,
			supplier_id,
			carrier_id,
			driver,
			vehicle_plate,
			material_id,
			quant_gross,
			quant_net,
			doc_ref,
			doc_quant_gross,
			doc_quant_net,
			doc_ref_gornyi,
			store)
		SELECT
			NEW.date_time,
			NEW.user_id,
			NEW.supplier_id,
			NEW.carrier_id,
			NEW.driver,
			NEW.vehicle_plate,
			NEW.material_id,
			NEW.quant_gross/1000,
			NEW.quant_net/1000,
			NULL,
			NEW.doc_quant_gross/1000,
			NEW.doc_quant_net/1000,
			NEW.doc_ref,
			'БАЗА';
				
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' AND NEW.date_time::date>='2021-06-24' THEN					

		UPDATE doc_material_procurements
		SET
			date_time = NEW.date_time,
			user_id = NEW.user_id,
			supplier_id = NEW.supplier_id,
			carrier_id = NEW.carrier_id,
			driver = NEW.driver,
			vehicle_plate = NEW.vehicle_plate,
			material_id = NEW.material_id,
			quant_gross = NEW.quant_gross/1000,
			quant_net = NEW.quant_net/1000,
			doc_quant_gross = NEW.doc_quant_gross/1000,
			doc_quant_net = NEW.doc_quant_net/1000
			
		WHERE doc_ref_gornyi = NEW.doc_ref;			
				
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' AND OLD.date_time::date>='2021-06-24' THEN
	
		DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 12:01:33 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi,
		store)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross/1000,
		quant_net/1000,
		NULL,
		doc_quant_gross/1000,
		doc_quant_net/1000,
		doc_ref,
		'БАЗА'
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
	
		IF (NEW.quant_gross>0 OR NEW.quant_net>0)
		AND POSITION('цемент' in lower(NEW.material_name))=0
		AND NEW.date_time::date>='2021-06-24' THEN					

			INSERT INTO doc_material_procurements
				(date_time,
				user_id,
				supplier_id,
				carrier_id,
				driver,
				vehicle_plate,
				material_id,
				quant_gross,
				quant_net,
				doc_ref,
				doc_quant_gross,
				doc_quant_net,
				doc_ref_gornyi,
				store)
			SELECT
				NEW.date_time,
				NEW.user_id,
				NEW.supplier_id,
				NEW.carrier_id,
				NEW.driver,
				NEW.vehicle_plate,
				NEW.material_id,
				NEW.quant_gross/1000,
				NEW.quant_net/1000,
				NULL,
				NEW.doc_quant_gross/1000,
				NEW.doc_quant_net/1000,
				NEW.doc_ref,
				'БАЗА';
		END IF;
						
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN	
					
		IF NEW.date_time::date>='2021-06-24' THEN
			UPDATE doc_material_procurements
			SET
				date_time = NEW.date_time,
				user_id = NEW.user_id,
				supplier_id = NEW.supplier_id,
				carrier_id = NEW.carrier_id,
				driver = NEW.driver,
				vehicle_plate = NEW.vehicle_plate,
				material_id = NEW.material_id,
				quant_gross = NEW.quant_gross/1000,
				quant_net = NEW.quant_net/1000,
				doc_quant_gross = NEW.doc_quant_gross/1000,
				doc_quant_net = NEW.doc_quant_net/1000
				
			WHERE doc_ref_gornyi = NEW.doc_ref;			
		END IF;
						
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
	
		IF NEW.date_time::date>='2021-06-24' THEN
			DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
		END IF;	
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 12:10:09 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi,
		store)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross/1000,
		quant_net/1000,
		NULL,
		doc_quant_gross/1000,
		doc_quant_net/1000,
		doc_ref,
		'БАЗА'
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
	
		IF (NEW.quant_gross>0 OR NEW.quant_net>0)
		AND POSITION('цемент' in lower(NEW.material_name))=0
		AND NEW.date_time::date>='2021-06-24' THEN					

			INSERT INTO doc_material_procurements
				(date_time,
				user_id,
				supplier_id,
				carrier_id,
				driver,
				vehicle_plate,
				material_id,
				quant_gross,
				quant_net,
				doc_ref,
				doc_quant_gross,
				doc_quant_net,
				doc_ref_gornyi,
				store)
			SELECT
				NEW.date_time,
				NEW.user_id,
				NEW.supplier_id,
				NEW.carrier_id,
				NEW.driver,
				NEW.vehicle_plate,
				NEW.material_id,
				NEW.quant_gross/1000,
				NEW.quant_net/1000,
				NULL,
				NEW.doc_quant_gross/1000,
				NEW.doc_quant_net/1000,
				NEW.doc_ref,
				'БАЗА';
		END IF;
						
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN	
					
		IF NEW.date_time::date>='2021-06-24' THEN
			UPDATE doc_material_procurements
			SET
				date_time = NEW.date_time,
				user_id = NEW.user_id,
				supplier_id = NEW.supplier_id,
				carrier_id = NEW.carrier_id,
				driver = NEW.driver,
				vehicle_plate = NEW.vehicle_plate,
				material_id = NEW.material_id,
				quant_gross = NEW.quant_gross/1000,
				quant_net = NEW.quant_net/1000,
				doc_quant_gross = NEW.doc_quant_gross/1000,
				doc_quant_net = NEW.doc_quant_net/1000,
				doc_ref = NEW.doc_ref_1c,
				number = NEW.number
				
			WHERE doc_ref_gornyi = NEW.doc_ref;			
		END IF;
						
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
	
		IF NEW.date_time::date>='2021-06-24' THEN
			DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
		END IF;	
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 12:19:51 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi,
		store)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross/1000,
		quant_net/1000,
		NULL,
		doc_quant_gross/1000,
		doc_quant_net/1000,
		doc_ref,
		'БАЗА'
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND POSITION('цемент' in lower(material_name))=0
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
	
		IF (NEW.quant_gross>0 OR NEW.quant_net>0)
		AND POSITION('цемент' in lower(NEW.material_name))=0
		AND NEW.date_time::date>='2021-06-24' THEN					

			INSERT INTO doc_material_procurements
				(date_time,
				user_id,
				supplier_id,
				carrier_id,
				driver,
				vehicle_plate,
				material_id,
				quant_gross,
				quant_net,
				doc_ref,
				doc_quant_gross,
				doc_quant_net,
				doc_ref_gornyi,
				store)
			SELECT
				NEW.date_time,
				NEW.user_id,
				NEW.supplier_id,
				NEW.carrier_id,
				NEW.driver,
				NEW.vehicle_plate,
				NEW.material_id,
				NEW.quant_gross/1000,
				NEW.quant_net/1000,
				NULL,
				NEW.doc_quant_gross/1000,
				NEW.doc_quant_net/1000,
				NEW.doc_ref,
				'БАЗА';
		END IF;
						
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN	
					
		IF NEW.date_time::date>='2021-06-24' THEN
			IF NEW.quant_gross=0 AND NEW.quant_net=0 THEN
				DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = NEW.doc_ref;
			ELSE
				UPDATE doc_material_procurements
				SET
					date_time = NEW.date_time,
					user_id = NEW.user_id,
					supplier_id = NEW.supplier_id,
					carrier_id = NEW.carrier_id,
					driver = NEW.driver,
					vehicle_plate = NEW.vehicle_plate,
					material_id = NEW.material_id,
					quant_gross = NEW.quant_gross/1000,
					quant_net = NEW.quant_net/1000,
					doc_quant_gross = NEW.doc_quant_gross/1000,
					doc_quant_net = NEW.doc_quant_net/1000,
					doc_ref = NEW.doc_ref_1c,
					number = NEW.number
					
				WHERE doc_ref_gornyi = NEW.doc_ref;			
			END IF;
		END IF;
						
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
	
		IF NEW.date_time::date>='2021-06-24' THEN
			DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
		END IF;	
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 24/06/2021 12:38:02 ******************
﻿-- Function: doc_material_procurements2_material_check(in_material_name text)

-- DROP FUNCTION doc_material_procurements2_material_check(in_material_name text);

CREATE OR REPLACE FUNCTION doc_material_procurements2_material_check(in_material_name text)
  RETURNS bool AS
$$
	SELECT (POSITION('цемент' in lower(in_material_name))=0 );
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION doc_material_procurements2_material_check(in_material_name text) OWNER TO beton;


-- ******************* update 24/06/2021 12:42:38 ******************
-- Function: public.doc_material_procurements_process2()

-- DROP FUNCTION public.doc_material_procurements_process2();

/**
 * Таблица принимает данные от горного, триггер переносит в рабочую таблицу
 *
	INSERT INTO doc_material_procurements
		(date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross,
		quant_net,
		doc_ref,
		doc_quant_gross,
		doc_quant_net,
		doc_ref_gornyi,
		store)
	SELECT
		date_time,
		user_id,
		supplier_id,
		carrier_id,
		driver,
		vehicle_plate,
		material_id,
		quant_gross/1000,
		quant_net/1000,
		NULL,
		doc_quant_gross/1000,
		doc_quant_net/1000,
		doc_ref,
		'БАЗА'
		
	FROM public.doc_material_procurements2
	where (quant_gross>0 OR quant_net>0)
	AND doc_material_procurements2_material_check(material_name)
	AND date_time::date=now()::date
	ORDER BY date_time DESC 
 
 */

CREATE OR REPLACE FUNCTION public.doc_material_procurements2_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
	
		IF (NEW.quant_gross>0 OR NEW.quant_net>0)
		AND doc_material_procurements2_material_check(NEW.material_name)
		AND NEW.date_time::date>='2021-06-24' THEN					

			INSERT INTO doc_material_procurements
				(date_time,
				user_id,
				supplier_id,
				carrier_id,
				driver,
				vehicle_plate,
				material_id,
				quant_gross,
				quant_net,
				doc_ref,
				doc_quant_gross,
				doc_quant_net,
				doc_ref_gornyi,
				store)
			SELECT
				NEW.date_time,
				NEW.user_id,
				NEW.supplier_id,
				NEW.carrier_id,
				NEW.driver,
				NEW.vehicle_plate,
				NEW.material_id,
				NEW.quant_gross/1000,
				NEW.quant_net/1000,
				NULL,
				NEW.doc_quant_gross/1000,
				NEW.doc_quant_net/1000,
				NEW.doc_ref,
				'БАЗА';
		END IF;
						
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN	
					
		IF NEW.date_time::date>='2021-06-24' AND doc_material_procurements2_material_check(NEW.material_name) THEN
			IF NEW.quant_gross=0 AND NEW.quant_net=0 THEN
				DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = NEW.doc_ref;
			ELSE
				UPDATE doc_material_procurements
				SET
					date_time = NEW.date_time,
					user_id = NEW.user_id,
					supplier_id = NEW.supplier_id,
					carrier_id = NEW.carrier_id,
					driver = NEW.driver,
					vehicle_plate = NEW.vehicle_plate,
					material_id = NEW.material_id,
					quant_gross = NEW.quant_gross/1000,
					quant_net = NEW.quant_net/1000,
					doc_quant_gross = NEW.doc_quant_gross/1000,
					doc_quant_net = NEW.doc_quant_net/1000,
					doc_ref = NEW.doc_ref_1c,
					number = NEW.number
					
				WHERE doc_ref_gornyi = NEW.doc_ref;			
			END IF;
		END IF;
						
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
	
		IF OLD.date_time::date>='2021-06-24' AND doc_material_procurements2_material_check(OLD.material_name) THEN
			DELETE FROM doc_material_procurements WHERE doc_ref_gornyi = OLD.doc_ref;
		END IF;	
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.doc_material_procurements2_process()
  OWNER TO beton;



-- ******************* update 28/06/2021 14:23:39 ******************

	-- ********** Adding new table from model **********
	CREATE TABLE public.gornyi_carrier_match
	(id serial NOT NULL,carrier_id int NOT NULL REFERENCES suppliers(id),plate  varchar(8),CONSTRAINT gornyi_carrier_match_pkey PRIMARY KEY (id)
	);



-- ******************* update 28/06/2021 15:23:32 ******************
-- VIEW: gornyi_carrier_match_list

--DROP VIEW gornyi_carrier_match_list;

CREATE OR REPLACE VIEW gornyi_carrier_match_list AS
	SELECT
		t.id 
		,suppliers_ref(cr) AS carriers_ref
		,t.plate
		
	FROM gornyi_carrier_match AS t
	LEFT JOIN suppliers AS cr ON cr.id = t.carrier_id
	;
	
ALTER VIEW gornyi_carrier_match_list OWNER TO beton;


-- ******************* update 28/06/2021 15:27:56 ******************
-- VIEW: gornyi_carrier_match_list

--DROP VIEW gornyi_carrier_match_list;

CREATE OR REPLACE VIEW gornyi_carrier_match_list AS
	SELECT
		t.id 
		,suppliers_ref(cr) AS carriers_ref
		,t.plate
		
	FROM gornyi_carrier_match AS t
	LEFT JOIN suppliers AS cr ON cr.id = t.carrier_id
	ORDER BY t.plate
	;
	
ALTER VIEW gornyi_carrier_match_list OWNER TO beton;


-- ******************* update 28/06/2021 15:32:34 ******************

	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'10044',
	'GornyiCarrierMatch_Controller',
	'get_list',
	'GornyiCarrierMatchList',
	'Справочники',
	'Соответствие ТС Горного перевозчикам',
	FALSE
	);
	

-- ******************* update 29/06/2021 11:48:06 ******************
﻿-- Function: shipments_cost(destinations, int, date, shipments, bool)

--DROP FUNCTION shipments_cost(destinations, int, date, shipments, bool);

CREATE OR REPLACE FUNCTION shipments_cost(in_destinations destinations, in_concrete_type_id int, in_date date, in_shipments shipments, in_editable bool)
  RETURNS numeric(15,2) AS
$$
	SELECT
		coalesce(
		(CASE
			WHEN in_editable AND coalesce(in_shipments.ship_cost_edit,FALSE) THEN in_shipments.ship_cost
			WHEN in_destinations.id=const_self_ship_dest_id_val() THEN 0
			WHEN in_concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(in_destinations.special_price,FALSE) THEN coalesce(in_destinations.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=in_date AND sh_p.distance_to>=in_destinations.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(in_destinations.price,0))			
				END
				*
				CASE WHEN in_date < '2021-07-01' THEN
					CASE
						WHEN in_shipments.quant>=7 THEN in_shipments.quant
						WHEN in_destinations.distance<=60 THEN greatest(5,in_shipments.quant)
						ELSE 7
					END
				ELSE
					CASE
						WHEN in_shipments.quant>=7 THEN in_shipments.quant
						WHEN in_destinations.distance<=60 THEN greatest(7,in_shipments.quant)
						ELSE 10
					END
				END	
		END)::numeric(15,2)
		,0)
	;
$$
  LANGUAGE sql VOLATILE --IMMUTABLE VOLATILE
  COST 100;
ALTER FUNCTION shipments_cost(destinations, int, date, shipments, bool) OWNER TO beton;



-- ******************* update 29/06/2021 11:50:58 ******************
﻿-- Function: shipments_cost(destinations, int, date, shipments, bool)

--DROP FUNCTION shipments_cost(destinations, int, date, shipments, bool);

CREATE OR REPLACE FUNCTION shipments_cost(in_destinations destinations, in_concrete_type_id int, in_date date, in_shipments shipments, in_editable bool)
  RETURNS numeric(15,2) AS
$$
	SELECT
		coalesce(
		(CASE
			WHEN in_editable AND coalesce(in_shipments.ship_cost_edit,FALSE) THEN in_shipments.ship_cost
			WHEN in_destinations.id=const_self_ship_dest_id_val() THEN 0
			WHEN in_concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(in_destinations.special_price,FALSE) THEN coalesce(in_destinations.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=in_date AND sh_p.distance_to>=in_destinations.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(in_destinations.price,0))			
				END
				*
				CASE WHEN in_date < '2021-07-01' THEN
					CASE
						WHEN in_shipments.quant>=7 THEN in_shipments.quant
						WHEN in_destinations.distance<=60 THEN greatest(5,in_shipments.quant)
						ELSE 7
					END
				ELSE
					CASE
						WHEN in_shipments.quant>=7 THEN in_shipments.quant
						WHEN in_destinations.distance<=60 THEN 7
						ELSE 10
					END
				END	
		END)::numeric(15,2)
		,0)
	;
$$
  LANGUAGE sql VOLATILE --IMMUTABLE VOLATILE
  COST 100;
ALTER FUNCTION shipments_cost(destinations, int, date, shipments, bool) OWNER TO beton;



-- ******************* update 30/06/2021 12:29:20 ******************

	-- ********** Adding new table from model **********
	CREATE TABLE public.address_distances
	(hash  varchar(36) NOT NULL,address text NOT NULL,route  geometry,distance  numeric(15,2),CONSTRAINT address_distances_pkey PRIMARY KEY (hash)
	);
	ALTER TABLE public.address_distances OWNER TO beton;
		


-- ******************* update 30/06/2021 13:01:36 ******************
-- Function: gornyi_carrier_match_process()

-- DROP FUNCTION gornyi_carrier_match_process();

CREATE OR REPLACE FUNCTION gornyi_carrier_match_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN		
		IF NEW.carrier_id IS NOT NULL AND NEW.plate IS NOT NULL AND NEW.plate<>'' THEN
			UPDATE doc_material_procurements2
			SET 
				carrier_id = NEW.carrier_id
			WHERE vahicle_plate = NEW.plate;
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN		
	
		IF coalesce(NEW.plate,'') <> coalesce(OLD.plate,'') THEN
			RAISE EXCEPTION 'Запрещено менять номер ТС!';
		END IF;
	
		IF coalesce(NEW.carrier_id,0) <> coalesce(OLD.carrier_id,0)
		THEN
			UPDATE doc_material_procurements2
			SET 
				carrier_id = NEW.carrier_id
			WHERE vahicle_plate = NEW.plate;
		END IF;
		
		RETURN NEW;
		
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gornyi_carrier_match_process() OWNER TO beton;



-- ******************* update 30/06/2021 13:03:14 ******************
-- Trigger: gornyi_carrier_match_trigger_after

-- DROP TRIGGER gornyi_carrier_match_trigger_after ON public.gornyi_carrier_match;

CREATE TRIGGER gornyi_carrier_match_trigger_after
    AFTER INSERT OR UPDATE 
    ON public.gornyi_carrier_match
    FOR EACH ROW
    EXECUTE PROCEDURE public.gornyi_carrier_match_process();


-- ******************* update 30/06/2021 13:05:57 ******************
-- Function: gornyi_carrier_match_process()

-- DROP FUNCTION gornyi_carrier_match_process();

CREATE OR REPLACE FUNCTION gornyi_carrier_match_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN		
		IF NEW.carrier_id IS NOT NULL AND NEW.plate IS NOT NULL AND NEW.plate<>'' THEN
			UPDATE doc_material_procurements2
			SET 
				carrier_id = NEW.carrier_id
			WHERE vehicle_plate = NEW.plate;
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN		
	
		IF coalesce(NEW.plate,'') <> coalesce(OLD.plate,'') THEN
			RAISE EXCEPTION 'Запрещено менять номер ТС!';
		END IF;
	
		IF coalesce(NEW.carrier_id,0) <> coalesce(OLD.carrier_id,0)
		THEN
			UPDATE doc_material_procurements2
			SET 
				carrier_id = NEW.carrier_id
			WHERE vehicle_plate = NEW.plate;
		END IF;
		
		RETURN NEW;
		
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gornyi_carrier_match_process() OWNER TO beton;



-- ******************* update 02/07/2021 15:17:22 ******************
﻿-- Function: shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)

-- DROP FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric);

CREATE OR REPLACE FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)
  RETURNS numeric AS
$$
	SELECT
		CASE WHEN in_date >= '2021-07-01' THEN
			CASE
				WHEN in_quant>=5 THEN in_quant
				WHEN in_distance<=60 THEN greatest(7,in_quant)
				ELSE 10
			END
		ELSE
			CASE
				WHEN in_quant>=7 THEN in_quant
				WHEN in_distance<=60 THEN greatest(5,in_quant)
				ELSE 7
			END
		END
	;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric) OWNER TO beton;


-- ******************* update 02/07/2021 15:18:08 ******************
-- VIEW: shipments_for_veh_owner_list

--DROP VIEW shipments_for_veh_owner_list;

CREATE OR REPLACE VIEW shipments_for_veh_owner_list AS
	SELECT
		sh.id,
		sh.ship_date_time,
		sh.destination_id,
		sh.destinations_ref,
		sh.concrete_type_id,
		sh.concrete_types_ref,
		sh.quant,
		sh.vehicle_id,
		sh.vehicles_ref,
		sh.driver_id,
		sh.drivers_ref,
		sh.vehicle_owner_id,
		sh.vehicle_owners_ref,
		sh.cost,
		sh.ship_cost_edit,
		sh.pump_cost_edit,
		sh.demurrage,
		sh.demurrage_cost,
		sh.acc_comment,
		sh.acc_comment_shipment,
		sh.owner_agreed,
		sh.owner_agreed_date_time,
		
		CASE
		WHEN sh.destination_id = const_self_ship_dest_id_val() THEN 0
		WHEN coalesce(dest.price_for_driver,0)>0 THEN dest.price_for_driver*shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)
		ELSE
			(WITH
			act_price AS (
				SELECT h.date AS d
				FROM shipment_for_driver_costs_h h
				WHERE h.date<=sh.ship_date_time::date
				ORDER BY h.date DESC
				LIMIT 1
			)
			SELECT shdr_cost.price
			FROM shipment_for_driver_costs AS shdr_cost
			WHERE
				shdr_cost.date=(SELECT d FROM act_price)
				AND shdr_cost.distance_to>=dest.distance
				/*OR shdr_cost.id=(
					SELECT t.id
					FROM shipment_for_driver_costs t
					WHERE t.date=(SELECT d FROM act_price)
					ORDER BY t.distance_to LIMIT 1
				)
				*/
			ORDER BY shdr_cost.distance_to ASC
			LIMIT 1
			) * shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)
		END AS cost_for_driver
		
	FROM shipments_list sh
	LEFT JOIN destinations AS dest ON dest.id=destination_id
	ORDER BY ship_date_time DESC
	;
	
ALTER VIEW shipments_for_veh_owner_list OWNER TO beton;


-- ******************* update 02/07/2021 15:20:50 ******************
-- VIEW: shipments_for_client_list

--DROP VIEW shipments_for_client_list;

CREATE OR REPLACE VIEW shipments_for_client_list AS

	SELECT
		sh.order_id
		,o.client_id
		,get_shift_start(sh.ship_date_time)::date AS ship_date
		,o.destination_id
		,destinations_ref(dest)::text AS destinations_ref
		,o.concrete_type_id
		,concrete_types_ref(ct)::text AS concrete_types_ref
		,(o.pump_vehicle_id IS NOT NULL) AS pump_exists
		,sum(sh.quant) AS quant
		
		,sum( (SELECT pr.price FROM client_price_list(o.client_id,o.date_time) AS pr WHERE pr.concrete_type_id=o.concrete_type_id)*sh.quant ) AS concrete_cost
		
		,sum((CASE
			WHEN coalesce(sh.ship_cost_edit,FALSE) THEN sh.ship_cost
			WHEN dest.id=const_self_ship_dest_id_val() THEN 0
			WHEN o.concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(dest.price,0))			
				END
				*
				shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)			
		END)::numeric(15,2)
		) AS deliv_cost
		
		,(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0				
				WHEN (SELECT bool_or(coalesce(t.pump_for_client_cost_edit,FALSE)) FROM shipments t WHERE t.order_id=o.id)
					THEN (SELECT sum(coalesce(t.pump_for_client_cost,0)::numeric(15,2)) FROM shipments t WHERE t.order_id=o.id)
				--last ship only!!!
				ELSE
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(SELECT
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0)*o.quant
								END
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices,o.date_time)->'keys'->>'id')::int
								--pvh.pump_price_id
								AND o.quant<=pr_vals.quant_to
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1
							)::numeric(15,2)
					END
			END
		) AS pump_cost
		
		--concrete
		,sum( (SELECT pr.price FROM client_price_list(o.client_id,o.date_time) AS pr WHERE pr.concrete_type_id=o.concrete_type_id)*sh.quant )+
		--deliv
		sum((CASE
			WHEN coalesce(sh.ship_cost_edit,FALSE) THEN sh.ship_cost
			WHEN dest.id=const_self_ship_dest_id_val() THEN 0
			WHEN o.concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(dest.price,0))			
				END
				*
				shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)			
		END)::numeric(15,2))+
		--pump
		(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0				
				WHEN (SELECT bool_or(coalesce(t.pump_for_client_cost_edit,FALSE)) FROM shipments t WHERE t.order_id=o.id)
					THEN (SELECT sum(coalesce(t.pump_for_client_cost,0)::numeric(15,2)) FROM shipments t WHERE t.order_id=o.id)
				--last ship only!!!
				ELSE
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(SELECT
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0)*o.quant
								END
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices,o.date_time)->'keys'->>'id')::int
								--pvh.pump_price_id
								AND o.quant<=pr_vals.quant_to
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1
							)::numeric(15,2)
					END
			END
		)
		AS total_cost
		
		,clients_ref(cl) AS clients_ref
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id=sh.order_id
	LEFT JOIN destinations dest ON dest.id=o.destination_id
	LEFT JOIN concrete_types ct ON ct.id=o.concrete_type_id
	LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	WHERE cl.account_from_date IS NULL OR get_shift_start(sh.ship_date_time)>=cl.account_from_date
	GROUP BY 
		sh.order_id
		,o.id
		,o.date_time
		,o.client_id
		,get_shift_start(sh.ship_date_time)::date
		,o.destination_id
		,destinations_ref
		,o.concrete_type_id
		,concrete_types_ref
		,o.pump_vehicle_id
		,pvh.pump_prices
		,cl.*
	ORDER BY get_shift_start(sh.ship_date_time)::date DESC
	;
	
ALTER VIEW shipments_for_client_list OWNER TO beton;


-- ******************* update 02/07/2021 15:21:29 ******************
-- View: public.shipments_list

--DROP VIEW shipments_for_veh_owner_list;
--DROP VIEW shipment_dates_list;
--DROP VIEW public.shipments_list;

CREATE OR REPLACE VIEW public.shipments_list AS 
	SELECT
		sh.id,
		sh.ship_date_time,
		sh.quant,
		
		--shipments_cost(dest,o.concrete_type_id,o.date_time::date,sh,TRUE) AS cost,
		(CASE
			WHEN coalesce(sh.ship_cost_edit,FALSE) THEN sh.ship_cost
			WHEN dest.id=const_self_ship_dest_id_val() THEN 0
			WHEN o.concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(dest.price,0))			
				END
				*
				shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)
				/*
				CASE
					WHEN sh.quant>=7 THEN sh.quant
					WHEN dest.distance<=60 THEN greatest(5,sh.quant)
					ELSE 7
				END
				*/
		END)::numeric(15,2)
		AS cost,
		
		sh.shipped,
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
		
		shipments_demurrage_cost(sh.demurrage::interval) AS demurrage_cost,
		sh.demurrage,
		
		sh.client_mark,
		sh.blanks_exist,
		
		users_ref(u) As users_ref,
		o.user_id,
		
		production_sites_ref(ps) AS production_sites_ref,
		sh.production_site_id,
		
		--vehicle_owners_ref(v_own) AS vehicle_owners_ref,
		vehicle_owner_on_date(v.vehicle_owners,sh.date_time) AS vehicle_owners_ref,
		
		sh.acc_comment,
		sh.acc_comment_shipment,
		--v_own.id AS vehicle_owner_id,
		((vehicle_owner_on_date(v.vehicle_owners,sh.date_time))->'keys'->>'id')::int AS vehicle_owner_id,
		
		--shipments_pump_cost(sh,o,dest,pvh,TRUE) AS pump_cost,
		(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0
				WHEN coalesce(sh.pump_cost_edit,FALSE) THEN sh.pump_cost::numeric(15,2)
				--last ship only!!!
				WHEN sh.id = (SELECT this_ship.id FROM shipments AS this_ship WHERE this_ship.order_id=o.id ORDER BY this_ship.ship_date_time DESC LIMIT 1)
				THEN
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(SELECT
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0)*o.quant
								END
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices,sh.date_time)->'keys'->>'id')::int
								--pvh.pump_price_id
								AND o.quant<=pr_vals.quant_to
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1
							)::numeric(15,2)
					END
				ELSE 0	
			END
		) AS pump_cost,
		
		pump_vehicles_ref(pvh,pvh_v,pvh_own) AS pump_vehicles_ref,
		pvh.vehicle_id AS pump_vehicle_id,
		pvh_v.vehicle_owner_id AS pump_vehicle_owner_id,
		sh.owner_agreed,
		sh.owner_agreed_date_time,
		sh.owner_pump_agreed,
		sh.owner_pump_agreed_date_time,
		
		vehicle_owners_ref(pvh_own) AS pump_vehicle_owners_ref,
		
		CASE
			WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(dest.price,0))			
		END AS ship_price,
		
		coalesce(sh.ship_cost_edit,FALSE) AS ship_cost_edit,
		coalesce(sh.pump_cost_edit,FALSE) AS pump_cost_edit,
		
		sh.pump_for_client_cost_edit,
		(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0
				WHEN coalesce(sh.pump_for_client_cost_edit,FALSE) THEN sh.pump_for_client_cost::numeric(15,2)
				--last ship only!!!
				WHEN sh.id = (SELECT this_ship.id FROM shipments AS this_ship WHERE this_ship.order_id=o.id ORDER BY this_ship.ship_date_time DESC LIMIT 1)
				THEN
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(SELECT
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0)*o.quant
								END
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices,sh.date_time)->'keys'->>'id')::int
								--pvh.pump_price_id
								AND o.quant<=pr_vals.quant_to
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1
							)::numeric(15,2)
					END
				ELSE 0	
			END
		) AS pump_for_client_cost
		
		
	FROM shipments sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN vehicle_schedules vs ON vs.id = sh.vehicle_schedule_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN users u ON u.id = sh.user_id
	LEFT JOIN production_sites ps ON ps.id = sh.production_site_id
	LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
	LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
	LEFT JOIN vehicles pvh_v ON pvh_v.id = pvh.vehicle_id
	LEFT JOIN vehicle_owners pvh_own ON pvh_own.id = pvh_v.vehicle_owner_id
	ORDER BY sh.date_time DESC
	--LIMIT 60
	;

ALTER TABLE public.shipments_list OWNER TO beton;



-- ******************* update 02/07/2021 15:23:27 ******************
﻿-- Function: shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)

-- DROP FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric);

CREATE OR REPLACE FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)
  RETURNS numeric AS
$$
	SELECT
		CASE WHEN in_date >= '2021-07-01' THEN
			CASE
				WHEN in_quant>=5 THEN in_quant
				WHEN in_distance<=60 THEN greatest(5,in_quant)
				ELSE 7
			END
		ELSE
			CASE
				WHEN in_quant>=7 THEN in_quant
				WHEN in_distance<=60 THEN greatest(5,in_quant)
				ELSE 7
			END
		END
	;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric) OWNER TO beton;


-- ******************* update 02/07/2021 15:23:56 ******************
﻿-- Function: shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)

-- DROP FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric);

CREATE OR REPLACE FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)
  RETURNS numeric AS
$$
	SELECT
		CASE WHEN in_date >= '2021-07-01' THEN
			CASE
				WHEN in_quant>=5 THEN in_quant
				WHEN in_distance<=60 THEN greatest(7,in_quant)
				ELSE 10
			END
		ELSE
			CASE
				WHEN in_quant>=7 THEN in_quant
				WHEN in_distance<=60 THEN greatest(5,in_quant)
				ELSE 7
			END
		END
	;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric) OWNER TO beton;


-- ******************* update 02/07/2021 15:36:58 ******************
﻿-- Function: shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)

-- DROP FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric);

CREATE OR REPLACE FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric)
  RETURNS numeric AS
$$
	SELECT
		CASE WHEN in_date >= '2021-07-01' THEN
			CASE
				WHEN in_quant>=7 THEN in_quant
				WHEN in_distance<=60 THEN greatest(7,in_quant)
				ELSE 10
			END
		ELSE
			CASE
				WHEN in_quant>=7 THEN in_quant
				WHEN in_distance<=60 THEN greatest(5,in_quant)
				ELSE 7
			END
		END
	;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION shipments_quant_for_cost(in_date date, in_quant numeric,in_distance numeric) OWNER TO beton;


-- ******************* update 02/07/2021 17:34:18 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND TG_OP='INSERT' THEN
		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
		VALUES
		(NEW.point->>'client',
		to_timestamp(NEW.point->>'navigation_unix_time') At time zone 'utc',
		'0'|| substring(((NEW.point->>'longitude')::number*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::number*100)::text,1,9),
		NEW.point->>'speed'::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp(NEW.point->>'received_unix_time') At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::number,
		(NEW.point->>'latitude')::number
		);
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 02/07/2021 17:45:29 ******************

-- DROP TRIGGER egts_data_after ON public.egts_data;
CREATE TRIGGER egts_data_trigger_after AFTER INSERT
  ON public.egts_data
  FOR EACH ROW
  EXECUTE PROCEDURE public.egts_data_process();



-- ******************* update 02/07/2021 17:54:15 ******************

 DROP TRIGGER egts_data_trigger_after ON public.egts_data;
 /*
CREATE TRIGGER egts_data_trigger_after AFTER INSERT
  ON public.egts_data
  FOR EACH ROW
  EXECUTE PROCEDURE public.egts_data_process();
*/


-- ******************* update 03/07/2021 07:59:38 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND TG_OP='INSERT' THEN
		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
		VALUES
		(NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc',
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric
		)
		ON CONFLICT DO NOTHING;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 03/07/2021 07:59:53 ******************

-- DROP TRIGGER egts_data_trigger_after ON public.egts_data;

CREATE TRIGGER egts_data_trigger_after AFTER INSERT
  ON public.egts_data
  FOR EACH ROW
  EXECUTE PROCEDURE public.egts_data_process();
/*

		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)

	SELECT
		NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc',
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric	
	FROM egts_data AS NEW
	ON CONFLICT DO NOTHING
*/	


-- ******************* update 03/07/2021 08:11:19 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
		VALUES
		(NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc',
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric
		)
		ON CONFLICT DO NOTHING;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 05/07/2021 11:36:27 ******************
﻿-- Function: owner_price_list(in_client_id int, in_date timestamp)

-- DROP FUNCTION owner_price_list(in_client_id int, in_date timestamp);

CREATE OR REPLACE FUNCTION owner_price_list(in_client_id int, in_date timestamp)
  RETURNS TABLE(
  	concrete_type_id int,
  	price numeric(15,2)
  ) AS
$$
	SELECT
		t.concrete_type_id,
		t.price
	FROM concrete_costs_for_owner AS t
	WHERE t.header_id = (
		SELECT
			h.concrete_costs_for_owner_h_id
		FROM vehicle_owner_concrete_prices AS h
		WHERE in_client_id = h.client_id AND h.date<=in_date
		ORDER BY h.date DESC
		LIMIT 1
	)
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION owner_price_list(in_client_id int, in_date timestamp) OWNER TO beton;


-- ******************* update 05/07/2021 11:36:42 ******************
-- VIEW: shipments_for_client_list

--DROP VIEW shipments_for_client_list;

CREATE OR REPLACE VIEW shipments_for_client_list AS

	SELECT
		sh.order_id
		,o.client_id
		,get_shift_start(sh.ship_date_time)::date AS ship_date
		,o.destination_id
		,destinations_ref(dest)::text AS destinations_ref
		,o.concrete_type_id
		,concrete_types_ref(ct)::text AS concrete_types_ref
		,(o.pump_vehicle_id IS NOT NULL) AS pump_exists
		,sum(sh.quant) AS quant
		
		,sum( (SELECT pr.price FROM owner_price_list(o.client_id,o.date_time) AS pr WHERE pr.concrete_type_id=o.concrete_type_id)*sh.quant ) AS concrete_cost
		
		,sum((CASE
			WHEN coalesce(sh.ship_cost_edit,FALSE) THEN sh.ship_cost
			WHEN dest.id=const_self_ship_dest_id_val() THEN 0
			WHEN o.concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(dest.price,0))			
				END
				*
				shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)			
		END)::numeric(15,2)
		) AS deliv_cost
		
		,(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0				
				WHEN (SELECT bool_or(coalesce(t.pump_for_client_cost_edit,FALSE)) FROM shipments t WHERE t.order_id=o.id)
					THEN (SELECT sum(coalesce(t.pump_for_client_cost,0)::numeric(15,2)) FROM shipments t WHERE t.order_id=o.id)
				--last ship only!!!
				ELSE
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(SELECT
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0)*o.quant
								END
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices,o.date_time)->'keys'->>'id')::int
								--pvh.pump_price_id
								AND o.quant<=pr_vals.quant_to
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1
							)::numeric(15,2)
					END
			END
		) AS pump_cost
		
		--concrete
		,sum( (SELECT pr.price FROM client_price_list(o.client_id,o.date_time) AS pr WHERE pr.concrete_type_id=o.concrete_type_id)*sh.quant )+
		--deliv
		sum((CASE
			WHEN coalesce(sh.ship_cost_edit,FALSE) THEN sh.ship_cost
			WHEN dest.id=const_self_ship_dest_id_val() THEN 0
			WHEN o.concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(dest.price,0))			
				END
				*
				shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)			
		END)::numeric(15,2))+
		--pump
		(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0				
				WHEN (SELECT bool_or(coalesce(t.pump_for_client_cost_edit,FALSE)) FROM shipments t WHERE t.order_id=o.id)
					THEN (SELECT sum(coalesce(t.pump_for_client_cost,0)::numeric(15,2)) FROM shipments t WHERE t.order_id=o.id)
				--last ship only!!!
				ELSE
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(SELECT
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0)*o.quant
								END
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices,o.date_time)->'keys'->>'id')::int
								--pvh.pump_price_id
								AND o.quant<=pr_vals.quant_to
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1
							)::numeric(15,2)
					END
			END
		)
		AS total_cost
		
		,clients_ref(cl) AS clients_ref
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id=sh.order_id
	LEFT JOIN destinations dest ON dest.id=o.destination_id
	LEFT JOIN concrete_types ct ON ct.id=o.concrete_type_id
	LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	WHERE cl.account_from_date IS NULL OR get_shift_start(sh.ship_date_time)>=cl.account_from_date
	GROUP BY 
		sh.order_id
		,o.id
		,o.date_time
		,o.client_id
		,get_shift_start(sh.ship_date_time)::date
		,o.destination_id
		,destinations_ref
		,o.concrete_type_id
		,concrete_types_ref
		,o.pump_vehicle_id
		,pvh.pump_prices
		,cl.*
	ORDER BY get_shift_start(sh.ship_date_time)::date DESC
	;
	
ALTER VIEW shipments_for_client_list OWNER TO beton;


-- ******************* update 05/07/2021 11:43:29 ******************
-- VIEW: shipments_for_client_list

--DROP VIEW shipments_for_client_list;

CREATE OR REPLACE VIEW shipments_for_client_list AS

	SELECT
		sh.order_id
		,o.client_id
		,get_shift_start(sh.ship_date_time)::date AS ship_date
		,o.destination_id
		,destinations_ref(dest)::text AS destinations_ref
		,o.concrete_type_id
		,concrete_types_ref(ct)::text AS concrete_types_ref
		,(o.pump_vehicle_id IS NOT NULL) AS pump_exists
		,sum(sh.quant) AS quant
		
		,sum(
			coalesce(
				(SELECT pr.price FROM owner_price_list(o.client_id,o.date_time) AS pr WHERE pr.concrete_type_id=o.concrete_type_id)
				,(SELECT pr.price FROM client_price_list(o.client_id,o.date_time) AS pr WHERE pr.concrete_type_id=o.concrete_type_id)
			)
			*sh.quant
		) AS concrete_cost
		
		,sum((CASE
			WHEN coalesce(sh.ship_cost_edit,FALSE) THEN sh.ship_cost
			WHEN dest.id=const_self_ship_dest_id_val() THEN 0
			WHEN o.concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(dest.price,0))			
				END
				*
				shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)			
		END)::numeric(15,2)
		) AS deliv_cost
		
		,(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0				
				WHEN (SELECT bool_or(coalesce(t.pump_for_client_cost_edit,FALSE)) FROM shipments t WHERE t.order_id=o.id)
					THEN (SELECT sum(coalesce(t.pump_for_client_cost,0)::numeric(15,2)) FROM shipments t WHERE t.order_id=o.id)
				--last ship only!!!
				ELSE
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(SELECT
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0)*o.quant
								END
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices,o.date_time)->'keys'->>'id')::int
								--pvh.pump_price_id
								AND o.quant<=pr_vals.quant_to
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1
							)::numeric(15,2)
					END
			END
		) AS pump_cost
		
		--concrete
		,sum( (SELECT pr.price FROM client_price_list(o.client_id,o.date_time) AS pr WHERE pr.concrete_type_id=o.concrete_type_id)*sh.quant )+
		--deliv
		sum((CASE
			WHEN coalesce(sh.ship_cost_edit,FALSE) THEN sh.ship_cost
			WHEN dest.id=const_self_ship_dest_id_val() THEN 0
			WHEN o.concrete_type_id=12 THEN const_water_ship_cost_val()
			ELSE
				CASE
					WHEN coalesce(dest.special_price,FALSE) THEN coalesce(dest.price,0)
					ELSE
					coalesce(
						(SELECT sh_p.price
						FROM shipment_for_owner_costs sh_p
						WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
						ORDER BY sh_p.date DESC,sh_p.distance_to ASC
						LIMIT 1
						),			
					coalesce(dest.price,0))			
				END
				*
				shipments_quant_for_cost(sh.ship_date_time::date,sh.quant::numeric,dest.distance::numeric)			
		END)::numeric(15,2))+
		--pump
		(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0				
				WHEN (SELECT bool_or(coalesce(t.pump_for_client_cost_edit,FALSE)) FROM shipments t WHERE t.order_id=o.id)
					THEN (SELECT sum(coalesce(t.pump_for_client_cost,0)::numeric(15,2)) FROM shipments t WHERE t.order_id=o.id)
				--last ship only!!!
				ELSE
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(SELECT
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0)*o.quant
								END
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices,o.date_time)->'keys'->>'id')::int
								--pvh.pump_price_id
								AND o.quant<=pr_vals.quant_to
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1
							)::numeric(15,2)
					END
			END
		)
		AS total_cost
		
		,clients_ref(cl) AS clients_ref
		
	FROM shipments AS sh
	LEFT JOIN orders o ON o.id=sh.order_id
	LEFT JOIN destinations dest ON dest.id=o.destination_id
	LEFT JOIN concrete_types ct ON ct.id=o.concrete_type_id
	LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	WHERE cl.account_from_date IS NULL OR get_shift_start(sh.ship_date_time)>=cl.account_from_date
	GROUP BY 
		sh.order_id
		,o.id
		,o.date_time
		,o.client_id
		,get_shift_start(sh.ship_date_time)::date
		,o.destination_id
		,destinations_ref
		,o.concrete_type_id
		,concrete_types_ref
		,o.pump_vehicle_id
		,pvh.pump_prices
		,cl.*
	ORDER BY get_shift_start(sh.ship_date_time)::date DESC
	;
	
ALTER VIEW shipments_for_client_list OWNER TO beton;


-- ******************* update 05/07/2021 12:35:51 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
		VALUES
		(NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc' + '1 hour'::interval,
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric
		)
		ON CONFLICT DO NOTHING;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 05/07/2021 12:46:59 ******************

					ALTER TYPE sms_types ADD VALUE 'order_cancel';
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_sms_types_val(sms_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='order'::sms_types AND $2='ru'::locales THEN 'заявка'
		WHEN $1='ship'::sms_types AND $2='ru'::locales THEN 'отгрузка'
		WHEN $1='remind'::sms_types AND $2='ru'::locales THEN 'напоминание'
		WHEN $1='procur'::sms_types AND $2='ru'::locales THEN 'поставка'
		WHEN $1='order_for_pump_ins'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (новая)'
		WHEN $1='order_for_pump_upd'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (изменена)'
		WHEN $1='order_for_pump_del'::sms_types AND $2='ru'::locales THEN 'заявка для насоса (удалена)'
		WHEN $1='remind_for_pump'::sms_types AND $2='ru'::locales THEN 'напоминание для насоса'
		WHEN $1='client_thank'::sms_types AND $2='ru'::locales THEN 'благодарность клиенту'
		WHEN $1='vehicle_zone_violation'::sms_types AND $2='ru'::locales THEN 'Въезд в запрещенную зону'
		WHEN $1='vehicle_tracker_malfunction'::sms_types AND $2='ru'::locales THEN 'Нерабочий трекер'
		WHEN $1='efficiency_warn'::sms_types AND $2='ru'::locales THEN 'Низская эффективность'
		WHEN $1='material_balance'::sms_types AND $2='ru'::locales THEN 'Остатки материалов'
		WHEN $1='mixer_route'::sms_types AND $2='ru'::locales THEN 'Маршрут для миксериста'
		WHEN $1='order_cancel'::sms_types AND $2='ru'::locales THEN 'Отмена заявки'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_sms_types_val(sms_types,locales) OWNER TO beton;		
		

-- ******************* update 05/07/2021 16:16:24 ******************
-- FUNCTION: public.set_vehicle_free()

-- DROP FUNCTION public.set_vehicle_free();

CREATE OR REPLACE FUNCTION public.set_vehicle_free()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

	DELETE FROM vehicle_route_cashe WHERE shipment_id = OLD.id;
	
	DELETE FROM vehicle_schedule_states WHERE shipment_id = OLD.id;
	
	--log
	PERFORM doc_log_delete('shipment'::doc_types,OLD.id);

	--register actions
	PERFORM ra_materials_remove_acts('shipment'::doc_types,OLD.id);
	PERFORM ra_material_consumption_remove_acts('shipment'::doc_types,OLD.id);
	
	RETURN OLD;
END;
$BODY$;

ALTER FUNCTION public.set_vehicle_free()
    OWNER TO beton;

--GRANT EXECUTE ON FUNCTION public.set_vehicle_free() TO ;



-- ******************* update 08/07/2021 05:55:16 ******************

		ALTER TABLE public.orders ADD COLUMN ext_prodution bool
			DEFAULT FALSE;



-- ******************* update 08/07/2021 05:56:18 ******************
		ALTER TABLE public.orders DROP COLUMN ext_prodution;

		ALTER TABLE public.orders ADD COLUMN ext_production bool
			DEFAULT FALSE;



-- ******************* update 08/07/2021 05:56:57 ******************
-- View: public.orders_dialog

-- DROP VIEW public.orders_dialog;

CREATE OR REPLACE VIEW public.orders_dialog AS 
	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN coalesce(d.price,0)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		o.descr,
		o.phone_cel,
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production
		
	FROM orders o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	ORDER BY o.date_time;

ALTER TABLE public.orders_dialog OWNER TO beton;



-- ******************* update 08/07/2021 12:29:01 ******************
-- Function: geo_zone_check()

-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	v_zone geometry;
	v_st_date_time timestamp without time zone;
	
	v_lon_min float;
	v_lon_max float;
	v_lat_min float;
	v_lat_max float;
	
	v_car_rec RECORD;	
	v_true_point boolean;
	v_control_in boolean;
	v_new_state vehicle_states;
	v_point_in_zone boolean;

	veh_not_on_route bool;
	v_client_route_done bool;
	v_cashe_route geometry;	
	v_current_point geometry;
	v_hypothetical_route_rest geometry;
	v_hypothetical_route_rest_t text;
	v_hypothetical_route_rest_len int;
	v_long_route_rest bool;

	V_SRID int;
	v_deviation_for_reroute_m int;
	v_deviation_pt_count int;
BEGIN
	--RETURN NEW;
	V_SRID = 0;
	SELECT d1::date INTO v_tracker_date FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
	
	FROM vehicle_schedule_states AS st
	WHERE st.tracker_id=NEW.car_id AND st.date_time::date = v_tracker_date
	ORDER BY st.date_time DESC
	LIMIT 1;

	--controled states only
	IF (v_cur_state='busy'::vehicle_states)
	OR (v_cur_state='at_dest'::vehicle_states)
	OR (v_cur_state='left_for_base'::vehicle_states)
	THEN
		-- Случай: едет на базу, а сам на объекте, т.е. ложное срабатывание, выехал с объекта, а потом снова вернулся
		-- direction to controle
		IF (v_cur_state='busy'::vehicle_states)
		OR (v_cur_state='left_for_base'::vehicle_states) THEN
			v_control_in = true;
		ELSE
			v_control_in = false;--controling out
		END IF;
		
		--coords to control
		IF (v_cur_state='busy'::vehicle_states) THEN
			--clients zone on shipment
			SELECT destinations.id,
				destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_destination_id,v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id=shipments.order_id
			LEFT JOIN destinations ON destinations.id=orders.destination_id
			WHERE shipments.id = v_shipment_id;

		ELSE
			-- base zone OR clients zone from state
			SELECT destinations.lon_min, destinations.lon_max,
				destinations.lat_min, destinations.lat_max,
				destinations.zone
			INTO v_lon_min,v_lon_max,v_lat_min,v_lat_max,v_zone
			FROM destinations
			WHERE destinations.id =
				CASE v_cur_state
					WHEN 'at_dest'::vehicle_states THEN v_destination_id
					ELSE constant_base_geo_zone_id()
				END;
		END IF;		

		
		--v_point_in_zone = (NEW.lon>=v_lon_min) AND (NEW.lon<=v_lon_max) AND (NEW.lat>=v_lat_min) AND (NEW.lat<=v_lat_max);
		--4326
		v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID));
		
		IF (v_control_in AND v_point_in_zone)
		OR (v_control_in=FALSE AND v_point_in_zone=FALSE) THEN
			v_true_point = TRUE;
		ELSE
			v_true_point = FALSE;
		END IF;
		IF v_true_point THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326
				v_point_in_zone = st_contains(v_zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				
				v_true_point = (v_control_in AND v_point_in_zone)
					OR (v_control_in=FALSE AND v_point_in_zone=FALSE);
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;

			IF v_true_point THEN
				--current position is inside/outside zone
				IF (v_cur_state='busy'::vehicle_states) THEN
					v_new_state = 'at_dest'::vehicle_states;
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id,destination_id,shipment_id)
					VALUES (CURRENT_TIMESTAMP,v_schedule_id,v_new_state,NEW.car_id,v_destination_id,v_shipment_id);
				END IF;
			END IF;
		END IF;
	END IF;
	
	--*** КОНТРОЛЬ ЗАПРЕЩЕННЫХ ЗОН!!! ****
	INSERT INTO sms_for_sending
		(tel, body, sms_type,event_key)
	(WITH
	zone_viol AS (
		SELECT
			string_agg(sms_text.body,',') AS body
		FROM
		(
		SELECT
			sms_templates_text(
				ARRAY[
					ROW('plate',(SELECT plate::text FROM vehicles WHERE tracker_id=NEW.car_id))::template_value,
					ROW('zone',dest.name::text)::template_value,
					ROW('date_time',to_char(now(),'DD/MM/YY HH24:MI'))::template_value
				],
				(SELECT pattern FROM sms_patterns WHERE sms_type='vehicle_zone_violation')
			) AS body	
		FROM
		(	SELECT
				zone_contains.zone_id,
				bool_and(zone_contains.inside_zone) AS inside_zone
			FROM
			(SELECT
				destinations.id AS zone_id,
				st_contains(
					destinations.zone,
					ST_GeomFromText('POINT('||last_pos.lon::text||' '||last_pos.lat::text||')', 0)
				) AS inside_zone
		
			FROM tracker_zone_controls
			LEFT JOIN destinations ON destinations.id=tracker_zone_controls.destination_id
			CROSS JOIN (
				SELECT
					tr.lon,tr.lat
				FROM car_tracking AS tr
				WHERE tr.car_id = NEW.car_id AND tr.gps_valid=1 --16/09/20!!!
				--(SELECT tracker_id FROM vehicles WHERE plate='864')
				ORDER BY tr.period DESC
				LIMIT const_geo_zone_check_points_count_val()	
			) AS last_pos
			) AS zone_contains	
			GROUP BY zone_contains.zone_id
		) AS zone_check	
		LEFT JOIN destinations AS dest ON dest.id=zone_check.zone_id
		WHERE zone_check.inside_zone
		) AS sms_text
		WHERE NOT exists (
			SELECT sms.id
			FROM sms_for_sending sms
			WHERE sms.event_key=NEW.car_id
				AND (now()::timestamp-sms.date_time)<=const_zone_violation_alarm_interval_val()
				AND sms.sms_type='vehicle_zone_violation'
			)
	)
	SELECT 
		us.phone_cel,
		(SELECT zone_viol.body FROM zone_viol) AS body,
		'vehicle_zone_violation',
		NEW.car_id

	FROM sms_pattern_user_phones AS u
	LEFT JOIN sms_patterns AS p ON p.id=u.sms_pattern_id
	LEFT JOIN users AS us ON us.id=u.user_id
	WHERE p.sms_type='vehicle_zone_violation' AND (SELECT zone_viol.body FROM zone_viol) IS NOT NULL
	);

	IF NEW.gps_valid = 1 THEN
--https://gist.github.com/rdeguzman/99e7fce88458aca678f52bf1a876d36a	
--transformations
		IF v_shipment_id IS NOT NULL
		AND (v_cur_state='left_for_dest'::vehicle_states
			OR (v_cur_state='left_for_base'::vehicle_states)
			OR (v_cur_state='busy'::vehicle_states)
			
			-- В этом случае маршрут не перестраиваем, но убираем пройденное
			OR (v_cur_state='at_dest'::vehicle_states)
		)
		
		THEN		
			-- route in cashe
			SELECT
				csh.route_line
				,csh.client_route_done
			INTO
				v_cashe_route
				,v_client_route_done
			FROM vehicle_route_cashe AS csh
			WHERE csh.shipment_id = v_shipment_id
				AND csh.vehicle_state = 
					CASE
						--v_cur_state='at_dest' OR 
						WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
						ELSE 'left_for_dest'::vehicle_states
					END
				AND csh.tracker_id = NEW.car_id
			;
		/*IF NEW.car_id='1026605398' THEN
			RAISE EXCEPTION 'v_shipment_id=%, v_cur_state=%',v_shipment_id,v_cur_state;
		END IF;*/
			
			IF v_cashe_route IS NOT NULL AND coalesce(v_client_route_done,FALSE) = FALSE THEN
				
				-- В зоне завода
				v_point_in_zone = FALSE;
							
				IF v_cur_state='busy'::vehicle_states THEN
					--If state is busy and current point is inside base zone, then skeep all farther checkings!
					SELECT 
						st_contains(
							destinations.zone,
							ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)
						)
					INTO v_point_in_zone
					FROM destinations
					WHERE destinations.id = constant_base_geo_zone_id()
					;
					
				ELSIF v_cur_state = 'at_dest'::vehicle_states THEN
					-- Необходимо определить конец маршрута
					-- если последние X минут скорость<X
					-- 1) генерим событие конца маршрута,
					-- 2) закрываем сессию клиента
					-- 3) если надо обновляем координаты места разгрузки
					-- PERFORM pg_notify('Vehicle.route_end.'||NEW.car_id, NULL);
					-- Если последняя точка со скоростью>3 дальше 10 минут
					SELECT
						now() - (tr.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone))
						> '00:10:00'::interval
					INTO v_client_route_done
					FROM car_tracking AS tr
					WHERE
						tr.car_id = NEW.car_id
						--AND tr.gps_valid=1
						AND tr.speed>3
					ORDER BY tr.period DESC
					LIMIT 1;

					-- тек - предыдущая > 10 минут
					IF v_client_route_done = FALSE THEN
						SELECT
							NEW.period - tr.period >= '00:10:00'::interval
						INTO v_client_route_done
						FROM car_tracking AS tr
						WHERE
							tr.car_id = NEW.car_id
							--AND tr.gps_valid=1
						ORDER BY tr.period DESC
						LIMIT 1 OFFSET 1;
					
					END IF;
					
					IF v_client_route_done THEN
						-- insert/update unload site
						SELECT o.client_id INTO v_client_id
						FROM orders AS o
						WHERE o.id = (SELECT order_id FROM shipments WHERE id=v_shipment_id);
						
						/*v_point_in_zone = FALSE;
						SELECT
							st_contains(
								st_transform(
									st_buffer(
										st_transform(
											ST_GeomFromText('POINT('||cl_dest.lon::text||' '||cl_dest.lat::text||')', 4326)
											,3857
										)
										,30
									)
								,4326),
								ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', 4326)
							)
						INTO v_point_in_zone	
						FROM client_destinations As cl_dest	
						WHERE
							cl_dest.client_id = v_client_id
							AND cl_dest.destination_id = v_destination_id;
						
						IF coalesce(v_point_in_zone,FALSE) = FALSE THEN
						END IF;
						*/
						
						INSERT INTO client_destinations
						(client_id,destination_id,lon,lat)
						VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
						ON CONFLICT (client_id,destination_id) DO UPDATE SET
							lon = NEW.lon,
							lat = NEW.lat
						;
						
						--route done
						UPDATE vehicle_route_cashe
						SET client_route_done = TRUE
						WHERE shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
							
						UPDATE logins SET date_time_out = now() WHERE pub_key = v_shipment_id::text;
							
					END IF;
					
				END IF;
				
				IF v_cur_state<>'busy'::vehicle_states OR v_point_in_zone=FALSE THEN
					-- не на заводе
					
					v_current_point = ST_GeomFromText('POINT('|| NEW.lon ||' '|| NEW.lat ||')', 4326);
					WITH			
					--constants
					reroute AS (
						SELECT
							(v->>'distance_m')::int AS distance_m
							,(v->>'points_cnt')::int AS points_cnt
						FROM const_deviation_for_reroute_val() AS v
					)
					SELECT
						--current point is NOT within allowed distance
						(					
							ST_Distance(
								st_transform(v_current_point,3857)
								,st_transform(v_cashe_route,3857)
							) > (SELECT distance_m FROM reroute)
						)
						AND
						
						--previous X points are NOT within allowed distance
						(SELECT					
							bool_and(prev_points.veh_not_on_route)
						FROM (SELECT
								ST_Distance(
									st_transform(st_geomFromText('POINT('|| tr.lon ||' '|| tr.lat ||')', 4326),3857)
									,st_transform(v_cashe_route,3857)
								) > (SELECT distance_m FROM reroute)
								AS veh_not_on_route
							FROM car_tracking AS tr
							WHERE tr.car_id = NEW.car_id AND tr.gps_valid = 1
							ORDER BY period DESC
							LIMIT (SELECT points_cnt FROM reroute)-1		
						) AS prev_points
						)
						
					INTO veh_not_on_route;

					IF coalesce(veh_not_on_route,FALSE)=TRUE THEN
						--rebuild!
						UPDATE vehicle_route_cashe
						SET
							route = NULL,
							update_dt = now(),
							update_cnt = update_cnt + 1
						WHERE
							shipment_id = v_shipment_id
							AND vehicle_state = 
								CASE
									--v_cur_state='at_dest' OR 
									WHEN v_cur_state='left_for_base' THEN 'left_for_base'::vehicle_states
									ELSE 'left_for_dest'::vehicle_states
								END
							AND tracker_id = NEW.car_id;
						
						PERFORM pg_notify(
							'Vehicle.rebuild_route'
							,json_build_object(
								'params',json_build_object(								
									'tracker_id',NEW.car_id
									,'shipment_id',v_shipment_id
									,'vehicle_state',
									CASE
										--v_cur_state='at_dest' OR 
										WHEN v_cur_state='left_for_base' THEN 'left_for_base'
										ELSE 'left_for_dest'
									END
								)
							)::text
						);
					ELSE
						-- vehicle is following route								
						-- send route from current point to the end with notification
						v_hypothetical_route_rest = ST_LineSubstring(
							v_cashe_route
							,ST_LineLocatePoint(
								v_cashe_route,
								ST_ClosestPoint(
								 	v_cashe_route,
								 	v_current_point
								)							 
							)
							,1
						);
						v_hypothetical_route_rest_t = ST_AsText(v_hypothetical_route_rest);
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'LINESTRING(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'MULTI(','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'GEOMETRYCOLLECTION','');
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,')','');						
						v_hypothetical_route_rest_t = replace(v_hypothetical_route_rest_t,'(','');						
						
						v_hypothetical_route_rest_len = ST_Length(ST_Transform(v_hypothetical_route_rest, 3857));
						
					END IF;

				END IF;	
			END IF;			
		END IF;
			
		SELECT (length(v_hypothetical_route_rest_t)>7500) INTO v_long_route_rest;
		IF v_long_route_rest THEN
			INSERT INTO route_rests VALUES(NEW.car_id,v_hypothetical_route_rest_t)
			ON CONFLICT (tracker_id) DO UPDATE SET
			route_rest = v_hypothetical_route_rest_t;
		END IF;
		
		--returns vehicles_last_pos struc + route
		BEGIN
			PERFORM pg_notify(
				'Vehicle.position.'||NEW.car_id
				,json_build_object(
					'params',json_build_object(
						'tracker_id',NEW.car_id
						,'lon',NEW.lon
						,'lat',NEW.lat
						,'heading',NEW.heading
						,'speed',NEW.speed
						,'period',NEW.period+age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'ns',NEW.ns
						,'ew',NEW.ew
						,'recieved_dt',NEW.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
						,'odometer',NEW.odometer::text
						,'voltage',round(NEW.voltage,0)
						,'route_rest',CASE WHEN v_long_route_rest THEN NULL ELSE v_hypothetical_route_rest_t END
						,'long_route_rest',v_long_route_rest
						,'route_rest_len',v_hypothetical_route_rest_len
					)
				)::text
			);
		EXCEPTION WHEN OTHERS THEN
		END;
	END IF;
		
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION geo_zone_check()
  OWNER TO beton;



-- ******************* update 08/07/2021 14:48:04 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
		VALUES
		(NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc', -- + '1 hour'::interval
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric
		)
		ON CONFLICT DO NOTHING;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 08/07/2021 15:09:22 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
		VALUES
		(NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc', -- + '1 hour'::interval
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric
		)
		ON CONFLICT DO NOTHING;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 08/07/2021 15:16:31 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
		VALUES
		(NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc'- '1 hour'::interval,
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric
		)
		ON CONFLICT DO NOTHING;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 08/07/2021 15:20:13 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
		VALUES
		(NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc' - '1 hour'::interval,
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric
		)
		ON CONFLICT DO NOTHING;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 08/07/2021 15:43:00 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		
		IF NEW.point->>'longitude'<>'0' AND NEW.point->>'latitude'<>'0' THEN
			INSERT INTO car_tracking
			(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
			VALUES
			(NEW.point->>'client',
			to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc' - '1 hour'::interval,
			'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
			substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
			(NEW.point->>'speed')::numeric,
			CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
			CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
			0,
			(NEW.point->>'course')::int,
			to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
			1,
			(NEW.point->>'longitude')::numeric,
			(NEW.point->>'latitude')::numeric
			)
			ON CONFLICT DO NOTHING;
		END IF;
				
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 08/07/2021 15:44:19 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		
		IF NEW.point->>'longitude'<>'0' AND NEW.point->>'latitude'<>'0' THEN
			INSERT INTO car_tracking
			(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
			VALUES
			(NEW.point->>'client',
			to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc', -- - '1 hour'::interval
			'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
			substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
			(NEW.point->>'speed')::numeric,
			CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
			CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
			0,
			(NEW.point->>'course')::int,
			to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
			1,
			(NEW.point->>'longitude')::numeric,
			(NEW.point->>'latitude')::numeric
			)
			ON CONFLICT DO NOTHING;
		END IF;
				
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 08/07/2021 15:45:02 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		
		IF NEW.point->>'longitude'<>'0' AND NEW.point->>'latitude'<>'0' THEN
			INSERT INTO car_tracking
			(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
			VALUES
			(NEW.point->>'client',
			to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc', -- - '1 hour'::interval
			'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
			substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
			(NEW.point->>'speed')::numeric,
			CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
			CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
			0,
			(NEW.point->>'course')::int,
			to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
			1,
			(NEW.point->>'longitude')::numeric,
			(NEW.point->>'latitude')::numeric
			)
			ON CONFLICT DO NOTHING;
		END IF;
				
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 08/07/2021 15:45:11 ******************

-- DROP TRIGGER egts_data_trigger_after ON public.egts_data;

CREATE TRIGGER egts_data_trigger_after AFTER INSERT
  ON public.egts_data
  FOR EACH ROW
  EXECUTE PROCEDURE public.egts_data_process();
/*

		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)

	SELECT
		NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc',
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric	
	FROM egts_data AS NEW
	WHERE NEW.point->>'longitude'<>'0' AND NEW.point->>'latitude'<>'0'
	ON CONFLICT DO NOTHING
	
	SELECT
		NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) + '1 hour'::interval,
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int),
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric	
	FROM egts_data AS NEW
	ORDER BY (NEW.point->>'navigation_unix_time')::int DESC LIMIT 100	
*/	


-- ******************* update 08/07/2021 15:47:21 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		
		IF NEW.point->>'longitude'<>'0' AND NEW.point->>'latitude'<>'0' THEN
			INSERT INTO car_tracking
			(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
			VALUES
			(NEW.point->>'client',
			to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc' + '1 hour'::interval,
			'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
			substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
			(NEW.point->>'speed')::numeric,
			CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
			CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
			0,
			(NEW.point->>'course')::int,
			to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
			1,
			(NEW.point->>'longitude')::numeric,
			(NEW.point->>'latitude')::numeric
			)
			ON CONFLICT DO NOTHING;
		END IF;
				
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;



-- ******************* update 08/07/2021 17:59:42 ******************
-- Function: public.vehicle_run_inf_on_schedule(integer)

DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(IN in_schedule_id integer)
  RETURNS TABLE(
  	st_free_start timestamp without time zone,
  	st_assigned timestamp without time zone,
  	st_shipped timestamp without time zone,
  	st_at_dest timestamp without time zone,
  	st_left_for_base timestamp without time zone,
  	st_free_end timestamp without time zone,
  	destinations_ref json,
  	run_time timestamp without time zone,
  	veh_id integer
  	) AS
$BODY$
DECLARE st_row RECORD;
	v_run_started boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
			
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started THEN
			st_shipped = st_row.date_time;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states OR st_row.state='assigned'::vehicle_states)
		AND (v_run_started=false) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			IF st_row.state='assigned'::vehicle_states THEN
				st_assigned = st_row.date_time;
				IF (st_row.shipment_id>0) THEN
					SELECT
						destinations_ref(destinations) INTO destinations_ref
					FROM shipments
					LEFT JOIN orders ON orders.id=shipments.order_id
					LEFT JOIN destinations ON destinations.id=orders.destination_id
					WHERE shipments.id=st_row.shipment_id;
				END IF;			
			END IF;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;
			
		ELSIF (st_row.state='free'::vehicle_states)
		AND (v_run_started) THEN
			IF destinations_ref IS NOT NULL THEN
				st_free_end = st_row.date_time;
				run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
				RETURN NEXT;
			END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;			
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
  OWNER TO beton;



-- ******************* update 08/07/2021 18:06:47 ******************
-- Function: public.vehicle_run_inf_on_schedule(integer)

--DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(IN in_schedule_id integer)
  RETURNS TABLE(
  	st_free_start timestamp without time zone,
  	st_assigned timestamp without time zone,
  	st_shipped timestamp without time zone,
  	st_at_dest timestamp without time zone,
  	st_left_for_base timestamp without time zone,
  	st_free_end timestamp without time zone,
  	destinations_ref json,
  	run_time timestamp without time zone,
  	veh_id integer
  	) AS
$BODY$
DECLARE st_row RECORD;
	v_run_started boolean;
	v_run_assigned boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started AND NOT v_run_assigned THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
					
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started THEN
			st_shipped = st_row.date_time;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states OR st_row.state='assigned'::vehicle_states)
		AND (v_run_started=FALSE) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			IF st_row.state='assigned'::vehicle_states THEN
				st_assigned = st_row.date_time;
				IF (st_row.shipment_id>0) THEN
					SELECT
						destinations_ref(destinations) INTO destinations_ref
					FROM shipments
					LEFT JOIN orders ON orders.id=shipments.order_id
					LEFT JOIN destinations ON destinations.id=orders.destination_id
					WHERE shipments.id=st_row.shipment_id;
				END IF;			
			END IF;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = TRUE;
			v_run_assigned = FALSE;
			
		ELSIF (st_row.state='free'::vehicle_states AND v_run_started)
		OR st_row.state='assigned'::vehicle_states AND v_run_assigned
		THEN
			--IF destinations_ref IS NOT NULL THEN
			--previous run
			st_free_end = st_row.date_time;
			run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
			RETURN NEXT;
			--END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = TRUE;	
			v_run_assigned = FALSE;		
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
  OWNER TO beton;



-- ******************* update 08/07/2021 18:11:39 ******************
-- Function: public.vehicle_run_inf_on_schedule(integer)

--DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(IN in_schedule_id integer)
  RETURNS TABLE(
  	st_free_start timestamp without time zone,
  	st_assigned timestamp without time zone,
  	st_shipped timestamp without time zone,
  	st_at_dest timestamp without time zone,
  	st_left_for_base timestamp without time zone,
  	st_free_end timestamp without time zone,
  	destinations_ref json,
  	run_time timestamp without time zone,
  	veh_id integer
  	) AS
$BODY$
DECLARE st_row RECORD;
	v_run_started boolean;
	v_run_assigned boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started AND NOT v_run_assigned THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
					
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started THEN
			st_shipped = st_row.date_time;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states OR st_row.state='assigned'::vehicle_states)
		AND (v_run_started=FALSE) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			IF st_row.state='assigned'::vehicle_states THEN
				st_assigned = st_row.date_time;
				IF (st_row.shipment_id>0) THEN
					SELECT
						destinations_ref(destinations) INTO destinations_ref
					FROM shipments
					LEFT JOIN orders ON orders.id=shipments.order_id
					LEFT JOIN destinations ON destinations.id=orders.destination_id
					WHERE shipments.id=st_row.shipment_id;
				END IF;			
			END IF;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = TRUE;
			v_run_assigned = FALSE;
			
		ELSIF (st_row.state='free'::vehicle_states AND v_run_started)
		OR st_row.state='assigned'::vehicle_states AND v_run_assigned
		THEN
			--IF destinations_ref IS NOT NULL THEN
			--previous run
			IF st_row.state='assigned'::vehicle_states THEN
				st_assigned = st_row.date_time;
				IF st_row.shipment_id>0 AND destinations_ref IS NULL THEN
					SELECT
						destinations_ref(destinations) INTO destinations_ref
					FROM shipments
					LEFT JOIN orders ON orders.id=shipments.order_id
					LEFT JOIN destinations ON destinations.id=orders.destination_id
					WHERE shipments.id=st_row.shipment_id;
				END IF;			
			END IF;
			st_free_end = st_row.date_time;
			run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
			RETURN NEXT;
			--END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = TRUE;	
			v_run_assigned = FALSE;		
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
  OWNER TO beton;



-- ******************* update 08/07/2021 18:16:29 ******************
-- Function: public.vehicle_run_inf_on_schedule(integer)

--DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(IN in_schedule_id integer)
  RETURNS TABLE(
  	st_free_start timestamp without time zone,
  	st_assigned timestamp without time zone,
  	st_shipped timestamp without time zone,
  	st_at_dest timestamp without time zone,
  	st_left_for_base timestamp without time zone,
  	st_free_end timestamp without time zone,
  	destinations_ref json,
  	run_time timestamp without time zone,
  	veh_id integer
  	) AS
$BODY$
DECLARE st_row RECORD;
	v_run_started boolean;
	v_run_assigned boolean;
	v_run_busy boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started AND NOT v_run_assigned THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
					
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started AND NOT v_run_busy THEN
			st_shipped = st_row.date_time;
			v_run_busy = TRUE;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states OR st_row.state='assigned'::vehicle_states)
		AND (v_run_started=FALSE) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			IF st_row.state='assigned'::vehicle_states THEN
				st_assigned = st_row.date_time;
				IF (st_row.shipment_id>0) THEN
					SELECT
						destinations_ref(destinations) INTO destinations_ref
					FROM shipments
					LEFT JOIN orders ON orders.id=shipments.order_id
					LEFT JOIN destinations ON destinations.id=orders.destination_id
					WHERE shipments.id=st_row.shipment_id;
				END IF;			
			END IF;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = TRUE;
			v_run_assigned = FALSE;
			v_run_busy = FALSE;
			
		ELSIF (st_row.state='free'::vehicle_states AND v_run_started)
		OR st_row.state='assigned'::vehicle_states AND v_run_assigned
		OR st_row.state='busy'::vehicle_states AND v_run_busy
		THEN
			--IF destinations_ref IS NOT NULL THEN
			--previous run
			IF st_row.state='assigned'::vehicle_states THEN
				st_assigned = st_row.date_time;
				IF st_row.shipment_id>0 AND destinations_ref IS NULL THEN
					SELECT
						destinations_ref(destinations) INTO destinations_ref
					FROM shipments
					LEFT JOIN orders ON orders.id=shipments.order_id
					LEFT JOIN destinations ON destinations.id=orders.destination_id
					WHERE shipments.id=st_row.shipment_id;
				END IF;			
			END IF;
			st_free_end = st_row.date_time;
			run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
			RETURN NEXT;
			--END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = TRUE;	
			v_run_assigned = FALSE;		
			v_run_busy = FALSE;
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
  OWNER TO beton;



-- ******************* update 08/07/2021 18:18:53 ******************
-- Function: public.vehicle_run_inf_on_schedule(integer)

--DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(IN in_schedule_id integer)
  RETURNS TABLE(
  	st_free_start timestamp without time zone,
  	st_assigned timestamp without time zone,
  	st_shipped timestamp without time zone,
  	st_at_dest timestamp without time zone,
  	st_left_for_base timestamp without time zone,
  	st_free_end timestamp without time zone,
  	destinations_ref json,
  	run_time timestamp without time zone,
  	veh_id integer
  	) AS
$BODY$
DECLARE st_row RECORD;
	v_run_started boolean;
	v_run_assigned boolean;
	v_run_busy boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started AND NOT v_run_assigned THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
					
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started AND NOT v_run_busy THEN
			st_shipped = st_row.date_time;
			v_run_busy = TRUE;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states OR st_row.state='assigned'::vehicle_states)
		AND (v_run_started=FALSE) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			IF st_row.state='assigned'::vehicle_states THEN
				st_assigned = st_row.date_time;
				IF (st_row.shipment_id>0) THEN
					SELECT
						destinations_ref(destinations) INTO destinations_ref
					FROM shipments
					LEFT JOIN orders ON orders.id=shipments.order_id
					LEFT JOIN destinations ON destinations.id=orders.destination_id
					WHERE shipments.id=st_row.shipment_id;
				END IF;			
			END IF;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = TRUE;
			v_run_assigned = FALSE;
			v_run_busy = FALSE;
			
		ELSIF (st_row.state='free'::vehicle_states AND v_run_started)
		OR st_row.state='assigned'::vehicle_states AND v_run_assigned
		OR st_row.state='busy'::vehicle_states AND v_run_busy
		THEN
			--IF destinations_ref IS NOT NULL THEN
			--previous run
			IF st_row.state='assigned'::vehicle_states THEN
				st_assigned = st_row.date_time;
			END IF;
			
			IF st_row.state='assigned'::vehicle_states
			OR st_row.state='busy'::vehicle_states THEN
				IF st_row.shipment_id>0 AND destinations_ref IS NULL THEN
					SELECT
						destinations_ref(destinations) INTO destinations_ref
					FROM shipments
					LEFT JOIN orders ON orders.id=shipments.order_id
					LEFT JOIN destinations ON destinations.id=orders.destination_id
					WHERE shipments.id=st_row.shipment_id;
				END IF;			
			END IF;
			st_free_end = st_row.date_time;
			run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
			RETURN NEXT;
			--END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = TRUE;	
			v_run_assigned = FALSE;		
			v_run_busy = FALSE;
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
  OWNER TO beton;



-- ******************* update 08/07/2021 18:26:27 ******************
-- FUNCTION: public.vehicle_run_inf_on_schedule(integer)

-- DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(
	in_schedule_id integer)
    RETURNS TABLE(st_free_start timestamp without time zone, st_assigned timestamp without time zone, st_shipped timestamp without time zone, st_at_dest timestamp without time zone, st_left_for_base timestamp without time zone, st_free_end timestamp without time zone, destinations_ref json, run_time timestamp without time zone, veh_id integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
DECLARE st_row RECORD;
	v_run_started boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
			
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started THEN
			st_shipped = st_row.date_time;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states)
		AND (v_run_started=false) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;
			
		ELSIF (st_row.state='free'::vehicle_states)
		AND (v_run_started) THEN
			IF destinations_ref IS NOT NULL THEN
				st_free_end = st_row.date_time;
				run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
				RETURN NEXT;
			END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;			
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;
END;
$BODY$;

ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
    OWNER TO beton;



-- ******************* update 09/07/2021 09:44:17 ******************
-- FUNCTION: public.vehicle_run_inf_on_schedule(integer)

 DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(
	in_schedule_id integer)
    RETURNS TABLE(
    	st_free_start timestamp without time zone,
    	st_assigned timestamp without time zone,
    	st_shipped timestamp without time zone,
    	st_at_dest timestamp without time zone,
    	st_left_for_base timestamp without time zone,
    	st_free_end timestamp without time zone,
    	destinations_ref json,
    	--run_time timestamp without time zone,
    	run_time interval,
    	veh_id integer
    	) 
    LANGUAGE 'sql'--'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
/*
DECLARE st_row RECORD;
	v_run_started boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
			
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started THEN
			st_shipped = st_row.date_time;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states)
		AND (v_run_started=false) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;
			
		ELSIF (st_row.state='free'::vehicle_states)
		AND (v_run_started) THEN
			IF destinations_ref IS NOT NULL THEN
				st_free_end = st_row.date_time;
				run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
				RETURN NEXT;
			END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;			
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;

END;
*/	
		SELECT
			--state previous free,shift_added,shift
			(SELECT
			 	CASE WHEN t.state='assigned' THEN st.date_time ELSE t.date_time END
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free','shift','shift_added','assigned')
				AND t.date_time < st.date_time
			ORDER BY t.date_time DESC
			LIMIT 1) AS st_free,
		
			--state assigned
			st.date_time AS st_assigned,
			
			--state busy - shipped
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='busy'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state IN ('assigned','out','free','out_from_shift')
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_shipped,
			
			--state at_dest
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='at_dest'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_at_dest,
			
			--state left_for_base
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='left_for_base'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_left_for_base,

			--free end: free, out_from_shift, out
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1) AS st_free_end,
			
			(SELECT
				destinations_ref(d)
			FROM shipments AS sh
			LEFT JOIN orders As o ON o.id=sh.order_id
			LEFT JOIN destinations AS d ON d.id=o.destination_id
			WHERE sh.id=st.shipment_id) AS destinations_ref,
			
			--run time: st_free_end - assigned
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1)
			- st.date_time AS run_time,
			
			sch.vehicle_id
			
		FROM vehicle_schedule_states AS st
		LEFT JOIN vehicle_schedules AS sch ON sch.id = st.schedule_id
		WHERE st.schedule_id=in_schedule_id AND st.state='assigned'
		ORDER BY st.date_time
$BODY$;

ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
    OWNER TO beton;

/*
		SELECT
			--state previous free,shift_added,shift
			(SELECT
			 	CASE WHEN t.state='assigned' THEN st.date_time ELSE t.date_time END
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free','shift','shift_added','assigned')
				AND t.date_time < st.date_time
			ORDER BY t.date_time DESC
			LIMIT 1) AS st_free,
		
			--state assigned
			st.date_time AS st_assigned,
			
			--state busy - shipped
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='busy'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state IN ('assigned','out','free','out_from_shift')
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_shipped,
			
			--state at_dest
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='at_dest'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_at_dest,
			
			--state left_for_base
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='left_for_base'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_left_for_base,

			--free end: free, out_from_shift, out
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1) AS st_free_end,
			
			(SELECT
				destinations_ref(d)
			FROM shipments AS sh
			LEFT JOIN orders As o ON o.id=sh.order_id
			LEFT JOIN destinations AS d ON d.id=o.destination_id
			WHERE sh.id=st.shipment_id) AS destinations_ref,
			
			--run time: st_free_end - assigned
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1)
			- st.date_time AS run_time,
			
			sch.vehicle_id
			
		FROM vehicle_schedule_states AS st
		LEFT JOIN vehicle_schedules AS sch ON sch.id = st.schedule_id
		WHERE st.schedule_id=60126 AND st.state='assigned'
		ORDER BY st.date_time
*/


-- ******************* update 09/07/2021 09:45:26 ******************
-- FUNCTION: public.vehicle_run_inf_on_schedule(integer)

 DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(
	in_schedule_id integer)
    RETURNS TABLE(
    	st_free_start timestamp without time zone,
    	st_assigned timestamp without time zone,
    	st_shipped timestamp without time zone,
    	st_at_dest timestamp without time zone,
    	st_left_for_base timestamp without time zone,
    	st_free_end timestamp without time zone,
    	destinations_ref json,
    	run_time timestamp without time zone,
    	veh_id integer
    	) 
    LANGUAGE 'sql'--'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
/*
DECLARE st_row RECORD;
	v_run_started boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
			
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started THEN
			st_shipped = st_row.date_time;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states)
		AND (v_run_started=false) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;
			
		ELSIF (st_row.state='free'::vehicle_states)
		AND (v_run_started) THEN
			IF destinations_ref IS NOT NULL THEN
				st_free_end = st_row.date_time;
				run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
				RETURN NEXT;
			END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;			
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;

END;
*/	
		SELECT
			--state previous free,shift_added,shift
			(SELECT
			 	CASE WHEN t.state='assigned' THEN st.date_time ELSE t.date_time END
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free','shift','shift_added','assigned')
				AND t.date_time < st.date_time
			ORDER BY t.date_time DESC
			LIMIT 1) AS st_free,
		
			--state assigned
			st.date_time AS st_assigned,
			
			--state busy - shipped
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='busy'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state IN ('assigned','out','free','out_from_shift')
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_shipped,
			
			--state at_dest
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='at_dest'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_at_dest,
			
			--state left_for_base
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='left_for_base'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_left_for_base,

			--free end: free, out_from_shift, out
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1) AS st_free_end,
			
			(SELECT
				destinations_ref(d)
			FROM shipments AS sh
			LEFT JOIN orders As o ON o.id=sh.order_id
			LEFT JOIN destinations AS d ON d.id=o.destination_id
			WHERE sh.id=st.shipment_id) AS destinations_ref,
			
			--run time: st_free_end - assigned
			now()::date+date_trunc('minute', 
				(SELECT t.date_time
				FROM vehicle_schedule_states AS t
				WHERE t.schedule_id=st.schedule_id
				 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
				    AND t.date_time > st.date_time
				ORDER BY t.date_time
				LIMIT 1)
				- st.date_time
			) AS run_time,
			
			sch.vehicle_id
			
		FROM vehicle_schedule_states AS st
		LEFT JOIN vehicle_schedules AS sch ON sch.id = st.schedule_id
		WHERE st.schedule_id=in_schedule_id AND st.state='assigned'
		ORDER BY st.date_time
$BODY$;

ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
    OWNER TO beton;

/*
		SELECT
			--state previous free,shift_added,shift
			(SELECT
			 	CASE WHEN t.state='assigned' THEN st.date_time ELSE t.date_time END
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free','shift','shift_added','assigned')
				AND t.date_time < st.date_time
			ORDER BY t.date_time DESC
			LIMIT 1) AS st_free,
		
			--state assigned
			st.date_time AS st_assigned,
			
			--state busy - shipped
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='busy'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state IN ('assigned','out','free','out_from_shift')
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_shipped,
			
			--state at_dest
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='at_dest'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_at_dest,
			
			--state left_for_base
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='left_for_base'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_left_for_base,

			--free end: free, out_from_shift, out
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1) AS st_free_end,
			
			(SELECT
				destinations_ref(d)
			FROM shipments AS sh
			LEFT JOIN orders As o ON o.id=sh.order_id
			LEFT JOIN destinations AS d ON d.id=o.destination_id
			WHERE sh.id=st.shipment_id) AS destinations_ref,
			
			--run time: st_free_end - assigned
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1)
			- st.date_time AS run_time,
			
			sch.vehicle_id
			
		FROM vehicle_schedule_states AS st
		LEFT JOIN vehicle_schedules AS sch ON sch.id = st.schedule_id
		WHERE st.schedule_id=60126 AND st.state='assigned'
		ORDER BY st.date_time
*/


-- ******************* update 09/07/2021 14:48:25 ******************
-- FUNCTION: public.vehicle_run_inf_on_schedule(integer)

-- DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(
	in_schedule_id integer)
    RETURNS TABLE(
    	st_free_start timestamp without time zone,
    	st_assigned timestamp without time zone,
    	st_shipped timestamp without time zone,
    	st_at_dest timestamp without time zone,
    	st_left_for_base timestamp without time zone,
    	st_free_end timestamp without time zone,
    	destinations_ref json,
    	run_time timestamp without time zone,
    	veh_id integer
    	) 
    LANGUAGE 'sql'--'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
/*
DECLARE st_row RECORD;
	v_run_started boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
			
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started THEN
			st_shipped = st_row.date_time;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states)
		AND (v_run_started=false) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;
			
		ELSIF (st_row.state='free'::vehicle_states)
		AND (v_run_started) THEN
			IF destinations_ref IS NOT NULL THEN
				st_free_end = st_row.date_time;
				run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
				RETURN NEXT;
			END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;			
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;

END;
*/	
		SELECT
			--state previous free,shift_added,shift
			(SELECT
			 	CASE WHEN t.state='assigned' THEN st.date_time ELSE t.date_time END
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free','shift','shift_added','assigned')
				AND t.date_time < st.date_time
			ORDER BY t.date_time DESC
			LIMIT 1) AS st_free,
		
			--state assigned
			st.date_time AS st_assigned,
			
			--state busy - shipped
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='busy'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state IN ('assigned','out','free','out_from_shift')
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_shipped,
			
			--state at_dest
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='at_dest'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state IN ('assigned','free','out','out_from_shift')
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_at_dest,
			
			--state left_for_base
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='left_for_base'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state IN ('assigned','free','out','out_from_shift')
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_left_for_base,

			--free end: free, out_from_shift, out
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1) AS st_free_end,
			
			(SELECT
				destinations_ref(d)
			FROM shipments AS sh
			LEFT JOIN orders As o ON o.id=sh.order_id
			LEFT JOIN destinations AS d ON d.id=o.destination_id
			WHERE sh.id=st.shipment_id) AS destinations_ref,
			
			--run time: st_free_end - assigned
			now()::date+date_trunc('minute', 
				(SELECT t.date_time
				FROM vehicle_schedule_states AS t
				WHERE t.schedule_id=st.schedule_id
				 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
				    AND t.date_time > st.date_time
				ORDER BY t.date_time
				LIMIT 1)
				- st.date_time
			) AS run_time,
			
			sch.vehicle_id
			
		FROM vehicle_schedule_states AS st
		LEFT JOIN vehicle_schedules AS sch ON sch.id = st.schedule_id
		WHERE st.schedule_id=in_schedule_id AND st.state='assigned'
		ORDER BY st.date_time
$BODY$;

ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
    OWNER TO beton;

/*
		SELECT
			--state previous free,shift_added,shift
			(SELECT
			 	CASE WHEN t.state='assigned' THEN st.date_time ELSE t.date_time END
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free','shift','shift_added','assigned')
				AND t.date_time < st.date_time
			ORDER BY t.date_time DESC
			LIMIT 1) AS st_free,
		
			--state assigned
			st.date_time AS st_assigned,
			
			--state busy - shipped
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='busy'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state IN ('assigned','out','free','out_from_shift')
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_shipped,
			
			--state at_dest
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='at_dest'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_at_dest,
			
			--state left_for_base
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='left_for_base'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		(SELECT n_st.date_time
					FROM vehicle_schedule_states AS n_st
					WHERE n_st.schedule_id=st.schedule_id
					AND n_st.state='assigned'
					AND n_st.date_time > st.date_time
					ORDER BY n_st.date_time
					LIMIT 1)
			ORDER BY t.date_time
			LIMIT 1) AS st_left_for_base,

			--free end: free, out_from_shift, out
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1) AS st_free_end,
			
			(SELECT
				destinations_ref(d)
			FROM shipments AS sh
			LEFT JOIN orders As o ON o.id=sh.order_id
			LEFT JOIN destinations AS d ON d.id=o.destination_id
			WHERE sh.id=st.shipment_id) AS destinations_ref,
			
			--run time: st_free_end - assigned
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1)
			- st.date_time AS run_time,
			
			sch.vehicle_id
			
		FROM vehicle_schedule_states AS st
		LEFT JOIN vehicle_schedules AS sch ON sch.id = st.schedule_id
		WHERE st.schedule_id=60126 AND st.state='assigned'
		ORDER BY st.date_time
*/


-- ******************* update 09/07/2021 14:58:15 ******************
--DROP VIEW public.vehicle_states_all;
CREATE OR REPLACE VIEW public.vehicle_states_all AS 
	SELECT 
		st.date_time,
		vs.id,
		CASE
		    WHEN st.state <> 'out'::vehicle_states AND st.state <> 'out_from_shift'::vehicle_states AND st.state <> 'shift'::vehicle_states AND st.state <> 'shift_added'::vehicle_states 

			THEN 1
			ELSE 0
		END AS vehicles_count,
		
		vehicles_ref(v) AS vehicles_ref,
		
		/*
		CASE
			WHEN v.vehicle_owner_id IS NULL THEN v.owner
			ELSE v_own.name
		END
		*/
		v_own.name::text AS owner,
		
		drivers_ref(d) AS drivers_ref,
		d.phone_cel::text AS driver_phone_cel,
		
		st.state, 

		CASE 
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN true
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route::interval,'00:00'::interval))::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time +  coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late,

		CASE
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1 + constant_vehicle_unload_time())::interval)::timestamp with time zone < CURRENT_TIMESTAMP
				THEN true
			ELSE false
		END AS is_late_at_dest,
		
		CASE
			--shift - no inf
			WHEN st.state = 'shift'::vehicle_states OR st.state = 'shift_added'::vehicle_states
				THEN ''

			-- out_from_shift && out inf=out time
			WHEN st.state = 'out_from_shift'::vehicle_states OR st.state = 'out'::vehicle_states
				THEN time5_descr(st.date_time::time)::text

			--free && assigned inf= time elapsed
			WHEN st.state = 'free'::vehicle_states OR st.state = 'assigned'::vehicle_states
				THEN to_char(CURRENT_TIMESTAMP-st.date_time,'HH24:MI')

			--busy && late inf = -
			--WHEN st.state = 'busy'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				--THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone)::time without time zone)::text
			WHEN st.state = 'busy'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::time without time zone)::text
				
			-- busy not late
			WHEN st.state = 'busy'::vehicle_states
				--THEN time5_descr(((st.date_time + (coalesce(dest.time_route,'00:00'::time)*2+constant_vehicle_unload_time())::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
				THEN time5_descr((coalesce(dest.time_route,'00:00'::time)+constant_vehicle_unload_time()::interval )::time without time zone)::text

			--at dest && late inf=route_time
			WHEN st.state = 'at_dest'::vehicle_states AND (st.date_time + (coalesce(dest.time_route,'00:00'::time)*1+constant_vehicle_unload_time())::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN time5_descr(coalesce(dest.time_route,'00:00'::time))::text

			--at dest NOT late
			WHEN st.state = 'at_dest'::vehicle_states
				THEN time5_descr( ((st.date_time + (coalesce(dest.time_route::interval,'00:00'::interval)+constant_vehicle_unload_time()::interval))::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text

			--left_for_base && LATE
			WHEN st.state = 'left_for_base'::vehicle_states AND (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval )::timestamp with time zone < CURRENT_TIMESTAMP
				THEN '-'::text || time5_descr((CURRENT_TIMESTAMP - (st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone)::time without time zone)::text

			--left_for_base NOT late
			WHEN st.state = 'left_for_base'::vehicle_states
				THEN time5_descr( ((st.date_time + coalesce(dest.time_route,'00:00'::time)::interval)::timestamp with time zone - CURRENT_TIMESTAMP)::time without time zone)::text
		    
			ELSE ''
		    
		END AS inf_on_return, 
		
		v.load_capacity,
		(SELECT COUNT(*)
		FROM shipments
		WHERE (shipments.vehicle_schedule_id = vs.id AND shipments.shipped)
		) AS runs,

		coalesce(
			(SELECT 
				(now()-(tr.period+AGE(now(),now() AT TIME ZONE 'UTC')) )>constant_no_tracker_signal_warn_interval()
				FROM car_tracking AS tr
				WHERE tr.car_id=v.tracker_id
				ORDER BY tr.period DESC LIMIT 1
			)
		,TRUE) AS tracker_no_data,
		
		(v.tracker_id IS NULL OR v.tracker_id='') AS no_tracker,
		
		vs.schedule_date,
		
		vehicle_schedules_ref(vs,v,d) AS vehicle_schedules_ref,
		
		d.phone_cel AS driver_tel
		,v.tracker_id
		
	FROM vehicle_schedules vs
	
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	
	
	LEFT JOIN vehicle_schedule_states st ON
		st.id = (SELECT vehicle_schedule_states.id 
			FROM vehicle_schedule_states
			WHERE vehicle_schedule_states.schedule_id = vs.id
			ORDER BY vehicle_schedule_states.date_time DESC NULLS LAST
			LIMIT 1
		)
	
	LEFT JOIN shipments AS sh ON sh.id=st.shipment_id
	LEFT JOIN orders AS o ON o.id=sh.order_id		
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id
	LEFT JOIN vehicle_owners AS v_own ON v_own.id=v.vehicle_owner_id
	;		
	--WHERE vs.schedule_date=in_date


ALTER TABLE public.vehicle_states_all OWNER TO beton;



-- ******************* update 09/07/2021 15:15:50 ******************
-- FUNCTION: public.vehicle_run_inf_on_schedule(integer)

-- DROP FUNCTION public.vehicle_run_inf_on_schedule(integer);

CREATE OR REPLACE FUNCTION public.vehicle_run_inf_on_schedule(
	in_schedule_id integer)
    RETURNS TABLE(
    	st_free_start timestamp without time zone,
    	st_assigned timestamp without time zone,
    	st_shipped timestamp without time zone,
    	st_at_dest timestamp without time zone,
    	st_left_for_base timestamp without time zone,
    	st_free_end timestamp without time zone,
    	destinations_ref json,
    	run_time timestamp without time zone,
    	veh_id integer
    	) 
    LANGUAGE 'sql'--'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
/*
DECLARE st_row RECORD;
	v_run_started boolean;
BEGIN
	v_run_started = false;
	FOR st_row IN
		SELECT
			vehicle_schedule_states.date_time,
			vehicle_schedule_states.state,
			coalesce(vehicle_schedule_states.shipment_id,0) AS shipment_id,
			vehicle_schedules.vehicle_id
		FROM vehicle_schedule_states
		LEFT JOIN vehicle_schedules ON vehicle_schedules.id = vehicle_schedule_states.schedule_id
		WHERE vehicle_schedules.id=in_schedule_id
		ORDER BY vehicle_schedule_states.date_time
	LOOP
		IF st_row.state='assigned'::vehicle_states
		AND v_run_started THEN
			st_assigned = st_row.date_time;
			IF (st_row.shipment_id>0) THEN
				SELECT
					destinations_ref(destinations) INTO destinations_ref
				FROM shipments
				LEFT JOIN orders ON orders.id=shipments.order_id
				LEFT JOIN destinations ON destinations.id=orders.destination_id
				WHERE shipments.id=st_row.shipment_id;
			END IF;
			
		ELSIF st_row.state='at_dest'::vehicle_states
		AND v_run_started THEN
			st_at_dest = st_row.date_time;

		ELSIF st_row.state='left_for_base'::vehicle_states
		AND v_run_started THEN
			st_left_for_base = st_row.date_time;
			
		ELSIF st_row.state='busy'::vehicle_states
		AND v_run_started THEN
			st_shipped = st_row.date_time;
			
		ELSIF (st_row.state='free'::vehicle_states OR st_row.state='shift'::vehicle_states)
		AND (v_run_started=false) THEN
			--new run
			st_free_start = st_row.date_time;
			veh_id = st_row.vehicle_id;
			
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;
			
		ELSIF (st_row.state='free'::vehicle_states)
		AND (v_run_started) THEN
			IF destinations_ref IS NOT NULL THEN
				st_free_end = st_row.date_time;
				run_time = now()::date+date_trunc('minute', st_free_end - st_shipped);--to_char(,'HH24:MI');			
				RETURN NEXT;
			END IF;
			
			--new run
			st_free_start = st_row.date_time;
			st_assigned = NULL;
			st_at_dest = NULL;
			st_left_for_base = NULL;
			st_shipped = NULL;
			st_free_end = NULL;			
			destinations_ref = NULL;
			run_time = NULL;
			
			v_run_started = true;			
		END IF;
	END LOOP;

	IF v_run_started THEN
		RETURN NEXT;
	END IF;

END;
*/	
		SELECT
			--state previous free,shift_added,shift
			(SELECT
			 	CASE WHEN t.state='assigned' THEN st.date_time ELSE t.date_time END
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free','shift','shift_added','assigned')
				AND t.date_time < st.date_time
			ORDER BY t.date_time DESC
			LIMIT 1) AS st_free,
		
			--state assigned
			st.date_time AS st_assigned,
			
			--state busy - shipped
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='busy'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		coalesce(
				 		(SELECT n_st.date_time
						FROM vehicle_schedule_states AS n_st
						WHERE n_st.schedule_id=st.schedule_id
						AND n_st.state IN ('assigned','out','free','out_from_shift')
						AND n_st.date_time > st.date_time
						ORDER BY n_st.date_time
						LIMIT 1)
				 		,(SELECT n_st.date_time
						FROM vehicle_schedule_states AS n_st
						WHERE n_st.schedule_id=st.schedule_id
						AND n_st.date_time::date = st.date_time::date
						ORDER BY n_st.date_time DESC
						LIMIT 1)
					)
			ORDER BY t.date_time
			LIMIT 1) AS st_shipped,
			
			--state at_dest
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='at_dest'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		coalesce(
				 		(SELECT n_st.date_time
						FROM vehicle_schedule_states AS n_st
						WHERE n_st.schedule_id=st.schedule_id
						AND n_st.state IN ('assigned','free','out','out_from_shift')
						AND n_st.date_time > st.date_time
						ORDER BY n_st.date_time
						LIMIT 1)
				 		,(SELECT n_st.date_time
						FROM vehicle_schedule_states AS n_st
						WHERE n_st.schedule_id=st.schedule_id
						AND n_st.date_time::date = st.date_time::date
						ORDER BY n_st.date_time DESC
						LIMIT 1)
					)
			ORDER BY t.date_time
			LIMIT 1) AS st_at_dest,
			
			--state left_for_base
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state='left_for_base'
				AND t.date_time BETWEEN
			 		st.date_time AND
			 		coalesce(
				 		(SELECT n_st.date_time
						FROM vehicle_schedule_states AS n_st
						WHERE n_st.schedule_id=st.schedule_id
						AND n_st.state IN ('assigned','free','out','out_from_shift')
						AND n_st.date_time > st.date_time
						ORDER BY n_st.date_time
						LIMIT 1)
				 		,(SELECT n_st.date_time
						FROM vehicle_schedule_states AS n_st
						WHERE n_st.schedule_id=st.schedule_id
						AND n_st.date_time::date = st.date_time::date
						ORDER BY n_st.date_time DESC
						LIMIT 1)
					)
			ORDER BY t.date_time
			LIMIT 1) AS st_left_for_base,

			--free end: free, out_from_shift, out
			(SELECT t.date_time
			FROM vehicle_schedule_states AS t
			WHERE t.schedule_id=st.schedule_id
			 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
			    AND t.date_time > st.date_time
			ORDER BY t.date_time
			LIMIT 1) AS st_free_end,
			
			(SELECT
				destinations_ref(d)
			FROM shipments AS sh
			LEFT JOIN orders As o ON o.id=sh.order_id
			LEFT JOIN destinations AS d ON d.id=o.destination_id
			WHERE sh.id=st.shipment_id) AS destinations_ref,
			
			--run time: st_free_end - assigned
			now()::date+date_trunc('minute', 
				(SELECT t.date_time
				FROM vehicle_schedule_states AS t
				WHERE t.schedule_id=st.schedule_id
				 	AND t.state IN ('free', 'out_from_shift', 'out','assigned')
				    AND t.date_time > st.date_time
				ORDER BY t.date_time
				LIMIT 1)
				- st.date_time
			) AS run_time,
			
			sch.vehicle_id
			
		FROM vehicle_schedule_states AS st
		LEFT JOIN vehicle_schedules AS sch ON sch.id = st.schedule_id
		WHERE st.schedule_id=in_schedule_id AND st.state='assigned'
		ORDER BY st.date_time
$BODY$;

ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
    OWNER TO beton;



-- ******************* update 10/07/2021 10:22:51 ******************
-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		
		IF NEW.point->>'longitude'<>'0' AND NEW.point->>'latitude'<>'0' THEN
			INSERT INTO car_tracking
			(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
			VALUES
			(NEW.point->>'client',
			to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc' + '1 hour'::interval,
			'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
			substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
			(NEW.point->>'speed')::numeric,
			CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
			CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
			0,
			(NEW.point->>'course')::int,
			to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
			1,
			(NEW.point->>'longitude')::numeric,
			(NEW.point->>'latitude')::numeric
			)
			ON CONFLICT (car_id, period) DO UPDATE
			SET
				recieved_dt = to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
				longitude = '0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
				latitude = substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
				speed = (NEW.point->>'speed')::numeric,
				ns = CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
				ew = CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
				heading = (NEW.point->>'course')::int,
				lon = (NEW.point->>'longitude')::numeric,
				lat = (NEW.point->>'latitude')::numeric
			;
		END IF;
				
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO beton;


