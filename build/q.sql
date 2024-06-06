--*************************	
with
per as (
	select
		'2024-05-01T06:00'::timestamp as d1,
		'2024-05-15T06:00'::timestamp as d2
),
veh_data as (
	select
		det.mon,
		det.vehicle_owner_id,
		det.vehicle_id,		
		sum(det.quant) as quant		
	from (
		select
			date_trunc('month', get_shift_start(sh.date_time))::date as mon,
			sch.vehicle_id,
			sh.quant,
			--add owner
			(vehicle_owner_on_date(vh.vehicle_owners, sh.date_time)->'keys'->>'id')::int as vehicle_owner_id
			
		from shipments as sh
		left join vehicle_schedules as sch on sch.id = sh.vehicle_schedule_id
		left join vehicles as vh on vh.id = sch.vehicle_id
		where sh.date_time between (select d1 from per) and (select d2 from per)
	) AS det
	left join vehicle_owners as own on own.id = det.vehicle_owner_id
	group by
		det.mon,
		det.vehicle_id,
		det.vehicle_owner_id
),
owner_data as (
	select
		veh_data.mon,
		veh_data.vehicle_owner_id,
		sum(veh_data.quant) as quant	
	from veh_data
	group by
		veh_data.mon,
		veh_data.vehicle_owner_id
)	
select
	b.mon,
	b.vehicle_id,
	b.quant,
	it.id as it_id,
	it.name as it_name,
	coalesce(
		coalesce(
			it_v.value,
			CASE
			WHEN it.query is null then 0
			ELSE
				vehicle_tot_rep_item_exec_query(
					it.query,
					b.vehicle_id,
					(select d1 from per),
					(select d2 from per)
				)
			END
		)
	,0) AS it_val,
	
	owner.vehicle_owner_id,
	owner.quant as owner_quant,
	owner.it_com_id,
	owner.it_com_name,
	owner.it_com_val
	
from veh_data as b
CROSS join vehicle_tot_rep_items as it
left join vehicle_tot_rep_item_vals as it_v on
	it_v.vehicle_id = b.vehicle_id
	and it_v.period = b.mon	
	and it_v.vehicle_tot_rep_item_id = it.id
left join (	
	select
		b.mon,
		b.vehicle_owner_id,
		b.quant,
		it_com.id as it_com_id,
		it_com.name as it_com_name,
		coalesce(
			coalesce(
				it_com_v.value,
				CASE
				WHEN it_com.query is null then 0
				ELSE
					vehicle_tot_rep_common_item_exec_query(
						it_com.query,
						b.vehicle_owner_id,
						(select d1 from per),
						(select d2 from per)
					)
				END
			)
		,0) AS it_com_val
		
	from owner_data as b
	CROSS join vehicle_tot_rep_common_items as it_com
	left join vehicle_tot_rep_common_item_vals as it_com_v on
		it_com_v.vehicle_owner_id = b.vehicle_owner_id
		and it_com_v.period = b.mon	
		and it_com_v.vehicle_tot_rep_common_item_id = it_com.id
) as owner on
	owner.mon = b.mon
	and owner.vehicle_owner_id = b.vehicle_owner_id




--***
with
per as (
	select
		'2024-05-01T06:00'::timestamp as d1,
		'2024-05-15T06:00'::timestamp as d2
),	
veh_data as (
	select
		det.mon,
		det.vehicle_owner_id,
		det.vehicle_id,		
		sum(det.quant) as quant		
	from (
		select
			date_trunc('month', get_shift_start(sh.date_time))::date as mon,
			sch.vehicle_id,
			sh.quant,
			--add owner
			(vehicle_owner_on_date(vh.vehicle_owners, sh.date_time)->'keys'->>'id')::int as vehicle_owner_id
			
		from shipments as sh
		left join vehicle_schedules as sch on sch.id = sh.vehicle_schedule_id
		left join vehicles as vh on vh.id = sch.vehicle_id
		where sh.date_time between (select d1 from per) and (select d2 from per)
	) AS det
	left join vehicle_owners as own on own.id = det.vehicle_owner_id
	group by
		det.mon,
		det.vehicle_id,
		det.vehicle_owner_id
),
owner_data as (
	select
		veh_data.mon,
		veh_data.vehicle_owner_id,		
		sum(veh_data.quant) as quant	
	from veh_data
	group by
		veh_data.mon,
		veh_data.vehicle_owner_id
),
owner_it_data as (
	select
		b.mon,
		b.vehicle_owner_id,
		coalesce(bal.value, 0) as balance_start,
		b.quant,	
		it_com.id as it_com_id,
		it_com.name as it_com_name,
		coalesce(it_com.is_income, false) as it_com_is_income,
		coalesce(
			coalesce(
				it_com_v.value,
				CASE
				WHEN it_com.query is null then 0
				ELSE
					vehicle_tot_rep_common_item_exec_query(
						it_com.query,
						b.vehicle_owner_id,
						(select d1 from per),
						(select d2 from per)
					)
				END
			)
		,0) AS it_com_val
		
	from owner_data as b
	CROSS join vehicle_tot_rep_common_items as it_com
	left join vehicle_tot_rep_balances as bal on
		bal.vehicle_owner_id = b.vehicle_owner_id
		and bal.period = b.mon
	left join vehicle_tot_rep_common_item_vals as it_com_v on
		it_com_v.vehicle_owner_id = b.vehicle_owner_id
		and it_com_v.period = b.mon	
		and it_com_v.vehicle_tot_rep_common_item_id = it_com.id
)
select
		sub.mon,
		sub.vehicle_owner_id,
		veh_on.name as vehicle_owner_name,
		sub.balance_start,
		sub.quant,	
		sub.it_com_id,
		sub.it_com_name,
		sub.it_com_is_income,
		sub.it_com_val	
from (
	(select
			owner_it_data.mon,
			owner_it_data.vehicle_owner_id,
			owner_it_data.balance_start,
			owner_it_data.quant,	
			owner_it_data.it_com_id,
			owner_it_data.it_com_name,
			owner_it_data.it_com_is_income,
			owner_it_data.it_com_val	
	from owner_it_data)
	
	union all
	
	(select
			bal.period as mon,
			bal.vehicle_owner_id,
			bal.value,
			0 as quant,	
			NULL as it_com_id,
			NULL as it_com_name,
			NULL as it_com_is_income,
			0 as it_com_val		
	from vehicle_tot_rep_balances as bal
	where
		bal.period between (select d1 from per) and (select d2 from per)
		and bal.vehicle_owner_id not in (select owner_data.vehicle_owner_id from owner_data)
	)
) as sub	
left join vehicle_owners as veh_on on veh_on.id = sub.vehicle_owner_id
order by
	veh_on.name,
	sub.mon,
	sub.it_com_is_income,
	sub.it_com_name
