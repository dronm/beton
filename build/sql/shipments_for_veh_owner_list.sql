-- VIEW: shipments_for_veh_owner_list

--DROP VIEW shipments_for_veh_owner_list;

CREATE OR REPLACE VIEW shipments_for_veh_owner_list AS
	SELECT
		sh.id,
		sh.ship_date_time,
		sh.destination_id,
		sh.destinations_ref,
		sh.concrete_type_id,
		sh.concrete_types_ref,
		sh.quant,
		sh.vehicle_id,
		sh.vehicles_ref,
		sh.driver_id,
		sh.drivers_ref,
		sh.vehicle_owner_id,
		sh.vehicle_owners_ref,
		sh.cost,
		sh.ship_cost_edit,
		sh.pump_cost_edit,
		sh.demurrage,
		sh.demurrage_cost,
		sh.acc_comment,
		sh.acc_comment_shipment,
		sh.owner_agreed,
		sh.owner_agreed_date_time,
		
		-- ЦЕНА ДЛЯ ВОДИТЕЛЯ
		CASE
		-- самовывоз
		WHEN sh.destination_id = const_self_ship_dest_id_val() THEN 0
		
		-- Цена для производственной зоны
		WHEN destination_prod_base_driver_price_val(pr_bs.id, dest.id, sh.ship_date_time::timestamp) IS NOT NULL THEN
			destination_prod_base_driver_price_val(pr_bs.id, dest.id, sh.ship_date_time::timestamp) *
				shipments_quant_for_cost(sh.ship_date_time::date, sh.quant::numeric, dest.distance::numeric, coalesce(cl.shipment_quant_for_cost,0))
		
		-- периодическая цена для всех зон
		WHEN coalesce(per_vals.price_for_driver, 0)>0 THEN
			per_vals.price_for_driver *
				shipments_quant_for_cost(sh.ship_date_time::date, sh.quant::numeric, dest.distance::numeric, coalesce(cl.shipment_quant_for_cost,0))
			
		-- все остальные случаи
		ELSE
			(WITH
			act_price AS (
				SELECT h.date AS d
				FROM shipment_for_driver_costs_h h
				WHERE h.date<=sh.ship_date_time::date
				ORDER BY h.date DESC
				LIMIT 1
			)
			SELECT shdr_cost.price
			FROM shipment_for_driver_costs AS shdr_cost
			WHERE
				shdr_cost.date=(SELECT d FROM act_price)
				AND shdr_cost.distance_to>=dest.distance
				/*OR shdr_cost.id=(
					SELECT t.id
					FROM shipment_for_driver_costs t
					WHERE t.date=(SELECT d FROM act_price)
					ORDER BY t.distance_to LIMIT 1
				)
				*/
			ORDER BY shdr_cost.distance_to ASC
			LIMIT 1
			) * shipments_quant_for_cost(sh.ship_date_time::date, sh.quant::numeric, dest.distance::numeric, coalesce(cl.shipment_quant_for_cost,0))
		END AS cost_for_driver,
		
		sh.production_sites_ref,
		production_bases_ref(pr_bs) AS production_bases_ref,
		pr_bs.id AS production_base_id
		
	FROM shipments_list sh
	LEFT JOIN destinations AS dest ON dest.id=destination_id
	
	LEFT JOIN (
		SELECT
			max(p.date_time) AS date_time,
			p.key AS destination_id
		FROM period_values AS p		
		WHERE p.period_value_type='destination_price_for_driver'::period_value_types		
		GROUP BY p.key
	) AS per_hist ON per_hist.destination_id = dest.id 
	LEFT JOIN (
		SELECT
			p.date_time AS date_time,
			p.key AS destination_id,
			p.val::numeric(15,2) AS price_for_driver
		FROM period_values AS p		
		WHERE p.period_value_type='destination_price_for_driver'::period_value_types		
	) AS per_vals ON per_vals.destination_id = dest.id AND per_vals.date_time = per_hist.date_time
		
	LEFT JOIN production_sites AS pr_st ON pr_st.id = sh.production_site_id
	LEFT JOIN production_bases AS pr_bs ON pr_bs.id = pr_st.production_base_id
	
	LEFT JOIN clients AS cl ON cl.id = sh.client_id
	
	ORDER BY ship_date_time DESC
	;
	
ALTER VIEW shipments_for_veh_owner_list OWNER TO ;
