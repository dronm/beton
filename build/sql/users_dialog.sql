-- View: public.users_dialog

-- DROP VIEW public.users_login;
-- DROP VIEW public.users_dialog;
--ALTER VIEW users_dialog RENAME COLUMN chat_status_ref to chat_statuses_ref;

CREATE OR REPLACE VIEW public.users_dialog
 AS
 SELECT users.id,
	users.name,
	users.email,
	users.pwd,
	users.role_id,
	users_tel_ext(users.id) AS tel_ext,
	users.phone_cel,
	users.create_dt,
	users.banned,
	users.time_zone_locale_id,
	users.production_site_id,
	users.elkon_user_name,
	time_zone_locales.name AS user_time_locale,
	production_sites_ref(ps.*) AS production_sites_ref,
	
	(SELECT
		chat_statuses_ref(chat_statuses)
	FROM user_chat_statuses AS t
	LEFT JOIN chat_statuses ON chat_statuses.id = t.chat_status_id
	WHERE t.user_id = users.id
	) AS chat_statuses_ref,
	
	null as contact_ids
	
FROM users
LEFT JOIN time_zone_locales ON time_zone_locales.id = users.time_zone_locale_id
LEFT JOIN production_sites ps ON ps.id = users.production_site_id;

-- ALTER TABLE public.users_dialog OWNER TO ;


