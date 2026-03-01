begin;

alter table shipments add column upd_ref jsonb;
alter table shipments add column faktura_ref jsonb;

commit;

