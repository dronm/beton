-- VIEW: notifications.max_out_messages_list

--DROP VIEW notifications.max_out_messages_list;

CREATE OR REPLACE VIEW notifications.max_out_messages_list AS
	SELECT
		m.id,
		m.message,
		m.created_at,
		m.sent_at,
		m.max_chat_id,
		m.contact_id,
		contacts_ref(ct) AS contacts_ref,
		m.error_str
		
	FROM notifications.max_out_messages AS m
	LEFT JOIN contacts AS ct on ct.id = m.contact_id
	ORDER BY m.sent_at DESC;


