--DROP VIEW ra_fuel_flow_list;

CREATE OR REPLACE VIEW ra_fuel_flow_list AS
	SELECT
		ra.id,
		ra.date_time,
		ra.vehicle_id,
		vehicles_ref(v) AS vehicles_ref,
		CASE
		WHEN ra.doc_type = 'fuel_transactions' THEN
			--debet
			fuel_transactions_ref(trans)
		WHEN ra.doc_type = 'fuel_consumptions' THEN
			--kredit
			fuel_consumptions_ref(cons)
		ELSE
			NULL
		END AS docs_ref,
		ra.quant

	FROM ra_fuel_flow AS ra
	LEFT JOIN vehicles AS v ON v.id = ra.vehicle_id
	LEFT JOIN fuel_transactions AS trans 
		ON trans.id = ra.doc_id AND ra.doc_type = 'fuel_transactions'
	LEFT JOIN fuel_consumptions AS cons 
		ON cons.id = ra.doc_id AND ra.doc_type = 'fuel_consumptions'
	ORDER BY 
		ra.date_time DESC
	;

