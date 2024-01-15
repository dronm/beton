-- Function: users_login_roles(in_user_id int)

-- DROP FUNCTION users_login_roles(in_user_id int);

CREATE OR REPLACE FUNCTION users_login_roles(in_user_id int)
  RETURNS jsonb AS
$$
	SELECT
		jsonb_agg(
			jsonb_build_object(
				'id', sub.role_id,
				'descr', enum_role_types_val(sub.role_id, 'ru')
			)
		)		
	FROM (
		SELECT DISTINCT
			u.role_id
		FROM entity_contacts AS u_ct
		LEFT JOIN users AS u On u.id = u_ct.entity_id
		WHERE
			u_ct.contact_id IN (
				SELECT contact_id
				FROM entity_contacts
				WHERE entity_type='users' AND entity_id = in_user_id
				)
			AND u_ct.entity_type='users'
			AND coalesce(u.banned, FALSE) = FALSE
			--and u_ct.entity_id<>in_user_id
	) AS sub
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION users_login_roles(in_user_id int) OWNER TO ;
