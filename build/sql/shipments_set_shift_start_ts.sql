CREATE OR REPLACE FUNCTION shipments_set_shift_start_ts()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
	NEW.shift_start_ts := get_shift_start(NEW.ship_date_time);
	RETURN NEW;
END;
$$;
