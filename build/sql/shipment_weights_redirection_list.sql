-- View: shipment_weights_redirection_list

 --DROP VIEW shipment_weights_redirection_list;

CREATE OR REPLACE VIEW shipment_weights_redirection_list AS 
	SELECT
		sh.id AS shipment_id,
		shw.date_time,
		shw.number,
		shw.material,
		shw.unloading_warehouse,
		shw.sender_client,
		vehicles_ref(v) AS vehicles_ref,
		vsch.vehicle_id,
		shw.sender_name,
		shw.quant_gross,
		shw.quant_net,
		sh.quant,
		coalesce(sh.quant, 0) * coalesce(const_shipment_weigh_redirect_rate_val(), 0) AS amount,
		CASE 
			WHEN pm.shipment_id IS NULL THEN NULL
			ELSE
				json_build_object(
					'created_at', pm.created_at,
					'users_ref', users_ref(u)
				) 
		END AS payment,
		shw.comment_text

	FROM shipment_weights shw
	LEFT JOIN shipments sh ON shw.shipment_id = sh.id
	LEFT JOIN vehicle_schedules AS vsch ON vsch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles AS v ON v.id = vsch.vehicle_id
	LEFT JOIN shipment_weight_redirection_payments AS pm ON pm.shipment_id = shw.shipment_id
	LEFT JOIN users AS u ON u.id = pm.user_id
	WHERE shw.ship_weighing_cause = 'redirection'
	ORDER BY 
		sh.ship_date_time DESC;

