-- FUNCTION: public.const_ping1c_process()

-- DROP FUNCTION IF EXISTS public.const_ping1c_process();

CREATE OR REPLACE FUNCTION public.const_ping1c_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF (TG_OP = 'UPDATE') THEN
		IF (NEW.val->>'result')::bool <> (OLD.val->>'result')::bool THEN
			PERFORM pg_notify(
				'Connect1cCheck.update'
				,json_build_object(
					'params',json_build_object(
						'result',(NEW.val->>'result')::bool
					)
				)::text
			);			
			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$;

