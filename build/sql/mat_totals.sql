-- FUNCTION: public.mat_totals(in_d date, in_production_base_id int)

 DROP FUNCTION public.mat_totals(in_d date, in_production_base_id int);

CREATE OR REPLACE FUNCTION public.mat_totals(in_d date, in_production_base_id int)
    RETURNS TABLE(
    	material_descr text,
    	--material_id int,
    	quant_ordered numeric,
    	quant_procured numeric,
    	quant_balance numeric,
    	quant_fact_balance numeric,
    	quant_morn_balance numeric,
    	quant_morn_next_balance numeric,
    	quant_morn_cur_balance numeric,
    	quant_morn_fact_cur_balance numeric,
    	balance_corrected_data json
    ) 
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
WITH
	--filter
	prod_base_sites AS (SELECT p_st.id FROM production_sites AS p_st WHERE p_st.production_base_id = in_production_base_id)
	
	,shift_time_from AS (SELECT in_d + const_first_shift_start_time_val() AS v)

	,shift_time_to AS (SELECT get_shift_end(shift_time_from.v) AS v FROM shift_time_from)
	SELECT
		sub.material_descr,
		sum(sub.quant_ordered) AS quant_ordered,
		sum(sub.quant_procured) AS quant_procured,
		sum(sub.quant_balance) AS quant_balance,
		sum(sub.quant_fact_balance) AS quant_fact_balance,
		sum(sub.quant_morn_balance) AS quant_morn_balance,
		sum(sub.quant_morn_next_balance) AS quant_morn_next_balance,
		sum(sub.quant_morn_cur_balance) AS quant_morn_cur_balance,
		sum(sub.quant_morn_fact_cur_balance) AS quant_morn_fact_cur_balance,
		(sub.balance_corrected_data::text)::json AS balance_corrected_data
	FROM (
	
		SELECT			
			m.name::text AS material_descr,
			--m.id AS material_id,
			m.ord AS material_ord,
			
			--заявки поставщикам на сегодня
			0::numeric AS quant_ordered,
			
			--Поставки
			COALESCE(proc.quant, 0)::numeric AS quant_procured,
			
			--остатки
			COALESCE(bal.quant, 0)::numeric AS quant_balance,
			
			COALESCE(bal_fact.quant, 0)::numeric AS quant_fact_balance,
			
			--остатки на завтра на утро
			-- начиная с 12/08/20 без прогноза будующего прихода, просто тек.остаток-расход по подборам от тек.времени до конца смены
			--COALESCE(plan_proc.quant,0)::numeric AS quant_morn_balance,
			--COALESCE(plan_proc.quant,0)::numeric AS quant_morn_next_balance,
			COALESCE(bal_fact.quant, 0) - COALESCE(mat_virt_cons.quant,0) AS quant_morn_balance,
			COALESCE(bal_fact.quant, 0) - COALESCE(mat_virt_cons.quant,0) AS quant_morn_next_balance,
			
			COALESCE(bal_morn.quant, 0)::numeric AS quant_morn_cur_balance,
			
			COALESCE(bal_morn_fact.quant, 0)::numeric AS quant_morn_fact_cur_balance,
			
			--Корректировки
			(SELECT
				json_agg(
					json_build_object(
						'date_time',cr.date_time,
						'balance_date_time',cr.balance_date_time,
						'users_ref',users_ref(cr_u),
						'materials_ref',materials_ref(m),
						'required_balance_quant',cr.required_balance_quant,
						'comment_text',cr.comment_text
					)
				)
			FROM material_fact_balance_corrections AS cr
			LEFT JOIN users AS cr_u ON cr_u.id=cr.user_id	
			WHERE
				cr.material_id = m.id
				AND cr.balance_date_time=(SELECT shift_time_from.v FROM shift_time_from)
				AND cr.production_site_id IN (SELECT pr_sites.id FROM prod_base_sites AS pr_sites)
			) AS balance_corrected_data
			
		FROM raw_materials AS m

		LEFT JOIN (
			SELECT *
			FROM rg_materials_balance((SELECT shift_time_from.v FROM shift_time_from)-'1 second'::interval, ARRAY[in_production_base_id], '{}'::int[])
		) AS bal_morn ON bal_morn.material_id=m.id
		
		LEFT JOIN (
			SELECT * FROM rg_material_facts_balance((SELECT shift_time_from.v FROM shift_time_from), ARRAY[in_production_base_id], '{}'::int[], '{}'::int[])
		) AS bal_morn_fact ON bal_morn_fact.material_id=m.id

		
		LEFT JOIN (
			SELECT *
			FROM rg_materials_balance(ARRAY[in_production_base_id], '{}'::int[])
		) AS bal ON bal.material_id=m.id
		LEFT JOIN (
			SELECT
				material_id,
				sum(quant) AS quant
			FROM rg_material_facts_balance(ARRAY[in_production_base_id], '{}'::int[], '{}'::int[])
			GROUP BY material_id		
		) AS bal_fact ON bal_fact.material_id=m.id
		
		LEFT JOIN (
			SELECT
				ra.material_id,
				sum(ra.quant) AS quant
			FROM ra_materials ra
			WHERE ra.date_time BETWEEN (SELECT shift_time_from.v FROM shift_time_from) AND (SELECT shift_time_to.v FROM shift_time_to)
				AND ra.deb
				AND ra.doc_type='material_procurement'
				AND ra.production_base_id = in_production_base_id
			GROUP BY ra.material_id
		) AS proc ON proc.material_id=m.id
		
		/*
		LEFT JOIN (
			SELECT
				plan_proc.material_id,
				plan_proc.balance_start AS quant
			FROM mat_plan_procur(
				get_shift_end((get_shift_end(get_shift_start(now()::timestamp))+'1 second')),
				now()::timestamp,
				now()::timestamp,
				NULL
			) AS plan_proc
		) AS plan_proc ON plan_proc.material_id=m.id
		*/
		
		/*
		LEFT JOIN (
			SELECT
				so.material_id,
				SUM(so.quant) AS quant
			FROM supplier_orders AS so
			WHERE so.date = in_d
			GROUP BY so.material_id
		) AS sup_ord ON sup_ord.material_id=m.id
		*/
		
		LEFT JOIN (
			SELECT *
			FROM mat_virtual_consumption(
				(SELECT shift_time_from.v FROM shift_time_from)
				,(SELECT shift_time_to.v FROM shift_time_to)
			)
		) AS mat_virt_cons ON mat_virt_cons.material_id = m.id
		
		WHERE m.concrete_part
		--ORDER BY m.ord
	) AS sub
	GROUP BY
		sub.material_ord,
		sub.material_descr,
		sub.balance_corrected_data::text
	ORDER BY sub.material_ord
;
$BODY$;

-- ALTER FUNCTION public.mat_totals(in_d date, in_production_base_id int)
--     OWNER TO beton;
--
-- GRANT EXECUTE ON FUNCTION public.mat_totals(in_d date, in_production_base_id int) TO beton;
--
-- GRANT EXECUTE ON FUNCTION public.mat_totals(in_d date, in_production_base_id int) TO PUBLIC;


