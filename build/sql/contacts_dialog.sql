-- VIEW: contacts_dialog

--DROP VIEW contacts_dialog;

CREATE OR REPLACE VIEW contacts_dialog AS
	SELECT
		ct.id,
		ct.name,
		posts_ref(p) AS posts_ref,
		ct.email,
		ct.tel,
		ct.descr,
		ct.tel_ext,
		ct.comment_text,
		(e_us.id IS NOT NULL) AS tm_exists,
		(e_us.tm_id IS NOT NULL) AS tm_activated,
		e_us.tm_photo,
		e_us.tm_first_name,
		e_us.id AS ext_id

		,(SELECT
			jsonb_agg(
				att.content_info || 
				case when att.content_preview is not null then 
					jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
				else '{}'::jsonb
				end
			)
		FROM attachments AS att
		WHERE att.ref->>'dataType' = 'contacts' AND (att.ref->'keys'->>'id')::int = ct.id
		) AS attachments_list
		
	FROM contacts AS ct
	LEFT JOIN posts AS p ON p.id = ct.post_id
	LEFT JOIN notifications.ext_users_photo_list AS e_us ON e_us.ext_contact_id = ct.id
	ORDER BY ct.name
	;
	
