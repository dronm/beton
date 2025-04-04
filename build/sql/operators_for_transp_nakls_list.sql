-- View: operators_for_transp_nakls_list

-- DROP VIEW operators_for_transp_nakls_list;

CREATE OR REPLACE VIEW operators_for_transp_nakls_list AS 
	SELECT
		t.user_id
		,t.production_site_id
		,production_sites_ref(ps) AS production_sites_ref
		,users_ref(u) AS users_ref
		
   FROM operators_for_transp_nakl AS t
   LEFT JOIN production_sites ps ON ps.id = t.production_site_id
   LEFT JOIN users u ON u.id = t.user_id
  ORDER BY u.name ASC;


