-- VIEW: notifications.tm_in_messages_beton_list

--DROP VIEW notifications.tm_in_messages_beton_list;

CREATE OR REPLACE VIEW notifications.tm_in_messages_beton_list AS
	SELECT
		m.id,
		m.app_id,
		m.message,
		m.date_time,
		u.ext_obj,
		u.ext_contact_id,
		
		contacts_ref(ct) AS contacts_ref,
		(SELECT
			json_agg(
				CASE
					WHEN ent.entity_type = 'clients' THEN
						(SELECT clients_ref(clients) FROM clients WHERE clients.id = ent.entity_id)
					
					WHEN ent.entity_type = 'users' THEN
						(SELECT users_ref(users) FROM users WHERE users.id = ent.entity_id)
						
					WHEN ent.entity_type = 'drivers' THEN
						(SELECT drivers_ref(drivers) FROM drivers WHERE drivers.id = ent.entity_id)
					
					WHEN ent.entity_type = 'suppliers' THEN
						(SELECT suppliers_ref(suppliers) FROM suppliers WHERE suppliers.id = ent.entity_id)
					
					ELSE NULL
				END
			)
		FROM entity_contacts AS ent
		WHERE ent.contact_id = u.ext_contact_id
		) AS entity
		
	FROM notifications.tm_in_messages AS m
	LEFT JOIN notifications.ext_users AS u ON (u.tm_user->>'id')::bigint = (m.message->'from'->>'id')::bigint
	LEFT JOIN contacts AS ct ON ct.id = u.ext_contact_id
	ORDER BY m.date_time DESC;
	
ALTER VIEW notifications.tm_in_messages_beton_list OWNER TO ;
