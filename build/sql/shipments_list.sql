-- View: public.shipments_list

--DROP VIEW shipments_for_veh_owner_list;
--DROP VIEW shipment_dates_list;
--DROP VIEW public.shipments_list;

CREATE OR REPLACE VIEW public.shipments_list AS 
	SELECT
		sh.id,
		sh.ship_date_time,
		sh.quant,
		
		--shipments_cost(dest,o.concrete_type_id,o.date_time::date,sh,TRUE) AS cost,
		(CASE
			-- Вручную из документа
			WHEN coalesce(sh.ship_cost_edit, FALSE) THEN sh.ship_cost
			
			-- Самовывоз
			WHEN dest.id=const_self_ship_dest_id_val() THEN 0
			
			-- Вода
			WHEN o.concrete_type_id = (select (const_water_val()->'keys'->>'id')::int) THEN
				case
					when sh.date_time::date>='2025-01-01' then
						water_ship_cost_on_date(sh.date_time) * shipments_quant_for_cost(sh.ship_date_time::date, sh.quant::numeric, dest.distance::numeric, coalesce(cl.shipment_quant_for_cost,0))
					else
						--water_ship_cost_on_date(sh.date_time)
						4000::numeric(15, 2)
				end
				
			-- Все остальное
			ELSE
				CASE
					-- цена по производственным зонам
					WHEN destination_prod_base_price_val(ps.production_base_id, dest.id, sh.ship_date_time::timestamp) IS NOT NULL THEN
						destination_prod_base_price_val(ps.production_base_id, dest.id, sh.ship_date_time::timestamp)
				
					-- специальная цена
					WHEN coalesce(dest.special_price, FALSE) THEN
						coalesce(period_value('destination_price'::period_value_types, dest.id, sh.date_time)::numeric(15,2),0)
						
					-- по схеме от расстояния
					ELSE
						coalesce(
							(SELECT sh_p.price
							FROM shipment_for_owner_costs sh_p
							WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
							ORDER BY sh_p.date DESC,sh_p.distance_to ASC
							LIMIT 1
							)			
							,coalesce(dest.price, 0)
						)
				END
				*
				shipments_quant_for_cost(sh.ship_date_time::date, sh.quant::numeric, dest.distance::numeric, coalesce(cl.shipment_quant_for_cost,0))
		END)::numeric(15,2)
		AS cost,
		
		sh.shipped,
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_type_id,		
		v.owner,
		
		vehicles_ref(v) AS vehicles_ref,
		vs.vehicle_id,
		
		drivers_ref(d) AS drivers_ref,
		vs.driver_id,
		
		destinations_ref(dest) As destinations_ref,
		o.destination_id,
		
		clients_ref(cl) As clients_ref,
		o.client_id,
		
		shipments_demurrage_cost(sh.demurrage::interval, sh.date_time) AS demurrage_cost,
		sh.demurrage,
		
		sh.client_mark,
		sh.blanks_exist,
		
		users_ref(u) As users_ref,
		o.user_id,
		
		production_sites_ref(ps) AS production_sites_ref,
		sh.production_site_id,
		
		--vehicle_owners_ref(v_own) AS vehicle_owners_ref,
		vehicle_owner_on_date(v.vehicle_owners,sh.date_time) AS vehicle_owners_ref,
		
		sh.acc_comment,
		sh.acc_comment_shipment,
		--v_own.id AS vehicle_owner_id,
		((vehicle_owner_on_date(v.vehicle_owners,sh.date_time))->'keys'->>'id')::int AS vehicle_owner_id,
		
		--shipments_pump_cost(sh,o,dest,pvh,TRUE) AS pump_cost,
		(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0
				WHEN coalesce(sh.pump_cost_edit,FALSE) THEN sh.pump_cost::numeric(15,2)
				--last ship only!!!
				WHEN sh.id = (SELECT this_ship.id FROM shipments AS this_ship WHERE this_ship.order_id=o.id ORDER BY this_ship.ship_date_time DESC LIMIT 1)
				THEN
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(WITH
							pump_price_id AS (
								SELECT (pump_vehicle_price_on_date(pvh.pump_prices, sh.date_time)->'keys'->>'id')::int AS id
							),
							garant_pr AS (
								SELECT
									price_fixed,
									greatest(o.quant - quant_to, 0) AS quant_over
								FROM pump_prices_values
								WHERE pump_price_id = (SELECT id FROM pump_price_id)
									AND coalesce(price_garanteed, FALSE)
									AND coalesce(quant_from, 0) <= o.quant
									AND coalesce(price_fixed, 0) > 0
								ORDER BY quant_from DESC
								LIMIT 1
							)
							SELECT
								coalesce((SELECT price_fixed FROM garant_pr), 0) +
								(SELECT
									CASE
										WHEN coalesce(pr_vals.price_fixed, 0)>0 THEN pr_vals.price_fixed
										ELSE coalesce(pr_vals.price_m, 0) * coalesce((SELECT quant_over FROM garant_pr), o.quant)
									END
								FROM pump_prices_values AS pr_vals
								WHERE pr_vals.pump_price_id = (SELECT id FROM pump_price_id)
									AND o.quant <= coalesce(pr_vals.quant_to, 999999)
									AND coalesce(pr_vals.price_garanteed, FALSE) = FALSE
								ORDER BY pr_vals.quant_to ASC
								LIMIT 1)
							)::numeric(15,2)
					END
				ELSE 0	
			END
		) AS pump_cost,
		
		pump_vehicles_ref(pvh,pvh_v,pvh_own) AS pump_vehicles_ref,
		pvh.vehicle_id AS pump_vehicle_id,
		pvh_v.vehicle_owner_id AS pump_vehicle_owner_id,
		sh.owner_agreed,
		sh.owner_agreed_date_time,
		sh.owner_pump_agreed,
		sh.owner_pump_agreed_date_time,
		
		vehicle_owners_ref(pvh_own) AS pump_vehicle_owners_ref,
		
		CASE
			-- цена по производственным зонам
			WHEN destination_prod_base_price_val(ps.production_base_id, dest.id, sh.ship_date_time::timestamp) IS NOT NULL THEN
				destination_prod_base_price_val(ps.production_base_id, dest.id, sh.ship_date_time::timestamp)
		
			WHEN coalesce(dest.special_price,FALSE) THEN
				coalesce(
					period_value('destination_price'::period_value_types, dest.id, sh.date_time)::numeric(15,2),
					0
				)
			ELSE
				coalesce(
					(SELECT sh_p.price
					FROM shipment_for_owner_costs sh_p
					WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=dest.distance
					ORDER BY sh_p.date DESC,sh_p.distance_to ASC
					LIMIT 1
					),			
					coalesce(dest.price,0)
				)			
		END AS ship_price,
		
		coalesce(sh.ship_cost_edit,FALSE) AS ship_cost_edit,
		coalesce(sh.pump_cost_edit,FALSE) AS pump_cost_edit,
		
		sh.pump_for_client_cost_edit,
		(SELECT
			CASE
				WHEN o.pump_vehicle_id IS NULL THEN 0
				WHEN coalesce(sh.pump_for_client_cost_edit,FALSE) THEN sh.pump_for_client_cost::numeric(15,2)
				--last ship only!!!
				WHEN sh.id = (SELECT this_ship.id FROM shipments AS this_ship WHERE this_ship.order_id=o.id ORDER BY this_ship.ship_date_time DESC LIMIT 1)
				THEN
					CASE
						WHEN coalesce(o.total_edit,FALSE) AND coalesce(o.unload_price,0)>0 THEN o.unload_price::numeric(15,2)
						ELSE
							(WITH
							pump_price_id AS (
								SELECT (pump_vehicle_price_on_date(pvh.pump_prices, sh.date_time)->'keys'->>'id')::int AS id
							),
							garant_pr AS (
								SELECT
									price_fixed,
									greatest(o.quant - quant_to, 0) AS quant_over
								FROM pump_prices_values
								WHERE pump_price_id = (SELECT id FROM pump_price_id)
									AND coalesce(price_garanteed, FALSE)
									AND coalesce(quant_from, 0) <= o.quant
									AND coalesce(price_fixed, 0) > 0
								ORDER BY quant_from DESC
								LIMIT 1
							)
							SELECT
								coalesce((SELECT price_fixed FROM garant_pr), 0) +
								(SELECT 
									CASE
										WHEN coalesce(pr_vals.price_fixed,0)>0 THEN pr_vals.price_fixed
										ELSE coalesce(pr_vals.price_m, 0) * coalesce((SELECT quant_over FROM garant_pr), o.quant)
									END
								FROM pump_prices_values AS pr_vals
								WHERE pr_vals.pump_price_id = (SELECT id FROM pump_price_id)
									AND o.quant <= coalesce(pr_vals.quant_to, 999999)
									AND coalesce(pr_vals.price_garanteed, FALSE) = FALSE								
								ORDER BY pr_vals.quant_to ASC
								LIMIT 1)
							)::numeric(15,2)
					END
				ELSE 0	
			END
		) AS pump_for_client_cost
		
		/*,prod.production_id
		,concrete_types_ref(prod_concr) AS production_concrete_types_ref
		,prod.concrete_quant AS production_concrete_quant
		*/
		
	FROM shipments sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN vehicle_schedules vs ON vs.id = sh.vehicle_schedule_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN users u ON u.id = sh.user_id
	LEFT JOIN production_sites ps ON ps.id = sh.production_site_id
	LEFT JOIN vehicle_owners v_own ON v_own.id = v.vehicle_owner_id
	LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
	LEFT JOIN vehicles pvh_v ON pvh_v.id = pvh.vehicle_id
	LEFT JOIN vehicle_owners pvh_own ON pvh_own.id = pvh_v.vehicle_owner_id
	
	/*LEFT JOIN (
		SELECT
			t.shipment_id,
			t.production_id,
			t.concrete_type_id,
			sum(concrete_quant)::numeric(19,4) AS concrete_quant
		FROM productions AS t
		GROUP BY t.shipment_id,t.production_id,t.concrete_type_id
	) AS prod ON prod.shipment_id = sh.id
	LEFT JOIN concrete_types AS prod_concr ON prod_concr.id = prod.concrete_type_id
	*/
	ORDER BY sh.date_time DESC
	--LIMIT 60
	;

ALTER TABLE public.shipments_list OWNER TO beton;

