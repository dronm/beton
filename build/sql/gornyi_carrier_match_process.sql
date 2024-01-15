-- Function: gornyi_carrier_match_process()

-- DROP FUNCTION gornyi_carrier_match_process();

CREATE OR REPLACE FUNCTION gornyi_carrier_match_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN		
		IF NEW.carrier_id IS NOT NULL AND NEW.plate IS NOT NULL AND NEW.plate<>'' THEN
			UPDATE doc_material_procurements2
			SET 
				carrier_id = NEW.carrier_id
			WHERE vehicle_plate = NEW.plate;
		END IF;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN		
	
		IF coalesce(NEW.plate,'') <> coalesce(OLD.plate,'') THEN
			RAISE EXCEPTION 'Запрещено менять номер ТС!';
		END IF;
	
		IF coalesce(NEW.carrier_id,0) <> coalesce(OLD.carrier_id,0)
		THEN
			UPDATE doc_material_procurements2
			SET 
				carrier_id = NEW.carrier_id
			WHERE vehicle_plate = NEW.plate;
		END IF;
		
		RETURN NEW;
		
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gornyi_carrier_match_process() OWNER TO ;

