-- FUNCTION: public.rg_materials_update_periods(timestamp without time zone, integer, numeric)

-- DROP FUNCTION public.rg_materials_update_periods(timestamp without time zone, integer, numeric);

CREATE OR REPLACE FUNCTION public.rg_materials_update_periods(
	in_date_time timestamp without time zone,
	in_production_base_id integer,
	in_material_id integer,
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
	CALC_DATE_TIME = rg_calc_period('material'::reg_types);
	v_loop_rg_period = rg_period('material'::reg_types,in_date_time);
	v_calc_interval = rg_calc_interval('material'::reg_types);
	LOOP
		UPDATE rg_materials
		SET
			quant = quant + in_delta_quant
		WHERE 
			date_time=v_loop_rg_period
			AND production_base_id = in_production_base_id
			AND material_id = in_material_id;
			
		IF NOT FOUND THEN
			BEGIN
				INSERT INTO rg_materials (date_time
				,production_base_id
				,material_id
				,quant)				
				VALUES (v_loop_rg_period
				,in_production_base_id
				,in_material_id
				,in_delta_quant);
			EXCEPTION WHEN OTHERS THEN
				UPDATE rg_materials
				SET
					quant = quant + in_delta_quant
				WHERE date_time = v_loop_rg_period
				AND production_base_id = in_production_base_id
				AND material_id = in_material_id;
			END;
		END IF;
		v_loop_rg_period = v_loop_rg_period + v_calc_interval;
		IF v_loop_rg_period > CALC_DATE_TIME THEN
			EXIT;  -- exit loop
		END IF;
	END LOOP;
	
	--Current balance
	CURRENT_BALANCE_DATE_TIME = reg_current_balance_time();
	UPDATE rg_materials
	SET
		quant = quant + in_delta_quant
	WHERE 
		date_time=CURRENT_BALANCE_DATE_TIME
		AND production_base_id = in_production_base_id
		AND material_id = in_material_id;
		
	IF NOT FOUND THEN
		BEGIN
			INSERT INTO rg_materials (date_time
			,production_base_id
			,material_id
			,quant)				
			VALUES (CURRENT_BALANCE_DATE_TIME
			,in_production_base_id
			,in_material_id
			,in_delta_quant);
		EXCEPTION WHEN OTHERS THEN
			UPDATE rg_materials
			SET
				quant = quant + in_delta_quant
			WHERE 
				date_time=CURRENT_BALANCE_DATE_TIME
				AND production_base_id = in_production_base_id
				AND material_id = in_material_id;
		END;
	END IF;					
	
END;
$BODY$;

ALTER FUNCTION public.rg_materials_update_periods(timestamp without time zone, integer, numeric)
    OWNER TO ;

