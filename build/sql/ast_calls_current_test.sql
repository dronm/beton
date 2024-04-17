-- View: ast_calls_current_contacts

DROP VIEW ast_calls_current_test;
/*
 
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
					END,
					'debt', debts.debt_total
				)
			)
		FROM entity_contacts AS t
		LEFT JOIN users AS u ON u.id = t.entity_id AND t.entity_type = 'users'
		LEFT JOIN clients AS cl ON cl.id = t.entity_id AND t.entity_type = 'clients'
		LEFT JOIN suppliers AS sp ON sp.id = t.entity_id AND t.entity_type = 'suppliers'
		LEFT JOIN drivers AS d ON d.id = t.entity_id AND t.entity_type = 'drivers'
		LEFT JOIN pump_vehicles AS pv ON pv.id = t.entity_id AND t.entity_type = 'pump_vehicles'
		LEFT JOIN vehicles AS v ON v.id = pv.vehicle_id
		
		LEFT JOIN (
			SELECT
				d.client_id,
				sum(d.debt_total) AS debt_total
			FROM client_debts AS d		
			GROUP BY d.client_id
		) AS debts ON debts.client_id = cl.id

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
   	
	ORDER BY ast.ext, ast.dt DESC;
*/

CREATE OR REPLACE VIEW public.ast_calls_current_test
 AS
 SELECT DISTINCT ON (ast.ext) ast.unique_id,
    ast.ext,
    COALESCE(ct.tel::text,
        CASE
            WHEN clt.tel IS NOT NULL THEN replace(
            CASE
                WHEN substr(clt.tel::text, 1, 2) = '8-'::text THEN substr(clt.tel::text, 3)::character varying
                ELSE clt.tel
            END::text, '-'::text, ''::text)
            WHEN substr(ast.caller_id_num::text, 1, 1) = '+'::text THEN '8'::text || substr(ast.caller_id_num::text, 2)
            ELSE ast.caller_id_num::text
        END) AS contact_tel,
    COALESCE(ct.tel::text,
        CASE
            WHEN clt.tel IS NOT NULL THEN replace(
            CASE
                WHEN substr(clt.tel::text, 1, 2) = '8-'::text THEN substr(clt.tel::text, 3)::character varying
                ELSE clt.tel
            END::text, '-'::text, ''::text)
            WHEN substr(ast.caller_id_num::text, 1, 1) = '+'::text THEN '8'::text || substr(ast.caller_id_num::text, 2)
            ELSE ast.caller_id_num::text
        END) AS num,
    ast.dt AS ring_time,
    ast.start_time AS answer_time,
    ast.end_time AS hangup_time,
    ast.client_id,
    clients_ref(cl.*) AS clients_ref,
    cl.name AS client_descr,
    cl.client_kind,
    get_client_kinds_descr(cl.client_kind) AS client_kind_descr,
    ast.manager_comment,
    ast.informed,
    COALESCE(ct.name::text, clt.name) AS contact_name,
    cld.debt_total AS debt,
    man.name AS client_manager_descr,
    client_types_ref(ctp.*) AS client_types_ref,
    client_come_from_ref(ccf.*) AS client_come_from_ref,
    p.name AS contact_post_name,
    ct.email AS contact_email
   FROM ast_calls ast
     LEFT JOIN clients cl ON cl.id = ast.client_id
     LEFT JOIN users man ON cl.manager_id = man.id
     LEFT JOIN client_tels clt ON clt.client_id = ast.client_id AND (clt.tel::text = ast.caller_id_num::text OR clt.tel::text = format_cel_phone("right"(ast.caller_id_num::text, 10)))
     LEFT JOIN client_debts cld ON cld.client_id = ast.client_id
     LEFT JOIN client_types ctp ON ctp.id = cl.client_type_id
     LEFT JOIN client_come_from ccf ON ccf.id = cl.client_come_from_id
     LEFT JOIN contacts ct ON ct.id = ast.contact_id
     LEFT JOIN posts p ON p.id = ct.post_id
  WHERE ast.end_time IS NULL AND char_length(ast.ext::text) <> char_length(ast.caller_id_num::text) AND ast.caller_id_num::text <> ''::text AND (ast.start_time IS NULL AND ast.dt::date = now()::date OR ast.start_time IS NOT NULL AND ast.start_time::date = now()::date)
  ORDER BY ast.ext, ast.dt DESC;

ALTER TABLE ast_calls_current_test OWNER TO ;

