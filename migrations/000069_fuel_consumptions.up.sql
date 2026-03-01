
	-- ********** Adding new table from model **********
	CREATE TABLE public.fuel_consumptions
	(
		id serial NOT NULL,
		date_time timestamp not null,
		vehicle_id int REFERENCES vehicles(id) not null,
		quant int not null,
		CONSTRAINT fuel_consumptions_pkey PRIMARY KEY (id)
	);
