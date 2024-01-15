-- Function: orders_complete_contact(in_client_id int, in_descr text)

-- DROP FUNCTION orders_complete_contact(in_client_id int, in_descr text);

CREATE OR REPLACE FUNCTION orders_complete_contact(in_client_id int, in_descr text)
  RETURNS TABLE(
  	contact_id int,
	descr text,		-- contact descr
	phone_cel text,		-- contact tel or old orders.phone_cel
	langs_ref json,
	tm_id int,		-- id for furthur get object
	tm_exists bool,
	tm_activated  bool,	
	tm_photo text		-- base64 preview
  ) AS
$$
	-- this client contacts
	SELECT
		ct.id AS contact_id,
		ct.name::text AS descr,
		ct.tel::text AS phone_cel,
		const_def_lang_val() AS langs_ref,
		e_user.id::int AS tm_id,
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,		
		e_user.tm_photo
	FROM entity_contacts AS cl_ct
	LEFT JOIN contacts ct ON ct.id = cl_ct.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id=cl_ct.contact_id
	WHERE cl_ct.entity_type = 'clients' AND cl_ct.entity_id = in_client_id
		AND (coalesce(in_descr,'')='' OR lower(ct.name) LIKE lower(in_descr)||'%%')
	;
	
	/*
	WITH
	-- client contacts first
	-- all other contacts from this client orders
	o_list AS (
		SELECT DISTINCT ON (coalesce(ct.name, o.descr))
				ct.id AS contact_id,
				coalesce(ct.name::text, o.descr::text) AS descr,				
				coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
				langs_ref(lg) AS langs_ref,
				(e_user.id IS NOT NULL) tm_exists,
				(e_user.tm_id IS NOT NULL) tm_activated,
				e_user.id::int AS tm_id,
				e_user.tm_photo,
				o.date_time
			FROM orders AS o
			LEFT JOIN clients cl ON cl.id=o.client_id
			LEFT JOIN contacts AS ct ON ct.id = o.contact_id OR o.phone_cel = ct.tel
			LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = ct.id
			LEFT JOIN langs lg ON lg.id=o.lang_id
			WHERE o.client_id = in_client_id 
				AND coalesce(ct.name::text, o.descr::text) IS NOT NULL
				AND coalesce(ct.tel::text, o.phone_cel::text) IS NOT NULL
				AND (coalesce(in_descr,'')='' OR lower(coalesce(ct.name, o.descr)) LIKE lower(in_descr)||'%%')
			LIMIT 10
	)
	(SELECT
		o_list.contact_id,
		o_list.descr,
		o_list.phone_cel,
		o_list.langs_ref,
		o_list.tm_id,
		o_list.tm_exists,
		o_list.tm_activated,
		o_list.tm_photo
	FROM o_list
	ORDER BY o_list.date_time DESC)

	UNION ALL

	(SELECT
		ct.id AS contact_id,
		ct.name::text AS descr,
		ct.tel::text AS phone_cel,
		const_def_lang_val() AS langs_ref,
		e_user.id::int AS tm_id,
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,		
		e_user.tm_photo
	FROM entity_contacts AS cl_ct
	LEFT JOIN contacts ct ON ct.id = cl_ct.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id=cl_ct.contact_id
	WHERE cl_ct.entity_type = 'clients' AND cl_ct.entity_id = in_client_id
		AND (coalesce(in_descr,'')='' OR lower(ct.name) LIKE lower(in_descr)||'%%')
		AND ct.id NOT IN (SELECT o_list.contact_id FROM o_list)
	);
	*/
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION orders_complete_contact(in_client_id int, in_descr text) OWNER TO ;


