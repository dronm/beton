begin;
alter table shipments add column client_specification_id int references client_specifications (id);

commit;
