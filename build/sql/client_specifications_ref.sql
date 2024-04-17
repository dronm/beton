--Refrerece type
CREATE OR REPLACE FUNCTION client_specifications_ref(client_specifications)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.contract||'/'||$1.specification,
		'dataType','client_specifications'
	);
$$
  LANGUAGE sql VOLATILE COST 100;

ALTER FUNCTION client_specifications_ref(client_specifications) OWNER TO beton;	

