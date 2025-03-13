-- VIEW: production_sites_last_production_list

--DROP VIEW production_sites_last_production_list;

CREATE OR REPLACE VIEW production_sites_last_production_list AS
	SELECT
		p_s.id,
		p_s.name,
		p_s.elkon_connection,
		
		p_s.last_elkon_production_id AS last_production_id,
		
		(
		SELECT
			array_agg(production_id ORDER BY production_id)
		FROM productions
		WHERE 
			production_site_id=p_s.id AND production_dt_end IS NULL
			AND production_id NOT IN (SELECT UNNEST(p_s.unclosed_production_ids))
		) AS production_ids,
		
		p_s.missing_elkon_production_ids
		
	FROM production_sites AS p_s
	
	WHERE p_s.active AND p_s.elkon_connection IS NOT NULL AND p_s.last_elkon_production_id IS NOT NULL
	;
	
