
CREATE OR REPLACE FUNCTION person_init(in_text text,no_space bool)
  RETURNS TEXT AS
$BODY$
	SELECT
		first||
		CASE WHEN length(second)>0 THEN ' '||substr(second,1,1)||'.' ELSE '' END||
		CASE WHEN length(middle)>0 THEN 
			CASE WHEN COALESCE(no_space, FALSE)
				THEN substr(middle,1,1)||'.' 
				ELSE ' '||substr(middle,1,1)||'.' 
			END
		ELSE '' 
		END
	FROM parse_person_name(in_text)
	AS (first text,second text,middle text)
$BODY$
LANGUAGE sql IMMUTABLE COST 100 CALLED ON NULL INPUT;


