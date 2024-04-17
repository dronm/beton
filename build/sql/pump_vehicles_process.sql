-- Function: public.pump_vehicles_process()

-- DROP FUNCTION public.pump_vehicles_process();

CREATE OR REPLACE FUNCTION public.pump_vehicles_process()
  RETURNS trigger AS
$BODY$
DECLARE
	v_tel text;
	vh_owner_name text;
BEGIN

	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN

		IF TG_OP='INSERT' OR
		(coalesce(NEW.phone_cels, '{}'::jsonb) != coalesce(OLD.phone_cels, '{}'::jsonb))
		THEN					
			SELECT rtrim(vh_o.name)
			INTO vh_owner_name
			FROM vehicle_owners AS vh_o
			WHERE vh_o.id = 
				(SELECT
					CASE WHEN owners.r->'fields'->'owner'->'keys'->>'id'='null' THEN NULL
						ELSE (owners.r->'fields'->'owner'->'keys'->>'id')::int
					END	
				FROM
				(
					SELECT jsonb_array_elements((SELECT v.vehicle_owners->'rows' FROM vehicles AS v WHERE v.id = NEW.vehicle_id)) AS r
				) AS owners
				ORDER BY owners.r->'fields'->'dt_from' DESC
				LIMIT 1
				)			
			;			
			FOR v_tel IN
				SELECT
					format_cel_standart(sub.tels->'fields'->>'tel') AS tel
				FROM (
					SELECT jsonb_array_elements(NEW.phone_cels->'rows') AS tels
				) AS sub
			LOOP
				--RAISE EXCEPTION 'vh_owner_name=%, v_tel=%', vh_owner_name, v_tel;
				PERFORM client_tels_add(vh_owner_name, vh_owner_name||', насос', v_tel);
			END LOOP;
		END IF;

		RETURN NEW;
	
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.pump_vehicles_process()
  OWNER TO ;

