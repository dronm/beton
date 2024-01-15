-- Function: add_user(in_app_id int, in_obj_ref json)

-- DROP FUNCTION add_user(in_app_id int, in_obj_ref json);

/**
 * returns activation_code
 */
CREATE OR REPLACE FUNCTION add_user(in_app_id int, in_obj_ref json)
  RETURNS int AS
$$  
DECLARE
	v_activation_code int;
BEGIN  
	BEGIN
		INSERT INTO notifications.ext_users (app_id, ext_obj)
		VALUES (in_app_id, in_obj_ref)
		RETURNING activation_code INTO v_activation_code;
	
	EXCEPTION WHEN SQLSTATE '23505' THEN
		SELECT
			activation_code
		INTO v_activation_code
		FROM notifications.ext_users
		WHERE app_id = in_app_id
			AND ext_obj->>'dataType' = in_obj_ref->>'dataType'
			AND (ext_obj->'keys'->>'id')::int = (in_obj_ref->'keys'->>'id')::int;
	END;
	
	RETURN v_activation_code;
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION add_user(in_app_id int, in_obj_ref json) OWNER TO ;
