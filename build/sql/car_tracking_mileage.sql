-- Function: public.car_tracking_mileage(in_car_id varchar(15), in_date_from timestampTZ, in_date_to timestampTZ);

-- DROP FUNCTION public.car_tracking_mileage(in_car_id varchar(15), in_date_from timestampTZ, in_date_to timestampTZ);
/*
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
*/
CREATE OR REPLACE FUNCTION public.car_tracking_mileage(
	in_car_id varchar(15),
	in_date_from timestamptz,
	in_date_to timestamptz
)
RETURNS TABLE(
	car_id varchar(15),
	mileage_km numeric
)
LANGUAGE sql
STABLE
AS $BODY$
	WITH points AS (
		SELECT
			ct.car_id,
			ct.period,
			ct.speed::double precision AS speed,
			ST_SetSRID(
				ST_MakePoint(
					ct.lon::double precision,
					ct.lat::double precision
				),
				4326
			)::geography AS geog
		FROM public.car_tracking AS ct
		WHERE
			(
				in_car_id IS NULL
				OR in_car_id = ''
				OR ct.car_id = in_car_id
			)
			AND ct.gps_valid = 1
			AND ct.lon BETWEEN -180 AND 180
			AND ct.lat BETWEEN -90 AND 90
			AND ct.period >= in_date_from AT TIME ZONE 'UTC'
			AND ct.period < in_date_to AT TIME ZONE 'UTC'
	),
	sequenced AS (
		SELECT
			car_id,
			period,
			speed,
			geog,
			LAG(period) OVER (
				PARTITION BY car_id
				ORDER BY period
			) AS previous_period,
			LAG(speed) OVER (
				PARTITION BY car_id
				ORDER BY period
			) AS previous_speed,
			LAG(geog) OVER (
				PARTITION BY car_id
				ORDER BY period
			) AS previous_geog
		FROM points
	),
	segments AS (
		SELECT
			car_id,
			ST_Distance(
				previous_geog,
				geog,
				true
			) AS distance_m
		FROM sequenced
		WHERE
			previous_geog IS NOT NULL
			AND period > previous_period
			AND (
				COALESCE(previous_speed, 0) > 0
				OR COALESCE(speed, 0) > 0
			)
	)
	SELECT
		segments.car_id,
		(
			SUM(segments.distance_m)
			/ 1000.0
		)::numeric AS mileage_km
	FROM segments
	GROUP BY segments.car_id
	ORDER BY segments.car_id;
$BODY$;
