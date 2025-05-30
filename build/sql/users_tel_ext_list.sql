-- View: public.users_tel_ext_list

-- DROP VIEW public.users_tel_ext_list;

CREATE OR REPLACE VIEW public.users_tel_ext_list AS 
	SELECT 
		e_ct.entity_id AS id, --user id
		ct.tel_ext
	FROM contacts AS ct
	LEFT JOIN entity_contacts AS e_ct ON e_ct.entity_type = 'users' AND e_ct.contact_id = ct.id
	WHERE tel_ext IS NOT NULL
	;

