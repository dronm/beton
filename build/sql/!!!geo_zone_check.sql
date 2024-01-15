-- DROP FUNCTION geo_zone_check();
/**
 */
CREATE OR REPLACE FUNCTION geo_zone_check()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tracker_date date;
	v_cur_state vehicle_states;
	v_production_base_id int;
	v_shipment_id int;
	v_schedule_id int;
	v_destination_id int;
	v_client_id int;
	
	v_zone geometry;
	
	v_st_date_time timestamp without time zone;
	
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
	SELECT d1::date INTO v_tracker_date
	FROM get_shift_bounds(NEW.recieved_dt+age(now(), now() at time zone 'UTC')) AS (d1 timestamp,d2 timestamp);

	--get last state
	SELECT
		st.state
		,st.shipment_id
		,st.schedule_id
		,st.destination_id
		,st.date_time
		,st.production_base_id
	INTO
		v_cur_state
		,v_shipment_id
		,v_schedule_id
		,v_destination_id
		,v_st_date_time
		,v_production_base_id
	
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
		IF v_cur_state = 'busy'::vehicle_states THEN
			--clients zone on shipment
			SELECT				
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM shipments
			LEFT JOIN orders ON orders.id = shipments.order_id
			LEFT JOIN destinations ON destinations.id = orders.destination_id
			WHERE
				shipments.id = v_shipment_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
			
		ELSIF  v_cur_state = 'at_dest'::vehicle_states THEN
			-- client zone from state
			SELECT
				destinations.id,
				destinations.zone
			INTO
				v_destination_id,
				v_zone
			FROM destinations
			WHERE
				destinations.id = v_destination_id
				AND
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			;
		ELSE
			--
			-- base zone
			-- ALL possible zones, NOT constant_base_geo_zone_id()
			-- returns one zone only
			SELECT
				b.id,
				b.destination_id,
				destinations.zone
			INTO
				v_production_base_id,
				v_destination_id,
				v_zone
			FROM production_bases AS b
			LEFT JOIN destinations ON destinations.id = b.destination_id
			WHERE
				(
					(v_control_in AND st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
					OR (NOT v_control_in AND NOT st_contains(destinations.zone, ST_GeomFromText('POINT('||NEW.lon::text||' '||NEW.lat::text||')', V_SRID)))
				)
			LIMIT 1			
			;
					
		END IF;		
		
		--if at least the last point inside zone
		IF v_zone IS NOT NULL THEN
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat
					FROM car_tracking AS t
					WHERE t.car_id = NEW.car_id AND t.gps_valid = 1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count() - 1
					OFFSET 1
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
					-- v_production_base_id = previous state value
					
				ELSEIF (v_cur_state='at_dest'::vehicle_states AND (now()-v_st_date_time)>'00:10:00'::interval) THEN
					-- Проверить сколько времени прошло с момента въезда в зону, если мало, то скорее всего
					-- ложное срабатывание
					v_new_state = 'left_for_base'::vehicle_states;
					-- v_production_base_id = previous state value OR some other logic!!! Куда назначили
					
				ELSEIF (v_cur_state='left_for_base'::vehicle_states) THEN
					v_new_state = 'free'::vehicle_states;
					--v_production_base_id = Фактическая зона, зона производственной площадки
				END IF;
				
				IF v_new_state IS NOT NULL THEN
					--change position
					INSERT INTO vehicle_schedule_states
					(date_time, schedule_id, state, tracker_id, destination_id, shipment_id, production_base_id)
					VALUES (CURRENT_TIMESTAMP,
						v_schedule_id,
						v_new_state,
						NEW.car_id,
						v_destination_id,
						v_shipment_id,
						v_production_base_id
					);
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
						
						IF v_destination_id IS NOT NULL AND v_client_id IS NOT NULL THEN
							INSERT INTO client_destinations
							(client_id,destination_id,lon,lat)
							VALUES (v_client_id,v_destination_id,NEW.lon,NEW.lat)
							ON CONFLICT (client_id,destination_id) DO UPDATE SET
								lon = NEW.lon,
								lat = NEW.lat
							;
						END IF;						
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

