-- Function: public.material_avg_consumption_on_ctp(timestamp without time zone, timestamp without time zone)

-- DROP FUNCTION public.material_avg_consumption_on_ctp(timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION public.material_avg_consumption_on_ctp(
    IN in_date_time_from timestamp without time zone,
    IN in_date_time_to timestamp without time zone)
  RETURNS TABLE(
  	concrete_type_name text,
  	concrete_type_id integer,
  	material_name text,
  	material_id integer,
  	material_ord integer,
  	concrete_quant numeric,
  	norm_quant numeric,
  	norm_cost numeric,
  	norm_quant_per_m3 numeric,
  	norm_cost_per_m3 numeric,
  	material_quant numeric,
  	material_cost numeric,
  	material_quant_per_m3 numeric,
  	material_cost_per_m3 numeric,
  	
  	material_quant_req numeric,
  	material_quant_req_per_m3 numeric,
  	material_req_cost numeric,
  	material_req_cost_per_m3 numeric
  ) AS
$BODY$
--**********************************************************************
	SELECT
		ct.name AS concrete_type_name
		,sub.concrete_type_id	
		,sub.material_name
		,sub.material_id
		,sub.material_ord	
	
		,sum(sub.concrete_quant)::numeric(19,4) AS concrete_quant
		,sum(sub.norm_quant)::numeric(19,4) AS norm_quant
		,sum(sub.norm_cost)::numeric(15,2) AS norm_cost
		,CASE WHEN sum(sub.concrete_quant) =0 THEN 0 ELSE round( (sum(sub.norm_quant)/sum(sub.concrete_quant) )::numeric(19,4), 4) END AS norm_quant_per_m3
		,CASE WHEN sum(sub.concrete_quant)=0 THEN 0 ELSE round( sum(sub.norm_cost) / sum(sub.concrete_quant) ,2) END AS norm_cost_per_m3

		,sum(sub.material_quant) AS material_quant
		,sum(sub.material_cost) AS material_cost
		,CASE WHEN sum(sub.concrete_quant)=0 THEN 0 ELSE round( (sum(sub.material_quant) / sum(sub.concrete_quant))::numeric(19,4), 4) END AS material_quant_per_m3
		,CASE WHEN sum(sub.concrete_quant)=0 THEN 0 ELSE round( (sum(sub.material_cost) / sum(sub.concrete_quant))::numeric(19,4) ,2) END AS material_cost_per_m3
	
		,sum(sub.material_quant_req) AS material_quant_req
		,CASE WHEN sum(sub.concrete_quant)=0 THEN 0 ELSE round( (sum(sub.material_quant_req) / sum(sub.concrete_quant))::numeric(19,4), 4) END AS material_quant_req_per_m3
		,sum(sub.material_req_cost) AS material_req_cost
		,CASE WHEN sum(sub.concrete_quant)=0 THEN 0 ELSE round( (sum(sub.material_req_cost) / sum(sub.concrete_quant))::numeric(19,4) ,2) END AS material_req_cost_per_m3
		
	FROM
	(
	SELECT
		prod.production_id
		,t.raw_material_id AS material_id
		,mat.name AS material_name
		,mat.ord AS material_ord
		,t.concrete_type_id
		,coalesce(t.concrete_quant,0) AS concrete_quant
		,sum(coalesce(t.material_quant,0)) + sum(coalesce(t_cor.quant,0)) AS material_quant		
		,sum(round(
			coalesce(
				(SELECT m_pr.price
				FROM raw_material_prices AS m_pr
				WHERE m_pr.raw_material_id=t.raw_material_id AND m_pr.date_time<t.date_time
				ORDER BY m_pr.date_time DESC LIMIT 1
				)
			,0) * 			
			(coalesce(t.material_quant,0)  + coalesce(t_cor.quant,0))
		,2)) AS material_cost	

		,sum(coalesce(t.material_quant_req,0)) AS material_quant_req
		,sum(round(
			coalesce(
				(SELECT m_pr.price
				FROM raw_material_prices AS m_pr
				WHERE m_pr.raw_material_id=t.raw_material_id AND m_pr.date_time<t.date_time
				ORDER BY m_pr.date_time DESC LIMIT 1
				)
			,0) * 			
			coalesce(t.material_quant_req,0)
		,2)) AS material_req_cost	

		-- 10/02/23 исправил, возвращало 0
		-- иногда отгрузка (shipment) не привязана к производству, тогда сдесь не хватает!
		,coalesce((SELECT
			rt.rate
		FROM raw_material_cons_rates AS rt
		WHERE rt.rate_date_id = 
			(SELECT rt_dt.id
			FROM raw_material_cons_rate_dates AS rt_dt
			WHERE rt_dt.dt <= t.date_time
			ORDER BY rt_dt.dt DESC
			LIMIT 1)
			AND rt.concrete_type_id = t.concrete_type_id
			AND rt.raw_material_id = t.raw_material_id
		), 0) * t.concrete_quant AS norm_quant		
		/*,CASE
			WHEN coalesce(sh.quant,0)=0 OR coalesce(t.concrete_quant,0)=0 THEN 0
			ELSE coalesce(ra_mat.quant,0)/coalesce(sh.quant,0) * coalesce(t.concrete_quant,0)
		END AS norm_quant*/
		
		,round(
			coalesce(
				(SELECT m_pr.price
				FROM raw_material_prices_for_norm AS m_pr
				WHERE m_pr.raw_material_id=t.raw_material_id AND m_pr.date_time<t.date_time
				ORDER BY m_pr.date_time DESC LIMIT 1
				)
			,0) *
			
			coalesce((SELECT
				rt.rate
			FROM raw_material_cons_rates AS rt
			WHERE rt.rate_date_id = 
				(SELECT rt_dt.id
				FROM raw_material_cons_rate_dates AS rt_dt
				WHERE rt_dt.dt <= t.date_time
				ORDER BY rt_dt.dt DESC
				LIMIT 1)
				AND rt.concrete_type_id = t.concrete_type_id
				AND rt.raw_material_id = t.raw_material_id
			),0) * t.concrete_quant
			
			/* 
			CASE
				-- 10/02/23 исправил, возвращало 0
				-- иногда отгрузка (shipment) не привязана к производству, тогда сдесь не хватает!
				WHEN coalesce(sh.quant,0)=0 OR coalesce(t.concrete_quant,0)=0 THEN 0
				ELSE coalesce(ra_mat.quant,0)/coalesce(sh.quant,0) * coalesce(t.concrete_quant,0)
			END::numeric(19,4)		
			*/
		,2) AS norm_cost	
	FROM material_fact_consumptions AS t
	LEFT JOIN productions AS prod ON prod.production_site_id=t.production_site_id AND prod.production_id=t.production_id
	
	--LEFT JOIN shipments AS sh ON sh.id=prod.shipment_id
	--LEFT JOIN ra_materials AS ra_mat ON ra_mat.doc_type='shipment' AND ra_mat.doc_id=sh.id AND ra_mat.material_id=t.raw_material_id
	
	LEFT JOIN raw_materials AS mat ON mat.id=t.raw_material_id
	LEFT JOIN material_fact_consumption_corrections AS t_cor ON
		t_cor.production_site_id=t.production_site_id
		AND t_cor.production_id=t.production_id
		AND t_cor.material_id=t.raw_material_id 
		AND (mat.is_cement=FALSE OR t_cor.cement_silo_id=t.cement_silo_id)
	
	WHERE t.date_time BETWEEN in_date_time_from AND in_date_time_to
	--'2020-07-19 06:00' AND '2020-07-20 06:00'
	--AND t.raw_material_id=7
	GROUP BY 
		--sh.id
		prod.production_id
		,t.concrete_type_id	
		,t.raw_material_id
		,mat.name
		,mat.ord
		,t.concrete_quant
		,norm_quant
		,norm_cost
	) AS sub
	LEFT JOIN concrete_types AS ct ON ct.id=sub.concrete_type_id
	--LEFT JOIN raw_materials AS mat ON mat.id=sub.material_id
	GROUP BY
		ct.name
		,sub.concrete_type_id	
		,sub.material_name
		,sub.material_id
		,sub.material_ord	
	ORDER BY ct.name,sub.material_ord
	;



$BODY$
  LANGUAGE sql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.material_avg_consumption_on_ctp(timestamp without time zone, timestamp without time zone)
  OWNER TO beton;

