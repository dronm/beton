with
per as (select '2023-12-31T06:00:00'::timestamp as d1, '2024-01-01T06:00:00'::timestamp as d2),
sl as (select 5 as id),
bal_start as (SELECT
	sum(quant) as q
FROM rg_cement_balance(			
	(SELECT d1 FROM per),
	(select array_agg(id) from sl)
)),
bal_end as (SELECT
	sum(quant) as q
FROM rg_cement_balance(			
	(SELECT d2 FROM per),
	(select array_agg(id) from sl)
))

select
	(select q from bal_start) as per_bal_start,
	(select q from bal_end) as per_bal_end,
	ra.date_time,
	ra.doc_type,
	ra.doc_id,
	case when ra.deb then ra.quant else 0 end as deb,
	case when not ra.deb then ra.quant else 0 end as kred,
	(select q from bal_start) +
		sum(case when ra.deb then ra.quant else -ra.quant end)
		over (order by ra.date_time) as run_bal
from ra_cement as ra
where
	ra.date_time between (SELECT d1 FROM per) and (SELECT d2 FROM per)
	and ra.cement_silos_id in (select id from sl)
order by ra.date_time


--select * from
update
	cement_silo_balance_resets
	set user_id = user_id
	where date_time between '2024-01-01' AND '2024-05-01'
