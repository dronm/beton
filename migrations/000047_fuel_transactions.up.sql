begin;
	-- ********** Adding new table from model **********
	CREATE TABLE public.fuel_transactions
	(id text NOT NULL,
	date_time timestamp NOT NULL,
	card_id text NOT NULL,
	vehicle_id int references vehicles(id),
	attrs json,
	quant numeric(15,2) DEFAULT 0,
	total  numeric(15,2) DEFAULT 0,
	CONSTRAINT fuel_transactions_pkey PRIMARY KEY (id)
	);

	DROP INDEX IF EXISTS fuel_transactions_period_idx;
	CREATE INDEX fuel_transactions_period_idx
	ON fuel_transactions(date_time);

	DROP INDEX IF EXISTS fuel_transactions_card_idx;
	CREATE INDEX fuel_transactions_card_idx
	ON fuel_transactions(card_id);

	DROP INDEX IF EXISTS fuel_transactions_vehicle_idx;
	CREATE INDEX fuel_transactions_vehicle_idx
	ON fuel_transactions(vehicle_id);
commit;
