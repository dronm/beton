-- FUNCTION: public.raw_material_cons_rates(integer, timestamp without time zone)

-- DROP FUNCTION public.raw_material_cons_rates(integer, timestamp without time zone);

CREATE OR REPLACE FUNCTION public.raw_material_cons_rates(
	in_concrete_type_id integer,
	in_date_time timestamp without time zone)
    RETURNS TABLE(concrete_type_id integer, material_id integer, rate numeric) 
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
	SELECT
		rates.concrete_type_id,
		rates.raw_material_id AS material_id,
		rates.rate
	FROM raw_material_cons_rates AS rates
	WHERE 
		rates.rate_date_id=(
			SELECT id
			FROM raw_material_cons_rate_dates
			WHERE dt <= $2
			ORDER BY dt DESC
			LIMIT 1
			)
		AND (
			($1 IS NULL OR $1=0)
			OR ($1>0 AND rates.concrete_type_id = $1)
		)
	;
$BODY$;

ALTER FUNCTION public.raw_material_cons_rates(integer, timestamp without time zone)
    OWNER TO beton;

GRANT EXECUTE ON FUNCTION public.raw_material_cons_rates(integer, timestamp without time zone) TO beton;

GRANT EXECUTE ON FUNCTION public.raw_material_cons_rates(integer, timestamp without time zone) TO PUBLIC;


