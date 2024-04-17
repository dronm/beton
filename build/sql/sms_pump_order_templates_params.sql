-- View: public.sms_pump_order_templates_params

-- DROP VIEW public.sms_pump_order_templates_params;

CREATE OR REPLACE VIEW public.sms_pump_order_templates_params
AS
	SELECT
		o.id,
		ct.tel,
		ARRAY[
			format('("quant","%s")'::text, o.quant::text)::template_value,
			format('("date","%s")'::text, date5_descr(o.date_time::date)::text)::template_value,
			format('("time","%s")'::text, time5_descr(o.date_time::time without time zone)::text)::template_value,
			format('("date","%s")'::text, date8_descr(o.date_time::date)::text)::template_value,
			format('("dest","%s")'::text, dest.name::text)::template_value,
			format('("concrete","%s")'::text, ctp.name::text)::template_value,
			format('("client","%s")'::text, cl.name::text)::template_value,
			format('("name","%s")'::text, o.descr)::template_value,
			format('("tel","%s")'::text,'+7'||format_cel_standart(o.phone_cel::text))::template_value,
			format('("car","%s")'::text, vh.plate::text)::template_value
		] AS template_params,
		ent_ct.contact_id
	
	FROM orders o
	LEFT JOIN concrete_types ctp ON ctp.id = o.concrete_type_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
	LEFT JOIN vehicles vh ON vh.id = pvh.vehicle_id
	LEFT JOIN clients cl ON cl.id = o.client_id		
	LEFT JOIN entity_contacts AS ent_ct ON ent_ct.entity_type = 'pump_vehicles' AND ent_ct.entity_id = pvh.id
	LEFT JOIN contacts ct ON ct.id = ent_ct.contact_id		
	WHERE ent_ct.contact_id IS NOT NULL
	;
	
ALTER TABLE public.sms_pump_order_templates_params
    OWNER TO ;

