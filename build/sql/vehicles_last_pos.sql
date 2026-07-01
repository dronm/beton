-- View: public.vehicles_last_pos

-- DROP VIEW public.vehicles_last_pos;

CREATE OR REPLACE VIEW public.vehicles_last_pos
AS
SELECT
	v.id
	,v.plate
	,v.feature
	,v.owner
	,v.make
	,v.tracker_id::text AS tracker_id
	,(SELECT
		json_build_object(
			'period',car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
			,'speed',round(car_tracking.speed, 0)
			,'ns',car_tracking.ns
			,'ew',car_tracking.ew
			,'recieved_dt',car_tracking.recieved_dt + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
			,'odometer',car_tracking.odometer
			,'voltage',round(car_tracking.voltage,0)
			,'heading',car_tracking.heading
			,'lon',car_tracking.lon
			,'lat',car_tracking.lat			
			,'engine_on', (car_tracking.engine_on='1')
			/*
			,'heading_descr',heading_descr(car_tracking.heading)
			,'pt_geom',ST_BUFFER(
				ST_GeomFromText('POINT('||car_tracking.lon::text||' '||car_tracking.lat::text||')', 4326)
				,(SELECT (const_deviation_for_reroute_val()->>'distance_m')::int)
			)
			*/
		)
	FROM car_tracking
	WHERE car_tracking.car_id::text = v.tracker_id::text
	ORDER BY car_tracking.period DESC
	LIMIT 1
	) AS pos_data,

	v.map_picture
	
FROM vehicles v
WHERE v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
ORDER BY v.plate_n;
