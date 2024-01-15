-- FUNCTION: public.sms_for_sending_process()

-- DROP FUNCTION IF EXISTS public.sms_for_sending_process();

CREATE OR REPLACE FUNCTION public.sms_for_sending_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
	IF (TG_OP='INSERT') THEN
		INSERT INTO notifications.ext_messages VALUES(
				jsonb_build_object(
					'app_id', 1,
					'messages', jsonb_build_array(
						jsonb_build_object(
							'sms',jsonb_build_object(
								'tel', format_cel_standart(NEW.tel),
								'body', NEW.body,
								'sms_type', NEW.sms_type,
								'doc_ref', NEW.doc_ref
							)							
						)
					)
				)
		);
		RETURN NEW;
	END IF;
END;
$BODY$;

ALTER FUNCTION public.sms_for_sending_process() OWNER TO ;

