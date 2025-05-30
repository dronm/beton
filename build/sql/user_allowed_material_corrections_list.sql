-- View: public.user_allowed_material_corrections_list

-- DROP VIEW suppliers_list;

CREATE OR REPLACE VIEW public.user_allowed_material_corrections_list AS 
	SELECT
		t.user_id,
		users_ref(u) AS users_ref
 	FROM public.user_allowed_material_corrections AS t 
	LEFT JOIN users AS u ON u.id = t.user_id
	ORDER BY u.name;


