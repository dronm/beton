-- FUNCTION: public.fuel_flow_report(timestampTZ, timestampTZ)

-- DROP FUNCTION IF EXISTS public.fuel_flow_report(timestamp without time zone, timestamp without time zone, int);

CREATE OR REPLACE FUNCTION public.fuel_flow_report(
	in_date_time_from timestamp without time zone,
	in_date_time_to timestamp without time zone,
	in_vehicle_id int
)
RETURNS TABLE(
	vehicles_ref json,
	quant_beg int,
	quant_deb int,
	quant_kred int,
	quant_end int
) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
	CALLED ON NULL INPUT
    ROWS 1000
AS $BODY$
	SELECT
		vehicles_ref(v) AS vehicle_id,
		SUM(agg.quant_beg) AS quant_beg,
		SUM(agg.quant_deb) AS quant_deb,
		SUM(agg.quant_kred) AS quant_kred,
		SUM(agg.quant_beg)+SUM(agg.quant_deb)-SUM(agg.quant_kred) AS quant_end
	FROM (

		--start
		(SELECT 
			b.vehicle_id,
			b.quant AS quant_beg,
			0 AS quant_deb,
			0 AS quant_kred
		FROM rg_fuel_flow_balance(
			in_date_time_from, 
			CASE 
				WHEN coalesce(in_vehicle_id, 0) = 0 THEN '{}' 
				ELSE ARRAY[in_vehicle_id] 
			END
		) AS b
		)

		UNION ALL

		-- debet
		(SELECT 
			f.vehicle_id,
			0 AS quant_beg,
			f.quant quant_deb,
			0 quant_kred
		FROM ra_fuel_flow AS f 
		WHERE f.date_time BETWEEN in_date_time_from AND in_date_time_to AND f.deb
		)

		UNION ALL

		-- kredit
		(SELECT 
			f.vehicle_id,
			0 AS quant_beg,
			0 AS quant_deb,
			f.quant AS quant_kred
		FROM ra_fuel_flow AS f
		WHERE f.date_time BETWEEN in_date_time_from AND in_date_time_to AND NOT f.deb
		)
	) AS agg
	LEFT JOIN vehicles AS v ON v.id = agg.vehicle_id
	GROUP BY v.*
$BODY$;
