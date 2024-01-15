-- Function: water_ship_cost_on_date(in_date_time timestamp)

-- DROP FUNCTION water_ship_cost_on_date(in_date_time timestamp);

CREATE OR REPLACE FUNCTION water_ship_cost_on_date(in_date_time timestamp)
  RETURNS numeric(15,2) AS
$$
	SELECT period_value('water_ship_cost', 0, in_date_time)::numeric(15,2);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION water_ship_cost_on_date(in_date_time timestamp) OWNER TO ;
