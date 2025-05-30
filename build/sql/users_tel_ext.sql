-- Function: public.users_tel_ext(in_user_id int)

-- DROP FUNCTION public.users_tel_ext(in_user_id int);

CREATE OR REPLACE FUNCTION public.users_tel_ext(in_user_id int)
  RETURNS text AS
$BODY$
	SELECT 
		ct.tel_ext
	FROM entity_contacts AS e_ct 
	LEFT join contacts AS ct ON ct.id = e_ct.contact_id
	WHERE e_ct.entity_type = 'users' AND e_ct.entity_id = in_user_id
	AND ct.tel_ext IS NOT NULL
	LIMIT 1
	;
$BODY$
  LANGUAGE sql VOLATILE COST 100;
