-- View: operators_for_transp_nakl_schedules_list

-- DROP VIEW operators_for_transp_nakl_schedules_list;

CREATE OR REPLACE VIEW operators_for_transp_nakl_schedules_list AS 
	SELECT
		t.user_id
		,t.for_date
		,t.production_site_id
		,production_sites_ref(ps) AS production_sites_ref
		,users_ref(u) AS users_ref
		
   FROM operators_for_transp_nakl_schedules AS t
   LEFT JOIN production_sites ps ON ps.id = t.production_site_id
   LEFT JOIN users u ON u.id = t.user_id
  ORDER BY t.for_date DESC, ps.name;



