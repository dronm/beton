-- FUNCTION: public.rg_total_recalc_fuel_flow()

-- DROP FUNCTION public.rg_total_recalc_fuel_flow();

CREATE OR REPLACE FUNCTION public.rg_total_recalc_fuel_flow(
	)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
	period_row RECORD;
	v_act_date_time timestamp without time zone;
	v_cur_period timestamp without time zone;
BEGIN	
	v_act_date_time = reg_current_balance_time();
	SELECT date_time INTO v_cur_period FROM rg_calc_periods WHERE reg_type='fuel_flow';
--RAISE EXCEPTION 'v_cur_period=%',v_cur_period;	
	FOR period_row IN
		WITH
		periods AS (
			(SELECT
				DISTINCT date_trunc('month', date_time) AS d,
				vehicle_id
			FROM ra_fuel_flow)
			UNION		
			(SELECT
				date_time AS d,
				vehicle_id
			FROM rg_fuel_flow WHERE date_time<=v_cur_period
			)
			ORDER BY d			
		)
		SELECT sub.d,sub.vehicle_id,sub.balance_fact,sub.balance_paper
		FROM
		(
		SELECT
			periods.d,
			periods.vehicle_id,
			COALESCE((
				SELECT SUM(CASE WHEN deb THEN quant ELSE 0 END)-SUM(CASE WHEN NOT deb THEN quant ELSE 0 END)
				FROM ra_fuel_flow AS ra WHERE ra.date_time <= last_month_day(periods.d::date)+'23:59:59'::interval
				AND ra.vehicle_id=periods.vehicle_id
			),0) AS balance_fact,
			
			(
			SELECT SUM(quant) FROM rg_fuel_flow WHERE date_time=periods.d
			AND vehicle_id=periods.vehicle_id
			) AS balance_paper
			
		FROM periods
		) AS sub
		WHERE sub.balance_fact<>sub.balance_paper ORDER BY sub.d	
	LOOP
		
		/*UPDATE rg_fuel_flow AS rg
		SET quant = period_row.balance_fact
		WHERE rg.date_time=period_row.d
		AND rg.vehicle_id=period_row.vehicle_id;
		
		IF NOT FOUND THEN
			INSERT INTO rg_fuel_flow (date_time,vehicle_id,quant)
			VALUES (period_row.d,period_row.vehicle_id,period_row.balance_fact);
		END IF;		
		*/
		
		DELETE FROM rg_fuel_flow
		WHERE date_time=period_row.d
		AND vehicle_id=period_row.vehicle_id;

		INSERT INTO rg_fuel_flow (date_time,vehicle_id,quant)
		VALUES (period_row.d,period_row.vehicle_id,period_row.balance_fact);
	END LOOP;

	--АКТУАЛЬНЫЕ ИТОГИ
	DELETE FROM rg_fuel_flow WHERE date_time>v_cur_period;
	
	INSERT INTO rg_fuel_flow (date_time,vehicle_id,quant)
	(
	SELECT
		v_act_date_time,
		rg.vehicle_id,
		COALESCE(rg.quant,0) +
		COALESCE((
		SELECT sum(ra.quant) FROM
		ra_fuel_flow AS ra
		WHERE ra.date_time BETWEEN v_cur_period AND last_month_day(v_cur_period::date)+'23:59:59'::interval
			AND ra.vehicle_id=rg.vehicle_id
			AND ra.deb=TRUE
		),0) - 
		COALESCE((
		SELECT sum(ra.quant) FROM
		ra_fuel_flow AS ra
		WHERE ra.date_time BETWEEN v_cur_period AND last_month_day(v_cur_period::date)+'23:59:59'::interval
			AND ra.vehicle_id=rg.vehicle_id
			AND ra.deb=FALSE
		),0)
		
	FROM rg_fuel_flow AS rg
	WHERE date_time=(v_cur_period-'1 month'::interval)
	);	
END;
$BODY$;

