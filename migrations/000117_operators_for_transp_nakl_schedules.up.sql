BEGIN;	
	-- ********** Adding new table from model **********
	CREATE TABLE public.operators_for_transp_nakl_schedules
	(
		id serial NOT NULL,
		for_date date NOT NULL,
		production_site_id int REFERENCES production_sites(id),
		user_id int REFERENCES users(id),
		CONSTRAINT operators_for_transp_nakl_schedules_pkey PRIMARY KEY (id,for_date)
	);
	DROP INDEX IF EXISTS operators_for_transp_nakl_schedules_user_id_production_site_id_idx;

	CREATE INDEX operators_for_transp_nakl_schedules_user_id_production_site_id_idx
	ON operators_for_transp_nakl_schedules(for_date,production_site_id);

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
COMMIT;


