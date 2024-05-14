-- Function: public.vehicle_schedules_after_process()

-- DROP FUNCTION public.vehicle_schedules_after_process();

CREATE OR REPLACE FUNCTION public.vehicle_schedules_after_process()
  RETURNS trigger AS
$BODY$
BEGIN
	--checkings for bereg only!
	IF TG_OP='UPDATE'  THEN
		IF (current_database()::text = 'beton') THEN
			PERFORM vehicle_schedules_to_konkrid(NEW.id, NEW.vehicle_id, LOWER(TG_OP));
		END IF;
	
		RETURN NEW;
		
	ELSIF TG_OP='DELETE' THEN
		IF (current_database()::text = 'beton') THEN
			PERFORM vehicle_schedules_to_konkrid(OLD.id, OLD.vehicle_id, LOWER(TG_OP));
		END IF;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicle_schedules_after_process()
  OWNER TO ;


