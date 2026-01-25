-- Function: production_reports_items(date_from timestampTZ, date_to timestampTZ)

--DROP FUNCTION production_reports_items(date_from timestampTZ, date_to timestampTZ);

CREATE OR REPLACE FUNCTION production_reports_items(date_from timestampTZ, date_to timestampTZ)
RETURNS TABLE(
	name text,
	code_1c text,
	quant numeric
) AS
$BODY$
	SELECT
		ct.name,
		ct.code_1c,
		sum(t.concrete_quant) AS quant
	FROM productions AS t
	LEFT JOIN concrete_types AS ct ON ct.id = t.concrete_type_id
	WHERE t.production_dt_end BETWEEN date_from AND date_to
	GROUP BY ct.code_1c, ct.name
	ORDER BY ct.name
;
$BODY$
LANGUAGE sql STABLE COST 100;
