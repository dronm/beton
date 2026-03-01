	-- ********** Adding new table from model **********
	CREATE TABLE public.ra_fuel_flow
	(id serial NOT NULL,
		date_time timestamp NOT NULL,
		deb bool,
		doc_type doc_types NOT NULL,
		doc_id int,
		vehicle_id int NOT NULL REFERENCES vehicles(id),
		quant int,
		CONSTRAINT ra_fuel_flow_pkey PRIMARY KEY (id)
	);
	DROP INDEX IF EXISTS ra_fuel_flow_date_time_idx;
	CREATE INDEX ra_fuel_flow_date_time_idx
	ON ra_fuel_flow(date_time);
	DROP INDEX IF EXISTS ra_fuel_flow_doc_idx;
	CREATE INDEX ra_fuel_flow_doc_idx
	ON ra_fuel_flow(doc_type,doc_id);
	DROP INDEX IF EXISTS ra_fuel_flow_vehicle_idx;
	CREATE INDEX ra_fuel_flow_vehicle_idx
	ON ra_fuel_flow(vehicle_id);

