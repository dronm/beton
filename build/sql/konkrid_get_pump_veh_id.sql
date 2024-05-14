-- Function: konkrid_get_pump_veh_id(in_pump_vehicle_plate text)

-- DROP FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text);

-- actually this function id used for all events: konkrid && beton

CREATE OR REPLACE FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text)
  RETURNS int AS
$$
	SELECT
		pvh.id
	FROM public.pump_vehicles as pvh
	WHERE
		pvh.vehicle_id = 
			(SELECT
				v.id
			FROM vehicles as v
			WHERE v.plate = in_pump_vehicle_plate
			LIMIT 1
			)
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION konkrid_get_pump_veh_id(in_pump_vehicle_plate text) OWNER TO ;
