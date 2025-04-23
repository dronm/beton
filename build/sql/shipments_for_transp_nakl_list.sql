-- View: public.shipments_for_transp_nakl_list;

-- DROP VIEW public.shipments_for_transp_nakl_list;

CREATE OR REPLACE VIEW public.shipments_for_transp_nakl_list AS 
	SELECT
		sh.id,
		sh.date_time,
		sh.order_id,
		shipments_ref(sh) AS shipments_ref,
		vehicles_ref(vh) AS vehicles_ref,

		drivers_ref(dr) AS drivers_ref,
		att_drv.id IS NOT NULL AS driver_sig_exists,

		op.users_ref AS operators_ref,
		att_op.id IS NOT NULL AS operator_sig_exists,

		clients_ref(vh_cl) AS carriers_ref,		
		vh_cl.ref_1c IS NOT NULL AS carrier_ref_1c_exists,

		production_sites_ref(pr_st) AS production_sites_ref,

		sh.quant

	FROM shipments AS sh 

	LEFT JOIN production_sites pr_st ON pr_st.id = sh.production_site_id
	--driver sig
	LEFT JOIN vehicle_schedules sch ON sch.id = sh.vehicle_schedule_id
	LEFT JOIN vehicles vh ON vh.id = sch.vehicle_id
	LEFT JOIN drivers dr ON dr.id = vh.driver_id
	LEFT JOIN entity_contacts ect_drv ON ect_drv.entity_type = 'drivers' AND ect_drv.entity_id = dr.id
	LEFT JOIN contacts ct_drv ON ct_drv.id = ect_drv.contact_id
	LEFT JOIN attachments att_drv ON 
			(att_drv.ref->'keys'->>'id')::int = ct_drv.id 
			AND att_drv.ref->>'dataType' = 'contacts'

	--operator sig
	LEFT JOIN operators_for_transp_nakls_list op ON 
			(op.production_sites_ref->'keys'->>'id')::int = sh.production_site_id
	LEFT JOIN entity_contacts ect_op ON 
			ect_op.entity_type = 'users' 
			AND ect_op.entity_id = (op.users_ref->'keys'->>'id')::int
	LEFT JOIN contacts ct_op ON ct_op.id = ect_op.contact_id
	LEFT JOIN attachments att_op ON 
			(att_op.ref->'keys'->>'id')::int = ct_op.id 
			AND att_op.ref->>'dataType' = 'contacts'

	--owner
	LEFT JOIN vehicle_owners AS v_own ON v_own.id = vh.official_vehicle_owner_id
	LEFT JOIN clients AS vh_cl ON vh_cl.id = v_own.client_id

	ORDER BY sh.date_time ASC;

