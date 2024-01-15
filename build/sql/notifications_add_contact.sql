-- Function: add_contact(in_app_id int, in_contact_id int)

-- DROP FUNCTION add_contact(in_app_id int, in_contact_id int);

/**
 * returns activation_code
 */
CREATE OR REPLACE FUNCTION add_contact(in_app_id int, in_contact_id int)
  RETURNS int AS
$$  
DECLARE
	v_activation_code int;
BEGIN
	SELECT
		activation_code
	INTO v_activation_code
	FROM notifications.ext_users
	WHERE app_id = in_app_id AND ext_contact_id = in_contact_id;
	
	IF v_activation_code IS NOT NULL THEN
		RAISE EXCEPTION 'Уже отправлен код';
	END IF;
	
	BEGIN
		INSERT INTO notifications.ext_users (app_id, ext_contact_id)
		VALUES (in_app_id, in_contact_id)
		RETURNING activation_code INTO v_activation_code;
	
	EXCEPTION WHEN SQLSTATE '23505' THEN
		SELECT
			activation_code
		INTO v_activation_code
		FROM notifications.ext_users
		WHERE app_id = in_app_id AND ext_contact_id = in_contact_id
		;
	END;
	
	IF v_activation_code IS NULL THEN
		RAISE EXCEPTION 'Ошибка генерации кода активации';
	END IF;
	
	RETURN v_activation_code;
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION add_contact(in_app_id int, in_contact_id int) OWNER TO ;
