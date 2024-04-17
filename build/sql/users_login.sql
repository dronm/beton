-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		const_first_shift_start_time_val() AS first_shift_start_time,
		CASE
			WHEN const_shift_length_time_val()>='24 hours'::interval THEN
				const_first_shift_start_time_val()::interval + 
				const_shift_length_time_val()::interval-'24 hours 1 second'::interval
			ELSE
				const_first_shift_start_time_val()::interval + 
				const_shift_length_time_val()::interval-'1 second'::interval
		END AS first_shift_end_time,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		(SELECT
			json_build_object(
				'back_days_allowed',restr.back_days_allowed,
				'front_days_allowed',restr.front_days_allowed
				
			)
		FROM role_view_restrictions AS restr WHERE restr.role_id = u.role_id) AS role_view_restriction
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	;

ALTER TABLE public.users_login
  OWNER TO beton;

