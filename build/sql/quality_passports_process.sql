-- FUNCTION: public.quality_passports_process()

-- DROP FUNCTION public.quality_passports_process();

CREATE OR REPLACE FUNCTION public.quality_passports_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		SELECT
			sh.order_id,
			o.client_id,
			quality_passports_smes_num(o.concrete_type_id, NEW.shipment_id),
			o.concrete_type_id
		INTO
			NEW.order_id,
			NEW.client_id,
			NEW.smes_num,
			NEW.concrete_type_id
		FROM shipments AS sh
		LEFT JOIN orders AS o ON o.id = sh.order_id
		WHERE sh.id = NEW.shipment_id;		

		RETURN NEW;
	END IF;
END
$BODY$;

ALTER FUNCTION public.quality_passports_process()
    OWNER TO ;

