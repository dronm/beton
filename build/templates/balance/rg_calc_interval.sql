-- FUNCTION: public.rg_calc_interval(reg_types)

-- DROP FUNCTION IF EXISTS public.rg_calc_interval(reg_types);

CREATE OR REPLACE FUNCTION public.rg_calc_interval(
	in_reg_type reg_types)
    RETURNS interval
    LANGUAGE 'sql'
    COST 100
    IMMUTABLE PARALLEL UNSAFE
AS $BODY$
	SELECT
		CASE $1
		WHEN 'material'::reg_types THEN '1 month'::interval
		WHEN 'cement'::reg_types THEN '1 month'::interval
		WHEN 'material_fact'::reg_types THEN '1 month'::interval
		WHEN 'fuel_flow'::reg_types THEN '1 month'::interval
		END;
$BODY$;


