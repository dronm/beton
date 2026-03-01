begin;

drop view if exists shipments_list;
alter table shipments drop column upd_ref;
alter table shipments drop column faktura_ref;

commit;


