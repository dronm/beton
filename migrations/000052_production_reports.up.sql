begin;
	-- ********** Adding new table from model **********
	CREATE TABLE IF NOT EXISTS public.production_reports
(id serial NOT NULL,
	shift_from timestampTZ NOT NULL,
	shift_to timestampTZ NOT NULL,
	ref_1c jsonb,
	data_for_1c json,
	CONSTRAINT production_reports_pkey PRIMARY KEY (id)
	);
	DROP INDEX IF EXISTS production_reports_period_idx;
	CREATE INDEX production_reports_period_idx
	ON production_reports(shift_to);
commit;
