-- View: public.doc_material_movements_list

 --DROP VIEW public.doc_material_movements_list;

CREATE OR REPLACE VIEW public.doc_material_movements_list AS 
	SELECT
	 	t.id,
	 	t.date_time,
	 	t.number,
		t.production_base_from_id,
		t.production_base_to_id,
		production_bases_ref(ps_from) AS production_bases_from_ref,
		production_bases_ref(ps_to) AS production_bases_to_ref,
		materials_ref(m) AS materials_ref,
		users_ref(u) AS users_ref,
		suppliers_ref(sp) AS carriers_ref,
		t.vehicle_plate,
		t.quant,
		users_ref(u_last) AS last_modif_users_ref,
		t.last_modif_date_time,
		t.comment_text

 	FROM doc_material_movements AS t 
	LEFT JOIN production_bases AS ps_from ON ps_from.id = t.production_base_from_id
	LEFT JOIN production_bases AS ps_to ON ps_to.id = t.production_base_to_id
	LEFT JOIN raw_materials AS m ON m.id = t.material_id
	LEFT JOIN users AS u ON u.id = t.user_id
	LEFT JOIN users AS u_last ON u_last.id = t.last_modif_user_id
	LEFT JOIN suppliers AS sp ON sp.id = t.carrier_id
	ORDER BY t.date_time DESC;


