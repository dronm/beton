
  -- select * from suppliers where name ilike '%стабилис%'
  -- update suppliers set name ='гидроресурс повтор'  where id = 383
--select count(*) from raw_material_tickets where carrier_id = 1861252
--union all
--select count(*) from raw_material_tickets where carrier_id = 1861252;

-- select count(*) from doc_material_procurements where carrier_id = 383 
-- union all
-- select count(*) from doc_material_procurements where carrier_id = 1861007;

-- update suppliers set name = 'ФОРСАЖ-АВТО (удалить)' where id = 386;
--update doc_material_procurements set carrier_id = 385 where carrier_id = 386;
-- update raw_material_tickets set carrier_id = 1861113 where carrier_id = 1861079;
delete from suppliers where id = 1861079;


-- select count(*) from doc_material_procurements where carrier_id=1861218
--  union all
-- select id, quant_gross, quant_net, date_time, supplier_id from doc_material_procurements  
-- update doc_material_procurements set carrier_id = 1861113 where carrier_id=1861079
-- update doc_material_procurements set supplier_id = 183 where supplier_id=94
-- where supplier_id in (select t.id from suppliers as t where coalesce(t.name,'')='')
-- where carrier_id in (select t.id from suppliers as t where coalesce(t.name,'')='')
-- where supplier_id=91
-- order by date_time desc

 -- update raw_material_procur_rates set supplier_id = 3 where supplier_id in (select t.id from suppliers as t where coalesce(t.name,'')='')
 -- update supplier_orders set supplier_id = 3 where supplier_id in (select t.id from suppliers as t where coalesce(t.name,'')='')
