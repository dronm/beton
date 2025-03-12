-- View: raw_material_cons_rates_dates_list

-- DROP VIEW raw_material_cons_rates_dates_list;

CREATE OR REPLACE VIEW raw_material_cons_rates_dates_list AS 
	SELECT
		d_from.id,
		d_from.dt,
		date8_descr(d_from.dt) AS dt_descr,
		/*(date8_descr(d_from.dt)::text || ' - '::text) || COALESCE(
			( SELECT date8_descr((d_to.dt - '1 day'::interval)::date)::text AS date
			FROM raw_material_cons_rate_dates d_to
			WHERE d_to.dt > d_from.dt
			ORDER BY d_to.dt
			LIMIT 1
			),
			CASE
				WHEN now()::date < d_from.dt THEN '---'::text
				ELSE date8_descr(now()::date)::text
			END
		) AS period,*/
		
		to_char(d_from.dt,'DD/MM/YY HH24:MI') || ' - '::text ||
		COALESCE(
			( SELECT
			 	to_char(d_to.dt-'1 second'::interval, 'DD/MM/YY HH24:MI') AS date
			FROM raw_material_cons_rate_dates d_to
			WHERE d_to.dt > d_from.dt
				AND
					CASE
						WHEN d_from.production_site_id IS NULL THEN d_to.production_site_id IS NULL
						ELSE d_to.production_site_id = d_from.production_site_id
					END
			ORDER BY d_to.dt
			LIMIT 1
			),
			CASE
				WHEN now() < d_from.dt THEN '---'::text
				ELSE to_char(now(),'DD/MM/YY HH24:MI')
			END
		) AS period,
		
		d_from.name,
		d_from.code,
		production_sites_ref(production_sites_ref_t) AS production_sites_ref,
		d_from.production_site_id
		
	FROM raw_material_cons_rate_dates d_from
	LEFT JOIN production_sites AS production_sites_ref_t ON production_sites_ref_t.id = d_from.production_site_id
	ORDER BY d_from.dt DESC;

ALTER TABLE raw_material_cons_rates_dates_list
  OWNER TO beton;

