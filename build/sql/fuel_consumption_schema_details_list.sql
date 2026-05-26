-- VIEW: fuel_consumption_schema_details_list

--DROP VIEW fuel_consumption_schema_details_list;

CREATE OR REPLACE VIEW fuel_consumption_schema_details_list AS
	SELECT
		t.id,
		t.fuel_consumption_schema_id,
		fuel_consumption_schema_ref(schm) AS fuel_consumption_schema_idschemas_ref,
		'' AS month_descr,
		t.month_from,
		t.month_to,
		t.quant_distance,
		t.quant_time
	FROM fuel_consumption_schema_details AS t
	LEFT JOIN fuel_consumption_schema AS schm ON schm.id = t.fuel_consumption_schema_id
	ORDER BY t.month_from
	;

