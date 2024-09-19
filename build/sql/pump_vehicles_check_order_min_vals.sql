-- Function: pump_vehicles_check_order_min_vals(in_pump_vehicle_id int, in_quant numeric(19,2), in_date_time timestamp, in_order_id int)

-- DROP FUNCTION pump_vehicles_check_order_min_vals(in_pump_vehicle_id int, in_quant numeric(19,2), in_date_time timestamp, in_order_id int);
/**
 * returns result bool, pump_vehicle_min_quant numeric(19,4), pump_vehicle_min_time_interval interval
 */
CREATE OR REPLACE FUNCTION pump_vehicles_check_order_min_vals(in_pump_vehicle_id int, in_quant numeric(19,2), in_date_time timestamp, in_order_id int)
  RETURNS RECORD AS
$$
	WITH
	order_data AS (
		SELECT
			orders.id,
			orders.quant,
			orders.pump_vehicle_id,
			orders.date_time
		FROM orders
		WHERE orders.id = in_order_id
	)
	,params AS (
		SELECT
			CASE
				WHEN in_pump_vehicle_id IS NOT NULL THEN in_pump_vehicle_id
				ELSE (SELECT pump_vehicle_id FROM order_data)
			END AS pump_vehicle_id,
			CASE
				WHEN in_quant IS NOT NULL THEN in_quant
				ELSE (SELECT quant FROM order_data)
			END AS quant,
			CASE
				WHEN in_date_time IS NOT NULL THEN in_date_time
				ELSE (SELECT date_time FROM order_data)
			END AS date_time			
	)
	
	
	,veh_data AS (
		SELECT
			coalesce(min_order_quant, 0) AS min_order_quant,
			coalesce(min_order_time_interval, '00:00') AS min_order_time_interval
		FROM pump_vehicles
		WHERE id = in_pump_vehicle_id
	)
	,res AS (
		SELECT
		CASE
			WHEN (SELECT min_order_quant FROM veh_data) = 0 AND (SELECT min_order_time_interval FROM veh_data) = '00:00'::interval THEN TRUE
			WHEN (SELECT min_order_quant FROM veh_data) > 0 AND (SELECT quant FROM params) < (SELECT min_order_quant FROM veh_data) THEN FALSE
			WHEN (SELECT min_order_time_interval FROM veh_data) <> '00:00'::interval AND
					--previous order with the same pump vehicle
					((SELECT date_time FROM params) - (SELECT
						o.date_time
					FROM orders AS o
					WHERE
						o.pump_vehicle_id = (SELECT pump_vehicle_id FROM params)
						AND o.date_time <= (SELECT date_time FROM params) 
						AND (in_order_id IS NULL OR o.id <> in_order_id)
					ORDER BY o.date_time DESC
					LIMIT 1
					) < (SELECT min_order_time_interval FROM veh_data))
					
					OR
					
					--next order with the same pump vehicle
					((SELECT
						o.date_time
					FROM orders AS o
					WHERE
						o.pump_vehicle_id = (SELECT pump_vehicle_id FROM params)
						AND o.date_time >= (SELECT date_time FROM params) 
						AND (in_order_id IS NULL OR o.id <> in_order_id)
					ORDER BY o.date_time ASC
					LIMIT 1
					) - (SELECT date_time FROM params) < (SELECT min_order_time_interval FROM veh_data))
					
					THEN FALSE
			ELSE TRUE
		END AS v
	)
	SELECT
		(SELECT v FROM res),
		case
			when NOT (SELECT v FROM res) then (select min_order_quant from pump_vehicles where id = (select pump_vehicle_id from params))
			else null
		end as min_quant,
		case
			when NOT (SELECT v FROM res) then (select min_order_time_interval from pump_vehicles where id = (select pump_vehicle_id from params))
			else null
		end as min_interval
	;
$$
  LANGUAGE sql VOLATILE
  CALLED ON NULL INPUT
  COST 100;
 ALTER FUNCTION pump_vehicles_check_order_min_vals(in_pump_vehicle_id int, in_quant numeric(19,2), in_date_time timestamp, in_order_id int) OWNER TO ;


