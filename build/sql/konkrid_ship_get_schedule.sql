-- Function: konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text)

-- DROP FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text);

CREATE OR REPLACE FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text)
  RETURNS int AS
$$
	SELECT
		sched.id
	FROM public.vehicle_schedules as sched
	WHERE
		sched.schedule_date = in_ship_date
		and sched.vehicle_id = 
			(SELECT	
				v.id
			FROM vehicles as v
			WHERE
				v.plate = in_ship_veh_plate
			LIMIT 1
			) 
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_ship_get_schedule(in_ship_date date, in_ship_veh_plate text) OWNER TO ;
