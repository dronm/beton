	-- ********** Adding new table from model **********
	CREATE TABLE public.user_allowed_material_corrections
	(user_id int NOT NULL REFERENCES users(id),CONSTRAINT user_allowed_material_corrections_pkey PRIMARY KEY (user_id)
	);

