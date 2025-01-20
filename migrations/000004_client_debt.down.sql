BEGIN;

	DROP INDEX IF EXISTS client_debts_firm_idx;
	CREATE UNIQUE INDEX client_debts_firm_idx
	ON client_debts(firm_id,client_id);
	DROP INDEX IF EXISTS client_debts_firm_client_idx;
	CREATE INDEX client_debts_firm_client_idx
	ON client_debts(client_id);
ALTER TABLE public.client_debts drop COLUMN client_contract_id;
COMMIT;
