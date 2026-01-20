	-- ********** Adding new table from model **********
	CREATE UNLOGGED TABLE public.distrib_commands
	(
		query_id text NOT NULL,
		session_id text NOT NULL,
		created_at timestampTZ default current_timestamp,
		CONSTRAINT distrib_commands_pkey PRIMARY KEY (query_id)
	);


