-- View: public.orders_make_for_lab_list

-- DROP VIEW public.orders_make_for_lab_list;

CREATE OR REPLACE VIEW public.orders_make_for_lab_list AS 
 SELECT o.id,
    o.clients_ref,
    o.destinations_ref,
    o.concrete_types_ref,
    o.comment_text,
	CASE
		WHEN ct.id IS NOT NULL THEN contacts_ref(ct)->>'descr'
		ELSE o.descr 
	END AS descr,

    coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
    o.unload_speed,
    o.date_time,
    o.date_time_to,
    o.quant,
    o.quant_rest,
    o.quant_ordered_day,
    o.quant_ordered_before_now,
    o.quant_shipped_before_now,
    o.quant_shipped_day_before_now,
    o.no_ship_mark,
    o.payed,
    o.under_control,
    o.pay_cash,
    o.total,
    o.pump_vehicle_owner,
    o.unload_type,
    o.pump_vehicle_owners_ref,
    o.pump_vehicle_length,
    o.pump_vehicle_comment,
    need_t.need_cnt > 0::numeric AS is_needed,
    
    coalesce(o.f_val,
	    coalesce((SELECT qp.f_val FROM quality_passports qp WHERE qp.order_id = o.id LIMIT 1), concr.f_val)
    ) AS f_val,
    coalesce(o.w_val,
    	coalesce((SELECT qp.w_val FROM quality_passports qp WHERE qp.order_id = o.id LIMIT 1), concr.w_val)
    ) AS w_val
    
   FROM orders_make_list o
  LEFT JOIN lab_entry_30days need_t ON need_t.concrete_type_id = (((o.concrete_types_ref -> 'keys'::text) ->> 'id'::text)::integer)
  LEFT JOIN contacts AS ct ON ct.id = o.contact_id
  LEFT JOIN orders ON orders.id = o.id
  LEFT JOIN concrete_types concr ON concr.id = orders.concrete_type_id
  
  WHERE o.date_time >= get_shift_start(now()::timestamp without time zone) AND o.date_time <= get_shift_end(get_shift_start(now()::timestamp without time zone))
  ORDER BY o.date_time;

