-- Function: notifications.user_chat_user_list(in_user_id int)

-- DROP FUNCTION notifications.user_chat_user_list(in_user_id int);

CREATE OR REPLACE FUNCTION notifications.user_chat_user_list(in_user_id int)
  RETURNS TABLE(
	id bigint,
	name text,
	name_short text,
	role_id role_types,
	chat_statuses_ref JSON,	
	is_online bool,
  	unviewed_msg_cnt int
  ) AS
$$
	SELECT
		users.id,
		users.name,
		person_init(users.name) AS name_short,
		users.role_id,
		chat_statuses_ref(st) AS chat_statuses_ref,
		
		(SELECT
			lg.date_time_out
		FROM logins AS lg
		WHERE lg.user_id = users.id
		ORDER BY lg.date_time_in DESC
		LIMIT 1
		) IS NULL AS is_online,

		(SELECT notifications.user_chat_unviewed_count(in_user_id, users.id)) AS unviewed_msg_cnt

	FROM users
	LEFT JOIN user_chat_statuses AS u_st ON u_st.user_id = users.id
	LEFT JOIN chat_statuses AS st ON st.id = u_st.chat_status_id
	WHERE
		coalesce(banned, FALSE) = FALSE
		AND users.name <> 'Регламент'
		AND users.role_id NOT IN ('client', 'vehicle_owner')
		AND users.id <> in_user_id
	ORDER BY users.role_id, users.name
	;

$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION notifications.user_chat_user_list(in_user_id int) OWNER TO ;


