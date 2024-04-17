-- View: destination_list_view

-- DROP VIEW destination_list_view;

CREATE OR REPLACE VIEW destination_list_view AS 
	WITH
	last_price AS
		(SELECT
			max(t.date) AS date,
			t.distance_to
		FROM shipment_for_owner_costs AS t
		GROUP BY t.distance_to
		ORDER BY t.distance_to
		)
	,act_price AS
		(SELECT
			t.distance_to,
			t.price
		FROM last_price
		LEFT JOIN shipment_for_owner_costs AS t ON last_price.date=t.date AND last_price.distance_to=t.distance_to
		ORDER BY t.distance_to
		)
	SELECT
		destinations.id,
		destinations.name,
		destinations.distance,
		time5_descr(destinations.time_route) AS time_route,
		CASE
			WHEN destination_prod_base_price_val(1, destinations.id, now()::timestamp) IS NOT NULL THEN
				destination_prod_base_price_val(1, destinations.id, now()::timestamp)
				
		
			WHEN coalesce(destinations.special_price,FALSE) = TRUE THEN
				coalesce(price_vals.price,0)
				
			ELSE
				coalesce(
					coalesce(
						(SELECT act_price.price
						FROM act_price
						WHERE destinations.distance <= act_price.distance_to
						LIMIT 1
						)
					,price_vals.price)
				,0)
		END AS price,
		
		destinations.special_price,
		
		CASE
			-- самовывоз
			WHEN destinations.id = const_self_ship_dest_id_val() THEN 0
			
			WHEN destination_prod_base_driver_price_val(1, destinations.id, now()::timestamp) IS NOT NULL THEN
				destination_prod_base_driver_price_val(1, destinations.id, now()::timestamp)
				
			
			-- специальная цена
			WHEN coalesce(price_for_dr_vals.price_for_driver,0)>0 THEN price_for_dr_vals.price_for_driver
			
			
			-- всеостальное
			ELSE
				(SELECT
					shdr_cost.price
				FROM shipment_for_driver_costs AS shdr_cost
				WHERE
					shdr_cost.date=(SELECT max(h.date) FROM shipment_for_driver_costs_h AS h)
					AND shdr_cost.distance_to>=destinations.distance
				ORDER BY shdr_cost.distance_to ASC
				LIMIT 1
				)
		END AS price_for_driver
		
		
	FROM destinations

	--price
	LEFT JOIN (
		SELECT
			max(p.date_time) AS date_time,
			p.key AS destination_id
		FROM period_values AS p		
		WHERE p.period_value_type='destination_price'::period_value_types		
		GROUP BY p.key
	) AS price_hist ON price_hist.destination_id = destinations.id 
	LEFT JOIN (
		SELECT
			p.date_time AS date_time,
			p.key AS destination_id,
			p.val::numeric(15,2) AS price
		FROM period_values AS p		
		WHERE p.period_value_type='destination_price'::period_value_types		
	) AS price_vals ON price_vals.destination_id = destinations.id AND price_vals.date_time = price_hist.date_time
	
	--price for driver
	LEFT JOIN (
		SELECT
			max(p.date_time) AS date_time,
			p.key AS destination_id
		FROM period_values AS p		
		WHERE p.period_value_type='destination_price_for_driver'::period_value_types		
		GROUP BY p.key
	) AS price_for_dr_hist ON price_for_dr_hist.destination_id = destinations.id 
	LEFT JOIN (
		SELECT
			p.date_time AS date_time,
			p.key AS destination_id,
			p.val::numeric(15,2) AS price_for_driver
		FROM period_values AS p		
		WHERE p.period_value_type='destination_price_for_driver'::period_value_types		
	) AS price_for_dr_vals ON price_for_dr_vals.destination_id = destinations.id AND price_for_dr_vals.date_time = price_for_dr_hist.date_time
	
	
	ORDER BY destinations.name;

ALTER TABLE destination_list_view
  OWNER TO ;

