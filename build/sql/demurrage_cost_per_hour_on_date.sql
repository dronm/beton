-- Function: demurrage_cost_per_hour_on_date(in_date_time timestamp)

-- DROP FUNCTION demurrage_cost_per_hour_on_date(in_date_time timestamp);

CREATE OR REPLACE FUNCTION demurrage_cost_per_hour_on_date(in_date_time timestamp)
  RETURNS numeric(15,2) AS
$$
	SELECT period_value('demurrage_cost_per_hour', 0, in_date_time)::numeric(15,2);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION demurrage_cost_per_hour_on_date(in_date_time timestamp) OWNER TO ;
