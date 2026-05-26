begin;
drop view if exists fuel_consumption_schema_details_list;
alter table fuel_consumption_schema_details alter column quant_distance type numeric(15,2);
alter table fuel_consumption_schema_details alter column quant_time type numeric(15,2);
commit;
