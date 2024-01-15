-- VIEW: production_sites_list

--DROP VIEW production_sites_list;

CREATE OR REPLACE VIEW production_sites_list AS
	SELECT
		id,
		name,
		production_base_id
	FROM production_sites
	ORDER BY name
	;
	
ALTER VIEW production_sites_list OWNER TO ;
