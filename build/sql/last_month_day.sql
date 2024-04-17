CREATE OR REPLACE FUNCTION last_month_day(date)
  RETURNS date AS
$BODY$
  SELECT (date_trunc('MONTH', $1) + INTERVAL '1 MONTH - 1 day')::date;
$BODY$
  LANGUAGE sql IMMUTABLE STRICT
  COST 100;
