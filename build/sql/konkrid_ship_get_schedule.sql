-- Function: konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text)

-- DROP FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text);

CREATE OR REPLACE FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text)
  RETURNS int AS
$BODY$
DECLARE
	v_vehicle_id int;
	v_sched_id int;
BEGIN
	SELECT	
		v.id
	INTO
		v_vehicle_id
	FROM vehicles as v
	WHERE
		lower(v.plate) = lower(in_ship_veh_plate)
	LIMIT 1;

	IF v_vehicle_id IS NULL THEN
		RAISE EXCEPTION 'vehicle not found';
	END IF;

	SELECT
		sched.id
	INTO
		v_sched_id	
	FROM public.vehicle_schedules as sched
	WHERE
		sched.schedule_date = in_ship_date
		and sched.vehicle_id = v_vehicle_id
	LIMIT 1;
	
	IF v_sched_id IS NULL THEN
		INSERT INTO public.vehicle_schedules
		(schedule_date, vehicle_id, driver_id, auto_gen, edit_date_time, edit_user_id, production_base_id)
		VALUES (
			in_ship_date,
			v_vehicle_id,
			NULL,
			FALSE,
			NOW(),
			(const_reglament_user_val()->'keys'->>'id')::int,
			1
		)
		RETURNING id
		INTO v_sched_id;		
	END IF;
	
	RETURN v_sched_id;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text) OWNER TO ;
