-- Function: ucase(text)

-- DROP FUNCTION ucase(text);

CREATE OR REPLACE FUNCTION ucase(text)
  RETURNS text AS
$$
	Select CONCAT(UPPER(SUBSTRING($1,1,1)),LOWER(SUBSTRING($1,2)))
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION ucase(text) OWNER TO ;
