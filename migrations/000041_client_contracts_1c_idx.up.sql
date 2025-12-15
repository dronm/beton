begin;


	DROP INDEX IF EXISTS client_contracts_1c_ref_idx;
	CREATE UNIQUE INDEX client_contracts_1c_ref_idx
	ON client_contracts_1c((ref_1c->>'ref_1c'));

commit;
