begin;

ALTER TABLE public.client_debts ADD COLUMN client_contract_id int REFERENCES client_contracts_1c(id);
	DROP INDEX IF EXISTS client_debts_firm_idx;
	CREATE UNIQUE INDEX client_debts_firm_idx
	ON client_debts(firm_id,client_id,client_contract_id);
	DROP INDEX IF EXISTS client_debts_firm_client_idx;
	CREATE INDEX client_debts_firm_client_idx
	ON client_debts(client_id,client_contract_id);

COMMIT;
