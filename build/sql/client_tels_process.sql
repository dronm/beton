-- Function: public.client_tels_process()

-- DROP FUNCTION public.client_tels_process();

CREATE OR REPLACE FUNCTION public.client_tels_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF TG_OP='INSERT'
		OR coalesce(NEW.name,'') != coalesce(OLD.name,'')
		OR coalesce(NEW.tel, '') != coalesce(OLD.tel, '')
		OR coalesce(NEW.client_id, 0) != coalesce(OLD.client_id, 0)
		THEN					
			NEW.search = 
				coalesce(NEW.name::text, '')||
				' '||coalesce(NEW.tel::text, '')||
				coalesce((SELECT ' ('||v.name::text||')'
					FROM clients AS v
					WHERE v.id = NEW.client_id
				),'')
				;
		END IF;
			
		RETURN NEW;
	
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.client_tels_process()
  OWNER TO ;

/*
update client_tels set search=''
*/
