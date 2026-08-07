-- FUNCTION: public.rg_fuel_flow_update_periods(timestamp without time zone, integer, numeric)

-- DROP FUNCTION public.rg_fuel_flow_update_periods(timestamp without time zone, integer, numeric);

CREATE OR REPLACE FUNCTION public.rg_fuel_flow_update_periods(
	in_date_time timestamp without time zone,
	in_vehicle_id integer,
	in_delta_quant numeric)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
	v_loop_rg_period timestamp;
	v_calc_interval interval;			  			
	CURRENT_BALANCE_DATE_TIME timestamp;
	CALC_DATE_TIME timestamp;
BEGIN
	CALC_DATE_TIME = rg_calc_period('fuel_flow'::reg_types);
	v_loop_rg_period = rg_period('fuel_flow'::reg_types,in_date_time);
	v_calc_interval = rg_calc_interval('fuel_flow'::reg_types);
	LOOP
		UPDATE rg_fuel_flow
		SET
			quant = quant + in_delta_quant
		WHERE 
			date_time=v_loop_rg_period
			AND vehicle_id = in_vehicle_id;
			
		IF NOT FOUND THEN
			BEGIN
				INSERT INTO rg_fuel_flow (date_time
				,vehicle_id
				,quant)				
				VALUES (v_loop_rg_period
				,in_vehicle_id
				,in_delta_quant);
			EXCEPTION WHEN OTHERS THEN
				UPDATE rg_fuel_flow
				SET
					quant = quant + in_delta_quant
				WHERE date_time = v_loop_rg_period
				AND vehicle_id = in_vehicle_id;
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
		quant = quant + in_delta_quant
	WHERE 
		date_time=CURRENT_BALANCE_DATE_TIME
		AND vehicle_id = in_vehicle_id;
		
	IF NOT FOUND THEN
		BEGIN
			INSERT INTO rg_fuel_flow (date_time
			,vehicle_id
			,quant)				
			VALUES (CURRENT_BALANCE_DATE_TIME
			,in_vehicle_id
			,in_delta_quant);
		EXCEPTION WHEN OTHERS THEN
			UPDATE rg_fuel_flow
			SET
				quant = quant + in_delta_quant
			WHERE 
				date_time=CURRENT_BALANCE_DATE_TIME
				AND vehicle_id = in_vehicle_id;
		END;
	END IF;					
	
END;
$BODY$;
