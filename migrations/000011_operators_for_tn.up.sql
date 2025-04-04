
	CREATE TABLE public.operators_for_transp_nakl
	(user_id int NOT NULL REFERENCES users(id),production_site_id int REFERENCES production_sites(id),CONSTRAINT operators_for_transp_nakl_pkey PRIMARY KEY (user_id)
	);
