begin;
	-- ********** Adding new table from model **********
	CREATE TABLE public.rg_fuel_flow
	(id serial NOT NULL,
	date_time timestamp NOT NULL,
	vehicle_id int REFERENCES vehicles(id),
	quant int,
	CONSTRAINT rg_fuel_flow_pkey PRIMARY KEY (id)
	);

	DROP INDEX IF EXISTS rg_fuel_flow_date_time_idx;
	CREATE INDEX rg_fuel_flow_date_time_idx
	ON rg_fuel_flow(date_time);
	DROP INDEX IF EXISTS rg_fuel_flow_vehicle_idx;
	CREATE INDEX rg_fuel_flow_vehicle_idx
	ON rg_fuel_flow(vehicle_id);

commit;
