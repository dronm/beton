-- FUNCTION: public.format_mon_rus(date, int)

-- DROP FUNCTION IF EXISTS public.format_mon_rus(date, int);

CREATE OR REPLACE FUNCTION public.format_mon_rus(date, int)
    RETURNS character varying
    LANGUAGE sql
    COST 100
    VOLATILE
AS $BODY$
	SELECT unnest(ARRAY['январь', 'февраль', 'март', 'апрель', 'май',
		'июнь', 'июль', 'август', 'сентябрь', 'октябрь',
		'ноябрь', 'декабрь']) || ' '|| to_char($1, case when $2 = 2 then 'yy' else 'yyyy' end)
	LIMIT 1 OFFSET date_part('month', $1) - 1;
$BODY$;

ALTER FUNCTION public.format_mon_rus(date, int)
    OWNER TO ;

