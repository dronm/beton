
--DROP FUNCTION ra_fuel_flow_process();

--process function
CREATE OR REPLACE FUNCTION ra_fuel_flow_process()
  RETURNS trigger AS
$BODY$
DECLARE
	v_delta_quant int DEFAULT 0;
	CALC_DATE_TIME timestamp;
	CURRENT_BALANCE_DATE_TIME timestamp;
	v_loop_rg_period timestamp;
	v_calc_interval interval;			  			
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		RETURN NEW;
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		RETURN NEW;
	ELSIF (TG_WHEN='AFTER' AND (TG_OP='UPDATE' OR TG_OP='INSERT')) THEN
		CALC_DATE_TIME = rg_calc_period('fuel_flow'::reg_types);
		IF (CALC_DATE_TIME IS NULL) OR (NEW.date_time::date > rg_period_balance('fuel_flow'::reg_types, CALC_DATE_TIME)) THEN
			CALC_DATE_TIME = rg_period('fuel_flow'::reg_types,NEW.date_time);
			PERFORM rg_fuel_flow_set_custom_period(CALC_DATE_TIME);						
		END IF;
		IF TG_OP='UPDATE' THEN
			v_delta_quant = OLD.quant;
		ELSE
			v_delta_quant = 0;
		END IF;
		v_delta_quant = NEW.quant - v_delta_quant;
		IF NOT NEW.deb THEN
			v_delta_quant = -1 * v_delta_quant;
		END IF;
		v_loop_rg_period = CALC_DATE_TIME;
		v_calc_interval = rg_calc_interval('fuel_flow'::reg_types);
		LOOP
			UPDATE rg_fuel_flow
			SET
			quant = quant + v_delta_quant
			WHERE 
				date_time=v_loop_rg_period
				AND vehicle_id = NEW.vehicle_id;
			IF NOT FOUND THEN
				BEGIN
					INSERT INTO rg_fuel_flow (date_time
					,vehicle_id
					,quant)				
					VALUES (v_loop_rg_period
					,NEW.vehicle_id
					,v_delta_quant);
				EXCEPTION WHEN OTHERS THEN
					UPDATE rg_fuel_flow
					SET
					quant = quant + v_delta_quant
					WHERE date_time = v_loop_rg_period
					AND vehicle_id = NEW.vehicle_id;
				END;
			END IF;
			v_loop_rg_period = v_loop_rg_period + v_calc_interval;
			IF v_loop_rg_period > CALC_DATE_TIME THEN
				EXIT;  -- exit loop
			END IF;
		END LOOP;

	--Current balance
	CURRENT_BALANCE_DATE_TIME = reg_current_balance_time();
	UPDATE rg_fuel_flow
	SET
	quant = quant + v_delta_quant
	WHERE 
		date_time=CURRENT_BALANCE_DATE_TIME
		AND vehicle_id = NEW.vehicle_id;
	IF NOT FOUND THEN
		BEGIN
			INSERT INTO rg_fuel_flow (date_time
			,vehicle_id
			,quant)				
			VALUES (CURRENT_BALANCE_DATE_TIME
			,NEW.vehicle_id
			,v_delta_quant);
		EXCEPTION WHEN OTHERS THEN
			UPDATE rg_fuel_flow
			SET
			quant = quant + v_delta_quant
			WHERE 
				date_time=CURRENT_BALANCE_DATE_TIME
				AND vehicle_id = NEW.vehicle_id;
		END;
	END IF;
	RETURN NEW;					
ELSIF (TG_WHEN='BEFORE' AND TG_OP='DELETE') THEN
	RETURN OLD;
ELSIF (TG_WHEN='AFTER' AND TG_OP='DELETE') THEN
	CALC_DATE_TIME = rg_calc_period('fuel_flow'::reg_types);
	IF (CALC_DATE_TIME IS NULL) OR (OLD.date_time::date > rg_period_balance('fuel_flow'::reg_types, CALC_DATE_TIME)) THEN
		CALC_DATE_TIME = rg_period('fuel_flow'::reg_types,OLD.date_time);
		PERFORM rg_fuel_flow_set_custom_period(CALC_DATE_TIME);						
	END IF;
	v_delta_quant = OLD.quant;
	IF OLD.deb THEN
		v_delta_quant = -1*v_delta_quant;					
	END IF;

	PERFORM rg_fuel_flow_update_periods(
		OLD.date_time, 
		OLD.vehicle_id, 
		v_delta_quant
	);

	RETURN OLD;					
END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE COST 100;
