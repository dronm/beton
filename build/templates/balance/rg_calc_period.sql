-- FUNCTION: public.rg_calc_period(reg_types)

-- DROP FUNCTION IF EXISTS public.rg_calc_period(reg_types);

CREATE OR REPLACE FUNCTION public.rg_calc_period(
	in_reg_type reg_types)
    RETURNS timestamp without time zone
    LANGUAGE 'sql'
    COST 100
    STABLE PARALLEL UNSAFE
AS $BODY$
	SELECT date_time FROM rg_calc_periods WHERE reg_type=$1;
$BODY$;

ALTER FUNCTION public.rg_calc_period(reg_types)
    OWNER TO beton;


