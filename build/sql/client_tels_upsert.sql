-- Function: client_tels_upsert(in_client_id int, in_name text, in_tel text)

-- DROP FUNCTION client_tels_upsert(in_client_id int, in_name text, in_tel text);

CREATE OR REPLACE FUNCTION client_tels_upsert(in_client_id int, in_name text, in_tel text)
  RETURNS json AS
$$  
DECLARE
	v_client_tels_ref json;
BEGIN  
	BEGIN
		INSERT INTO client_tels (client_id, name, tel)
		VALUES (in_client_id, in_name, in_tel)
		RETURNING client_tels_ref(client_tels) AS client_tels_ref INTO v_client_tels_ref;
		
	EXCEPTION WHEN SQLSTATE '23505' THEN
		SELECT
			client_tels_ref(client_tels) AS client_tels_ref
		INTO v_client_tels_ref
		FROM client_tels
		WHERE client_id=in_client_id AND tel=in_tel;
	END;
	
	RETURN v_client_tels_ref;
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION client_tels_upsert(in_client_id int, in_name text, in_tel text) OWNER TO ;
