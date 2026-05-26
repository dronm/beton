begin;	

	CREATE TABLE public.vehicle_fuel_consumption_schema_details
	(
		id serial NOT NULL,
		vehicle_id int NOT NULL REFERENCES vehicles(id),
		month_from int not NULL,
		month_to int not NULL,
		quant_distance  numeric(15,2),
		quant_time  numeric(15,2),
		CONSTRAINT vehicle_fuel_consumption_schema_details_pkey PRIMARY KEY (id)
	);

	DROP INDEX IF EXISTS vehicle_fuel_consumption_schema_details_vehicle_idx;
	CREATE INDEX vehicle_fuel_consumption_schema_details_vehicle_idx
	ON vehicle_fuel_consumption_schema_details(vehicle_id);

commit;
