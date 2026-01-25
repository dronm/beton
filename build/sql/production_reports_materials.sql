-- Function: production_reports_materials(date_from timestampTZ, date_to timestampTZ)

--DROP VIEW IF EXISTS production_reports_dialog;
--DROP FUNCTION production_reports_materials(date_from timestampTZ, date_to timestampTZ);

CREATE OR REPLACE FUNCTION production_reports_materials(date_from timestampTZ, date_to timestampTZ)
RETURNS TABLE(
	name text,
	ref_1c text,
	ref_1c_descr text,
	quant numeric
) AS
$BODY$
	SELECT
		mt.name,
		mt.ref_1c->'keys'->>'ref_1c',
		mt.ref_1c->>'descr',
		sum(t.material_quant) AS quant
	FROM material_fact_consumptions AS t
	LEFT JOIN raw_materials AS mt ON mt.id = t.raw_material_id
	WHERE t.date_time BETWEEN date_from AND date_to
	GROUP BY mt.ref_1c, mt.name
	ORDER BY mt.name
;
$BODY$
LANGUAGE sql STABLE COST 100;

