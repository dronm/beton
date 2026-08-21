-- FUNCTION: public.rg_calc_period_start(reg_types, timestamp without time zone)

-- DROP FUNCTION IF EXISTS public.rg_calc_period_start(reg_types, timestamp without time zone);

CREATE OR REPLACE FUNCTION public.rg_calc_period_start(
	in_reg_type reg_types,
	in_date_time timestamp without time zone)
    RETURNS timestamp without time zone
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
	SELECT date_trunc('month', $2)::timestamp without time zone;
$BODY$;


