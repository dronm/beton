-- Теперь с 09/06/23 еще и разделение по производству
-- FUNCTION: public.material_actions_prod_base1(without time zone, timestamp without time zone)

-- DROP FUNCTION IF EXISTS public.material_actions_prod_base1(timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION public.material_actions_prod_base1(
	in_date_time_from timestamp without time zone,
	in_date_time_to timestamp without time zone)
    RETURNS TABLE(is_cement boolean, material_name text, quant_start numeric, quant_deb numeric, quant_kred numeric, pr1_quant_kred numeric, pr2_quant_kred numeric, pr3_quant_kred numeric, quant_correction numeric, quant_end numeric) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	WITH
	prod_base AS (SELECT 1 AS id),
	prod_base_silos AS (
	SELECT
		sl.id
	FROM cement_silos AS sl
	WHERE sl.production_site_id IN (SELECT pst.id from production_sites AS pst WHERE pst.production_base_id = (SELECT prod_base.id FROM prod_base))	
	)
	--По цементу
	(
	SELECT
		TRUE AS is_cement,
		sil.name::text AS material_name,
		coalesce(bal_start.quant,0) AS quant_start,	
		coalesce(ra_deb.quant,0) AS quant_deb,
		coalesce(ra_kred.quant,0) AS quant_kred,
		coalesce(ra_kred.pr1_quant,0) AS pr1_quant_kred,
		coalesce(ra_kred.pr2_quant,0) AS pr2_quant_kred,
		coalesce(ra_kred.pr3_quant,0) AS pr3_quant_kred,
		coalesce(ra_deb.quant_correction,0)-coalesce(ra_kred.quant_correction,0) AS quant_correction,
		coalesce(bal_start.quant,0)+coalesce(ra_deb.quant,0)+coalesce(ra_deb.quant_correction,0)-coalesce(ra_kred.quant,0)-coalesce(ra_kred.quant_correction,0) AS quant_end
	FROM cement_silos AS sil
	
	--остаток нач: только силосы по базе 1
	LEFT JOIN (SELECT * FROM rg_cement_balance(
			in_date_time_from,
			(SELECT array_agg(prod_base_silos.id) FROM prod_base_silos)
		)
	) AS bal_start ON bal_start.cement_silos_id=sil.id
	
	--Приход
	LEFT JOIN (
		SELECT
			ra.cement_silos_id,
			sum(
				CASE
					WHEN doc_type='cement_silo_balance_reset' THEN 0
					ELSE ra.quant
				END
			) AS quant,
			sum(
				CASE
					WHEN doc_type='cement_silo_balance_reset' THEN ra.quant
					ELSE 0
				END
			) AS quant_correction
			
		FROM ra_cement AS ra
		LEFT JOIN cement_silos AS sl ON sl.id = ra.cement_silos_id
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND ra.deb AND ra.cement_silos_id IN (SELECT prod_base_silos.id FROM prod_base_silos)
		GROUP BY ra.cement_silos_id
	) AS ra_deb ON ra_deb.cement_silos_id = sil.id 
	
	--Расход
	LEFT JOIN (
		SELECT
			ra.cement_silos_id,
			sum(
				CASE
					WHEN ra.doc_type<>'cement_silo_balance_reset' THEN ra.quant
					ELSE 0
				END
			) AS quant,
			sum(
				CASE
					WHEN ra.doc_type='cement_silo_balance_reset' THEN ra.quant
					ELSE 0
				END
			) AS quant_correction,
			sum(
				CASE
					WHEN ra.doc_type<>'cement_silo_balance_reset' AND sl.production_site_id=1 THEN ra.quant
					ELSE 0
				END
			) AS pr1_quant,
			sum(
				CASE
					WHEN ra.doc_type<>'cement_silo_balance_reset' AND sl.production_site_id=2 THEN ra.quant
					ELSE 0
				END
			) AS pr2_quant,
			sum(
				CASE
					WHEN ra.doc_type<>'cement_silo_balance_reset' AND sl.production_site_id=4 THEN ra.quant
					ELSE 0
				END
			) AS pr3_quant

		FROM ra_cement AS ra
		LEFT JOIN cement_silos AS sl ON sl.id = ra.cement_silos_id
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND NOT ra.deb AND ra.cement_silos_id IN (SELECT prod_base_silos.id FROM prod_base_silos)
		GROUP BY ra.cement_silos_id
	) AS ra_kred ON ra_kred.cement_silos_id = sil.id 
	WHERE sil.id IN (SELECT prod_base_silos.id FROM prod_base_silos)
	ORDER BY sil.name
	)
	
	UNION ALL
	
	--По материалам без складов
	(
	SELECT
		FALSE AS is_cement,
		m.name,
		coalesce(bal_start.quant,0) AS quant_start,
		coalesce(ra_deb.quant,0) AS quant_deb,
		coalesce(ra_kred.quant,0) AS quant_kred,
		coalesce(ra_kred.pr1_quant,0) AS pr1_quant_kred,
		coalesce(ra_kred.pr2_quant,0) AS pr2_quant_kred,
		coalesce(ra_kred.pr3_quant,0) AS pr3_quant_kred,
		coalesce(ra_deb.quant_correction,0)-coalesce(ra_kred.quant_correction,0) AS quant_correction,
		coalesce(bal_start.quant,0)+coalesce(ra_deb.quant,0)+coalesce(ra_deb.quant_correction,0)-coalesce(ra_kred.quant,0)-coalesce(ra_kred.quant_correction,0) AS quant_end
	
	FROM raw_materials AS m
	
	--остаток нач
	LEFT JOIN (
		SELECT
			t_rg.*
		FROM rg_material_facts_balance(
			in_date_time_from,
			(SELECT array_agg(prod_base.id) FROM prod_base),
			'{}',
			'{}'
		) AS t_rg
	) AS bal_start ON bal_start.material_id = m.id
	
	--Приход
	LEFT JOIN (
		SELECT
			ra.material_id,
			sum(
				CASE
					WHEN ra.doc_type='material_fact_balance_correction' THEN 0
					ELSE ra.quant
				END
			) AS quant,
			sum(
				CASE
					WHEN ra.doc_type='material_fact_balance_correction' THEN ra.quant
					ELSE 0
				END
			) AS quant_correction
			
		FROM ra_material_facts AS ra
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND ra.deb AND ra.production_base_id = (SELECT prod_base.id FROM prod_base)
		GROUP BY ra.material_id
	) AS ra_deb ON ra_deb.material_id = m.id 
	
	--Расход
	LEFT JOIN (
		SELECT
			ra.material_id,
			sum(
				CASE
					WHEN ra.doc_type='material_fact_balance_correction' THEN 0
					ELSE ra.quant
				END
			) AS quant,
			sum(
				CASE
					-- OR ra.doc_type='material_fact_consumption_correction'
					WHEN doc_type='material_fact_balance_correction' THEN ra.quant
					ELSE 0
				END
			) AS quant_correction,
			sum(
				CASE
					WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id = 1)
						OR
						(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id = 1)
						THEN ra.quant
					ELSE 0
				END
			) AS pr1_quant,
			sum(
				CASE
					WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id=2)
						OR
						(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id = 2)
						THEN ra.quant
					ELSE 0
				END
			) AS pr2_quant,
			sum(
				CASE
					WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id=4)
						OR
						(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id = 4)
						THEN ra.quant
					ELSE 0
				END
			) AS pr3_quant
			
		FROM ra_material_facts AS ra
		LEFT JOIN material_fact_consumptions AS cons ON ra.doc_type='material_fact_consumption' AND ra.doc_id=cons.id
		LEFT JOIN material_fact_consumption_corrections AS cons_cor ON ra.doc_type='material_fact_consumption_correction' AND ra.doc_id=cons_cor.id
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND NOT ra.deb AND ra.production_base_id = (SELECT prod_base.id FROM prod_base)
		GROUP BY ra.material_id
	) AS ra_kred ON ra_kred.material_id = m.id 
	WHERE concrete_part AND NOT is_cement AND NOT coalesce(dif_store,FALSE)
	ORDER BY ord
	)
	
	UNION ALL
	
	--По материалам с местами хранения
	(
	SELECT
		FALSE AS is_cement,
		m.name||', '||coalesce(st_map.store,'') AS name,
		coalesce(bal_start.quant,0) AS quant_start,
		coalesce(ra_deb.quant,0) AS quant_deb,
		coalesce(ra_kred.quant,0) AS quant_kred,
		coalesce(ra_kred.pr1_quant,0) AS pr1_quant_kred,
		coalesce(ra_kred.pr2_quant,0) AS pr2_quant_kred,
		coalesce(ra_kred.pr3_quant,0) AS pr3_quant_kred,
		coalesce(ra_deb.quant_correction,0)-coalesce(ra_kred.quant_correction,0) AS quant_correction,
		coalesce(bal_start.quant,0)+coalesce(ra_deb.quant,0)+coalesce(ra_deb.quant_correction,0)-coalesce(ra_kred.quant,0)-coalesce(ra_kred.quant_correction,0) AS quant_end
	
	FROM raw_materials AS m
	
	--остаток нач
	LEFT JOIN (
		SELECT
			t_rg.*
		FROM rg_material_facts_balance(
			in_date_time_from,
			(SELECT array_agg(prod_base.id) FROM prod_base),
			'{}',
			'{}'
		) AS t_rg
	) AS bal_start ON bal_start.material_id = m.id
	
	--Приход
	LEFT JOIN (
		SELECT
			ra.production_site_id,
			ra.material_id,
			sum(
				CASE
					WHEN ra.doc_type='material_fact_balance_correction' THEN 0
					ELSE ra.quant
				END
			) AS quant,
			sum(
				CASE
					WHEN ra.doc_type='material_fact_balance_correction' THEN ra.quant
					ELSE 0
				END
			) AS quant_correction
			
		FROM ra_material_facts AS ra
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND ra.deb AND ra.production_base_id = (SELECT prod_base.id FROM prod_base)
		GROUP BY ra.production_site_id,ra.material_id
	) AS ra_deb ON ra_deb.material_id = m.id  AND ra_deb.production_site_id = bal_start.production_site_id
	
	--Расход
	LEFT JOIN (
		SELECT
			ra.production_site_id,
			ra.material_id,
			sum(
				CASE
					WHEN ra.doc_type='material_fact_balance_correction' THEN 0
					ELSE ra.quant
				END
			) AS quant,
			sum(
				CASE
					-- OR ra.doc_type='material_fact_consumption_correction'
					WHEN doc_type='material_fact_balance_correction' THEN ra.quant
					ELSE 0
				END
			) AS quant_correction,
			sum(
				CASE
					WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id=1)
						OR
						(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id=1)
						THEN ra.quant
					ELSE 0
				END
			) AS pr1_quant,
			sum(
				CASE
					WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id=2)
						OR
						(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id=2)
						THEN ra.quant
					ELSE 0
				END
			) AS pr2_quant,
			sum(
				CASE
					WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id=4)
						OR
						(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id=4)
						THEN ra.quant
					ELSE 0
				END
			) AS pr3_quant
			
		FROM ra_material_facts AS ra
		LEFT JOIN material_fact_consumptions AS cons ON ra.doc_type='material_fact_consumption' AND ra.doc_id=cons.id
		LEFT JOIN material_fact_consumption_corrections AS cons_cor ON ra.doc_type='material_fact_consumption_correction' AND ra.doc_id=cons_cor.id
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND NOT ra.deb AND ra.production_base_id = (SELECT prod_base.id FROM prod_base)
		GROUP BY ra.production_site_id,ra.material_id
	) AS ra_kred ON ra_kred.material_id = m.id AND ra_kred.production_site_id=bal_start.production_site_id
	
	LEFT JOIN store_map_to_production_sites AS st_map ON st_map.production_site_id = bal_start.production_site_id
	
	WHERE concrete_part AND NOT is_cement AND coalesce(dif_store,FALSE) = TRUE
	ORDER BY ord
	)
	
	;
$BODY$;

ALTER FUNCTION public.material_actions_prod_base1(timestamp without time zone, timestamp without time zone)
    OWNER TO ;

