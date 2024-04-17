-- Function: public.egts_data_process()

-- DROP FUNCTION public.egts_data_process();

CREATE OR REPLACE FUNCTION public.egts_data_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		
		IF NEW.point->>'longitude'<>'0' AND NEW.point->>'latitude'<>'0' THEN
			INSERT INTO car_tracking
			(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)
			VALUES
			(NEW.point->>'client',
			to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc' + '1 hour'::interval,
			'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
			substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
			(NEW.point->>'speed')::numeric,
			CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
			CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
			0,
			(NEW.point->>'course')::int,
			to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
			1,
			(NEW.point->>'longitude')::numeric,
			(NEW.point->>'latitude')::numeric
			)
			ON CONFLICT (car_id, period) DO UPDATE
			SET
				recieved_dt = to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
				longitude = '0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
				latitude = substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
				speed = (NEW.point->>'speed')::numeric,
				ns = CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
				ew = CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
				heading = (NEW.point->>'course')::int,
				lon = (NEW.point->>'longitude')::numeric,
				lat = (NEW.point->>'latitude')::numeric
			;
		END IF;
				
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.egts_data_process()
  OWNER TO ;

