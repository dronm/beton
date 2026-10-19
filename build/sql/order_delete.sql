-- FUNCTION: public.order_delete()

-- DROP FUNCTION IF EXISTS public.order_delete();

CREATE OR REPLACE FUNCTION public.order_delete()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

BEGIN
	IF (TG_OP='DELETE') THEN
		DELETE FROM order_pumps WHERE order_id=OLD.id;
		DELETE FROM order_contacts WHERE order_id=OLD.id;

		RETURN OLD;
	END IF;
	
END;
$BODY$;
