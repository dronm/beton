-- VIEW: 

insert into period_values(period_value_type, key, date_time, val) values('min_quant_for_ship_cost', 0, '2021-07-01T00:00:00','10');
select val::numeric from period_values where period_value_type='min_quant_for_ship_cost' and key=0 order by date_time desc limit 1;
select period_value('min_quant_for_ship_cost', 0, now()::timestamp);
