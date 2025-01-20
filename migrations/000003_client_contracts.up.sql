
begin;
	-- ********** Adding new table from model **********
	CREATE TABLE public.client_contracts_1c
(id serial NOT NULL,
	client_id int REFERENCES clients(id),
	ref_1c jsonb,CONSTRAINT client_contracts_1c_pkey PRIMARY KEY (id)
	);
	CREATE UNIQUE INDEX client_contracts_1c_ref_idx
	ON client_contracts_1c((ref_1c->'keys'->>'ref_1c'));
	CREATE INDEX client_contracts_1c_client_idx
	ON client_contracts_1c(client_id);

commit;
