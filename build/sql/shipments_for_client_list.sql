-- VIEW: shipments_for_client_list

--DROP VIEW shipments_for_client_list;
CREATE OR REPLACE VIEW shipments_for_client_list AS
SELECT
	x.order_id,
	x.client_id,
	x.ship_date,
	x.destination_id,
	destinations_ref(dest)::text AS destinations_ref,
	x.concrete_type_id,
	concrete_types_ref(ct)::text AS concrete_types_ref,
	(x.pump_vehicle_id IS NOT NULL) AS pump_exists,
	x.quant,
	(x.concrete_price * x.quant)::numeric(15,2) AS concrete_cost,
	x.deliv_cost,
	x.pump_cost,
	(x.client_price * x.quant + x.deliv_cost + x.pump_cost)::numeric(15,2) AS total_cost,
	clients_ref(cl)::text AS clients_ref
FROM (
	SELECT
		b.*,
		coalesce(op.price, cp.price, 0)::numeric(15,2) AS concrete_price,
		coalesce(cp.price, 0)::numeric(15,2) AS client_price,
		CASE
			WHEN b.pump_vehicle_id IS NULL THEN 0
			WHEN b.pump_has_edit THEN b.pump_sum
			WHEN coalesce(b.total_edit, FALSE) AND coalesce(b.unload_price, 0) > 0 THEN b.unload_price::numeric(15,2)
			ELSE coalesce(ppv.pump_calc, 0)::numeric(15,2)
		END AS pump_cost
	FROM (
		SELECT
			s.order_id,
			o.client_id,
			s.shift_start_ts::date AS ship_date,
			o.destination_id,
			o.concrete_type_id,
			o.pump_vehicle_id,
			o.date_time AS order_date_time,
			o.total_edit,
			o.unload_price,
			o.quant AS order_quant,
			sum(s.quant) AS quant,

			sum(
				(
					CASE
						WHEN coalesce(s.ship_cost_edit, FALSE) THEN s.ship_cost
						WHEN dest.id = const_self_ship_dest_id_val() THEN 0
						WHEN o.concrete_type_id = 12 THEN const_water_ship_cost_val()
						ELSE
							(
								CASE
									WHEN coalesce(dest.special_price, FALSE) THEN coalesce(pv.pv_price, 0)
									ELSE coalesce(sfoc.price, coalesce(pv.pv_price, 0))
								END
							)
							* shipments_quant_for_cost(
								s.shift_start_ts::date,
								s.quant::numeric,
								dest.distance::numeric,
								coalesce(cl.shipment_quant_for_cost, 0)
							)
					END
				)::numeric(15,2)
			) AS deliv_cost,

			bool_or(coalesce(s.pump_has_edit, FALSE)) AS pump_has_edit,
			max(s.pump_sum) AS pump_sum

		FROM (
			SELECT
				sh.*,
				bool_or(coalesce(sh.pump_for_client_cost_edit, FALSE)) OVER (PARTITION BY sh.order_id) AS pump_has_edit,
				sum(coalesce(sh.pump_for_client_cost, 0)::numeric(15,2)) OVER (PARTITION BY sh.order_id) AS pump_sum
			FROM shipments sh
		) s
		JOIN orders o ON o.id = s.order_id
		JOIN destinations dest ON dest.id = o.destination_id
		JOIN clients cl ON cl.id = o.client_id

		LEFT JOIN LATERAL (
			SELECT coalesce(
				period_value('destination_price'::period_value_types, dest.id, s.date_time)::numeric(15,2),
				0
			) AS pv_price
		) pv ON TRUE

		LEFT JOIN LATERAL (
			SELECT sh_p.price
			FROM shipment_for_owner_costs sh_p
			WHERE sh_p.date <= o.date_time::date
				AND sh_p.distance_to >= dest.distance
			ORDER BY sh_p.date DESC, sh_p.distance_to ASC
			LIMIT 1
		) sfoc ON TRUE

		WHERE cl.account_from_date IS NULL OR s.shift_start_ts >= cl.account_from_date

		GROUP BY
			s.order_id,
			o.client_id,
			s.shift_start_ts::date,
			o.destination_id,
			o.concrete_type_id,
			o.pump_vehicle_id,
			o.date_time,
			o.total_edit,
			o.unload_price,
			o.quant
	) b

	LEFT JOIN pump_vehicles pvh ON pvh.id = b.pump_vehicle_id

	LEFT JOIN LATERAL (
		SELECT pr.price
		FROM owner_price_list(b.client_id, b.order_date_time) pr
		WHERE pr.concrete_type_id = b.concrete_type_id
		LIMIT 1
	) op ON TRUE

	LEFT JOIN LATERAL (
		SELECT pr.price
		FROM client_price_list(b.client_id, b.order_date_time) pr
		WHERE pr.concrete_type_id = b.concrete_type_id
		LIMIT 1
	) cp ON TRUE

	LEFT JOIN LATERAL (
		SELECT
			(
				CASE
					WHEN coalesce(pr_vals.price_fixed, 0) > 0 THEN pr_vals.price_fixed
					ELSE coalesce(pr_vals.price_m, 0) * b.order_quant
				END
			)::numeric(15,2) AS pump_calc
		FROM pump_prices_values pr_vals
		WHERE pr_vals.pump_price_id = (pump_vehicle_price_on_date(pvh.pump_prices, b.order_date_time)->'keys'->>'id')::int
			AND b.order_quant <= pr_vals.quant_to
		ORDER BY pr_vals.quant_to ASC
		LIMIT 1
	) ppv ON TRUE
) x
JOIN destinations dest ON dest.id = x.destination_id
JOIN concrete_types ct ON ct.id = x.concrete_type_id
JOIN clients cl ON cl.id = x.client_id;
