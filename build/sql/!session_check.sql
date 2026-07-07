select 
	l.user_id,
	u.name,
	l.date_time_in,
	l.date_time_out
from sessions as s
left join logins as l on l.session_id = s.id
left join users as u on u.id = l.user_id
--where l.date_time_out is not null

