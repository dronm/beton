-- Function: public.client_tels_ref(client_tels)

-- DROP FUNCTION public.client_tels_ref(client_tels);

CREATE OR REPLACE FUNCTION public.client_tels_ref(client_tels)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr',$1.name||' '||format_cel_phone($1.tel)||' ('||(SELECT cl.name FROM clients AS cl WHERE cl.id = $1.client_id)||')',
		'dataType','client_tels'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.client_tels_ref(client_tels) OWNER TO beton;

