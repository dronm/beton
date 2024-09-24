-- VIEW: user_operator_list

--DROP VIEW user_operator_list;

CREATE OR REPLACE VIEW user_operator_list AS
	SELECT
		u.id,
		u.name,
		u.email,
		u.phone_cel,
		production_sites_ref(ps) AS production_sites_ref,
		
		(SELECT
			json_agg(
				json_build_object(
					'name', ct.name,
					'tel', ct.tel,
					'tel_ext', ct.tel_ext,
					'email', ct.email,
					'post', p.name
				)
			)
		FROM entity_contacts AS en
		LEFT JOIN contacts AS ct ON ct.id = en.contact_id
		LEFT JOIN posts AS p ON p.id = ct.post_id
		WHERE en.entity_type = 'users' AND en.entity_id = u.id
		) AS contact_list,
		
		(SELECT
			array_agg(en.contact_id)
		FROM entity_contacts AS en
		WHERE en.entity_type = 'users' AND en.entity_id = u.id
		) AS contact_ids
		
		
	FROM users AS u
	LEFT JOIN production_sites AS ps ON ps.id=u.production_site_id
	WHERE role_id='operator' AND NOT coalesce(banned,FALSE)
	ORDER BY u.name
	;
	
ALTER VIEW user_operator_list OWNER TO ;

