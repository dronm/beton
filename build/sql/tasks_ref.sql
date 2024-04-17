--Refrerece type
CREATE OR REPLACE FUNCTION tasks_ref(tasks)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.,
		'dataType','tasks'
	);
$$
  LANGUAGE sql VOLATILE COST 100;
ALTER FUNCTION tasks_ref(tasks) OWNER TO beton;	

