-- View: shipment_weights_list

 --DROP VIEW shipment_weights_list;

CREATE OR REPLACE VIEW shipment_weights_list AS 
	SELECT
		sh.id AS shipment_id,
		shw.date_time,
		sh.quant,
		shw.number,
		shw.material,
		vehicles_ref(v) AS vehicles_ref,
		orders_ref(o) AS orders_ref,
		destinations_ref(dest) AS destinations_ref,
		shw.sender_name,
		shw.quant_gross,
		shw.quant_net,
		shw.comment_text

	FROM shipment_weights shw
	LEFT JOIN shipments sh ON shw.shipment_id = sh.id
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles AS v ON v.id = vsch.vehicle_id
	ORDER BY 
		sh.ship_date_time DESC;

