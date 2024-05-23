-- VIEW: raw_material_ticket_carrier_agg_list

-- DROP VIEW raw_material_ticket_carrier_agg_list;

CREATE OR REPLACE VIEW raw_material_ticket_carrier_agg_list AS
	WITH
	sel AS (
		SELECT
			carrier_id,
			raw_material_id,
			quarry_id,
			quant,
			count(*) AS ticket_count,
			count(*) * quant AS quant_tot
		FROM raw_material_tickets		
		WHERE close_date_time IS NULL
		GROUP BY
			carrier_id,
			raw_material_id,
			quarry_id,
			quant				
	)
	SELECT
		suppliers_ref(sp) AS carriers_ref,
		materials_ref(mat) AS raw_materials_ref,
		quarries_ref(qr) AS quarries_ref,
		sel.quant,
		sel.ticket_count,
		sel.quant_tot
	FROM sel
	LEFT JOIN suppliers AS sp ON sp.id = sel.carrier_id
	LEFT JOIN raw_materials AS mat ON mat.id = sel.raw_material_id	
	LEFT JOIN quarries AS qr ON qr.id = sel.quarry_id
	ORDER BY sp.name, mat.name
	;
	
-- ALTER VIEW raw_material_ticket_carrier_agg_list OWNER TO ;

