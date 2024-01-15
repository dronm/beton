-- Function: public.drivers_process()

-- DROP FUNCTION public.drivers_process();

CREATE OR REPLACE FUNCTION public.drivers_process()
  RETURNS trigger AS
$BODY$
BEGIN

	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN

		IF TG_OP='INSERT' OR (coalesce(NEW.phone_cel, '')<>'' AND coalesce(NEW.phone_cel, '') != coalesce(OLD.phone_cel, ''))
		THEN					
			PERFORM client_tels_add(rtrim(NEW.name), NEW.phone_cel);
		END IF;

		RETURN NEW;
	
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.drivers_process()
  OWNER TO ;

