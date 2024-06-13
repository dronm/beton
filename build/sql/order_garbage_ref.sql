-- Function: public.order_garbage_ref(order_garbage)

-- DROP FUNCTION public.order_garbage_ref(order_garbage);

CREATE OR REPLACE FUNCTION public.order_garbage_ref(order_garbage)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr','Удаленная заявка №'||order_garbage_num($1)::text||' от '||to_char($1.date_time,'DD/MM/YY HH24:MI'),
		'dataType','order_garbage'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.order_garbage_ref(order_garbage) OWNER TO ;

