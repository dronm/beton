-- View: orders_list

-- DROP VIEW orders_list;

CREATE OR REPLACE VIEW orders_list AS 
	SELECT
		o.id,
		order_num(o.*) AS number,
		clients_ref(cl) AS clients_ref,
		o.client_id,
		destinations_ref(d) AS destinations_ref,
		o.destination_id,
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_type_id,
		o.unload_type AS unload_type,
		o.comment_text AS comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.date_time,
		o.quant,
		users_ref(u) AS users_ref,
		o.user_id,
		orders_ref(o) AS orders_ref,
		contacts_ref(ct) AS contacts_ref,
		o.last_modif_date_time,
		users_ref(last_u) AS last_modif_users_ref,

	    coalesce(
        (
            SELECT json_agg(
                json_build_object(
                    'id', oct.id,
                    'contact', json_build_object(
                        'name', oct_ct.name,
                        'tel', oct_ct.tel
                    )
                )
                ORDER BY oct.id
            )
            FROM public.order_contacts AS oct
            JOIN public.contacts AS oct_ct ON oct_ct.id = oct.contact_id
            WHERE oct.order_id = o.id
        ),
        '[]'::json
    ) AS contact_list	

   FROM orders o
   LEFT JOIN clients cl ON cl.id = o.client_id
   LEFT JOIN destinations d ON d.id = o.destination_id
   LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
   LEFT JOIN contacts ct ON ct.id = o.contact_id
   LEFT JOIN users u ON u.id = o.user_id
   LEFT JOIN users last_u ON last_u.id = o.last_modif_user_id
  ORDER BY o.date_time DESC;


-- View: public.orders_dialog

-- DROP VIEW public.orders_dialog;

CREATE OR REPLACE VIEW public.orders_dialog AS 
	SELECT
		o.id,
		order_num(o.*) AS number,		
		clients_ref(cl) AS clients_ref,		
		
		destinations_ref(d) AS destinations_ref,
		o.destination_price AS destination_cost,		
		--d.price AS destination_price,		
		CASE
			WHEN coalesce(d.special_price,FALSE) THEN
				--coalesce(d.price,0)
				period_value('destination_price', d.id, o.date_time)::numeric(15,2)
			ELSE
			coalesce(
				(SELECT sh_p.price
				FROM shipment_for_owner_costs sh_p
				WHERE sh_p.date<=o.date_time::date AND sh_p.distance_to>=d.distance
				ORDER BY sh_p.date DESC,sh_p.distance_to ASC
				LIMIT 1
				),			
			coalesce(d.price,0))			
		END  AS destination_price,
		
		d.time_route,
		d.distance,
		
		concrete_types_ref(concr) AS concrete_types_ref,
		o.concrete_price AS concrete_cost,		
		--concr.price AS concrete_price,
		coalesce(
			/*(SELECT
				ct_p.price
			FROM concrete_costs ct_p
			WHERE ct_p.date<=o.date_time::date AND ct_p.concrete_type_id=o.concrete_type_id
			ORDER BY ct_p.date DESC
			LIMIT 1
			),*/
			(SELECT pr.price FROM client_price_list(o.client_id,o.date_time)AS pr WHERE pr.concrete_type_id=o.concrete_type_id),
			coalesce(concr.price,0)
		) AS concrete_price,
		
		o.unload_type,
		o.comment_text,
		
		coalesce(ct.name::text, o.descr::text) AS descr,
		coalesce(ct.tel::text, o.phone_cel::text) AS phone_cel,
		
		o.unload_speed,
		o.date_time,
		o.time_to,		
		o.quant,
		langs_ref(l) AS langs_ref,
		o.total,
		o.total_edit,
		o.pay_cash,
		o.unload_price AS unload_cost,
		o.payed,
		o.under_control,
		
		pv.phone_cel AS pump_vehicle_phone_cel,
		pump_vehicles_ref(pv,v) AS pump_vehicles_ref,
		pump_prices_ref(ppr) AS pump_prices_ref,
		
		users_ref(u) AS users_ref,
		
		d.distance AS destination_distance,
		
		users_ref(lm_u) AS last_modif_users_ref,
		o.last_modif_date_time,
		
		o.create_date_time,
		
		o.ext_production,
		
		(e_user.id IS NOT NULL) tm_exists,
		(e_user.tm_id IS NOT NULL) tm_activated,
		e_user.tm_photo,
		
		o.contact_id AS contact_id,
		
		client_specifications_ref(spec) AS client_specifications_ref,
		
		o.f_val,
		o.w_val,

		coalesce(
			CASE
				WHEN o.client_specification_id IS NOT NULL THEN
					(SELECT 
						sum(d.debt_total)
					FROM client_contracts_1c AS cl_ct 
					LEFT JOIN client_debts AS d ON d.client_id=spec.client_id
						AND d.client_contract_id = cl_ct.id 
					WHERE cl_ct.ref_1c->>'ref_1c' = spec.client_contract_1c_ref
					)
				ELSE
					--no specificaton
					(SELECT 
						sum(d.debt_total)
					FROM client_debts AS d 
					WHERE d.client_id = o.client_id
					)
			END
		, 0) AS client_debt

		,cl.ref_1c AS client_ref_1c
		,o.ref_1c,
		
		(SELECT 
			DATE_TRUNC('minute', dbt.update_date)
		FROM client_debts AS dbt 
		WHERE dbt.client_id = o.client_id
		LIMIT 1
		) AS client_debt_date,

		coalesce(
			(
				SELECT json_agg(
					json_build_object(
						'id', oct.id,
						'contact', json_build_object(
							'name', oct_ct.name,
							'tel', oct_ct.tel
						)
					)
					ORDER BY oct.id
				)
				FROM public.order_contacts AS oct
				JOIN public.contacts AS oct_ct ON oct_ct.id = oct.contact_id
				WHERE oct.order_id = o.id
			),
			'[]'::json
		) AS contact_list
		
	FROM orders o
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations d ON d.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN langs l ON l.id = o.lang_id
	LEFT JOIN pump_vehicles pv ON pv.id = o.pump_vehicle_id
	LEFT JOIN users u ON u.id = o.user_id
	LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
	LEFT JOIN vehicles v ON v.id = pv.vehicle_id
	LEFT JOIN users lm_u ON lm_u.id = o.last_modif_user_id
	
	--LEFT JOIN client_tels AS tl ON tl.client_id=o.client_id AND tl.tel=o.phone_cel	
	
	LEFT JOIN contacts AS ct ON ct.id = o.contact_id
	LEFT JOIN notifications.ext_users_photo_list AS e_user ON e_user.ext_contact_id = o.contact_id
	LEFT JOIN client_specifications AS spec ON spec.id = o.client_specification_id
	-- LEFT JOIN (
	-- 	SELECT
	-- 		d.client_id,
	-- 		d.update_date
	-- 		sum(d.debt_total) AS debt_total
	-- 	FROM client_debts AS d		
	-- 	GROUP BY 
	-- 		d.client_id,
	-- 		d.update_date
	-- ) AS debts ON debts.client_id = o.client_id
	
	ORDER BY o.date_time;


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
	o.concrete_type_id,

	coalesce(
	(
		SELECT json_agg(
			json_build_object(
				'id', oct.id,
				'contact', json_build_object(
					'name', oct_ct.name,
					'tel', oct_ct.tel
				)
			)
			ORDER BY oct.id
		)
		FROM public.order_contacts AS oct
		JOIN public.contacts AS oct_ct ON oct_ct.id = oct.contact_id
		WHERE oct.order_id = o.id
	),
	'[]'::json
	) AS contact_list	

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
