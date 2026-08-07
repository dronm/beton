
-- Function: fuel_corrections_process()

-- DROP FUNCTION fuel_corrections_process();

CREATE OR REPLACE FUNCTION fuel_corrections_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_fuel_flow ra_fuel_flow%ROWTYPE;	
BEGIN
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN

		IF NEW.quant_correction <> 0 THEN
			reg_fuel_flow.date_time		= NEW.date_time;
			reg_fuel_flow.deb			= (NEW.quant_correction > 0);
			reg_fuel_flow.doc_type  	= 'fuel_corrections'::doc_types;
			reg_fuel_flow.doc_id  		= NEW.id;
			reg_fuel_flow.vehicle_id	= NEW.vehicle_id;
			reg_fuel_flow.quant			= abs(NEW.quant_correction);
			PERFORM ra_fuel_flow_add_act(reg_fuel_flow);	
				 
			--Event support
			PERFORM pg_notify(
					'FuelFlow.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',NEW.date_time::date
					)
				)::text
			);
		END IF;
			
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN

		PERFORM ra_fuel_flow_remove_acts('fuel_corrections'::doc_types,OLD.id);
		
		NEW.quant_correction = (coalesce(
			(SELECT quant FROM rg_fuel_flow_balance(
				NEW.date_time,
				ARRAY[NEW.vehicle_id]
			))
		,0) - NEW.quant) * -1;
/*
raise exception 'vehID: %, correction:%, quant:%, bal:%, data_time:%', 
NEW.vehicle_id,
NEW.quant_correction, NEW.quant,
			(SELECT quant FROM rg_fuel_flow_balance(
				NEW.date_time,
				ARRAY[NEW.vehicle_id]
			)), NEW.date_time
		;*/

		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		NEW.quant_correction = (coalesce(
			(SELECT quant FROM rg_fuel_flow_balance(
				NEW.date_time,
				ARRAY[NEW.vehicle_id]
			))
		,0) - NEW.quant) * -1;

		RETURN NEW;
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			PERFORM ra_fuel_flow_remove_acts('fuel_corrections'::doc_types,OLD.id);
		ELSE
			--Event support
			PERFORM pg_notify(
				'FuelFlow.change'
				,json_build_object(
					'params',json_build_object(
						'cond_date',OLD.date_time::date
					)
				)::text
			);
			
		END IF;
	
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

