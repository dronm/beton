
	-- ********** Adding new table from model **********
	CREATE TABLE public.deploy_updates
	(id serial NOT NULL, updated_at timestamp default now(),
	CONSTRAINT deploy_updates_pkey PRIMARY KEY (id)
	);
