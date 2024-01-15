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
						--AND n_st.date_time::date = st.date_time::date
						--AND get_shift_start(n_st.date_time) = get_shift_start(st.date_time)
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
						AND n_st.state IN ('assigned', 'free', 'out', 'out_from_shift')
						AND n_st.date_time > st.date_time
						ORDER BY n_st.date_time
						LIMIT 1)
				 		,(SELECT n_st.date_time
						FROM vehicle_schedule_states AS n_st
						WHERE n_st.schedule_id = st.schedule_id
						--AND n_st.date_time::date = st.date_time::date
						--AND get_shift_start(n_st.date_time) = get_shift_start(st.date_time)
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
						--AND n_st.date_time::date = st.date_time::date
						--AND get_shift_start(n_st.date_time) = get_shift_start(st.date_time)
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
		WHERE st.schedule_id = in_schedule_id AND st.state='assigned'
		ORDER BY st.date_time
$BODY$;

ALTER FUNCTION public.vehicle_run_inf_on_schedule(integer)
    OWNER TO ;

