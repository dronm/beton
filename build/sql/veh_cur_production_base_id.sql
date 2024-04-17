/*
CREATE TYPE production_zone AS (
	zone geometry,
	production_base_id int
); 

*/

﻿-- Function: veh_cur_production_base_id(in_vehicle_tracker_id varchar(15))

-- DROP FUNCTION veh_cur_production_base_id2(in_vehicle_tracker_id varchar(15));

CREATE OR REPLACE FUNCTION veh_cur_production_base_id(in_vehicle_tracker_id varchar(15))
  RETURNS int AS
$$
DECLARE	
	v_zone production_zone; -- {"zone":geometry, "production_base_id":int}
	v_zone_list production_zone[];
	v_production_base_id int;
	v_true_point bool;
	v_car_rec RECORD;
	V_SRID int;	
BEGIN
	IF coalesce(in_vehicle_tracker_id, '') <> '' THEN
		V_SRID = 0;
		-- если ТС нахидится в одной из зон - поставим эту зону
		SELECT
			ARRAY_AGG(
				row(destinations.zone, b.id)::production_zone
			)
		INTO
			v_zone_list
		FROM production_bases AS b
		LEFT JOIN destinations ON destinations.id = b.destination_id;

		FOREACH v_zone in array v_zone_list
		LOOP
			--check last X points to be sure
			v_true_point = FALSE;
			FOR v_car_rec IN SELECT lon,lat FROM car_tracking AS t
					WHERE t.car_id = in_vehicle_tracker_id AND t.gps_valid=1
					ORDER BY t.period DESC
					LIMIT constant_geo_zone_check_points_count()-1 OFFSET 1
			LOOP	
				--4326				
				v_true_point = st_contains(v_zone.zone, ST_GeomFromText('POINT('||v_car_rec.lon::text||' '||v_car_rec.lat::text||')', V_SRID));
				IF v_true_point = FALSE THEN
					EXIT;
				END IF;
			END LOOP;
			
			IF v_true_point THEN
				v_production_base_id = v_zone.production_base_id;
				EXIT;
			END IF;
		END LOOP;
	END IF;				
		
	RETURN v_production_base_id;
END
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION veh_cur_production_base_id(in_vehicle_tracker_id varchar(15)) OWNER TO ;
