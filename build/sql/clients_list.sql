-- View: public.clients_list

-- DROP VIEW public.clients_list;

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
	/*LEFT JOIN (
		SELECT
			orders.client_id,
	    		sum(orders.quant) AS quant
	   	FROM orders
	  	GROUP BY orders.client_id
	) o ON o.client_id = cl.id
	*/
	ORDER BY cl.name
	;

ALTER TABLE public.clients_list OWNER TO beton;

