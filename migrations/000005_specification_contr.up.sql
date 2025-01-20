begin;

ALTER TABLE public.client_specifications ADD COLUMN client_contract_1c_id int REFERENCES client_contracts_1c(id);

commit;

