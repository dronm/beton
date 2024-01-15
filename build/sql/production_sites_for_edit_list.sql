-- VIEW: production_sites_for_edit_list

--DROP VIEW production_sites_for_edit_list;

CREATE OR REPLACE VIEW production_sites_for_edit_list AS
	SELECT
		s.*,
		production_bases_ref(b) AS production_bases_ref
	FROM production_sites AS s
	LEFT JOIN production_bases AS b ON b.id = s.production_base_id
	ORDER BY name
	;
	
ALTER VIEW production_sites_for_edit_list OWNER TO ;
