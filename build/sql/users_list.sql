-- View: users_list

-- DROP VIEW users_list;

CREATE OR REPLACE VIEW users_list AS 

	SELECT u.id,
	    u.name,
	    u.role_id,
	    u.phone_cel,
	    u.tel_ext,
	    u.email,
	    u.banned,
	    ( SELECT
	    		json_agg(
	    			json_build_object(
	    				'name', ct.name,	    				
	    				'tel', ct.tel,
	    				'tel_ext', ct.tel_ext,
	    				'email', ct.email,
	    				'post', p.name
	    			)
	    		) AS json_agg
		FROM entity_contacts en
		LEFT JOIN contacts ct ON ct.id = en.contact_id
		LEFT JOIN posts p ON p.id = ct.post_id
		WHERE en.entity_type = 'users'::data_types AND en.entity_id = u.id
	  ) AS contact_list,
	  
	    ( SELECT
	    		array_agg(en.contact_id)
		FROM entity_contacts en
		WHERE en.entity_type = 'users'::data_types AND en.entity_id = u.id
	  ) AS contact_ids
	  
	  
	  FROM users u
	  ORDER BY u.name
	;
ALTER TABLE users_list OWNER TO ;
	  
