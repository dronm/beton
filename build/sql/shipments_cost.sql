-- Function: shipments_cost(in_production_base_id int, destinations, int, date, shipments, bool)

--DROP FUNCTION shipments_cost(in_production_base_id int, destinations, int, date, shipments, bool);

CREATE OR REPLACE FUNCTION shipments_cost(in_production_base_id int, in_destinations destinations, in_concrete_type_id int, in_date date, in_shipments shipments, in_editable bool)
  RETURNS numeric(15,2) AS
$$
	SELECT
		coalesce(
			(CASE
				-- вручную в документе
				WHEN in_editable AND coalesce(in_shipments.ship_cost_edit,FALSE) THEN in_shipments.ship_cost
				
				-- самовывоз
				WHEN in_destinations.id = const_self_ship_dest_id_val() THEN 0
				
				-- Вода
				WHEN in_concrete_type_id = 12 THEN
					water_ship_cost_on_date(in_shipments.date_time)
					
				-- все остальное
				ELSE
					CASE
						-- цена по производственным зонам
						WHEN destination_prod_base_price_val(in_production_base_id, in_destinations.id, in_shipments.ship_date_time::timestamp) IS NOT NULL THEN
							destination_prod_base_price_val(in_production_base_id, in_destinations.id, in_shipments.ship_date_time::timestamp)
							
						-- специальная цена
						WHEN coalesce(in_destinations.special_price,FALSE) THEN
							coalesce(in_destinations.price,0)
							
						-- по шаблону от расстояния
						ELSE
							coalesce(
								(SELECT sh_p.price
								FROM shipment_for_owner_costs sh_p
								WHERE sh_p.date<=in_date AND sh_p.distance_to>=in_destinations.distance
								ORDER BY sh_p.date DESC,sh_p.distance_to ASC
								LIMIT 1
								),			
							coalesce(in_destinations.price,0))			
					END
					*
					shipments_quant_for_cost(in_date, in_shipments.quant::numeric, in_destinations.distance::numeric)
					/*
					CASE
						WHEN in_date < '2021-07-01' THEN
						CASE
							WHEN in_shipments.quant>=7 THEN in_shipments.quant
							WHEN in_destinations.distance<=60 THEN greatest(5,in_shipments.quant)
							ELSE 7
						END
						ELSE
							CASE
								WHEN in_shipments.quant>=7 THEN in_shipments.quant
								WHEN in_destinations.distance<=60 THEN 7
								ELSE 10
							END
					END	
					*/
			END)::numeric(15,2)
			,0
		)
	;
$$
  LANGUAGE sql STABLE --IMMUTABLE VOLATILE
  COST 100;
ALTER FUNCTION shipments_cost(in_production_base_id int, destinations, int, date, shipments, bool) OWNER TO ;

