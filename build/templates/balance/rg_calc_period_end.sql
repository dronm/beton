-- FUNCTION: public.rg_calc_period_end(reg_types, timestamp without time zone)

-- DROP FUNCTION IF EXISTS public.rg_calc_period_end(reg_types, timestamp without time zone);

CREATE OR REPLACE FUNCTION public.rg_calc_period_end(
	in_reg_type reg_types,
	in_date_time timestamp without time zone)
    RETURNS timestamp without time zone
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	--v_calc_interval interval;
BEGIN
	--v_calc_interval = rg_calc_interval(in_reg_type);
	RETURN last_month_day(in_date_time::date)+'23:59:59.999'::interval;
END;
$BODY$;


