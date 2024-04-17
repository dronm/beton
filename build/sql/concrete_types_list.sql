-- VIEW: concrete_types_list

--DROP VIEW concrete_types_list;

CREATE OR REPLACE VIEW concrete_types_list AS
	SELECT
		ctp.id,
		ctp.name,
		ctp.code_1c,
		ctp.pres_norm,
		ctp.mpa_ratio,
		--ctp.price
		coalesce(act_price.price,0) AS price
		,ctp.material_cons_rates
		,ctp.show_on_site
		,coalesce(ctp.official_name, ctp.name) AS official_name
		
		,ctp.prochnost
		,f_val
		,w_val
		
	FROM concrete_types AS ctp
	/*
	LEFT JOIN (
		SELECT
			max(t.date) AS date,
			t.concrete_type_id
		FROM concrete_costs AS t
		GROUP BY t.concrete_type_id
	) AS last_price ON last_price.concrete_type_id=ctp.id
	LEFT JOIN concrete_costs AS act_price ON act_price.date=last_price.date AND act_price.concrete_type_id=last_price.concrete_type_id
	*/
	
	LEFT JOIN concrete_costs AS act_price
	ON
		act_price.concrete_type_id=ctp.id
		AND act_price.concrete_costs_h_id= (SELECT t.id
			FROM concrete_costs_h AS t
			WHERE
				(t.clients_list IS NULL OR (jsonb_array_length(clients_list->'rows')=0) )
				AND t.date<=now()::date
			ORDER BY t.date DESC
			LIMIT 1
		)	
	
	ORDER BY ctp.name
	;
	
ALTER VIEW concrete_types_list OWNER TO ;
