-- VIEW: shipments_for_doc_list

-- DROP VIEW shipments_for_doc_list;

CREATE OR REPLACE VIEW shipments_for_doc_list AS
	SELECT
		sh.id,
		sh.ship_date_time,
		sh.production_site_id,
		production_sites_ref(ps) AS production_sites_ref,
		o.client_id,
		clients_ref(cl) As clients_ref,
		o.destination_id,
		destinations_ref(dest) AS destinations_ref,
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_type_id,
		vehicles_ref(v) AS vehicles_ref,
		vs.vehicle_id,
		drivers_ref(d) AS drivers_ref,
		vs.driver_id,
		sh.quant,
		sh.vehicle_schedule_id

	FROM shipments as sh
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN vehicle_schedules vs ON vs.id = sh.vehicle_schedule_id
	LEFT JOIN drivers d ON d.id = vs.driver_id
	LEFT JOIN vehicles v ON v.id = vs.vehicle_id
	LEFT JOIN production_sites ps ON ps.id = sh.production_site_id
	LEFT JOIN concrete_types AS ct ON ct.id=o.concrete_type_id
	LEFT JOIN destinations AS dest ON dest.id=o.destination_id

	ORDER BY sh.ship_date_time DESC
	;
	
ALTER VIEW shipments_for_doc_list OWNER TO ;
