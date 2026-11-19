CREATE OR REPLACE FUNCTION public.vehicle_driver_work_time(in_month date)
RETURNS TABLE (drivers_ref json, vehicles_ref json, time_data json)
LANGUAGE sql STABLE AS $report$
	WITH period AS (
		SELECT date_trunc('month', in_month::timestamp) AS month_start
	),
	worked_days AS (
		SELECT DISTINCT sch.vehicle_id, sch.schedule_date AS day
		FROM public.vehicle_schedules AS sch
		CROSS JOIN period AS p
		WHERE sch.schedule_date >= p.month_start
			AND sch.schedule_date < p.month_start + interval '1 month'
			AND EXISTS (
				SELECT 1 FROM public.shipments AS sh
				WHERE sh.vehicle_schedule_id = sch.id
			)
	),
	calendar AS (
		SELECT d::date AS day
		FROM period AS p
		CROSS JOIN LATERAL generate_series(
			p.month_start, p.month_start + interval '1 month - 1 day', interval '1 day'
		) AS d
	),
	vehicle_month AS (
		SELECT active.vehicle_id,
			json_agg(json_build_object(
				'day', c.day,
				'is_day_off', extract(isodow FROM c.day) IN (6, 7),
				'hours', CASE WHEN w.day IS NULL THEN 0 ELSE 8 END
			) ORDER BY c.day) AS time_data
		FROM (SELECT DISTINCT vehicle_id FROM worked_days) AS active
		CROSS JOIN calendar AS c
		LEFT JOIN worked_days AS w ON w.vehicle_id = active.vehicle_id AND w.day = c.day
		GROUP BY active.vehicle_id
	)
	SELECT public.drivers_ref(dr), public.vehicles_ref(v), m.time_data
	FROM vehicle_month AS m
	JOIN public.vehicles AS v ON v.id = m.vehicle_id
	LEFT JOIN public.drivers AS dr ON dr.id = v.driver_id
	ORDER BY dr.name, v.plate, v.id;
$report$;
