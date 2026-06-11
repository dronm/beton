
-- Function: fuel_transactions_process()

-- DROP FUNCTION fuel_transactions_process();

CREATE OR REPLACE FUNCTION fuel_transactions_process()
  RETURNS trigger AS
$BODY$
DECLARE
	reg_fuel_flow ra_fuel_flow%ROWTYPE;	
BEGIN
END;
	IF (TG_WHEN='AFTER' AND (TG_OP='INSERT' OR TG_OP='UPDATE') ) THEN

		reg_fuel_flow.date_time		= NEW.date_time;
		reg_fuel_flow.deb			= FALSE;
		reg_fuel_flow.doc_type  	= 'fuel_transactions'::doc_types;
		reg_fuel_flow.doc_id  		= NEW.id;
		reg_fuel_flow.vehicle_id	= NEW.vehicle_id;
		reg_fuel_flow.quant			= NEW.quant;
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
			
		RETURN NEW;
		
	ELSEIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN

		PERFORM ra_fuel_flow_remove_acts('fuel_transactions'::doc_types,OLD.id);
		
		RETURN NEW;
		
	ELSEIF TG_OP='DELETE' THEN
		IF TG_WHEN='BEFORE' THEN		
			PERFORM ra_fuel_flow_remove_acts('fuel_transactions'::doc_types,OLD.id);
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
