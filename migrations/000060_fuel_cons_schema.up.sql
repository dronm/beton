begin;
	-- ********** Adding new table from model **********
	CREATE TABLE public.fuel_consumption_schema
(id serial NOT NULL,
	name text,
	CONSTRAINT fuel_consumption_schema_pkey PRIMARY KEY (id)
	);
		
commit;
