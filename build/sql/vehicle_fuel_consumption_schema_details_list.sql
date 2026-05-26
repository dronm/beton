-- VIEW: vehicle_fuel_consumption_schema_details_list

--DROP VIEW vehicle_fuel_consumption_schema_details_list;

CREATE OR REPLACE VIEW vehicle_fuel_consumption_schema_details_list AS
	SELECT
		t.id,
		t.vehicle_id,
		vehicles_ref(v) AS vehicles_ref,
		'' AS month_descr,
		t.month_from,
		t.month_to,
		t.quant_distance,
		t.quant_time
	FROM vehicle_fuel_consumption_schema_details AS t
	LEFT JOIN vehicles AS v ON v.id = t.vehicle_id
	ORDER BY t.month_from
	;


