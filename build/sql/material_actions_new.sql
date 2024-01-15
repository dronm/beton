-- Function: material_actions(in_date_time_from timestamp without time zone,in_date_time_to timestamp without time zone)

-- DROP FUNCTION material_actions(in_date_time_from timestamp without time zone,in_date_time_to timestamp without time zone);
-- DROP FUNCTION material_actions3(in_date_time_from timestamp without time zone,in_date_time_to timestamp without time zone); 

CREATE OR REPLACE FUNCTION material_actions(in_date_time_from timestamp without time zone,in_date_time_to timestamp without time zone)
  RETURNS TABLE(
  	is_cement bool,
  	material_name text,
  	quant_start numeric(19,4),
  	quant_deb numeric(19,4),
  	quant_kred numeric(19,4),
  	pr1_quant_kred numeric(19,4),
  	pr2_quant_kred numeric(19,4),
  	pr3_quant_kred numeric(19,4),
  	quant_correction numeric(19,4),
  	quant_end numeric(19,4)
  
  ) AS
$$
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
	
	--остаток нач
	LEFT JOIN (SELECT * FROM rg_cement_balance(in_date_time_from,'{}')) AS bal_start ON bal_start.cement_silos_id=sil.id
	
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
		LEFT JOIN cement_silos AS sl ON sl.id=ra.cement_silos_id
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND ra.deb
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
		LEFT JOIN cement_silos AS sl ON sl.id=ra.cement_silos_id
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND NOT ra.deb
		GROUP BY ra.cement_silos_id
	) AS ra_kred ON ra_kred.cement_silos_id = sil.id 
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
	LEFT JOIN (SELECT * FROM rg_material_facts_balance(in_date_time_from,'{}')) AS bal_start ON bal_start.material_id=m.id
	
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
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND ra.deb
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
		WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND NOT ra.deb
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
		coalesce(sub.quant_start,0) AS quant_start,
		coalesce(sub.quant_deb,0) AS quant_deb,
		coalesce(sub.quant_kred,0) AS quant_kred,
		coalesce(sub.pr1_quant_kred,0) AS pr1_quant_kred,
		coalesce(sub.pr2_quant_kred,0) AS pr2_quant_kred,
		coalesce(sub.pr3_quant_kred,0) AS pr3_quant_kred,
		coalesce(sub.quant_correction_deb,0)-coalesce(sub.quant_correction_kred,0) AS quant_correction,
		coalesce(sub.quant_start,0)+coalesce(sub.quant_deb,0)+coalesce(sub.quant_correction_deb,0)-coalesce(sub.quant_kred,0)-coalesce(sub.quant_correction_kred,0) AS quant_end	
	FROM (
		SELECT
			rg_ra.production_site_id,
			rg_ra.material_id,
			sum(rg_ra.quant_start) AS quant_start,
			sum(rg_ra.quant_deb) AS quant_deb,
			sum(rg_ra.quant_correction_deb) AS quant_correction_deb,
			sum(rg_ra.quant_kred) AS quant_kred,
			sum(rg_ra.quant_correction_kred) AS quant_correction_kred,
			sum(rg_ra.pr1_quant_kred) AS pr1_quant_kred,
			sum(rg_ra.pr2_quant_kred) AS pr2_quant_kred,
			sum(rg_ra.pr3_quant_kred) AS pr3_quant_kred
		FROM (
			--остаток нач
			(SELECT
				b.production_site_id,
				b.material_id,
				b.quant AS quant_start,
				0 AS quant_deb,
				0 AS quant_correction_deb,
				0 AS quant_kred,
				0 AS quant_correction_kred,
				0 AS pr1_quant_kred,
				0 AS pr2_quant_kred,
				0 AS pr3_quant_kred
			FROM rg_material_facts_balance(
				in_date_time_from,
				'{}',
				(SELECT array_agg(raw_m.id) FROM raw_materials AS raw_m WHERE raw_m.concrete_part AND NOT raw_m.is_cement AND coalesce(raw_m.dif_store,FALSE)=TRUE)
			) AS b)
			
			--Приход
			UNION ALL
			(
			SELECT
				ra.production_site_id,
				ra.material_id,
				0 AS quant_start,
				sum(
					CASE
						WHEN ra.doc_type='material_fact_balance_correction' THEN 0
						ELSE ra.quant
					END
				) AS quant_deb,
				sum(
					CASE
						WHEN ra.doc_type='material_fact_balance_correction' THEN ra.quant
						ELSE 0
					END
				) AS quant_correction_deb,
				0 AS quant_kred,
				0 AS quant_correction_kred,
				0 AS pr1_quant_kred,
				0 AS pr2_quant_kred,
				0 AS pr3_quant_kred
				
			FROM ra_material_facts AS ra
			WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND ra.deb
				AND ra.material_id IN (SELECT raw_m.id FROM raw_materials AS raw_m WHERE raw_m.concrete_part AND NOT raw_m.is_cement AND coalesce(raw_m.dif_store,FALSE)=TRUE)
			GROUP BY ra.production_site_id,ra.material_id
			)
			
			--Расход
			UNION ALL
			(
			SELECT
				ra.production_site_id,
				ra.material_id,
				0 AS quant_start,
				0 AS quant_deb,
				0 AS quant_correction_deb,
				sum(
					CASE
						WHEN ra.doc_type='material_fact_balance_correction' THEN 0
						ELSE ra.quant
					END
				) AS quant_kred,
				sum(
					CASE
						-- OR ra.doc_type='material_fact_consumption_correction'
						WHEN doc_type='material_fact_balance_correction' THEN ra.quant
						ELSE 0
					END
				) AS quant_correction_kred,
				sum(
					CASE
						WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id=1)
							OR
							(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id=1)
							THEN ra.quant
						ELSE 0
					END
				) AS pr1_quant_kred,
				sum(
					CASE
						WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id=2)
							OR
							(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id=2)
							THEN ra.quant
						ELSE 0
					END
				) AS pr2_quant_kred,
				sum(
					CASE
						WHEN (ra.doc_type='material_fact_consumption' AND cons.production_site_id=4)
							OR
							(ra.doc_type='material_fact_consumption_correction' AND cons_cor.production_site_id=4)
							THEN ra.quant
						ELSE 0
					END
				) AS pr3_quant_kred
				
			FROM ra_material_facts AS ra
			LEFT JOIN material_fact_consumptions AS cons ON ra.doc_type='material_fact_consumption' AND ra.doc_id=cons.id
			LEFT JOIN material_fact_consumption_corrections AS cons_cor ON ra.doc_type='material_fact_consumption_correction' AND ra.doc_id=cons_cor.id
			WHERE ra.date_time BETWEEN in_date_time_from AND in_date_time_to AND NOT ra.deb
				AND ra.material_id IN (SELECT raw_m.id FROM raw_materials AS raw_m WHERE raw_m.concrete_part AND NOT raw_m.is_cement AND coalesce(raw_m.dif_store,FALSE)=TRUE)
			GROUP BY ra.production_site_id,ra.material_id
			
			)
		) AS rg_ra
		GROUP BY rg_ra.production_site_id, rg_ra.material_id
	
	) AS sub
	LEFT JOIN raw_materials AS m ON m.id = sub.material_id
	LEFT JOIN store_map_to_production_sites AS st_map ON st_map.production_site_id = sub.production_site_id
	ORDER BY m.ord
	)
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION material_actions(in_date_time_from timestamp without time zone,in_date_time_to timestamp without time zone) OWNER TO ;
