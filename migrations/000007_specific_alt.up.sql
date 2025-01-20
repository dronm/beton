BEGIN;		

ALTER TABLE public.client_specifications ADD COLUMN client_contract_1c_ref  varchar(36);

ALTER TABLE public.client_specifications DROP COLUMN client_contract_1c_id;

COMMIT;

