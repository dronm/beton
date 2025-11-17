begin;

	-- ********** Adding new table from model **********
	CREATE TABLE public.ext_productions
	(id serial NOT NULL,
	ext_id text NOT NULL,
	production_site_id int REFERENCES production_sites(id),
	production jsonb,
	materials jsonb,
	updated_at timestampTZ DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT ext_productions_pkey PRIMARY KEY (id)
	);
	DROP INDEX IF EXISTS ext_productions_idx;
	CREATE UNIQUE INDEX ext_productions_idx
	ON ext_productions(production_site_id,ext_id);

commit;
