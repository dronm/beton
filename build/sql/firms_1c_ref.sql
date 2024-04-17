--Refrerece type
CREATE OR REPLACE FUNCTION firms_1c_ref(firms_1c)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.ref_1c->>'descr',
		'dataType','firms_1c'
	);
$$
  LANGUAGE sql VOLATILE COST 100;
ALTER FUNCTION firms_1c_ref(firms_1c) OWNER TO ;	
	
