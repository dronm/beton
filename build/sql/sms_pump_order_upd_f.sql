-- Function: sms_pump_order_upd_ct(in_order_id int)

-- DROP FUNCTION sms_pump_order_upd_ct(in_order_id int);

CREATE OR REPLACE FUNCTION sms_pump_order_upd_ct(in_order_id int)
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
			WHERE t.sms_type = 'order_for_pump_upd'::sms_types AND t.lang_id = (SELECT (const_def_lang_val()->'keys'->>'id')::int)
			)
		),
		contact_id
	FROM sms_pump_order_templates_params
	WHERE id = in_order_id;

$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION sms_pump_order_upd_ct(in_order_id int) OWNER TO ;
