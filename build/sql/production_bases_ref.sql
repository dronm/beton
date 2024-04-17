-- Function: public.production_bases_ref(production_bases)

-- DROP FUNCTION public.production_bases_ref(production_bases);

CREATE OR REPLACE FUNCTION public.production_bases_ref(production_bases)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.name,
		'dataType','production_bases'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.production_bases_ref(production_bases) OWNER TO beton;

