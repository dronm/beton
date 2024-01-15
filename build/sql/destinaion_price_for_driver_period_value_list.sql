-- VIEW: destinaion_price_for_driver_period_value_list

DROP VIEW destinaion_price_for_driver_period_value_list;
/*
CREATE OR REPLACE VIEW destinaion_price_for_driver_period_value_list AS
	SELECT
		pv.id,
		pv.date_time,
		pv.key AS destination_id,
		destinations_ref(d) AS destinations_ref,
		pv.val::numeric(15,2) AS val
	FROM period_values AS pv
	LEFT JOIN destinations AS d ON d.id = pv.key
	WHERE pv.period_value_type = 'destination_price_for_driver'
	ORDER BY d.name,pv.date_time desc
	;
	
ALTER VIEW destinaion_price_for_driver_period_value_list OWNER TO ;
*/
