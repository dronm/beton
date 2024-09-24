-- View: drivers_list

-- DROP VIEW drivers_list;

CREATE OR REPLACE VIEW drivers_list AS 
	SELECT
	 	dr.id,
	 	dr.name,
	 	dr.driver_licence,
	 	dr.driver_licence_class,
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
		WHERE en.entity_type = 'drivers' AND en.entity_id = dr.id
		) AS contact_list,
		
		(SELECT
			array_agg(en.contact_id)
		FROM entity_contacts AS en
		WHERE en.entity_type = 'drivers' AND en.entity_id = dr.id
		) AS contact_ids
		
	 	
 	FROM drivers AS dr
	ORDER BY dr.name;

ALTER TABLE drivers_list OWNER TO ;

