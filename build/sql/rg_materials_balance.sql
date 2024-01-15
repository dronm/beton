-- FUNCTION: public.rg_materials_balance(integer[],integer[])

-- DROP FUNCTION public.rg_materials_balance(integer[],integer[]);

CREATE OR REPLACE FUNCTION public.rg_materials_balance(
	in_production_base_id_ar integer[]
	,in_material_id_ar integer[])
    RETURNS TABLE(
    	production_base_id int,
    	material_id integer,
    	quant numeric
    ) 
    LANGUAGE 'sql'

    COST 100
    VOLATILE STRICT 
    ROWS 1000
AS $BODY$
	SELECT
		b.production_base_id
		,b.material_id
		,sum(b.quant) AS quant				
	FROM rg_materials AS b
	WHERE b.date_time=reg_current_balance_time()
		
		AND (ARRAY_LENGTH(in_production_base_id_ar,1) IS NULL OR (b.production_base_id=ANY(in_production_base_id_ar)))
		AND (ARRAY_LENGTH(in_material_id_ar,1) IS NULL OR (b.material_id=ANY(in_material_id_ar)))
		
		AND(
		b.quant<>0
		)
	GROUP BY
		b.production_base_id
		,b.material_id
	ORDER BY
		b.production_base_id
		,b.material_id;
$BODY$;

ALTER FUNCTION public.rg_materials_balance(integer[],integer[])
    OWNER TO ;

