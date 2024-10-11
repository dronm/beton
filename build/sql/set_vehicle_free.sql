-- FUNCTION: public.set_vehicle_free()

-- DROP FUNCTION public.set_vehicle_free();

CREATE OR REPLACE FUNCTION public.set_vehicle_free()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE
	spec_id int;
BEGIN

	DELETE FROM vehicle_route_cashe WHERE shipment_id = OLD.id;
	
	DELETE FROM vehicle_schedule_states WHERE shipment_id = OLD.id;
	
	DELETE FROM quality_passports WHERE shipment_id = OLD.id;
	
	--specification
	SELECT
		coalesce(o.client_specification_id, 0)
	INTO
		spec_id
	FROM orders AS o
	WHERE o.id=OLD.order_id;
	
	IF spec_id > 0 THEN
		DELETE FROM client_specification_flows WHERE client_specification_id = spec_id AND shipment_id = OLD.id;
	END IF;
	
	
	--log
	PERFORM doc_log_delete('shipment'::doc_types,OLD.id);

	--register actions
	PERFORM ra_materials_remove_acts('shipment'::doc_types,OLD.id);
	PERFORM ra_material_consumption_remove_acts('shipment'::doc_types,OLD.id);
	
	RETURN OLD;
END;
$BODY$;

ALTER FUNCTION public.set_vehicle_free()
    OWNER TO ;

--GRANT EXECUTE ON FUNCTION public.set_vehicle_free() TO ;

