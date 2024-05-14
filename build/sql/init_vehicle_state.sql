-- FUNCTION: public.init_vehicle_state()

-- DROP FUNCTION IF EXISTS public.init_vehicle_state();

CREATE OR REPLACE FUNCTION public.init_vehicle_state()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	INSERT INTO vehicle_schedule_states (date_time,state,schedule_id,tracker_id) VALUES (NEW.schedule_date + constant_first_shift_start_time(),
		CASE			
			WHEN NEW.auto_gen THEN 'shift'::vehicle_states
			WHEN NEW.auto_gen=false
				AND get_shift_start(CURRENT_TIMESTAMP::timestamp without time zone)=get_shift_start(NEW.schedule_date+constant_first_shift_start_time()) THEN
				'free'::vehicle_states
			ELSE 'shift_added'::vehicle_states
		END,
		NEW.id,
		get_vehicle_tracker_id_on_schedule_id(NEW.id));
		
	IF (current_database()::text = 'beton') THEN
		PERFORM vehicle_schedules_to_konkrid(NEW.id, NEW.vehicle_id, LOWER(TG_OP));
	END IF;
		
	RETURN NEW;
EXCEPTION WHEN raise_exception THEN
	RAISE EXCEPTION 'Нет возможности добавить автомобиль!';
END;
$BODY$;

ALTER FUNCTION public.init_vehicle_state()
    OWNER TO beton;

