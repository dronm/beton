-- Function: public.vehicle_mileage(in_vehicle_tracker varchar(15), in_date_from timestampTZ, in_date_to timestampTZ);

-- DROP FUNCTION public.vehicle_mileage(in_vehicle_tracker varchar(15), in_date_from timestampTZ, in_date_to timestampTZ);

CREATE OR REPLACE FUNCTION public.vehicle_mileage(in_vehicle_tracker varchar(15), in_date_from timestampTZ, in_date_to timestampTZ)
  RETURNS numeric AS
$BODY$
	WITH sorted_data AS (
	    SELECT
		car_id,
		period,
		ST_SetSRID(ST_MakePoint(lon, lat), 4326) AS geom,
		LEAD( ST_SetSRID(ST_MakePoint(lon, lat), 4326) ) OVER (
		    PARTITION BY car_id ORDER BY period
		) AS next_geom
	    FROM
		public.car_tracking
	    WHERE
	    	car_id = in_vehicle_tracker
	    	AND gps_valid = 1
	    	AND speed > 0
	    	AND period BETWEEN (in_date_from at time zone 'UTC') AND (in_date_to at time zone 'UTC')
	),
	distances AS (
	    SELECT
		car_id,
		period,
		ST_Distance(geom::geography, next_geom::geography) AS mileage
	    FROM
		sorted_data
	    WHERE
		next_geom IS NOT NULL
	)
	SELECT
	    SUM(mileage) / 1000 AS mileage_km -- Convert meters to kilometers
	FROM distances;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;

