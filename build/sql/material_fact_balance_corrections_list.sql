-- VIEW: material_fact_balance_corrections_list

--DROP VIEW material_fact_balance_corrections_list;

CREATE OR REPLACE VIEW material_fact_balance_corrections_list AS
	SELECT
		t.id,
		t.date_time,
		t.balance_date_time,
		t.user_id,
		users_ref(u) AS users_ref,
		t.material_id,
		materials_ref(mat) AS materials_ref,
		t.required_balance_quant,
		t.comment_text,
		t.production_site_id,
		production_sites_ref(pr_st) AS production_sites_ref,
		users_ref(u_last) AS last_modif_users_ref,
		t.last_modif_date_time
		
	FROM material_fact_balance_corrections t
	LEFT JOIN users u ON u.id=t.user_id
	LEFT JOIN raw_materials mat ON mat.id=t.material_id
	LEFT JOIN production_sites AS pr_st ON pr_st.id=t.production_site_id		
	LEFT JOIN users AS u_last ON u_last.id = t.last_modif_user_id
	ORDER BY t.date_time DESC
	;
	
