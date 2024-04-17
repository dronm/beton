-- Function: public.client_tels_add(in_client_name text, in_contact_name text, in_tel text)

-- DROP FUNCTION public.client_tels_add(in_client_name text, in_contact_name text, in_tel text);

CREATE OR REPLACE FUNCTION public.client_tels_add(in_client_name text, in_contact_name text, in_tel text)
  RETURNS void AS
$BODY$  
DECLARE
	v_id int;  
BEGIN	

	SELECT id INTO v_id
	FROM client_tels WHERE tel = in_tel;	

	IF v_id IS NOT NULL THEN
		RETURN;
	END IF;
	
	--no contact...
	SELECT id INTO v_id
	FROM clients WHERE  rtrim(name) = in_client_name;	
	
	IF v_id	IS NULL THEN
		INSERT INTO clients (name)
		VALUES (in_client_name) RETURNING id INTO v_id;		
	END IF;

	INSERT INTO client_tels (client_id, name, tel)
	VALUES (v_id, in_contact_name, in_tel);			
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.client_tels_add(in_client_name text, in_contact_name text, in_tel text) OWNER TO ;

