-- Function: public.user_allowed_material_correction_check(in_user_id int, in_date_time timestamp)

-- DROP FUNCTION public.user_allowed_material_correction_check(in_user_id int, in_date_time timestamp)

CREATE OR REPLACE FUNCTION public.user_allowed_material_correction_check(in_user_id int, in_date_time timestamp)
  RETURNS bool AS
$BODY$
	SELECT
		CASE
			WHEN get_shift_end(now()::timestamp without time zone)::date = get_shift_end(in_date_time::timestamp without time zone)::date THEN TRUE
			ELSE COALESCE((
				SELECT 
					al.user_id IS NOT NULL --OR u.role_id IN ('owner'::role_types, 'boss'::role_types)
				FROM users AS u
				LEFT JOIN user_allowed_material_corrections AS al ON al.user_id = u.id
				WHERE u.id = in_user_id
				LIMIT 1
			), FALSE)
		END;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;


