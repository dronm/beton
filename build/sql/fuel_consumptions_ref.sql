-- Function: public.fuel_consumptions_ref(fuel_consumptions)

-- DROP FUNCTION public.fuel_consumptions_ref(fuel_consumptions);

CREATE OR REPLACE FUNCTION public.fuel_consumptions_ref(fuel_consumptions)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
		),	
		'descr','Расход топлива №' ||$1.id::text||' от ' || to_char($1.date_time, 'DD/MM/YY'),
		'dataType','fuel_consumptions'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;


