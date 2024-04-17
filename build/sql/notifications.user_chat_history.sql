-- Function: notifications.user_chat(in_user_id bigint, in_private_user_id bigint, in_cnt int)

--DROP FUNCTION notifications.user_chat_history(in_user_id bigint, in_private_user_id bigint, in_cnt int);
 
-- if private user not set - it is a common chat
 
CREATE OR REPLACE FUNCTION notifications.user_chat_history(in_user_id bigint, in_private_user_id bigint, in_cnt int)
  RETURNS TABLE(
  	id int,
  	date_time timestampTZ,
  	tp varchar(3),
  	from_user JSONB,
  	from_contact_id int,
  	to_user JSONB,
  	to_contact_id int,
  	text text,
  	media_type text,
  	message jsonb
  ) AS
$$
	SELECT
		sub_o.id
		,sub_o.date_time
		,sub_o.tp
		,users_ref(from_u) AS from_user
		,from_ect.contact_id AS from_contact_id
		,users_ref(to_u) AS to_user
		,to_ect.contact_id AS to_contact_id
		,notifications.message_text(sub_o.message) AS text
		,notifications.message_media_type(sub_o.message) AS media_type
		,sub_o.message
	FROM (
		SELECT
			sub.*
		FROM (
			(SELECT
				m.id,
				m.date_time AS date_time,
				'in' AS tp,
				CASE
					WHEN in_private_user_id IS NULL THEN m.from_user_id
					ELSE in_private_user_id
				END AS from_user_id,
				m.to_user_id AS to_user_id,
				m.message
				
			FROM notifications.user_chat AS m
			-- to me from private user or from any user to all users (except me) if private user not specified
			WHERE
				(in_private_user_id IS NOT NULL AND m.to_user_id = in_user_id AND m.from_user_id = in_private_user_id)
				OR (in_private_user_id IS NULL AND m.to_user_id IS NULL AND m.from_user_id <> in_user_id)
			ORDER BY m.date_time DESC)

			UNION ALL

			(SELECT
				m.id,
				m.date_time AS date_time,
				'out' AS tp,
				m.from_user_id AS from_user_id,
				CASE
					WHEN in_private_user_id IS NULL THEN NULL
					ELSE in_private_user_id
				END AS to_user_id,
				m.message
				
			FROM notifications.user_chat AS m
			-- from me to private user if specified or from me to common chat
			WHERE
				(in_private_user_id IS NOT NULL AND m.from_user_id = in_user_id AND m.to_user_id = in_private_user_id)
				OR
				(in_private_user_id IS NULL AND m.from_user_id = in_user_id AND m.to_user_id IS NULL)
			ORDER BY m.date_time DESC)
		) AS sub
		ORDER BY sub.date_time DESC
		LIMIT in_cnt
	) AS sub_o
	LEFT JOIN public.users AS from_u ON from_u.id = sub_o.from_user_id
	LEFT JOIN public.entity_contacts AS from_ect ON from_ect.entity_type = 'users' AND from_ect.entity_id = sub_o.from_user_id
	LEFT JOIN public.users AS to_u ON to_u.id = sub_o.to_user_id
	LEFT JOIN public.entity_contacts AS to_ect ON to_ect.entity_type = 'users' AND to_ect.entity_id = sub_o.to_user_id
	
	ORDER BY sub_o.date_time ASC;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION notifications.user_chat_history(in_user_id bigint, in_private_user_id bigint, in_cnt int) OWNER TO ;

