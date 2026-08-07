CREATE OR REPLACE FUNCTION workplaces_ref(workplaces)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.name,
		'dataType','workplaces'
	);
$$
  LANGUAGE sql VOLATILE COST 100;
