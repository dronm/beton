select
		veh_it.mon,
		veh_it.vehicle_id,
		veh_it.vehicle_owner_id,
		veh_it.it_com_id,
		veh_it.it_com_name,
		veh_it.it_id,
		veh_it.it_name,	
		veh_it.quant,
		coalesce(
			coalesce(
				it_com.value,
				/*
				CASE
				WHEN veh_it.it_com_query is null then 0
				ELSE
					vehicle_tot_rep_common_item_exec_query(
						veh_it.it_com_query,
						veh_it.vehicle_owner_id,
						'2024-05-01T06:00',
						'2024-05-15T06:00'
					)
				END
				*/
				0
			)
		,0) AS it_com_val,
		
		coalesce(
			coalesce(
				it.value,
				CASE
				WHEN veh_it.it_query is null then 0
				ELSE
					vehicle_tot_rep_item_exec_query(
						veh_it.it_query,
						veh_it.vehicle_id,
						'2024-05-01T06:00',
						'2024-05-15T06:00'
					)
				END
			)
		,0) AS it_val 
		
from (
	select
		det.mon,
		det.vehicle_id,
		det.vehicle_owner_id,
		it_com.id as it_com_id,
		it_com.name as it_com_name,
		it_com.query as it_com_query,
		it.id as it_id,
		it.name as it_name,	
		it.query as it_query,		
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
		where sh.date_time between '2024-05-01T06:00' and '2024-05-15T06:00'
	) AS det
	left join vehicle_owners as own on own.id = det.vehicle_owner_id
	CROSS join vehicle_tot_rep_common_items as it_com
	CROSS join vehicle_tot_rep_items as it
	group by
		det.mon,
		det.vehicle_id,
		det.vehicle_owner_id,
		it_com.id,
		it_com.name,
		it_com.query,
		it.id,
		it.name,
		it.query
) as veh_it
left join vehicle_tot_rep_common_item_vals as it_com on it_com.vehicle_tot_rep_common_item_id = veh_it.it_com_id
	and it_com.vehicle_owner_id = veh_it.vehicle_owner_id
	and it_com.period = veh_it.mon
	
left join vehicle_tot_rep_item_vals as it on it.vehicle_tot_rep_item_id = veh_it.it_id
	and it.vehicle_id = veh_it.vehicle_id
	and it.period = veh_it.mon	
