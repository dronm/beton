-- View: suppliers_list

-- DROP VIEW suppliers_list;

CREATE OR REPLACE VIEW suppliers_list AS 
	SELECT
	 	sp.id,
	 	sp.name,
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
		WHERE en.entity_type = 'suppliers' AND en.entity_id = sp.id
		) AS contact_list
	 	
 	FROM suppliers AS sp
	ORDER BY sp.name;

ALTER TABLE suppliers_list OWNER TO ;

