-- Function: public.car_tracking_mileage(in_car_id varchar(15), in_date_from timestampTZ, in_date_to timestampTZ);

-- DROP FUNCTION public.car_tracking_mileage(in_car_id varchar(15), in_date_from timestampTZ, in_date_to timestampTZ);

CREATE OR REPLACE FUNCTION public.car_tracking_mileage(in_car_id varchar(15), in_date_from timestampTZ, in_date_to timestampTZ)
  RETURNS TABLE(
  	car_id varchar(15),
  	mileage_km numeric
  ) AS
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
	    	(COALESCE(in_car_id, '') = '' OR in_car_id = car_id)
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
	    car_id,
	    SUM(mileage) / 1000 AS mileage_km -- Convert meters to kilometers
	FROM
	    distances
	GROUP BY
	    car_id
	ORDER BY
	    car_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.car_tracking_mileage(in_car_id varchar(15), in_date_from timestampTZ, in_date_to timestampTZ)
  OWNER TO beton;

