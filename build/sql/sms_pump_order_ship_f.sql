-- Function: sms_pump_order_ship_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_ship_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_ship_ct(in_order_id int)
  RETURNS TABLE(
  	phone_cel text,
  	message text,
  	ext_contact_id int
  ) AS
$$
	SELECT
		tel,
		sms_templates_text(
			template_params
			,(SELECT t.pattern
			FROM sms_patterns t
			WHERE t.sms_type = 'order_for_pump_ship'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE
		id = in_order_id
		-- add check for inform checkbox
		AND
		coalesce(
			(SELECT
				TRUE
			FROM pump_vehicles AS p
			WHERE p.id = (SELECT pump_vehicle_id FROM orders AS o WHERE o.id = in_order_id) AND p.driver_ship_inform
			)
		, FALSE)
		;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_ship_ct(in_order_id int) OWNER TO ;
