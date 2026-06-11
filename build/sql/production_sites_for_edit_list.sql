-- VIEW: production_sites_for_edit_list

--DROP VIEW production_sites_for_edit_list;

CREATE OR REPLACE VIEW production_sites_for_edit_list AS
	SELECT
		--s.*,
		s.id,
		s.name,
		s.elkon_connection,
		s.active,

		CASE WHEN s.active THEN s.last_elkon_production_id
		ELSE
			(
				SELECT 
					pr.production_id 
				FROM productions AS pr 
				WHERE pr.production_site_id = s.id
				ORDER BY 
					pr.production_site_id, 
					pr.production_id DESC
				LIMIT 1
			)
		END AS last_elkon_production_id,

		s.missing_elkon_production_ids,
		s.production_plant_type,
		s.production_base_id,
		production_bases_ref(b) AS production_bases_ref
	FROM production_sites AS s
	LEFT JOIN production_bases AS b ON b.id = s.production_base_id
	ORDER BY name
	;
