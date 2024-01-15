-- View: ast_calls_current_contacts

 DROP VIEW ast_calls_current_contacts_test;
CREATE OR REPLACE VIEW ast_calls_current_contacts_test AS 
	SELECT
		--DISTINCT ON (ast.ext)
		ast.unique_id,
		ast.ext,				
		ast.caller_id_num::text AS contact_tel,
		
		ast.dt AS ring_time,
		ast.start_time AS answer_time,
		ast.end_time AS hangup_time,
		ast.manager_comment,
		ast.informed,
		ct.id AS contact_id,
		ct.name AS contact_name,
		ct.email AS contact_email,
		p.name AS contact_post_name,
		(SELECT
			json_agg(
				json_build_object(
					'tp', t.entity_type,
					'id', t.entity_id,
					'descr',
					CASE
						WHEN t.entity_type = 'users' THEN u.name::text
						WHEN t.entity_type = 'clients' THEN cl.name::text
						WHEN t.entity_type = 'suppliers' THEN sp.name::text
						WHEN t.entity_type = 'drivers' THEN d.name::text
						WHEN t.entity_type = 'pump_vehicles' THEN v.plate::text
					END
				)
			)
		FROM entity_contacts AS t
		LEFT JOIN users AS u ON u.id = t.entity_id AND t.entity_type = 'users'
		LEFT JOIN clients AS cl ON cl.id = t.entity_id AND t.entity_type = 'clients'
		LEFT JOIN suppliers AS sp ON sp.id = t.entity_id AND t.entity_type = 'suppliers'
		LEFT JOIN drivers AS d ON d.id = t.entity_id AND t.entity_type = 'drivers'
		LEFT JOIN pump_vehicles AS pv ON pv.id = t.entity_id AND t.entity_type = 'pump_vehicles'
		LEFT JOIN vehicles AS v ON v.id = pv.vehicle_id
		WHERE t.contact_id = ast.contact_id
		) AS contact_entities,
		
		(SELECT
		FROM entity_contacts
		WHERE t.contact_id = ast.contact_id AND t.entity_type = 'clients'
		LIMIT 1
		)
		
	FROM ast_calls ast
   	LEFT JOIN contacts ct ON ct.id = ast.contact_id
   	LEFT JOIN posts p ON p.id = ct.post_id   
   	/*
	WHERE
		ast.end_time IS NULL
		AND char_length(ast.ext::text) <> char_length(ast.caller_id_num::text)
		AND ast.caller_id_num::text <> ''::text
		AND ( (ast.start_time IS NULL AND ast.dt::date=now()::date) OR (ast.start_time IS NOT NULL AND ast.start_time::date=now()::date) )
	*/	
	ORDER BY ast.ext, ast.dt DESC;

ALTER TABLE ast_calls_current_contacts_test OWNER TO ;

