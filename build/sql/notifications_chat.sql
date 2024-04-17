-- Function: notifications.chat(in_app_id int, in_tm_user_id bigint, in_cnt int)

--DROP FUNCTION notifications.chat(in_app_id int, in_tm_user_id bigint, in_cnt int);
 
CREATE OR REPLACE FUNCTION notifications.chat(in_app_id int, in_tm_user_id bigint, in_cnt int)
  RETURNS TABLE(
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
		sub_o.*
	FROM (
		SELECT
			sub.*
		FROM (
			(SELECT
				m.date_time AS date_time,
				'in' AS tp,
				from_u .ext_obj AS from_user,
				from_u .ext_contact_id AS from_contact_id,
				NULL AS to_user,
				NULL AS to_contact_id,
				notifications.message_text(m.message) AS text,
				notifications.message_media_type(m.message) AS media_type,
				m.message
				
			FROM notifications.tm_in_messages AS m
			LEFT JOIN notifications.ext_users AS from_u ON (from_u.tm_user->>'id')::bigint = (m.message->'chat'->>'id')::bigint AND from_u.app_id = in_app_id
			WHERE m.app_id = in_app_id AND (m.message->'chat'->>'id')::bigint = in_tm_user_id
			ORDER BY m.date_time DESC)

			UNION ALL

			(SELECT
				m.sent_date_time AS date_time,
				'out' AS tp,
				m.ext_obj AS from_user,
				m.ext_contact_id AS from_contact_id,
				to_u.ext_obj AS to_user,
				to_u.ext_contact_id AS to_contact_id,
				notifications.message_text(m.message) AS text,
				notifications.message_media_type(m.message) AS media_type,
				m.message
				
			FROM notifications.tm_out_messages AS m
			--LEFT JOIN notifications.ext_users AS from_u ON (from_u.tm_user->>'id')::bigint = (m.message->>'chat_id')::bigint
			LEFT JOIN notifications.ext_users AS to_u ON (to_u.tm_user->>'id')::bigint = (m.message->>'chat_id')::bigint AND to_u.app_id = in_app_id
			WHERE m.app_id = in_app_id AND m.sent_date_time IS NOT NULL AND (m.message->>'text' IS NULL OR substring(m.message->>'text', 1, 16) <> 'Код авторизации:')
			AND (m.message->>'chat_id')::bigint = in_tm_user_id
			ORDER BY m.sent_date_time DESC)
		) AS sub
		ORDER BY sub.date_time DESC
		LIMIT in_cnt
	) AS sub_o
	ORDER BY sub_o.date_time ASC;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION notifications.chat(in_app_id int, in_tm_user_id bigint, in_cnt int) OWNER TO ;

