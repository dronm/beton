-- Function: public.vehicles_process()

-- DROP FUNCTION public.vehicles_process();

CREATE OR REPLACE FUNCTION public.vehicles_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF TG_OP='INSERT' OR (OLD.vehicle_owners IS NULL AND NEW.vehicle_owners IS NOT NULL) OR NEW.vehicle_owners<>OLD.vehicle_owners THEN
			SELECT
				array_agg(
					CASE WHEN sub.obj->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
					ELSE (sub.obj->'fields'->'owner'->'keys'->>'id')::int
					END
				)
			INTO NEW.vehicle_owners_ar
			FROM (
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS obj
			) AS sub		
			;
			
			--last owner
			SELECT
				CASE WHEN owners.row->'fields'->'owner'->'keys'->>'id'='null' THEN NULL 
					ELSE (owners.row->'fields'->'owner'->'keys'->>'id')::int
				END
			INTO NEW.vehicle_owner_id
			FROM
			(
				SELECT jsonb_array_elements(NEW.vehicle_owners->'rows') AS row
			) AS owners
			ORDER BY (owners.row->'fields'->>'dt_from')::timestamp DESC
			LIMIT 1;
		END IF;
		
		--plate number for sorting
		IF TG_OP='INSERT' OR NEW.plate<>OLD.plate THEN
			NEW.plate_n = CASE WHEN regexp_replace(NEW.plate, '\D','','g')='' THEN 0 ELSE regexp_replace(NEW.plate, '\D','','g')::int END;
		END IF;
		
		RETURN NEW;
	
	--not used as there is no uniquness on plate field	
	/*ELSIF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN
		IF coalesce(NEW.tracker_id,'') <> coalesce(OLD.tracker_id,'')
		OR coalesce(NEW.plate,'') <> coalesce(OLD.plate,'') THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Vehicle.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	
		RETURN NEW;

	ELSIF TG_WHEN='AFTER' AND TG_OP='INSERT' THEN
		IF coalesce(NEW.tracker_id,'') <> '' THEN
			INSERT INTO konkrid.bereg_to_konkrid
				VALUES ('Vehicle.to_konkrid',
					json_build_object('params',
						json_build_object('id', NEW.id)
					)::text
			);
		END IF;
	
		RETURN NEW;
	*/	
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.vehicles_process()
  OWNER TO ;

