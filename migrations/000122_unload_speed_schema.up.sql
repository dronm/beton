	
	CREATE TABLE public.unload_speed_schema
	(
		id serial NOT NULL,
		speed int NOT NULL,
		quant  numeric(19,4),
		CONSTRAINT unload_speed_schema_pkey PRIMARY KEY (id)
	);
	INSERT INTO unload_speed_schema (speed, quant) VALUES (59, 15), (9999, 60);

