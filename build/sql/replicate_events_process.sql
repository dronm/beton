-- FUNCTION: public.replicate_events_process()

-- DROP FUNCTION IF EXISTS public.replicate_events_process();

CREATE OR REPLACE FUNCTION public.replicate_events_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		PERFORM pg_notify(
			NEW.event_id,
			NEW.params
		);
			
		RETURN NEW;
	END IF;
	
END;
$BODY$;

ALTER FUNCTION public.replicate_events_process()
    OWNER TO ;

