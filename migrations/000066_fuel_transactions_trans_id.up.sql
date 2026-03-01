begin;

alter table fuel_transactions add column transaction_id text NOT NULL;
update fuel_transactions set transaction_id = id;

commit;
