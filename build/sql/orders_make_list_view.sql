-- View: public.orders_make_list_view

-- DROP VIEW public.orders_make_list_view;

CREATE OR REPLACE VIEW public.orders_make_list_view
 AS
 SELECT o.id,
    get_short_str(cl.name::text, 15) AS client_descr,
    o.client_id,
    get_short_str(d.name::text, 10) AS destination_descr,
    o.destination_id,
    concr.name AS concrete_type_descr,
    o.concrete_type_id,
    o.unload_type,
        CASE
            WHEN o.unload_type = 'pump'::unload_types OR o.unload_type = 'band'::unload_types THEN vh.owner
            ELSE ''::character varying
        END AS unload_type_descr,
    get_short_str(o.comment_text, 15) AS comment_text,
    get_short_str(o.descr, 15) AS descr,
    o.phone_cel,
    o.unload_speed,
    date8_time5_descr(o.date_time) AS date_time_descr,
    date8_descr(o.date_time::date) AS date_time_date_descr,
    time5_descr(o.date_time::time without time zone) AS date_time_time_descr,
    o.date_time,
    o.date_time_to,
    time5_descr(o.date_time::time without time zone + '01:00:00'::interval) AS date_time_to_user_descr,
    time5_descr(o.date_time_to::time without time zone) AS date_time_to_descr,
    o.quant,
    o.quant - COALESCE(( SELECT sum(shipments.quant) AS sum
           FROM shipments
          WHERE shipments.order_id = o.id AND shipments.shipped = true), 0::double precision) AS quant_rest,
        CASE
            WHEN now()::timestamp without time zone > o.date_time AND now()::timestamp without time zone < o.date_time_to THEN round((o.quant / (date_part('epoch'::text, o.date_time_to - o.date_time) / 60::double precision) * (date_part('epoch'::text, now()::timestamp without time zone::timestamp with time zone - o.date_time::timestamp with time zone) / 60::double precision))::numeric, 2)::double precision
            WHEN now()::timestamp without time zone > o.date_time_to THEN o.quant
            ELSE 0::double precision
        END AS quant_ordered_before_now,
        CASE
            WHEN o.date_time::time without time zone >= constant_first_shift_start_time() AND o.date_time::time without time zone < (constant_first_shift_start_time()::interval + constant_day_shift_length())::time without time zone AND o.date_time_to::time without time zone >= constant_first_shift_start_time() AND o.date_time_to::time without time zone < (constant_first_shift_start_time()::interval + constant_day_shift_length())::time without time zone THEN o.quant
            WHEN o.date_time::time without time zone >= constant_first_shift_start_time() AND o.date_time::time without time zone < (constant_first_shift_start_time()::interval + constant_day_shift_length())::time without time zone AND o.date_time::time without time zone < (constant_first_shift_start_time()::interval + constant_day_shift_length())::time without time zone THEN round((o.quant / (date_part('epoch'::text, o.date_time_to - o.date_time) / 60::double precision) * (date_part('epoch'::text, o.date_time::date + (constant_first_shift_start_time()::interval + constant_day_shift_length()) - o.date_time) / 60::double precision))::numeric, 2)::double precision
            ELSE 0::double precision
        END AS quant_ordered_day,
    ( SELECT COALESCE(sum(shipments.quant), 0::double precision) AS sum
           FROM shipments
          WHERE shipments.order_id = o.id AND shipments.ship_date_time < now()::timestamp without time zone) AS quant_shipped_before_now,
    ( SELECT COALESCE(sum(shipments.quant), 0::double precision) AS sum
           FROM shipments
          WHERE shipments.order_id = o.id AND shipments.ship_date_time::time without time zone >= constant_first_shift_start_time() AND shipments.ship_date_time::time without time zone <= (constant_first_shift_start_time()::interval + constant_day_shift_length())::time without time zone) AS quant_shipped_day_before_now,
        CASE
            WHEN (o.quant - COALESCE(( SELECT sum(shipments.quant) AS sum
               FROM shipments
              WHERE shipments.order_id = o.id AND shipments.shipped = true), 0::double precision)) > 0::double precision AND (now()::timestamp without time zone::timestamp with time zone - (( SELECT shipments.ship_date_time
               FROM shipments
              WHERE shipments.order_id = o.id AND shipments.shipped = true
              ORDER BY shipments.ship_date_time DESC
             LIMIT 1))::timestamp with time zone) > constant_ord_mark_if_no_ship_time()::interval THEN true
            ELSE false
        END AS no_ship_mark,
        CASE
            WHEN o.pay_cash THEN o.total
            ELSE 0::numeric
        END AS total,
        CASE
            WHEN o.pay_cash THEN format_money(o.total)
            ELSE ''::text
        END AS total_descr,
    o.payed,
        CASE
            WHEN o.payed THEN 'опл'::text
            WHEN o.under_control THEN '!'::text
            ELSE '-'::text
        END AS payed_inf
   FROM orders o
     LEFT JOIN clients cl ON cl.id = o.client_id
     LEFT JOIN destinations d ON d.id = o.destination_id
     LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
     LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
     LEFT JOIN vehicles vh ON vh.id = pvh.vehicle_id
  ORDER BY o.date_time;

ALTER TABLE public.orders_make_list_view
    OWNER TO beton;

GRANT ALL ON TABLE public.orders_make_list_view TO beton;
GRANT SELECT ON TABLE public.orders_make_list_view TO premier;


