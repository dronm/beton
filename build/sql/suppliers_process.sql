-- Function: public.suppliers_process()

-- DROP FUNCTION public.suppliers_process();

CREATE OR REPLACE FUNCTION public.suppliers_process()
  RETURNS trigger AS
$BODY$
BEGIN

	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN

		IF TG_OP='INSERT' OR (coalesce(NEW.tel, '')<>'' AND coalesce(NEW.tel, '') != coalesce(OLD.tel, ''))
		THEN					

			PERFORM client_tels_add(NEW.name, NEW.tel);
		END IF;

		IF TG_OP='INSERT' OR (coalesce(NEW.tel2, '')<>'' AND coalesce(NEW.tel2, '') != coalesce(OLD.tel2, ''))
		THEN					
			PERFORM client_tels_add(NEW.name, NEW.tel2);
		END IF;
			
		RETURN NEW;
	
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.suppliers_process()
  OWNER TO ;

