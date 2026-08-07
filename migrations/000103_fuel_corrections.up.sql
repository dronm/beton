BEGIN;

	-- ********** Adding new table from model **********
	CREATE TABLE public.fuel_corrections
	(
		id serial NOT NULL,
		date_time timestamp NOT NULL,
		vehicle_id int REFERENCES vehicles(id),
		quant int DEFAULT 0,
		quant_correction int DEFAULT 0,
		CONSTRAINT fuel_corrections_pkey PRIMARY KEY (id)
	);

	DROP INDEX IF EXISTS fuel_corrections_period_idx;
	CREATE INDEX fuel_corrections_period_idx
	ON fuel_corrections(date_time);

	DROP INDEX IF EXISTS fuel_corrections_card_idx;
	CREATE INDEX fuel_corrections_card_idx
	ON fuel_corrections(vehicle_id);

COMMIT;
