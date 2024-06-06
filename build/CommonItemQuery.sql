--ID=3 Самовывоз (БЕТОН)

SELECT
	-1*sum(sh.cost_concrete+sh.cost_shipment) AS cost
FROM shipments_for_client_veh_owner_list AS sh
WHERE sh.ship_date BETWEEN '{{DATE_FROM}}' AND '{{DATE_TO}}'
	AND sh.client_id = (SELECT own.client_id FROM vehicle_owners AS own WHERE own.id={{VEHICLE_OWNER_ID}})
	


SELECT
	-1*sum(
		coalesce(
			--ship cost
			shipments_cost(ps.production_base_id, dest, o.concrete_type_id, o.date_time::date, sh, TRUE) +
			
			--concrete cost
			(SELECT
				pr.price
			FROM vehicle_owner_concrete_prices AS pr_t
			LEFT JOIN concrete_costs_for_owner AS pr ON pr.header_id = pr_t.concrete_costs_for_owner_h_id AND pr.concrete_type_id=o.concrete_type_id
			WHERE
				pr_t.vehicle_owner_id={{VEHICLE_OWNER_ID}}
				AND pr_t.client_id=o.client_id
				AND pr_t.date<=o.date_time
			ORDER BY pr_t.date DESC
			LIMIT 1)
		,0)*o.quant::numeric	
	) AS cost
FROM shipments AS sh
left join orders as o on o.id = sh.order_id
LEFT JOIN production_sites ps ON ps.id = sh.production_site_id
LEFT JOIN destinations AS dest ON dest.id=o.destination_id
WHERE
	sh.ship_date_time BETWEEN '{{DATE_FROM}}' AND '{{DATE_TO}}'
	AND o.client_id = (SELECT own.client_id FROM vehicle_owners AS own WHERE own.id={{VEHICLE_OWNER_ID}})
	
