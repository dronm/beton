-- VIEW: shipments_for_client_veh_owner_list
-- Rewritten to:
-- 1) eliminate global GROUP BY shipments (uses LATERAL per-order aggregates instead)
-- 2) compute expensive cost_* only once and reuse for cost_total
-- 3) keep semantics equivalent to your original view (including last shipment logic)

DROP VIEW shipments_for_client_veh_owner_list;

CREATE OR REPLACE VIEW shipments_for_client_veh_owner_list AS
SELECT
	o.id,
	o.date_time AS ship_date,
	o.concrete_type_id,
	concrete_types_ref(ct) AS concrete_types_ref,
	o.destination_id,
	destinations_ref(dest) AS destinations_ref,
	o.quant,
	o.client_id,
	clients_ref(cl) AS clients_ref,

	-- Costs computed once (and reused below)
	coalesce(calc.cost_shipment, 0) AS cost_shipment,
	coalesce(calc.cost_concrete, 0) AS cost_concrete,
	coalesce(calc.cost_other_owner_pump, 0)::numeric(15,2) AS cost_other_owner_pump,

	vown_cl.vehicle_owner_id,

	-- Demurrage: per-order aggregate (no global GROUP BY)
	coalesce(sh_agg.demurrage_cost, 0.00)::numeric(15,2) AS cost_demurrage,

	-- Total: reuse computed values (avoid re-running correlated subqueries / functions)
	(
		coalesce(calc.cost_shipment, 0)
		+ coalesce(calc.cost_concrete, 0)
		+ coalesce(calc.cost_other_owner_pump, 0)
		+ coalesce(sh_agg.demurrage_cost, 0.00)
	)::numeric(15,2) AS cost_total
FROM orders o
LEFT JOIN concrete_types ct ON ct.id = o.concrete_type_id
LEFT JOIN destinations dest ON dest.id = o.destination_id
LEFT JOIN vehicle_owner_clients vown_cl ON vown_cl.client_id = o.client_id
LEFT JOIN clients cl ON cl.id = o.client_id
LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
LEFT JOIN vehicles pvh_v ON pvh_v.id = pvh.vehicle_id

-- Per-order shipments aggregate: last ship_date_time + demurrage sum
LEFT JOIN LATERAL (
	SELECT
		max(s.ship_date_time) AS last_ship_date_time,
		sum(coalesce(shipments_demurrage_cost(s.demurrage::interval, s.date_time), 0.00))::numeric(15,2) AS demurrage_cost
	FROM shipments s
	WHERE s.order_id = o.id
) sh_agg ON true

-- Per-order "last shipment" row (matches your original max(ship_date_time) join semantics)
LEFT JOIN LATERAL (
	SELECT
		s.id,
		s.ship_date_time,
		s.order_id,
		s.pump_for_client_cost_edit,
		s.pump_for_client_cost
	FROM shipments s
	WHERE s.order_id = o.id
	ORDER BY s.ship_date_time DESC
	LIMIT 1
) last_sh ON true

-- Compute all expensive cost pieces once
CROSS JOIN LATERAL (
	SELECT
		-- Shipment cost: per-order correlated aggregate
		coalesce((
			SELECT sum(shipments_cost(ps.production_base_id, dest, o.concrete_type_id, o.date_time::date, sh, TRUE))
			FROM shipments sh
			LEFT JOIN production_sites ps ON ps.id = sh.production_site_id
			WHERE sh.order_id = o.id
		), 0)::numeric AS cost_shipment,

		-- Concrete cost: as-of price lookup
		(
			coalesce((
				SELECT pr.price
				FROM vehicle_owner_concrete_prices pr_t
				LEFT JOIN concrete_costs_for_owner pr
					ON pr.header_id = pr_t.concrete_costs_for_owner_h_id
					AND pr.concrete_type_id = o.concrete_type_id
				WHERE pr_t.vehicle_owner_id = vown_cl.vehicle_owner_id
					AND pr_t.client_id = o.client_id
					AND pr_t.date <= o.date_time
				ORDER BY pr_t.date DESC
				LIMIT 1
			), 0) * o.quant::numeric
		)::numeric AS cost_concrete,

		-- Other owner's pump cost: use last_sh + pricing table lookup
		coalesce((
			CASE
				WHEN o.pump_vehicle_id IS NULL
					OR pvh_v.vehicle_owner_id = vown_cl.vehicle_owner_id
					THEN 0::numeric(15,2)

				WHEN coalesce(last_sh.pump_for_client_cost_edit, FALSE)
					THEN last_sh.pump_for_client_cost::numeric(15,2)

				WHEN coalesce(o.total_edit, FALSE) AND coalesce(o.unload_price, 0) > 0
					THEN o.unload_price::numeric(15,2)

				ELSE (
					SELECT
						CASE
							WHEN coalesce(pr_vals.price_fixed, 0) > 0 THEN pr_vals.price_fixed
							ELSE coalesce(pr_vals.price_m, 0) * o.quant
						END
					FROM pump_prices_values pr_vals
					WHERE pr_vals.pump_price_id =
						(pump_vehicle_price_on_date(pvh.pump_prices, o.date_time)->'keys'->>'id')::int
						AND o.quant <= pr_vals.quant_to
					ORDER BY pr_vals.quant_to ASC
					LIMIT 1
				)::numeric(15,2)
			END
		), 0)::numeric(15,2) AS cost_other_owner_pump
) calc;
