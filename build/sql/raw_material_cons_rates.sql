-- FUNCTION: public.raw_material_cons_rates(in_production_site_id integer, integer, timestamp without time zone)

-- DROP FUNCTION public.raw_material_cons_rates(integer, integer, timestamp without time zone);

CREATE OR REPLACE FUNCTION public.raw_material_cons_rates(
	in_production_site_id integer,
	in_concrete_type_id integer,
	in_date_time timestamp without time zone
)
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
		rates.rate_date_id = (
			SELECT d.id
			FROM raw_material_cons_rate_dates AS d
			WHERE d.dt <= in_date_time
				--AND d.production_site_id = in_production_site_id
				AND (
					(in_date_time < '2023-06-21' AND d.production_site_id IS NULL)
					OR
					(in_date_time >= '2023-06-21' AND d.production_site_id = in_production_site_id)
				)
			ORDER BY d.dt DESC
			LIMIT 1
		)
		AND (
			coalesce(in_concrete_type_id, 0) = 0
			OR rates.concrete_type_id = in_concrete_type_id
		)
	;
$BODY$;

ALTER FUNCTION public.raw_material_cons_rates(integer, integer, timestamp without time zone)
    OWNER TO ;

