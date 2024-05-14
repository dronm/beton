-- Function: vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text)

-- DROP FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text);

CREATE OR REPLACE FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text)
  RETURNS void AS
$$
BEGIN
	IF
		coalesce(
			(SELECT
					(owners.f->'owner'->'keys'->>'id')::int = 286 AS konkrid_owned
			FROM (
				SELECT
						jsonb_array_elements(vehicle_owners->'rows')->'fields' AS f
				FROM vehicles AS v
				WHERE v.tracker_id = (SELECT vehicles.tracker_id FROM vehicles WHERE vehicles.id = in_vehicle_id AND coalesce(vehicles.tracker_id,'')<>'')
			) AS owners
			ORDER BY (owners.f->>'dt_from')::timestamp DESC
			LIMIT 1)
		, FALSE
		) THEN
		
		INSERT INTO konkrid.bereg_to_konkrid
			VALUES ('VehicleSchedule.to_konkrid_' || in_oper,
				json_build_object('params',
					json_build_object('id', in_vehicle_schedule_id)
				)::text
		);
	END IF;
END;	
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vehicle_schedules_to_konkrid(in_vehicle_schedule_id int, in_vehicle_id int, in_oper text) OWNER TO ;
