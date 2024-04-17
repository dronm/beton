-- View: public.lab_entry_list

 DROP VIEW public.lab_entry_list;

CREATE OR REPLACE VIEW public.lab_entry_list AS 
	SELECT
		sh.id AS shipment_id,
		sh.date_time,
		lab.shipment_id IS NOT NULL AS samples_exist,
		production_sites_ref(pr_site) AS production_sites_ref,
		sh.production_site_id,
		
		concr.id AS concrete_type_id,
		concrete_types_ref(concr) AS concrete_types_ref,
		(
			SELECT round(avg(d.ok)) AS round
			FROM lab_entry_details d
			WHERE d.shipment_id = sh.id
		) AS ok,
		
		(
			SELECT round(avg(d.weight)) AS round
			FROM lab_entry_details d
			WHERE d.shipment_id = sh.id AND d.id >= 3
		) AS weight,
		
		round(
		CASE
			WHEN concr.pres_norm IS NOT NULL AND concr.pres_norm > 0::numeric THEN (
			(
				SELECT avg(s_lab_det.kn::numeric / concr.mpa_ratio) AS avg
				FROM lab_entry_details s_lab_det
				WHERE s_lab_det.shipment_id = sh.id AND s_lab_det.id < 3
			)
			) / concr.pres_norm * 100::numeric * 2::numeric / 2::numeric
			ELSE 0::numeric
		END) AS p7,
		
		round(
		CASE
			WHEN concr.pres_norm IS NOT NULL AND concr.pres_norm > 0::numeric THEN (
			(
				SELECT avg(s_lab_det.kn::numeric / concr.mpa_ratio) AS avg
				FROM lab_entry_details s_lab_det
				WHERE s_lab_det.shipment_id = sh.id AND s_lab_det.id >= 3
			)
			) / concr.pres_norm * 100::numeric * 2::numeric / 2::numeric
			ELSE 0::numeric
		END) AS p28,
		
		lab.samples,
		lab.materials,
		cl.id AS client_id,
		clients_ref(cl) AS clients_ref,
		cl.phone_cel AS client_phone,
		o.destination_id,
		destinations_ref(dest) AS destinations_ref,
		lab.ok2,
		lab."time",
		
		raw_material_cons_rate_dates_ref(rt_d) AS raw_material_cons_rate_dates_ref,
		lab.rate_date_id,
		
		CASE
			WHEN sh.shipped AND concr.name NOT ilike '%вода%' THEN
				coalesce(
					(SELECT
						FALSE
					FROM productions AS p
					LEFT JOIN material_fact_consumptions AS cons ON cons.production_site_id = p.production_site_id AND cons.production_id = p.production_id
					LEFT JOIN raw_materials AS m ON m.id = cons.raw_material_id
					WHERE p.shipment_id = sh.id AND m.name ilike '%добавка%' AND cons.material_quant >0
					LIMIT 1
					)
				,TRUE)
			ELSE
				FALSE
		END AS no_additive_material
		
		,lab.f
		,lab.w
		
	FROM shipments sh
	LEFT JOIN lab_entries lab ON lab.shipment_id = sh.id
	LEFT JOIN orders o ON o.id = sh.order_id
	LEFT JOIN clients cl ON cl.id = o.client_id
	LEFT JOIN destinations dest ON dest.id = o.destination_id
	LEFT JOIN concrete_types concr ON concr.id = o.concrete_type_id
	LEFT JOIN production_sites pr_site ON pr_site.id = sh.production_site_id
	LEFT JOIN raw_material_cons_rate_dates AS rt_d ON rt_d.id = lab.rate_date_id
	ORDER BY sh.date_time DESC, sh.id;

ALTER TABLE public.lab_entry_list OWNER TO ;


