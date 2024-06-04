delete from sessions where id in (select session_id from logins where date_time_out is null
	and user_id in (select users.id from users where role_id = 'client'))
