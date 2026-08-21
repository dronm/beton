-- View: shipment_weights_self_list

 --DROP VIEW shipment_weights_self_ship_list;

CREATE OR REPLACE VIEW shipment_weights_self_ship_list AS 
	SELECT
		sh.id AS shipment_id,
		shw.date_time,
		shw.number,
		shw.material,
		vehicles_ref(v) AS vehicles_ref,
		vsch.vehicle_id,
		shw.sender_name,
		shw.quant_gross,
		shw.quant_net,
		shw.comment_text

	FROM shipment_weights shw
	LEFT JOIN shipments sh ON shw.shipment_id = sh.id
	LEFT JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles AS v ON v.id = vsch.vehicle_id
	WHERE shw.ship_weighing_cause = 'self_ship'
	ORDER BY 
		sh.ship_date_time DESC;
