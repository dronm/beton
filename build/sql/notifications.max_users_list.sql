
-- VIEW: notifications.max_users_list;

-- DROP VIEW notifications.max_users_list;

CREATE OR REPLACE VIEW notifications.max_users_list AS
SELECT
	mu.id,
	mu.max_user_id,
	mu.username,
	mu.raw_user, 
	mu.raw_user_with_photo,
	mu.contact_id,
	ct.tel AS contacts_tel,
	contacts_ref(ct) AS contacts_ref,
	mu.updated_at,
	mu.avatar_url
FROM notifications.max_users AS mu
LEFT JOIN contacts AS ct ON ct.id = mu.contact_id
ORDER BY mu.username;
;
