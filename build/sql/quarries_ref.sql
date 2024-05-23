

-- DROP FUNCTION public.quarries_ref(quarries);

CREATE OR REPLACE FUNCTION public.quarries_ref(quarries)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.name,
		'dataType','quarries'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.quarries_ref(quarries) OWNER TO ;

