begin;
drop view if exists shipments_dialog;
alter table shipments drop column client_specification_id;
commit;

