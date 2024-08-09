-- Теперь с 09/06/23 еще и разделение по производству
-- FUNCTION: public.material_actions_prod_base2(without time zone, timestamp without time zone)

-- DROP FUNCTION IF EXISTS public.material_actions_prod_base2(timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION public.material_actions_prod_base2(
	in_date_time_from timestamp without time zone,
	in_date_time_to timestamp without time zone)
    RETURNS TABLE(
    	is_cement boolean,
    	material_name text,
    	quant_start numeric,
    	quant_deb numeric,
    	quant_kred numeric,
    	pr1_quant_kred numeric,	-- Расход с определенного завода одной производственной зоны, сколько заводов, столько и полей
    	quant_correction numeric,
    	quant_end numeric
    ) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	WITH
	date_time_from AS (SELECT in_date_time_from AS d),
	date_time_to AS (SELECT in_date_time_to AS d),
	prod_base AS (SELECT 2 AS id),
	prod_site1 AS (SELECT 5 AS id),
	prod_base_silos AS (
	SELECT
		sl.id
	FROM cement_silos AS sl
	WHERE sl.production_site_id IN (SELECT pst.id from production_sites AS pst WHERE pst.production_base_id = (SELECT prod_base.id FROM prod_base))	
	),
	mat_with_stores AS (
		SELECT
			mt.id,
			mt.name
		FROM raw_materials AS mt
		WHERE mt.concrete_part AND NOT mt.is_cement AND coalesce(mt.dif_store, FALSE) = TRUE
		ORDER BY mt.ord
	)
	
	--Данные по цементу
	(
	-- все возможные силосы
	SELECT
		TRUE AS is_cement,
		sil.name::text AS material_name,
		coalesce(bal_start.quant, 0) AS quant_start,	
		coalesce(ra.quant_deb, 0) AS quant_deb,
		coalesce(ra.quant_kred, 0) AS quant_kred,
		coalesce(ra.pr1_quant_kred, 0) AS pr1_quant_kred,
		coalesce(ra.quant_deb_correction,0) - coalesce(ra.quant_kred_correction,0) AS quant_correction,
		coalesce(bal_start.quant, 0) + coalesce(ra.quant_deb, 0) + coalesce(ra.quant_deb_correction, 0) - coalesce(ra.quant_kred, 0) - coalesce(ra.quant_kred_correction, 0) AS quant_end
	FROM cement_silos AS sil	
	LEFT JOIN production_sites AS pst ON pst.id = sil.production_site_id
	--цепляем остаток начальный: только силосы по этой базе
	LEFT JOIN (SELECT
			rg.cement_silos_id,
			coalesce(rg.quant, 0) AS quant
		FROM rg_cement_balance(
			(SELECT d FROM date_time_from),
			(SELECT array_agg(prod_base_silos.id) FROM prod_base_silos)
		) AS rg
	) AS bal_start ON bal_start.cement_silos_id = sil.id
	
	--цепляем приход/корректировку, расход/обнуление силосов
	LEFT JOIN (
		SELECT
			ra.cement_silos_id,
			--приход
			sum(
				CASE
					WHEN ra.deb AND doc_type='cement_silo_balance_reset' THEN 0
					WHEN ra.deb THEN ra.quant
					ELSE 0
				END
			) AS quant_deb,
			sum(
				CASE
					WHEN ra.deb AND doc_type='cement_silo_balance_reset' THEN ra.quant
					ELSE 0
				END
			) AS quant_deb_correction,
			
			-- расход
			sum(
				CASE
					WHEN ra.deb = FALSE AND ra.doc_type<>'cement_silo_balance_reset' THEN ra.quant
					ELSE 0
				END
			) AS quant_kred,
			sum(
				CASE
					WHEN ra.deb = FALSE AND ra.doc_type='cement_silo_balance_reset' THEN ra.quant
					ELSE 0
				END
			) AS quant_kred_correction,
			sum(
				CASE
					WHEN ra.deb = FALSE AND ra.doc_type<>'cement_silo_balance_reset' AND sl.production_site_id = (SELECT pst.id FROM prod_site1 AS pst) THEN ra.quant
					ELSE 0
				END
			) AS pr1_quant_kred
			
		FROM ra_cement AS ra
		LEFT JOIN cement_silos AS sl ON sl.id = ra.cement_silos_id
		WHERE ra.date_time BETWEEN (SELECT d FROM date_time_from) AND (SELECT d FROM date_time_to)
			AND ra.cement_silos_id IN (SELECT prod_base_silos.id FROM prod_base_silos)
		GROUP BY ra.cement_silos_id
	) AS ra ON ra.cement_silos_id = sil.id 
		
	WHERE sil.id IN (SELECT prod_base_silos.id FROM prod_base_silos)
	ORDER BY
		pst.name,
		sil.production_descr	
		--sil.weigh_app_name
		--sil.name
	)
	
	UNION ALL
	
	--По материалам без складов
	(
	-- Все возможные материалы без складов
	SELECT
		FALSE AS is_cement,
		m.name,
		coalesce(bal_start.quant, 0) AS quant_start,
		coalesce(ra.quant_deb, 0) AS quant_deb,
		coalesce(ra.quant_kred,0) AS quant_kred,
		coalesce(ra.pr1_quant_kred, 0) AS pr1_quant_kred,
		coalesce(ra.quant_deb_correction,0) - coalesce(ra.quant_kred_correction,0) AS quant_correction,
		coalesce(bal_start.quant, 0) + coalesce(ra.quant_deb, 0) + coalesce(ra.quant_deb_correction, 0) - coalesce(ra.quant_kred, 0) - coalesce(ra.quant_kred_correction, 0) AS quant_end
	
	FROM raw_materials AS m
	
	--остаток нач
	LEFT JOIN (
		SELECT
			t_rg.material_id,
			coalesce(t_rg.quant, 0) AS quant
		FROM rg_material_facts_balance(
			(SELECT d FROM date_time_from),
			(SELECT array_agg(prod_base.id) FROM prod_base),
			'{}',
			'{}'
		) AS t_rg
	) AS bal_start ON bal_start.material_id = m.id
	
	--Приход, расход
	LEFT JOIN (
		SELECT
			ra.material_id,
			-- приход
			sum(
				CASE
					WHEN ra.deb AND ra.doc_type='material_fact_balance_correction' THEN 0
					WHEN ra.deb THEN ra.quant
					ELSE 0
				END
			) AS quant_deb,
			sum(
				CASE
					WHEN ra.deb AND ra.doc_type='material_fact_balance_correction' THEN ra.quant
					ELSE 0
				END
			) AS quant_deb_correction,
			
			-- расход
			sum(
				CASE
					WHEN ra.deb = FALSE AND ra.doc_type='material_fact_balance_correction' THEN 0
					WHEN ra.deb = FALSE THEN ra.quant
					ELSE 0
				END
			) AS quant_kred,
			sum(
				CASE
					-- OR ra.doc_type='material_fact_consumption_correction'
					WHEN ra.deb = FALSE AND doc_type='material_fact_balance_correction' THEN ra.quant
					ELSE 0
				END
			) AS quant_kred_correction,
			sum(
				CASE
					WHEN (ra.deb = FALSE AND ra.doc_type='material_fact_consumption' AND cons.production_site_id = (SELECT pst.id FROM prod_site1 AS pst))
						OR
						(ra.deb = FALSE AND ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id = (SELECT pst.id FROM prod_site1 AS pst))
						THEN ra.quant
					ELSE 0
				END
			) AS pr1_quant_kred
			
		FROM ra_material_facts AS ra
		LEFT JOIN material_fact_consumptions AS cons ON ra.doc_type='material_fact_consumption' AND ra.doc_id=cons.id
		LEFT JOIN material_fact_consumption_corrections AS cons_cor ON ra.doc_type='material_fact_consumption_correction' AND ra.doc_id=cons_cor.id		
		WHERE ra.date_time BETWEEN (SELECT d FROM date_time_from) AND (SELECT d FROM date_time_to)
			AND ra.production_base_id = (SELECT prod_base.id FROM prod_base)
		GROUP BY ra.material_id
	) AS ra ON ra.material_id = m.id 
	
	WHERE concrete_part AND NOT is_cement AND NOT coalesce(dif_store,FALSE)
	ORDER BY ord
	)
	
	UNION ALL
	
	--По материалам с местами хранения
	(
	SELECT
		FALSE AS is_cement,
		mt.name||', '||coalesce(st_map.store, '') AS name,
		coalesce(sub.bal_start, 0) AS quant_start,
		coalesce(sub.quant_deb, 0) AS quant_deb,
		coalesce(sub.quant_kred, 0) AS quant_kred,
		coalesce(sub.pr1_quant_kred, 0) AS pr1_quant_kred,
		coalesce(sub.quant_deb_correction, 0) - coalesce(sub.quant_kred_correction, 0) AS quant_correction,
		coalesce(sub.bal_start, 0) + coalesce(sub.quant_deb, 0) + coalesce(sub.quant_deb_correction, 0) - coalesce(sub.quant_kred, 0) - coalesce(sub.quant_kred_correction,0) AS quant_end
	
	FROM mat_with_stores AS mt
	
	-- Остаток + приход, расход по материалам и силосам
	LEFT JOIN (
		SELECT
			sub.production_site_id,
			sub.material_id,		
			sum(coalesce(sub.bal_start, 0)) AS bal_start,
			sum(coalesce(sub.quant_deb, 0)) AS quant_deb,
			sum(coalesce(sub.quant_deb_correction, 0)) AS quant_deb_correction,
			sum(coalesce(sub.quant_kred, 0)) AS quant_kred,
			sum(coalesce(sub.quant_kred_correction, 0)) AS quant_kred_correction,
			sum(coalesce(sub.pr1_quant_kred, 0)) AS pr1_quant_kred
		FROM (
			--остаток нач		
			(SELECT
			 	t_rg.production_site_id,
				t_rg.material_id,				
				coalesce(t_rg.quant, 0) AS bal_start,
				0 AS quant_deb,
				0 AS quant_deb_correction,
				0 AS quant_kred,
				0 AS quant_kred_correction,
				0 AS pr1_quant_kred
			FROM rg_material_facts_balance(
				(SELECT d FROM date_time_from),
				(SELECT array_agg(prod_base.id) FROM prod_base),
				'{}',
				(SELECT array_agg(mt.id) FROM mat_with_stores AS mt)
			) AS t_rg)
			UNION ALL
			--приход, расход
			(
				SELECT
					ra.production_site_id,
					ra.material_id,
					0 AS bal_start,
					--приход
					sum(
						CASE
							WHEN ra.deb AND ra.doc_type='material_fact_balance_correction' THEN 0
							WHEN ra.deb THEN ra.quant
							ELSE 0
						END
					) AS quant_deb,
					sum(
						CASE
							WHEN ra.deb AND ra.doc_type='material_fact_balance_correction' THEN ra.quant
							ELSE 0
						END
					) AS quant_deb_correction,

					--расход
					sum(
						CASE
							WHEN ra.deb = FALSE AND  ra.doc_type='material_fact_balance_correction' THEN 0
							WHEN ra.deb = FALSE THEN ra.quant
							ELSE 0
						END
					) AS quant_kred,
					sum(
						CASE
							-- OR ra.doc_type='material_fact_consumption_correction'
							WHEN ra.deb = FALSE AND doc_type='material_fact_balance_correction' THEN ra.quant
							ELSE 0
						END
					) AS quant_kred_correction,
					sum(
						CASE
							WHEN (ra.deb = FALSE AND ra.doc_type='material_fact_consumption' AND cons.production_site_id = (SELECT pst.id FROM prod_site1 AS pst))
								OR
								(ra.deb = FALSE AND ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id = (SELECT pst.id FROM prod_site1 AS pst))
								THEN ra.quant
							ELSE 0
						END
					) AS pr1_quant_kred

				FROM ra_material_facts AS ra
				LEFT JOIN material_fact_consumptions AS cons ON ra.doc_type='material_fact_consumption' AND ra.doc_id=cons.id
				LEFT JOIN material_fact_consumption_corrections AS cons_cor ON ra.doc_type='material_fact_consumption_correction' AND ra.doc_id=cons_cor.id		
				WHERE ra.date_time BETWEEN (SELECT d FROM date_time_from) AND (SELECT d FROM date_time_to)
					AND ra.production_base_id = (SELECT prod_base.id FROM prod_base)
					AND ra.material_id IN (SELECT mt.id FROM mat_with_stores AS mt)
				GROUP BY ra.production_site_id,ra.material_id
			)			
		) AS sub
		GROUP BY sub.production_site_id, sub.material_id		
	) AS sub ON sub.material_id = mt.id
	LEFT JOIN store_map_to_production_sites AS st_map ON st_map.production_site_id = sub.production_site_id		
	)
	;
$BODY$;

ALTER FUNCTION public.material_actions_prod_base2(timestamp without time zone, timestamp without time zone)
    OWNER TO ;

