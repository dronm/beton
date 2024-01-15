-- VIEW: demurrage_cost_per_hour_period_value_list

DROP VIEW demurrage_cost_per_hour_period_value_list;
/*
CREATE OR REPLACE VIEW demurrage_cost_per_hour_period_value_list AS
	SELECT
		pv.id,
		pv.date_time,
		pv.val::numeric(15,2) AS val
	FROM period_values AS pv
	WHERE pv.period_value_type = 'demurrage_cost_per_hour' AND pv.key = 0
	ORDER BY pv.date_time desc
	;
	
ALTER VIEW demurrage_cost_per_hour_period_value_list OWNER TO ;
*/
