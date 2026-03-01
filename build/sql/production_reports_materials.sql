-- Function: production_reports_materials(date_from timestampTZ, date_to timestampTZ)

--DROP VIEW IF EXISTS production_reports_dialog;
--DROP FUNCTION production_reports_materials(date_from timestampTZ, date_to timestampTZ);

CREATE OR REPLACE FUNCTION production_reports_materials(date_from timestampTZ, date_to timestampTZ)
RETURNS TABLE(
	wareshouse_ref_1c text,
	wareshouse_name text,
	production_site_name text,
	name text,
	ref_1c text,
	ref_1c_descr text,
	quant numeric
) AS
$BODY$
	SELECT
		ps.ref_1c->'keys'->>'ref_1c' AS warehouse_ref_1c,
		ps.ref_1c->>'descr' AS warehouse_name,
		ps.name AS production_site_name,
		mt.name,
		mt.ref_1c->'keys'->>'ref_1c',
		mt.ref_1c->>'descr',
		sum(t.material_quant) AS quant
	FROM material_fact_consumptions AS t
	LEFT JOIN raw_materials AS mt ON mt.id = t.raw_material_id
	LEFT JOIN production_sites AS ps ON ps.id = t.production_site_id
	WHERE t.date_time BETWEEN date_from AND date_to
	GROUP BY 
		ps.ref_1c,
		ps.name,
		mt.ref_1c, 
		mt.name
	ORDER BY 
		ps.name, 
		mt.name
;
$BODY$
LANGUAGE sql STABLE COST 100;

