-- VIEW: water_ship_cost_period_value_list

DROP VIEW water_ship_cost_period_value_list;
/*
CREATE OR REPLACE VIEW water_ship_cost_period_value_list AS
	SELECT
		pv.id,
		pv.date_time,
		pv.val::numeric(15,2) AS val
	FROM period_values AS pv
	WHERE pv.period_value_type = 'water_ship_cost' AND pv.key = 0
	ORDER BY pv.date_time desc
	;
	
ALTER VIEW water_ship_cost_period_value_list OWNER TO ;
*/
