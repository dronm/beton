-- FUNCTION: public.sup_procur_deviation(date)

-- DROP FUNCTION public.sup_procur_deviation(date);

CREATE OR REPLACE FUNCTION public.sup_procur_deviation(
	check_date date)
    RETURNS TABLE(supplier_id integer, supplier_descr text, material_id integer, material_descr text, quant_proc numeric, quant_ord numeric, compl_percent numeric) 
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
SELECT
		sub.supplier_id,
		sp.name::text AS supplier_descr,
		sub.material_id AS material_id,
		m.name::text AS material_descr,
		SUM(sub.quant_proc) AS quant_proc,
		SUM(sub.quant_ord) AS quant_ord,
		ROUND(
			CASE
				WHEN
					(SUM(sub.quant_ord)=0
					AND SUM(sub.quant_proc)<>0)
					OR
					(SUM(sub.quant_ord)<>0
					AND SUM(sub.quant_proc)=0)					
				THEN NULL
				WHEN
					(SUM(sub.quant_ord)=0
					AND SUM(sub.quant_proc)=0)				
				THEN 0
				ELSE
				SUM(sub.quant_proc)/SUM(sub.quant_ord)*100
			END
		) AS compl_percent
	FROM (
		SELECT
			so.supplier_id,
			so.material_id,
			SUM(so.quant) AS quant_ord,
			0 AS quant_proc
		FROM supplier_orders AS so
		WHERE so.date = $1
		GROUP BY supplier_id,material_id
		
		UNION ALL
		
		SELECT
			supplier_id,
			ra.material_id,
			0 AS quant_ord,
			SUM(ra.quant) AS quant_proc
		FROM ra_materials AS ra
		LEFT JOIN doc_material_procurements AS d ON d.id=ra.doc_id
		WHERE ra.date_time BETWEEN
			$1-'1 day'::interval+'20:00'::interval AND $1+'19:59:59'::interval
			AND ra.deb=TRUE AND doc_type='material_procurement'::doc_types
		GROUP BY get_shift_start(ra.date_time),d.supplier_id,ra.material_id		
	) AS sub
	LEFT JOIN raw_materials AS m ON m.id=sub.material_id
	LEFT JOIN suppliers AS sp ON sp.id=sub.supplier_id		
	GROUP BY 
		sub.supplier_id,
		sub.material_id,
		sp.name::text,
		m.name::text		
	ORDER BY 
		sub.supplier_id,
		sub.material_id
$BODY$;

ALTER FUNCTION public.sup_procur_deviation(date)
    OWNER TO ;

