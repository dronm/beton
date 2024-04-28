-- FUNCTION: public.get_shift_bounds(timestamp without time zone)

-- DROP FUNCTION IF EXISTS public.get_shift_bounds(timestamp without time zone);

CREATE OR REPLACE FUNCTION public.get_shift_bounds(
	timestamp without time zone)
    RETURNS record
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE shift_start_time time without time zone;
	shift_start_date date;
	ret RECORD;
BEGIN
	shift_start_time = const_first_shift_start_time_val();
	
	IF $1::time<shift_start_time THEN
		shift_start_date = $1::date - 1;
	ELSE
		shift_start_date = $1::date;
	END IF;
	
	ret = (shift_start_date + shift_start_time,
		shift_start_date + shift_start_time + const_shift_length_time_val() - '00:00:01'::time);
	RETURN ret;
END;
$BODY$;

ALTER FUNCTION public.get_shift_bounds(timestamp without time zone)
    OWNER TO concrete1;

