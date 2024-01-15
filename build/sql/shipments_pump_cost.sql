-- Function: shipments_pump_cost(shipments, orders, destinations, pump_vehicles, bool)

--DROP FUNCTION shipments_pump_cost(shipments, orders, destinations, pump_vehicles, bool);

CREATE OR REPLACE FUNCTION shipments_pump_cost(in_shipments shipments, in_orders orders, in_destinations destinations,
	in_pump_vehicles pump_vehicles, in_editable bool)
  RETURNS numeric(15,2) AS
$$
	SELECT
		CASE
			WHEN in_orders.pump_vehicle_id IS NULL THEN 0
			WHEN in_editable AND coalesce(in_shipments.pump_cost_edit,FALSE) THEN in_shipments.pump_cost::numeric(15,2)
			--last ship only!!!
			WHEN in_shipments.id = (SELECT this_ship.id FROM shipments AS this_ship WHERE this_ship.order_id=in_orders.id ORDER BY this_ship.ship_date_time DESC LIMIT 1)
			THEN
				CASE
					WHEN coalesce(in_orders.total_edit,FALSE) AND coalesce(in_orders.unload_price,0)>0 THEN in_orders.unload_price::numeric(15,2)
					ELSE
						(WITH
						pump_price_id AS (
							SELECT (pump_vehicle_price_on_date(in_pump_vehicles.pump_prices, in_shipments.date_time)->'keys'->>'id')::int AS id
						),
						garant_pr AS (
							SELECT
								price_fixed,
								greatest(in_orders.quant - quant_to, 0) AS quant_over
							FROM pump_prices_values
							WHERE pump_price_id = (SELECT id FROM pump_price_id)
								AND coalesce(price_garanteed, FALSE)
								AND coalesce(quant_from, 0) <= in_orders.quant
								AND coalesce(price_fixed, 0) > 0
							ORDER BY quant_from DESC
							LIMIT 1
						)
						SELECT 
							coalesce((SELECT price_fixed FROM garant_pr), 0) +
							(SELECT 
								CASE
									WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
									ELSE coalesce(pr_vals.price_m,0) *
										coalesce((SELECT quant_over FROM garant_pr), in_orders.quant)
								END
								
							FROM pump_prices_values AS pr_vals
							WHERE pr_vals.pump_price_id = (SELECT id FROM pump_price_id)
								AND in_orders.quant <= coalesce(pr_vals.quant_to, 999999)
								AND coalesce(pr_vals.price_garanteed, FALSE) = FALSE
							ORDER BY pr_vals.quant_to ASC
							LIMIT 1)
							
						)::numeric(15,2)
				END
			ELSE 0	
		END
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION shipments_pump_cost(shipments, orders, destinations, pump_vehicles, bool) OWNER TO ;

