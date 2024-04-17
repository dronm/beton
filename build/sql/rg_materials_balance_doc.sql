-- FUNCTION: public.rg_materials_balance(doc_types, integer, integer[])

-- DROP FUNCTION public.rg_materials_balance(doc_types, integer, integer[], integer[]);

CREATE OR REPLACE FUNCTION public.rg_materials_balance(
	in_doc_type doc_types,
	in_doc_id integer,
	in_production_base_id_ar integer[],
	in_material_id_ar integer[]
	)
    RETURNS TABLE(
    	production_base_id integer
    	,material_id integer
    	, quant numeric
    ) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE STRICT 
    ROWS 1000
AS $BODY$
DECLARE
	v_doc_date_time timestamp without time zone;
	v_doc_id int;
	v_cur_per timestamp;
	v_act_direct boolean;
	v_act_direct_sgn int;
	v_calc_interval interval;
BEGIN
	SELECT id,date_time INTO v_doc_id,v_doc_date_time FROM doc_log WHERE doc_type=in_doc_type AND doc_id=in_doc_id;
	v_cur_per = rg_period('material'::reg_types, v_doc_date_time);
	v_calc_interval = rg_calc_interval('material'::reg_types);
	v_act_direct = ( (rg_calc_period_end('material'::reg_types,v_cur_per)-v_doc_date_time)>(v_doc_date_time - v_cur_per) );
	IF v_act_direct THEN
		v_act_direct_sgn = 1;
	ELSE
		v_act_direct_sgn = -1;
	END IF;

	RETURN QUERY 
	SELECT 
	sub.production_base_id
	,sub.material_id
	,SUM(sub.quant) AS quant				
	FROM(
	SELECT
	
	b.production_base_id
	,b.material_id
	,b.quant				
	FROM rg_materials AS b
	WHERE (v_act_direct AND b.date_time = (v_cur_per-v_calc_interval)) OR (NOT v_act_direct AND b.date_time = v_cur_per)
	
	AND (ARRAY_LENGTH(in_production_base_id_ar,1) IS NULL OR (b.production_base_id=ANY(in_production_base_id_ar)))
	AND (ARRAY_LENGTH(in_material_id_ar,1) IS NULL OR (b.material_id=ANY(in_material_id_ar)))
	
	AND(
	b.quant<>0
	)
	
	UNION ALL
	
	(SELECT
	
	act.production_base_id
	,act.material_id
	,
	CASE act.deb
		WHEN TRUE THEN act.quant*v_act_direct_sgn
		ELSE -act.quant*v_act_direct_sgn
	END AS quant								
	FROM doc_log
	LEFT JOIN ra_materials AS act ON act.doc_type=doc_log.doc_type AND act.doc_id=doc_log.doc_id
	WHERE (v_act_direct AND (doc_log.date_time>=v_cur_per AND doc_log.id<v_doc_id) )
		OR (NOT v_act_direct AND (doc_log.date_time<(v_cur_per+v_calc_interval) AND doc_log.id>=v_doc_id) )				
	
	AND (ARRAY_LENGTH(in_production_base_id_ar,1) IS NULL OR (act.production_base_id=ANY(in_production_base_id_ar)))
	AND (ARRAY_LENGTH(in_material_id_ar,1) IS NULL OR (act.material_id=ANY(in_material_id_ar)))
	
	AND (
	
	act.quant<>0
	)
	ORDER BY doc_log.date_time,doc_log.id)
	) AS sub
	WHERE (
		ARRAY_LENGTH(in_production_base_id_ar,1) IS NULL OR (sub.production_base_id=ANY(in_production_base_id_ar))
		AND ARRAY_LENGTH(in_material_id_ar,1) IS NULL OR (sub.material_id=ANY(in_material_id_ar))
	)
	GROUP BY
	
	sub.production_base_id
	,sub.material_id
	HAVING
	
	SUM(sub.quant)<>0
					
	ORDER BY
	sub.production_base_id
	,sub.material_id
	;
END;
$BODY$;

ALTER FUNCTION public.rg_materials_balance(doc_types, integer, integer[], integer[])
    OWNER TO ;

