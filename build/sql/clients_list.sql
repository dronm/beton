-- View: public.clients_list

-- DROP VIEW public.clients_list;

/*
CREATE OR REPLACE VIEW public.clients_list AS 
	SELECT
		cl.id,
		cl.name,
		cl.manager_comment,
		cl.client_type_id,
		client_types_ref(ct) AS client_types_ref,
		client_come_from_ref(ccf) AS client_come_from_ref,
		cl.client_come_from_id,
		cl.phone_cel,		
		
		coalesce( (SELECT TRUE FROM orders o WHERE o.client_id=cl.id LIMIT 1),FALSE) AS ours,
		
		cl.client_kind,
		cl.email,
		
		(SELECT
			a.dt::date AS dt
		FROM ast_calls a
		WHERE a.client_id = cl.id
		ORDER BY a.dt
		LIMIT 1
		) AS first_call_date,
		
		users_ref(man) AS users_ref,
		
		cl.inn
		
		,users_ref(acc) AS accounts_ref,
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
		WHERE en.entity_type = 'clients' AND en.entity_id = cl.id
		) AS contact_list,
		
		clients_ref(cl) AS descr,
		
		cl.ref_1c IS NOT NULL AS ref_1c_exists,
		
		(SELECT
			array_agg(en.contact_id)
		FROM entity_contacts AS en
		WHERE en.entity_type = 'clients' AND en.entity_id = cl.id
		) AS contact_ids
		
		
	FROM clients cl
	LEFT JOIN client_types ct ON ct.id = cl.client_type_id
	LEFT JOIN client_come_from ccf ON ccf.id = cl.client_come_from_id
	LEFT JOIN users man ON man.id = cl.manager_id
	LEFT JOIN users acc ON acc.id = cl.user_id

	ORDER BY cl.name
	;
	*/
CREATE OR REPLACE VIEW public.clients_list AS
WITH orders_exists AS (
	SELECT DISTINCT o.client_id
	FROM orders AS o
),
first_calls AS (
	SELECT
		a.client_id,
		MIN(a.dt)::date AS first_call_date
	FROM ast_calls AS a
	GROUP BY a.client_id
),
contacts_agg AS (
	SELECT
		en.entity_id AS client_id,
		json_agg(
			json_build_object(
				'name', ct.name,
				'tel', ct.tel,
				'tel_ext', ct.tel_ext,
				'email', ct.email,
				'post', p.name
			)
			ORDER BY ct.name
		) AS contact_list,
		array_agg(en.contact_id ORDER BY en.contact_id) AS contact_ids
	FROM entity_contacts AS en
	LEFT JOIN contacts AS ct ON ct.id = en.contact_id
	LEFT JOIN posts AS p ON p.id = ct.post_id
	WHERE en.entity_type = 'clients'
	GROUP BY en.entity_id
)
SELECT
	cl.id,
	cl.name,
	cl.manager_comment,
	cl.client_type_id,
	client_types_ref(ct) AS client_types_ref,
	client_come_from_ref(ccf) AS client_come_from_ref,
	cl.client_come_from_id,
	cl.phone_cel,
	(oe.client_id IS NOT NULL) AS ours,
	cl.client_kind,
	cl.email,
	fc.first_call_date,
	users_ref(man) AS users_ref,
	cl.inn,
	users_ref(acc) AS accounts_ref,
	ca.contact_list,
	clients_ref(cl) AS descr,
	(cl.ref_1c IS NOT NULL) AS ref_1c_exists,
	ca.contact_ids
FROM clients AS cl
LEFT JOIN client_types AS ct ON ct.id = cl.client_type_id
LEFT JOIN client_come_from AS ccf ON ccf.id = cl.client_come_from_id
LEFT JOIN users AS man ON man.id = cl.manager_id
LEFT JOIN users AS acc ON acc.id = cl.user_id
LEFT JOIN orders_exists AS oe ON oe.client_id = cl.id
LEFT JOIN first_calls AS fc ON fc.client_id = cl.id
LEFT JOIN contacts_agg AS ca ON ca.client_id = cl.id
;

