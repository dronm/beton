-- Function: public.chat_statuses_ref(public.chat_statuses)

-- DROP FUNCTION public.chat_statuses_ref(public.chat_statuses);

CREATE OR REPLACE FUNCTION public.chat_statuses_ref(public.chat_statuses)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id
			),	
		'descr', $1.name,
		'dataType','chat_statuses'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.chat_statuses_ref(public.chat_statuses)
  OWNER TO ;

