BEGIN;		

ALTER TABLE public.client_specifications DROP COLUMN client_contract_1c_ref;

ALTER TABLE public.client_specifications add COLUMN client_contract_1c int;

COMMIT;


