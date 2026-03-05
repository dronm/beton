
WITH ships AS (
	SELECT
		sum(cost) AS cost,
		sum(cost_for_driver) AS cost_for_driver,
		sum(demurrage_cost) AS demurrage_cost
	FROM shipments_for_veh_owner_list t
	WHERE t.vehicle_owner_id = 401
		AND t.ship_date_time >= timestamp '2026-02-01 06:00:00'
		AND t.ship_date_time <  timestamp '2026-03-01 06:00:00'
),
pumps AS (
	SELECT sum(t.pump_cost) AS cost
	FROM shipments_pump_list t
	WHERE t.pump_vehicle_owner_id = 401
		AND t.date_time >= timestamp '2026-02-01 06:00:00'
		AND t.date_time <  timestamp '2026-03-01 06:00:00'
),
client_ships AS (
	SELECT
		sum(t.cost_concrete) AS cost_concrete,
		sum(t.cost_shipment) AS cost_shipment,
		sum(t.cost_other_owner_pump) AS cost_other_owner_pump,
		sum(t.cost_demurrage) AS cost_demurrage
	FROM shipments_for_client_veh_owner_list t
	WHERE t.vehicle_owner_id = 401
		AND t.ship_date >= timestamp '2026-02-01 06:00:00'
		AND t.ship_date <  timestamp '2026-03-01 06:00:00'
)
SELECT
	coalesce(ships.cost, 0.00) AS ship_cost,
	coalesce(ships.cost_for_driver, 0.00) AS ship_for_driver_cost,
	coalesce(ships.demurrage_cost, 0.00) AS ship_demurrage_cost,
	coalesce(pumps.cost, 0.00) AS pumps_cost,
	coalesce(client_ships.cost_concrete, 0.00) AS client_ships_concrete_cost,
	coalesce(client_ships.cost_other_owner_pump, 0.00) AS client_ships_other_owner_pump_cost,
	coalesce(client_ships.cost_demurrage, 0.00) AS demurrage_cost,
	coalesce(client_ships.cost_shipment, 0.00) AS client_ships_shipment_cost
FROM ships
CROSS JOIN pumps
CROSS JOIN client_ships;
