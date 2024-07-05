-- FUNCTION: public.order_after_process()

-- DROP FUNCTION IF EXISTS public.order_after_process();

CREATE OR REPLACE FUNCTION public.order_after_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

DECLARE
	v_f boolean;
BEGIN	
	IF TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF NEW.date_time::date >= '2024-05-07' THEN
			IF current_database() = 'bereg' AND NEW.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Order.to_konkrid_' || LOWER(TG_OP),
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
				
			ELSIF current_database() = 'concrete1' THEN
				INSERT INTO beton.replicate_events
					VALUES ('Order.to_bereg_' || LOWER(TG_OP),
						json_build_object('params',
							json_build_object('id', NEW.id)
						)::text
				);
			
			END IF;
		END IF;
	
		IF TG_OP = 'INSERT' OR (TG_OP='UPDATE'
			AND NEW.phone_cel<>''
			AND (
				(NEW.client_id<>OLD.client_id)
				OR (NEW.phone_cel<>OLD.phone_cel)
			)
			)
		THEN		
			SELECT
				TRUE
			INTO v_f FROM client_tels
			WHERE client_id = NEW.client_id
				AND tel=NEW.phone_cel;
			
			IF v_f IS NULL THEN
				
				BEGIN
					INSERT INTO client_tels
						(client_id,tel,name)
					VALUES (NEW.client_id,NEW.phone_cel,NEW.descr);
				EXCEPTION WHEN OTHERS THEN
				END;
			END IF;
			
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='DELETE' THEN
		IF OLD.date_time::date >= '2024-05-07' THEN
			IF current_database() = 'bereg' AND OLD.client_id = (const_konkrid_client_val()->'keys'->>'id')::int THEN
				INSERT INTO konkrid.replicate_events
					VALUES ('Order.to_konkrid_delete',
						json_build_object('params',
							json_build_object('create_date_time', OLD.create_date_time::text)
						)::text
				);
				
			ELSIF current_database() = 'concrete1' THEN
				INSERT INTO beton.replicate_events
					VALUES ('Order.to_bereg_delete',
						json_build_object('params',
							json_build_object('create_date_time', OLD.create_date_time::text)
						)::text
				);
			
			END IF;
		END IF;	
	
		RETURN OLD;
	END IF;	
	
END;
$BODY$;

ALTER FUNCTION public.order_after_process()
    OWNER TO ;

