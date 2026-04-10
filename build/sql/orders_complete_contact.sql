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
	tm_photo text,		-- base64 preview
	max_data json
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
		e_user.tm_photo,

		CASE WHEN mxu.max_user_id IS NULL THEN NULL
		ELSE
			json_build_object(
				'max_user_id', mxu.max_user_id,
				'username', mxu.username,
				'avatar_url', mxu.avatar_url
			) 
		END AS max_data


	FROM entity_contacts AS cl_ct
	LEFT JOIN contacts ct ON ct.id = cl_ct.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id=cl_ct.contact_id
	LEFT JOIN notifications.max_users AS mxu ON mxu.contact_id = cl_ct.contact_id
	WHERE cl_ct.entity_type = 'clients' AND cl_ct.entity_id = in_client_id
		AND (coalesce(in_descr,'')='' OR lower(ct.name) LIKE lower(in_descr)||'%%')
	LIMIT 50
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;


