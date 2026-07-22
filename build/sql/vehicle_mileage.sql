-- Function: public.vehicle_mileage(in_vehicle_tracker varchar(15), in_date_from timestampTZ, in_date_to timestampTZ);

-- DROP FUNCTION public.vehicle_mileage(in_vehicle_tracker varchar(15), in_date_from timestampTZ, in_date_to timestampTZ);

-- returns mileage in km for a given vehicle tracker and period
/*
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

*/

CREATE OR REPLACE FUNCTION public.vehicle_mileage(
	in_vehicle_tracker varchar(15),
	in_date_from timestamptz,
	in_date_to timestamptz
)
RETURNS numeric
LANGUAGE sql
STABLE
AS $BODY$
	WITH sorted_data AS (
		SELECT
			ct.period,
			ST_SetSRID(
				ST_MakePoint(
					ct.lon::double precision,
					ct.lat::double precision
				),
				4326
			)::geography AS geog,
			LEAD(
				ST_SetSRID(
					ST_MakePoint(
						ct.lon::double precision,
						ct.lat::double precision
					),
					4326
				)::geography
			) OVER (
				ORDER BY ct.period
			) AS next_geog
		FROM public.car_tracking AS ct
		WHERE
			ct.car_id = in_vehicle_tracker
			AND ct.gps_valid = 1
			AND ct.speed > 0
			AND ct.lon BETWEEN -180 AND 180
			AND ct.lat BETWEEN -90 AND 90
			AND ct.period >= in_date_from AT TIME ZONE 'UTC'
			AND ct.period < in_date_to AT TIME ZONE 'UTC'
	)
	SELECT
		COALESCE(
			SUM(
				ST_Distance(
					geog,
					next_geog,
					true
				)
			) / 1000.0,
			0
		)::numeric
	FROM sorted_data
	WHERE next_geog IS NOT NULL;
$BODY$;
