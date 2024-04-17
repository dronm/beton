-- View: public.sup_orders_for_sms

-- DROP VIEW public.sup_orders_for_sms;

CREATE OR REPLACE VIEW public.sup_orders_for_sms
 AS
	SELECT
		m.id AS material_id,
		m.name AS material_descr,
		sp.id AS supplier_id,
		sp.name AS supplier_descr,
		sp.tel,
		sp.tel2,
		round(o.quant) AS quant,
		replace(replace(replace(replace(templ.pattern, '[date]'::text, date8_descr((now()::date + '1 day'::interval)::date)::text), '[quant]'::text, round(o.quant)::text), '[mat]'::text, m.name::text), '[sup]'::text, sp.name::text) AS mes_text,
		suppliers_ref(sp) AS ext_obj
		
	FROM supplier_orders o
	LEFT JOIN raw_materials m ON m.id = o.material_id
	LEFT JOIN suppliers sp ON sp.id = o.supplier_id
	LEFT JOIN sms_patterns templ ON templ.sms_type = 'procur'::sms_types
		AND templ.lang_id = coalesce(sp.lang_id, (const_def_lang_val()->'keys'->>'id')::int)
	WHERE o.date = (now()::date + '1 day'::interval)
		AND coalesce(sp.tel::text, '::text') <> ''::text
		AND coalesce(sp.order_notification, FALSE) = TRUE;

ALTER TABLE public.sup_orders_for_sms
    OWNER TO ;

