begin;
-- ********** Adding new table from model **********
	CREATE TABLE public.fuel_consumption_schema_details
	(id serial NOT NULL,
	fuel_consumption_schema_id int NOT NULL REFERENCES fuel_consumption_schema(id),
	month_from int,
	month_to int,
	quant_distance int,
	quant_time int,CONSTRAINT fuel_consumption_schema_details_pkey PRIMARY KEY (id)
	);

	DROP INDEX IF EXISTS fuel_consumption_schema_schema_idx;
	CREATE INDEX fuel_consumption_schema_schema_idx
	ON fuel_consumption_schema_details(fuel_consumption_schema_id,month_from);

commit;
