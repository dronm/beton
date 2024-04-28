/*
CREATE UNLOGGED TABLE bereg_to_konkrid
(
	event_id text,
	params text
);

ALTER TABLE bereg_to_konkrid OWNER TO ;

*/

--DROP TRIGGER car_tracking_queue_after_insert ON public.car_tracking_queue;
/*
CREATE TRIGGER bereg_to_konkrid_after_insert
    AFTER INSERT
    ON public.bereg_to_konkrid
    FOR EACH ROW
    EXECUTE PROCEDURE public.bereg_to_konkrid_process();
*/


CREATE OR REPLACE FUNCTION public.bereg_to_konkrid_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='INSERT' ) THEN
		--IF current_database() = 'concrete1' THEN
			PERFORM pg_notify(
				NEW.event_id,
				NEW.params
			);
		--END IF;
			
		RETURN NEW;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.bereg_to_konkrid_process()
  OWNER TO ;

