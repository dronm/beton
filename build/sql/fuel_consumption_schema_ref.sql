CREATE OR REPLACE FUNCTION fuel_consumption_schema_ref(fuel_consumption_schema)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.name,
		'dataType','fuel_consumption_schema'
	);
$$
  LANGUAGE sql VOLATILE COST 100;

