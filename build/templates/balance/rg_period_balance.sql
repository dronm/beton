-- FUNCTION: public.rg_period_balance(reg_types, timestamp without time zone)

-- DROP FUNCTION IF EXISTS public.rg_period_balance(reg_types, timestamp without time zone);

CREATE OR REPLACE FUNCTION public.rg_period_balance(
	in_reg_type reg_types,
	in_date_time timestamp without time zone)
    RETURNS timestamp without time zone
    LANGUAGE 'sql'
    COST 100
    IMMUTABLE PARALLEL UNSAFE
AS $BODY$
	SELECT
		date_trunc('month',in_date_time) + rg_calc_interval(in_reg_type) - '0.000001 second'::interval
$BODY$;


