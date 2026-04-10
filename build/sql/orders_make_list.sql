-- View: public.orders_make_list

--DROP VIEW public.orders_make_for_lab_list;
--DROP VIEW public.orders_make_list;
/*
CREATE OR REPLACE VIEW public.orders_make_list
 AS
 SELECT o.id,
    clients_ref(cl.*) AS clients_ref,
    destinations_ref(d.*) AS destinations_ref,
    concrete_types_ref(concr.*) AS concrete_types_ref,
    o.comment_text,
        CASE
            WHEN ct.id IS NOT NULL AND POSITION((','::text) IN (ct.descr)) > 0 THEN SUBSTRING(ct.descr FROM 1 FOR POSITION((','::text) IN (ct.descr)) - 1)
            WHEN ct.id IS NOT NULL THEN ct.descr
            ELSE o.descr
        END AS descr,
    COALESCE(ct.tel::text, o.phone_cel::text) AS phone_cel,
    o.unload_speed,
    o.date_time,
    o.date_time_to,
    o.quant,
    o.quant::numeric - COALESCE(( SELECT sum(shipments.quant::numeric) AS sum
           FROM shipments
          WHERE shipments.order_id = o.id AND shipments.shipped), 0::numeric
	) AS quant_rest,

	CASE
		WHEN o.date_time::time without time zone >= const_first_shift_start_time_val() AND o.date_time::time without time zone < (const_first_shift_start_time_val()::interval + const_day_shift_length_val()) AND o.date_time_to::time without time zone >= const_first_shift_start_time_val() AND o.date_time_to::time without time zone < (const_first_shift_start_time_val()::interval + const_day_shift_length_val()) THEN o.quant::numeric
		WHEN o.date_time::time without time zone >= const_first_shift_start_time_val() AND o.date_time::time without time zone < (const_first_shift_start_time_val()::interval + const_day_shift_length_val()) AND o.date_time::time without time zone < (const_first_shift_start_time_val()::interval + const_day_shift_length_val()) THEN round((o.quant / (date_part('epoch'::text, o.date_time_to - o.date_time) / 60::numeric) * (date_part('epoch'::text, o.date_time::date + (const_first_shift_start_time_val()::interval + const_day_shift_length_val()) - o.date_time) / 60::numeric))::numeric, 2)::numeric
		ELSE 0::numeric
	END AS quant_ordered_day,

	CASE
		WHEN now()::timestamp without time zone > o.date_time AND now()::timestamp without time zone < o.date_time_to THEN round((o.quant / (date_part('epoch'::text, o.date_time_to - o.date_time) / 60::double precision) * (date_part('epoch'::text, now()::timestamp without time zone::timestamp with time zone - o.date_time::timestamp with time zone) / 60::numeric))::numeric, 2)::numeric
		WHEN now()::timestamp without time zone > o.date_time_to THEN o.quant::numeric
		ELSE 0::numeric
	END AS quant_ordered_before_now,

    ( SELECT COALESCE(sum(shipments.quant), 0::double precision) AS sum
           FROM shipments
          WHERE shipments.order_id = o.id AND shipments.ship_date_time < now()::timestamp without time zone) AS quant_shipped_before_now,
    ( SELECT COALESCE(sum(shipments.quant), 0::double precision) AS sum
           FROM shipments
          WHERE shipments.order_id = o.id AND shipments.ship_date_time::time without time zone >= constant_first_shift_start_time() AND shipments.ship_date_time::time without time zone <= (const_first_shift_start_time_val()::interval + const_day_shift_length_val())) AS quant_shipped_day_before_now,
        CASE
            WHEN (o.quant - COALESCE(( SELECT sum(shipments.quant) AS sum
               FROM shipments
              WHERE shipments.order_id = o.id AND shipments.shipped), 0::double precision)) > 0::double precision AND (now()::timestamp without time zone::timestamp with time zone - (( SELECT shipments.ship_date_time
               FROM shipments
              WHERE shipments.order_id = o.id AND shipments.shipped
              ORDER BY shipments.ship_date_time DESC
             LIMIT 1))::timestamp with time zone) > const_ord_mark_if_no_ship_time_val()::interval THEN true
            ELSE false
        END AS no_ship_mark,

    o.payed,
    o.under_control,
    o.pay_cash,
        CASE
            WHEN o.pay_cash THEN o.total
            ELSE 0::numeric
        END AS total,
    vh.owner AS pump_vehicle_owner,
    o.unload_type,
    ( SELECT (owners."row" -> 'fields'::text) -> 'owner'::text
           FROM ( SELECT jsonb_array_elements(vh.vehicle_owners -> 'rows'::text) AS "row") owners
          WHERE o.date_time >= (((owners."row" -> 'fields'::text) ->> 'dt_from'::text)::timestamp without time zone)
          ORDER BY (((owners."row" -> 'fields'::text) ->> 'dt_from'::text)::timestamp without time zone) DESC
         LIMIT 1) AS pump_vehicle_owners_ref,
    pvh.pump_length AS pump_vehicle_length,
    pvh.comment_text AS pump_vehicle_comment,
    o.contact_id,
    COALESCE(o.f_val, COALESCE(( SELECT qp.f_val
           FROM quality_passports qp
          WHERE qp.order_id = o.id
         LIMIT 1), concr.f_val)) AS f_val,
    COALESCE(o.w_val, COALESCE(( SELECT qp.w_val
           FROM quality_passports qp
          WHERE qp.order_id = o.id
         LIMIT 1), concr.w_val)) AS w_val,
         
   o.client_id, --added for filter json column
   o.destination_id,
   o.user_id,
	o.concrete_type_id
         
   FROM orders o
     LEFT JOIN clients cl ON cl.id = o.client_id
     LEFT JOIN destinations d ON d.id = o.destination_id
     LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
     LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
     LEFT JOIN vehicles vh ON vh.id = pvh.vehicle_id
     LEFT JOIN contacts ct ON ct.id = o.contact_id
  ORDER BY o.date_time;
*/
CREATE OR REPLACE VIEW public.orders_make_list AS
SELECT
	o.id,
	clients_ref(cl.*) AS clients_ref,
	destinations_ref(d.*) AS destinations_ref,
	concrete_types_ref(concr.*) AS concrete_types_ref,
	o.comment_text,
	CASE
		WHEN ct.id IS NOT NULL AND POSITION(',' IN ct.descr) > 0 THEN SUBSTRING(ct.descr FROM 1 FOR POSITION(',' IN ct.descr) - 1)
		WHEN ct.id IS NOT NULL THEN ct.descr
		ELSE o.descr
	END AS descr,
	COALESCE(ct.tel::text, o.phone_cel::text) AS phone_cel,
	o.unload_speed::numeric AS unload_speed,
	o.date_time,
	o.date_time_to,
	o.quant::numeric AS quant,
	o.quant::numeric - sh.shipped_total::numeric AS quant_rest,

	CASE
		WHEN o.date_time_to <= o.date_time THEN 0::numeric
		ELSE ROUND(
			o.quant::numeric
			* GREATEST(
				0::numeric,
				(
					EXTRACT(
						EPOCH FROM LEAST(o.date_time_to, ds.day_shift_end)
						- GREATEST(o.date_time, ds.day_shift_start)
					) / 60.0
				)::numeric
			)
			/ NULLIF(
				(EXTRACT(EPOCH FROM (o.date_time_to - o.date_time)) / 60.0)::numeric,
				0::numeric
			),
			2
		)
	END AS quant_ordered_day,

	CASE
		WHEN now()::timestamp without time zone <= o.date_time THEN 0::numeric
		WHEN now()::timestamp without time zone >= o.date_time_to THEN o.quant::numeric
		WHEN o.date_time_to <= o.date_time THEN 0::numeric
		ELSE ROUND(
			o.quant::numeric
			* (
				EXTRACT(EPOCH FROM (now()::timestamp without time zone - o.date_time)) / 60.0
			)::numeric
			/ NULLIF(
				(EXTRACT(EPOCH FROM (o.date_time_to - o.date_time)) / 60.0)::numeric,
				0::numeric
			),
			2
		)
	END AS quant_ordered_before_now,

	sh.shipped_before_now AS quant_shipped_before_now,
	sh.shipped_day_before_now AS quant_shipped_day_before_now,

	CASE
		WHEN o.quant::numeric - sh.shipped_total > 0::numeric
			AND sh.last_shipped_at IS NOT NULL
			AND now()::timestamp without time zone - sh.last_shipped_at > const_ord_mark_if_no_ship_time_val()::interval
		THEN true
		ELSE false
	END AS no_ship_mark,

	o.payed,
	o.under_control,
	o.pay_cash,
	CASE
		WHEN o.pay_cash THEN o.total::numeric
		ELSE 0::numeric
	END AS total,
	vh.owner AS pump_vehicle_owner,
	o.unload_type,

	(
		SELECT (owners.row -> 'fields' -> 'owner')
		FROM (
			SELECT jsonb_array_elements(vh.vehicle_owners -> 'rows') AS row
		) owners
		WHERE o.date_time >= ((owners.row -> 'fields' ->> 'dt_from')::timestamp without time zone)
		ORDER BY ((owners.row -> 'fields' ->> 'dt_from')::timestamp without time zone) DESC
		LIMIT 1
	) AS pump_vehicle_owners_ref,

	pvh.pump_length::numeric AS pump_vehicle_length,
	pvh.comment_text AS pump_vehicle_comment,
	o.contact_id,
	COALESCE(o.f_val, qp.f_val, concr.f_val) AS f_val,
	COALESCE(o.w_val, qp.w_val, concr.w_val) AS w_val,

	o.client_id,
	o.destination_id,
	o.user_id,
	o.concrete_type_id

FROM orders o
LEFT JOIN clients cl ON cl.id = o.client_id
LEFT JOIN destinations d ON d.id = o.destination_id
LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
LEFT JOIN pump_vehicles pvh ON pvh.id = o.pump_vehicle_id
LEFT JOIN vehicles vh ON vh.id = pvh.vehicle_id
LEFT JOIN contacts ct ON ct.id = o.contact_id

LEFT JOIN LATERAL (
	SELECT
		o.date_time::date + const_first_shift_start_time_val()::interval AS day_shift_start,
		o.date_time::date + (const_first_shift_start_time_val()::interval + const_day_shift_length_val()) AS day_shift_end
) ds ON true

LEFT JOIN LATERAL (
	SELECT
		COALESCE(
			SUM(s.quant::numeric) FILTER (WHERE s.shipped),
			0::numeric
		) AS shipped_total,
		COALESCE(
			SUM(s.quant::numeric) FILTER (
				WHERE s.ship_date_time < now()::timestamp without time zone
			),
			0::numeric
		) AS shipped_before_now,
		COALESCE(
			SUM(s.quant::numeric) FILTER (
				WHERE s.ship_date_time < now()::timestamp without time zone
					AND s.ship_date_time::time without time zone >= ds.day_shift_start::time without time zone
					AND s.ship_date_time::time without time zone <= ds.day_shift_end::time without time zone
			),
			0::numeric
		) AS shipped_day_before_now,
		MAX(s.ship_date_time) FILTER (WHERE s.shipped) AS last_shipped_at
	FROM shipments s
	WHERE s.order_id = o.id
) sh ON true

LEFT JOIN LATERAL (
	SELECT
		qp.f_val,
		qp.w_val
	FROM quality_passports qp
	WHERE qp.order_id = o.id
	LIMIT 1
) qp ON true

ORDER BY o.date_time;
