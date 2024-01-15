-- Function: format_cel_standart(text)

-- DROP FUNCTION format_cel_standart(text);

CREATE OR REPLACE FUNCTION format_cel_standart(text)
  RETURNS text AS
$BODY$
	SELECT 
		CASE
			WHEN char_length($1)<=10 THEN $1
			WHEN substr($1,1,1)='8' THEN replace(substr($1,2), '-', '')
			WHEN substr($1,1,2)='+7' THEN replace(substr($1,3), '-', '')
			ELSE replace($1, '-', '')
		END;
$BODY$
  LANGUAGE sql STABLE
  COST 100;
ALTER FUNCTION format_cel_standart(text) OWNER TO ;

