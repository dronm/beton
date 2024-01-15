-- Function: period_value(in_period_value_type period_value_types, in_key_id int, in_date_time timestamp)

-- DROP FUNCTION period_value(in_period_value_type period_value_types, in_key_id int, in_date_time timestamp);

CREATE OR REPLACE FUNCTION period_value(in_period_value_type period_value_types, in_key_id int, in_date_time timestamp)
  RETURNS text AS
$$
	SELECT
		val
	FROM period_values
	WHERE period_value_type = in_period_value_type AND key = in_key_id
		AND date_time <= in_date_time
	ORDER BY date_time desc
	LIMIT 1;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION period_value(in_period_value_type period_value_types, in_key_id int, in_date_time timestamp) OWNER TO ;
