-- FUNCTION: public.order_garbage_num(order_garbage)

-- DROP FUNCTION IF EXISTS public.order_garbage_num(order_garbage);

CREATE OR REPLACE FUNCTION public.order_garbage_num(
	order_garbage)
    RETURNS character varying
    LANGUAGE 'sql'
    COST 100
    IMMUTABLE
AS $BODY$
	SELECT 
	CASE WHEN EXTRACT(DAY FROM $1.date_time)<10 THEN
		'0' || EXTRACT(DAY FROM $1.date_time)::varchar || '-' || trim(to_char($1.number,'000'))
	ELSE
		EXTRACT(DAY FROM $1.date_time)::varchar || '-' || trim(to_char($1.number,'000'))
	END;
$BODY$;

ALTER FUNCTION public.order_garbage_num(order_garbage)
    OWNER TO ;

