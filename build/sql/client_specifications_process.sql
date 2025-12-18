-- Function: client_specifications_process()

-- DROP FUNCTION client_specifications_process();

CREATE OR REPLACE FUNCTION client_specifications_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' 
	--AND (TG_OP='INSERT' OR NEW.client_contract_1c_ref IS DISTINCT FROM OLD.client_contract_1c_ref)  
	THEN		
		SELECT
			ct.ref_1c->>'descr'
		INTO NEW.contract
		FROM client_contracts_1c AS ct
		WHERE 
			ct.client_id = NEW.client_id
			AND ct.ref_1c->>'ref_1c' = NEW.client_contract_1c_ref
		;
		
		RETURN NEW;
		
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


