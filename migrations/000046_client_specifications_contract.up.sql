begin;
	DROP INDEX IF EXISTS client_specifications_contract_unq_idx;
	CREATE UNIQUE INDEX client_specifications_contract_unq_idx
	ON client_specifications(client_id,client_contract_id);
commit;
