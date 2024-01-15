--Refrerece type
CREATE OR REPLACE FUNCTION task_importance_levels_ref(task_importance_levels)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.name,
		'dataType','task_importance_levels'
	);
$$
  LANGUAGE sql VOLATILE COST 100;
ALTER FUNCTION task_importance_levels_ref(task_importance_levels) OWNER TO beton;	

