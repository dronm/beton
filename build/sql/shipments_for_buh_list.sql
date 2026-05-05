-- View: public.shipments_for_buh_list;

-- DROP VIEW public.shipments_for_buh_list;

CREATE OR REPLACE VIEW public.shipments_for_buh_list AS 
	SELECT
		sh.id,
		sh.date_time,
		sh.order_id,
		shipments_ref(sh) AS shipments_ref,
		vehicles_ref(vh) AS vehicles_ref,

		drivers_ref(dr) AS drivers_ref,

		clients_ref(vh_cl) AS carriers_ref,		
		vh_cl.ref_1c IS NOT NULL AS carrier_ref_1c_exists,

		production_sites_ref(pr_st) AS production_sites_ref,

		sh.quant,
		bd.ref_1c AS buh_doc_ref_1c

	FROM shipments AS sh 

	LEFT JOIN production_sites AS pr_st ON pr_st.id = sh.production_site_id

	LEFT JOIN vehicle_schedules AS sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles AS vh ON vh.id = sch.vehicle_id
	LEFT JOIN drivers AS dr ON dr.id = vh.driver_id

	LEFT JOIN vehicle_owners AS v_own ON v_own.id = vh.official_vehicle_owner_id
	LEFT JOIN clients AS vh_cl ON vh_cl.id = v_own.client_id
	LEFT JOIN buh_doc_shipments AS bdsh ON bdsh.order_id = sh.order_id AND bdsh.shipment_id = sh.id
	LEFT JOIN buh_docs AS bd ON bd.id = bdsh.buh_doc_id


	ORDER BY sh.date_time ASC;

