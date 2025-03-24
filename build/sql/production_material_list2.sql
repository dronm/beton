-- VIEW: production_material_list

--DROP VIEW material_cons_tolerance_violation_list;
--DROP VIEW production_material_list;

CREATE OR REPLACE VIEW production_material_list AS
	SELECT
		prod.production_dt_start AS date_time,
		prod.production_site_id,
		production_sites_ref(ps) AS production_sites_ref,
		prod.production_id,
		mat.id AS material_id,
		materials_ref(mat) AS materials_ref,
		cement_silos_ref(cem) AS cement_silos_ref,
		t.cement_silo_id,
		sum(coalesce(t.material_quant, 0)) AS material_quant,
		sum(coalesce(t.material_quant,0)) + coalesce(t_cor.quant,0) AS quant_fact,
		sum(coalesce(t.material_quant_req,0)) AS quant_fact_req,
		
		--Подбор
		CASE WHEN coalesce(sh.quant,0)=0 OR (coalesce(t.concrete_quant,0)=0 AND coalesce(o.quant,0)=0) THEN 0
		ELSE coalesce(ra_mat.quant,0)/coalesce(sh.quant,0) * coalesce(t.concrete_quant, o.quant)
		END AS quant_consuption,
		
		coalesce(t_cor.quant,0) AS quant_corrected,

		t_cor.elkon_id AS elkon_correction_id,
		users_ref(cor_u) AS correction_users_ref,
		t_cor.date_time_set correction_date_time_set,

		--(Факт + исправление) - подбор, если есть одинаковые материалы - складываем вместе!
		CASE
			WHEN (SELECT count(*)
				FROM material_fact_consumptions AS t_rolled
				WHERE t_rolled.production_site_id=prod.production_site_id
					AND t_rolled.production_id=prod.production_id
					AND t_rolled.raw_material_id=t.raw_material_id
			)>=2 THEN
				coalesce((SELECT sum(t_rolled.material_quant)
				FROM material_fact_consumptions AS t_rolled
				WHERE t_rolled.production_site_id=prod.production_site_id
					AND t_rolled.production_id=prod.production_id
					AND t_rolled.raw_material_id=t.raw_material_id
				),0) + 
				coalesce((SELECT sum(cor_rolled.quant)
				FROM material_fact_consumption_corrections AS cor_rolled
				WHERE cor_rolled.production_site_id=prod.production_site_id
					AND cor_rolled.production_id=prod.production_id
					AND cor_rolled.material_id=t.raw_material_id
				),0)			
				
			ELSE (sum(coalesce(t.material_quant,0)) + coalesce(t_cor.quant,0))
		END
		-
		CASE WHEN coalesce(sh.quant,0)=0 OR (coalesce(t.concrete_quant,0)=0 AND coalesce(o.quant,0)=0) THEN 0
		ELSE coalesce(ra_mat.quant,0)/coalesce(sh.quant,0) * coalesce(t.concrete_quant, o.quant)
		END 
		AS quant_dif
	
		,CASE
			WHEN mat.id IS NULL THEN FALSE
			WHEN t.raw_material_id IS NULL AND coalesce(ra_mat.quant,0) = 0 THEN FALSE --no fact, and no norm(quant=0)
			WHEN t.raw_material_id IS NULL THEN TRUE --no fact
			WHEN coalesce(ra_mat.quant,0) = 0 OR coalesce(sh.quant,0)=0 OR (coalesce(t.concrete_quant,0)=0 AND coalesce(o.quant,0)=0) THEN TRUE
			ELSE
				coalesce(
				( abs(
					coalesce(ra_mat.quant,0)/coalesce(sh.quant,0) * coalesce(t.concrete_quant,0)
					-
					-- - (sum(t.material_quant) + coalesce(t_cor.quant,0))
					CASE
						WHEN (SELECT count(*)
							FROM material_fact_consumptions AS t_rolled
							WHERE t_rolled.production_site_id=prod.production_site_id
								AND t_rolled.production_id=prod.production_id
								AND t_rolled.raw_material_id=t.raw_material_id
						)>=2 THEN
							coalesce((SELECT sum(t_rolled.material_quant)
							FROM material_fact_consumptions AS t_rolled
							WHERE t_rolled.production_site_id=prod.production_site_id
								AND t_rolled.production_id=prod.production_id
								AND t_rolled.raw_material_id=t.raw_material_id
							),0) + 
							coalesce((SELECT sum(cor_rolled.quant)
							FROM material_fact_consumption_corrections AS cor_rolled
							WHERE cor_rolled.production_site_id=prod.production_site_id
								AND cor_rolled.production_id=prod.production_id
								AND cor_rolled.material_id=t.raw_material_id
							),0)			
				
						ELSE (sum(t.material_quant) + coalesce(t_cor.quant,0))
					END
					
				) * 100 /coalesce(ra_mat.quant,0)/coalesce(sh.quant,0) * coalesce(t.concrete_quant,o.quant,0)
					 	>= mat.max_fact_quant_tolerance_percent
				)
			,FALSE)
		END AS dif_violation
	
		,mat.max_fact_quant_tolerance_percent
		,row_to_json(pr_com.*) AS production_comment
		,mat.ord AS material_ord
		
		--required quant
		--(Факт + исправление) - подбор, если есть одинаковые материалы - складываем вместе!
		/*,CASE
			WHEN (SELECT count(*)
				FROM material_fact_consumptions AS t_rolled
				WHERE t_rolled.production_site_id=prod.production_site_id
					AND t_rolled.production_id=prod.production_id
					AND t_rolled.raw_material_id=t.raw_material_id
			)>=2 THEN
				coalesce((SELECT sum(t_rolled.material_quant)
				FROM material_fact_consumptions AS t_rolled
				WHERE t_rolled.production_site_id=prod.production_site_id
					AND t_rolled.production_id=prod.production_id
					AND t_rolled.raw_material_id=t.raw_material_id
				),0) + 
				coalesce((SELECT sum(cor_rolled.quant)
				FROM material_fact_consumption_corrections AS cor_rolled
				WHERE cor_rolled.production_site_id=prod.production_site_id
					AND cor_rolled.production_id=prod.production_id
					AND cor_rolled.material_id=t.raw_material_id
				),0)			
				
			ELSE (sum(coalesce(t.material_quant,0)) + coalesce(t_cor.quant,0))
		END - sum(coalesce(t.material_quant_req,0)) */
		,(sum(coalesce(t.material_quant,0)) + coalesce(t_cor.quant,0)) - sum(coalesce(t.material_quant_req,0)) AS quant_req_dif
		
		,CASE
			WHEN mat.id IS NULL THEN FALSE
			WHEN t.raw_material_id IS NULL AND coalesce(ra_mat.quant,0) = 0 THEN FALSE --no fact, and no norm(quant=0)
			WHEN t.raw_material_id IS NULL THEN TRUE --no fact, norm exists
			WHEN coalesce(ra_mat.quant,0) = 0 OR coalesce(sh.quant,0)=0 OR (coalesce(t.concrete_quant,0)=0 AND coalesce(o.quant,0)=0) THEN TRUE
			ELSE
				coalesce(
				( abs(
					sum(t.material_quant_req)
					-
					--(sum(t.material_quant_req) + coalesce(t_cor.quant,0))
					CASE
						WHEN (SELECT count(*)
							FROM material_fact_consumptions AS t_rolled
							WHERE t_rolled.production_site_id=prod.production_site_id
								AND t_rolled.production_id=prod.production_id
								AND t_rolled.raw_material_id=t.raw_material_id
						)>=2 THEN
							coalesce((SELECT sum(t_rolled.material_quant)
							FROM material_fact_consumptions AS t_rolled
							WHERE t_rolled.production_site_id=prod.production_site_id
								AND t_rolled.production_id=prod.production_id
								AND t_rolled.raw_material_id=t.raw_material_id
							),0) + 
							coalesce((SELECT sum(cor_rolled.quant)
							FROM material_fact_consumption_corrections AS cor_rolled
							WHERE cor_rolled.production_site_id=prod.production_site_id
								AND cor_rolled.production_id=prod.production_id
								AND cor_rolled.material_id=t.raw_material_id
							),0)			
				
						ELSE (sum(t.material_quant_req) + coalesce(t_cor.quant,0))
					END
					
				) * 100 /coalesce(ra_mat.quant,0)/coalesce(sh.quant,0) * coalesce(t.concrete_quant,0)
					 	>= mat.max_fact_quant_tolerance_percent
				)
			,FALSE)
		END AS req_dif_violation


	FROM shipments AS sh
	LEFT JOIN productions AS prod ON prod.shipment_id=sh.id
	LEFT JOIN ra_materials AS ra_mat ON ra_mat.doc_type='shipment' AND ra_mat.doc_id=sh.id
	FULL OUTER JOIN material_fact_consumptions AS t ON
		prod.production_site_id = t.production_site_id
		AND prod.production_id=t.production_id
		AND t.raw_material_id=ra_mat.material_id
	LEFT JOIN production_sites AS ps ON ps.id=t.production_site_id
	LEFT JOIN raw_materials AS mat ON mat.id=coalesce(ra_mat.material_id, t.raw_material_id)
	LEFT JOIN cement_silos AS cem ON cem.id=t.cement_silo_id
	LEFT JOIN material_fact_consumption_corrections AS t_cor ON t_cor.production_site_id=t.production_site_id AND t_cor.production_id=t.production_id
			AND t_cor.material_id=t.raw_material_id AND (t_cor.cement_silo_id IS NULL OR t_cor.cement_silo_id=t.cement_silo_id)
	LEFT JOIN users AS cor_u ON cor_u.id=t_cor.user_id
	LEFT JOIN production_comments AS pr_com
		ON pr_com.production_site_id=t.production_site_id AND pr_com.production_id=t.production_id AND pr_com.material_id=t.raw_material_id
	LEFT JOIN orders AS o ON o.id = sh.order_id
	
	GROUP BY
		prod.production_dt_start,
		prod.production_site_id,prod.production_id,t.raw_material_id,mat.max_fact_quant_tolerance_percent,
		mat.ord,ra_mat.quant,t.raw_material_id,mat.id,t.cement_silo_id,
		ps.*,mat.*,cem.*,
		t_cor.elkon_id,cor_u.*,t_cor.date_time_set,t_cor.quant,sh.quant,t.concrete_quant, o.quant
		,pr_com.*
	ORDER BY prod.production_site_id,
		prod.production_id,
		mat.ord
			
	;
	

