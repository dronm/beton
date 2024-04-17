-- Function: notifications.user_chat_unviewed_count(in_from_user_id int, in_to_user_id int)

-- DROP FUNCTION notifications.user_chat_unviewed_count(in_from_user_id int, in_to_user_id int);

-- returns unviewed message count for the user

CREATE OR REPLACE FUNCTION notifications.user_chat_unviewed_count(in_user_id int, in_with_user_id int)
  RETURNS int AS  
$$
	SELECT	coalesce(
			(SELECT
				count(*)
			FROM notifications.user_chat AS m
			LEFT JOIN notifications.user_chat_message_views AS v ON v.user_id = in_user_id AND v.user_chat_id = m.id
			WHERE
				-- not from me
				m.from_user_id <> in_user_id
				
				-- if with particular user
				AND (in_with_user_id IS NULL OR m.from_user_id = in_with_user_id)
				
				-- to all for common chat or to me for private chat
				AND ( (in_with_user_id IS NULL AND (m.to_user_id IS NULL OR m.to_user_id = in_user_id))
					OR (in_with_user_id IS NOT NULL AND m.to_user_id = in_user_id)
				)
				
				-- unseen
				AND coalesce(v.user_chat_id IS NOT NULL, FALSE) = FALSE)
		,0)
	;
/*
	SELECT
		coalesce(
			(WITH
			last_open AS (SELECT date_time
				FROM notifications.user_chat_last_open
				WHERE
					user_id = in_to_user_id
					AND (
						(in_from_user_id IS NULL AND with_user_id IS NULL)
						OR (in_from_user_id IS NOT NULL AND with_user_id = in_from_user_id)
					)
			)
			SELECT
				count(*)
			FROM notifications.user_chat AS m
			LEFT JOIN notifications.user_chat_message_views AS v ON v.user_id = in_to_user_id AND v.user_chat_id = m.id
			WHERE
				(m.to_user_id IS NULL OR m.to_user_id = in_to_user_id)
				AND (in_from_user_id IS NULL OR m.from_user_id = in_from_user_id)
				AND coalesce(v.user_chat_id IS NOT NULL, FALSE) = FALSE
				AND ((SELECT date_time FROM last_open) IS NULL OR m.date_time > (SELECT date_time FROM last_open))
			),
		0)
	;
*/	
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION notifications.user_chat_unviewed_count(in_user_id int, in_with_user_id int) OWNER TO ;

