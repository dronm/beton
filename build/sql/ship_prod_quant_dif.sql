-- Function: ship_prod_quant_dif(d1 timestamp, d2 timestamp)

 DROP FUNCTION ship_prod_quant_dif(d1 timestamp, d2 timestamp);

CREATE OR REPLACE FUNCTION ship_prod_quant_dif(d1 timestamp, d2 timestamp)
  RETURNS TABLE(
  	concrete_type_id int,
  	concrete_type_name text,
  	quant numeric(19,4),
  	concrete_quant numeric(19,4)
  ) AS
$$  
	SELECT
		tot.concrete_type_id,
		ct_t.name AS concrete_type_name,
		sum(tot.quant)::numeric(19,4),
		sum(tot.concrete_quant)::numeric(19,4)	
	FROM (
 		(SELECT
			o.concrete_type_id,
			sum(sh.quant) AS quant,
			0 AS concrete_quant	
		FROM shipments AS sh
		LEFT JOIN orders AS o ON o.id = sh.order_id
		WHERE sh.shipped AND sh.date_time BETWEEN d1 and d2
		GROUP BY o.concrete_type_id)
		
		UNION ALL		
		
		(SELECT
			prod.concrete_type_id,
			0 AS quant,
			sum(prod.concrete_quant) AS concrete_quant	
		FROM productions AS prod
		WHERE prod.production_dt_end BETWEEN d1 and d2
		GROUP BY prod.concrete_type_id	)	
	
	) AS tot
	LEFT JOIN concrete_types AS ct_t ON ct_t.id = tot.concrete_type_id
	GROUP BY tot.concrete_type_id,ct_t.name
	ORDER BY ct_t.name
	;   
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION ship_prod_quant_dif(d1 timestamp, d2 timestamp) OWNER TO ;
