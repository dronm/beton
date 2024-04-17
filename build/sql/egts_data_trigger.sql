
-- DROP TRIGGER egts_data_trigger_after ON public.egts_data;

CREATE TRIGGER egts_data_trigger_after AFTER INSERT
  ON public.egts_data
  FOR EACH ROW
  EXECUTE PROCEDURE public.egts_data_process();
/*

		INSERT INTO car_tracking
		(car_id, period, longitude, latitude, speed, ns, ew, magvar, heading, recieved_dt, gps_valid, lon, lat)

	SELECT
		NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) At time zone 'utc',
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int) At time zone 'utc',
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric	
	FROM egts_data AS NEW
	WHERE NEW.point->>'longitude'<>'0' AND NEW.point->>'latitude'<>'0'
	ON CONFLICT DO NOTHING
	
	SELECT
		NEW.point->>'client',
		to_timestamp((NEW.point->>'navigation_unix_time')::int) + '1 hour'::interval,
		'0'|| substring(((NEW.point->>'longitude')::numeric*100)::text,1,9),
		substring( ((NEW.point->>'latitude')::numeric*100)::text,1,9),
		(NEW.point->>'speed')::numeric,
		CASE WHEN (NEW.point->>'course')::int >=90 AND (NEW.point->>'course')::int <270 THEN 'n' ELSE 's' END,
		CASE WHEN (NEW.point->>'course')::int >=180 THEN 'w' ELSE 'e' END,
		0,
		(NEW.point->>'course')::int,
		to_timestamp((NEW.point->>'received_unix_time')::int),
		CASE WHEN coalesce(NEW.point->>'longitude','') <> '' AND coalesce(NEW.point->>'latitude','') <> '' THEN 1 ELSE 0 END,
		(NEW.point->>'longitude')::numeric,
		(NEW.point->>'latitude')::numeric	
	FROM egts_data AS NEW
	ORDER BY (NEW.point->>'navigation_unix_time')::int DESC LIMIT 100	
*/	
