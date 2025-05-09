-- Function: public.client_contracts_1c_ref(client_contracts_1c)
-- DROP FUNCTION public.client_contracts_1c_ref(client_contracts_1c);

CREATE OR REPLACE FUNCTION public.client_contracts_1c_ref(client_contracts_1c)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.ref_1c->>'descr',
		'dataType','client_contracts_1c'
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;

