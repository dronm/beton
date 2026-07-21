	-- ********** Adding new table from model **********
	CREATE TABLE public.workplaces
	(
		id serial NOT NULL,
		name text NOT NULL,
		tel_ext  varchar(5),
		mac_addresses jsonb,
		user_id int REFERENCES users(id),
		CONSTRAINT workplaces_pkey PRIMARY KEY (id)
	);

