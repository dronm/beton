-- FUNCTION: public.user_operations_process()

-- DROP FUNCTION IF EXISTS public.user_operations_process();

CREATE OR REPLACE FUNCTION public.user_operations_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF TG_OP='UPDATE' AND (
		 (coalesce(OLD.status,'')<>'end' AND coalesce(NEW.status,'')='end')
		 OR NEW.status='progress'
		 OR NEW.status='error'
	)
	THEN		
		PERFORM pg_notify(
			'UserOperation.'||md5(NEW.user_id::text||NEW.operation_id)
			,json_build_object(
				'params',json_build_object(
					'status', NEW.status,
					'payload', NEW.payload,
					'error_text', NEW.error_text
				)
			)::text
		);
	END IF;
	
	RETURN NEW;
END;
$BODY$;
