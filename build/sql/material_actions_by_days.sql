--http://localhost/beton_new/?c=RawMaterial_Controller&f=get_material_actions_by_shift_list&v=ViewHTMLXSL&cond_fields=date_time,date_time,material_id&cond_sgns=ge,le,e&cond_vals=2023-10-01T06:00:00,2023-10-04T05:59:59,79&templ=RepMaterialActionByShift
--select * from raw_materials where name like '%Цемент%'
			WITH
				rep_period AS (SELECT
							   get_shift_start('2023-10-01T06:00:00')::timestamp without time zone AS d1,
							   '2023-10-15T06:00:00'::timestamp without time zone AS d2
				),
				mat AS (SELECT 5 AS id),
				cement AS (SELECT is_cement FROM raw_materials WHERE id=(SELECT id FROM mat)),
				rest_beg AS (
						SELECT quant
						FROM rg_material_facts_balance(			
							(SELECT d1 FROM rep_period),
							ARRAY[(SELECT id FROM mat)]
						)
				),
				rest_end AS (
						SELECT quant
						FROM rg_material_facts_balance(			
							(SELECT d2 FROM rep_period),
							ARRAY[(SELECT id FROM mat)]
						)
				),
				prod_site1 AS (SELECT 1 AS id),
				prod_site2 AS (SELECT 2 AS id),
				prod_site3 AS (SELECT 4 AS id),
				prod_site4 AS (SELECT 5 AS id),
				prod_site5 AS (SELECT 6 AS id)
				
				SELECT
					sub.day,
					LAG(quant_running_bal, 1, sub.quant_period_beg) OVER( ORDER BY sub.shift) AS quant_running_bal_beg,					
					sub.quant_deb,
					sub.quant_kred_pr1,
					sub.quant_kred_pr2,
					sub.quant_kred_pr3,
					sub.quant_kred_pr4,
					sub.quant_kred_pr5,
					sub.quant_kred_pr,
					sub.quant_correct,										
					sub.quant_kred,
					sub.quant_running_bal AS quant_running_bal_end,
					
					--just for teting
					sub.quant_bal_day,
					sub.quant_period_beg,
					sub.quant_period_end					
				FROM (
					SELECT
						shift,
						to_char(shift::date, 'DD.MM.YY') AS day,
						(SELECT quant FROM rest_beg) AS quant_period_beg,
						(SELECT quant FROM rest_end) AS quant_period_end,
						
						-- total debet
						coalesce(deb.quant_deb, 0) AS quant_deb,
						
						-- kredit by pro sites
						coalesce(deb.quant_kred_pr1, 0) AS quant_kred_pr1,
						coalesce(deb.quant_kred_pr2, 0) AS quant_kred_pr2,
						coalesce(deb.quant_kred_pr3, 0) AS quant_kred_pr3,
						coalesce(deb.quant_kred_pr4, 0) AS quant_kred_pr4,
						coalesce(deb.quant_kred_pr5, 0) AS quant_kred_pr5,
						
						-- total kredit by prod sites
						coalesce(deb.quant_kred_pr1, 0) + coalesce(deb.quant_kred_pr2, 0) + coalesce(deb.quant_kred_pr3, 0) +
							coalesce(deb.quant_kred_pr4, 0) + coalesce(deb.quant_kred_pr5, 0)
						AS quant_kred_pr,
							
						-- kredit correct
						coalesce(deb.quant_correct, 0) AS quant_correct,
						
						-- total kredit = prod kredit + correct kredit
						coalesce(deb.quant_kred_pr1, 0) + coalesce(deb.quant_kred_pr2, 0) + coalesce(deb.quant_kred_pr3, 0) +
							coalesce(deb.quant_kred_pr4, 0) + coalesce(deb.quant_kred_pr5, 0) -
							coalesce(deb.quant_correct, 0)
						AS quant_kred,
						
						-- day balance = total debet - total kredit	
						coalesce(deb.quant_deb, 0) - 
							(coalesce(deb.quant_kred_pr1, 0) + coalesce(deb.quant_kred_pr2, 0) + coalesce(deb.quant_kred_pr3, 0) +
								coalesce(deb.quant_kred_pr4, 0) + coalesce(deb.quant_kred_pr5, 0) - coalesce(deb.quant_correct, 0)
							)
						AS quant_bal_day,
						 
						-- running balance = balance start + sum(total debet) - sum(total kredit)
						(SELECT quant FROM rest_beg) +
							sum(coalesce(deb.quant_deb, 0)
							- (
								coalesce(deb.quant_kred_pr1, 0) + coalesce(deb.quant_kred_pr2, 0) + coalesce(deb.quant_kred_pr3, 0) +
								coalesce(deb.quant_kred_pr4, 0) + coalesce(deb.quant_kred_pr5, 0) -
								coalesce(deb.quant_correct, 0)
							  )
							)
						OVER (ORDER BY shift)
						AS quant_running_bal
						
					FROM	
						generate_series(
							(SELECT d1 FROM rep_period),
							(SELECT d2 FROM rep_period),
							'1 day'
						) AS shift
					LEFT JOIN (
						(SELECT
							get_shift_start(ra.date_time) AS d,
						
							-- total prih, no correction
							sum(CASE
								WHEN ra.deb AND ra.doc_type='material_fact_balance_correction' THEN 0
								WHEN ra.deb THEN ra.quant
								ELSE 0
							END) AS quant_deb,
							
							--rash pr1
							sum(CASE
								WHEN ra.deb = FALSE
									AND cons.production_site_id = (SELECT pst.id FROM prod_site1 AS pst)
									AND ra.doc_type='material_fact_consumption'
									THEN ra.quant
								WHEN ra.deb = FALSE
									AND cons_cor.production_site_id = (SELECT pst.id FROM prod_site1 AS pst)
									AND ra.doc_type='material_fact_consumption_correction'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr1,

							--rash pr2
							sum(CASE
								WHEN ra.deb = FALSE
									AND cons.production_site_id = (SELECT pst.id FROM prod_site2 AS pst)
									AND ra.doc_type='material_fact_consumption'
									THEN ra.quant
								WHEN ra.deb = FALSE
									AND cons_cor.production_site_id = (SELECT pst.id FROM prod_site2 AS pst)
									AND ra.doc_type='material_fact_consumption_correction'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr2,

							--rash pr3
							sum(CASE
								WHEN ra.deb = FALSE
									AND cons.production_site_id = (SELECT pst.id FROM prod_site3 AS pst)
									AND ra.doc_type='material_fact_consumption'
									THEN ra.quant
								WHEN ra.deb = FALSE
									AND cons_cor.production_site_id = (SELECT pst.id FROM prod_site3 AS pst)
									AND ra.doc_type='material_fact_consumption_correction'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr3,

							--rash pr4
							sum(CASE
								WHEN ra.deb = FALSE
									AND cons.production_site_id = (SELECT pst.id FROM prod_site4 AS pst)
									AND ra.doc_type='material_fact_consumption'
									THEN ra.quant
								WHEN ra.deb = FALSE
									AND cons_cor.production_site_id = (SELECT pst.id FROM prod_site4 AS pst)
									AND ra.doc_type='material_fact_consumption_correction'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr4,

							--rash pr5
							sum(CASE
								WHEN ra.deb = FALSE
									AND cons.production_site_id = (SELECT pst.id FROM prod_site5 AS pst)
									AND ra.doc_type='material_fact_consumption'
									THEN ra.quant
								WHEN ra.deb = FALSE
									AND cons_cor.production_site_id = (SELECT pst.id FROM prod_site5 AS pst)
									AND ra.doc_type='material_fact_consumption_correction'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr5,

							--total correct +/-
							sum(CASE
								WHEN ra.deb = TRUE AND ra.doc_type='material_fact_balance_correction'
									THEN ra.quant
								WHEN ra.deb = FALSE AND ra.doc_type='material_fact_balance_correction'
									THEN ra.quant * -1
								ELSE 0
							END) AS quant_correct
						
						FROM ra_material_facts AS ra
						LEFT JOIN material_fact_consumptions AS cons ON ra.doc_type='material_fact_consumption' AND ra.doc_id=cons.id
						LEFT JOIN material_fact_consumption_corrections AS cons_cor ON ra.doc_type='material_fact_consumption_correction' AND ra.doc_id=cons_cor.id
						LEFT JOIN raw_materials AS mt ON mt.id = ra.material_id
						WHERE
							ra.material_id = (SELECT id FROM mat)
							AND (SELECT is_cement FROM cement) = FALSE
							AND ra.date_time BETWEEN (SELECT d1 FROM rep_period) AND (SELECT d2 FROM rep_period)
						GROUP BY
							get_shift_start(ra.date_time)
						)
						
						UNION ALL
						--cement
						(SELECT
							get_shift_start(ra.date_time) AS d,
						
							-- total prih, no correction
							sum(CASE
								WHEN ra.deb AND ra.doc_type='cement_silo_balance_reset' THEN 0
								WHEN ra.deb THEN ra.quant
								ELSE 0
							END) AS quant_deb,
							
							--rash pr1
							sum(CASE
								WHEN ra.deb = FALSE
									AND sl.production_site_id = (SELECT pst.id FROM prod_site1 AS pst)
									AND ra.doc_type<>'cement_silo_balance_reset'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr1,

							--rash pr2
							sum(CASE
								WHEN ra.deb = FALSE
									AND sl.production_site_id = (SELECT pst.id FROM prod_site2 AS pst)
									AND ra.doc_type<>'cement_silo_balance_reset'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr2,

							--rash pr3
							sum(CASE
								WHEN ra.deb = FALSE
									AND sl.production_site_id = (SELECT pst.id FROM prod_site3 AS pst)
									AND ra.doc_type<>'cement_silo_balance_reset'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr3,

							--rash pr4
							sum(CASE
								WHEN ra.deb = FALSE
									AND sl.production_site_id = (SELECT pst.id FROM prod_site4 AS pst)
									AND ra.doc_type<>'cement_silo_balance_reset'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr4,

							--rash pr5
							sum(CASE
								WHEN ra.deb = FALSE
									AND sl.production_site_id = (SELECT pst.id FROM prod_site5 AS pst)
									AND ra.doc_type<>'cement_silo_balance_reset'
									THEN ra.quant
								ELSE 0
							END) AS quant_kred_pr5,

							--total correct +/-
							sum(CASE
								WHEN ra.deb = TRUE AND ra.doc_type='cement_silo_balance_reset'
									THEN ra.quant
								WHEN ra.deb = FALSE AND ra.doc_type='cement_silo_balance_reset'
									THEN ra.quant * -1
								ELSE 0
							END) AS quant_correct
						
						FROM ra_cement AS ra
						LEFT JOIN cement_silos AS sl ON sl.id = ra.cement_silos_id
						WHERE
							(SELECT is_cement FROM cement)
							AND ra.date_time BETWEEN (SELECT d1 FROM rep_period) AND (SELECT d2 FROM rep_period)
						GROUP BY
							get_shift_start(ra.date_time)
						)
						
						
					) AS deb ON deb.d = shift
				) AS sub

