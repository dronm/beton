--DROP OR REPLACE FUNCTION public.drivers_work_time_report(


CREATE OR REPLACE FUNCTION public.drivers_work_time_report(
	in_report_date date,
	in_vehicle_id integer DEFAULT NULL,
	in_driver_id integer DEFAULT NULL
)
RETURNS TABLE(
	drivers_ref json,
	vehicles_ref json,
	time_data json
)
LANGUAGE plpgsql
VOLATILE
AS $BODY$
DECLARE
	v_month_start date;
	v_month_end date;
	v_period_start timestamp without time zone;
	v_period_end timestamp without time zone;
BEGIN
	v_month_start := date_trunc('month', in_report_date)::date;
	v_month_end := (date_trunc('month', in_report_date) + interval '1 month - 1 day')::date;

	v_period_start := get_shift_start(v_month_start::timestamp without time zone);
	v_period_end := get_shift_end(v_month_end::timestamp without time zone);

	RETURN QUERY
	WITH days AS (
		SELECT gs::date AS day
		FROM generate_series(
			v_month_start::timestamp without time zone,
			v_month_end::timestamp without time zone,
			interval '1 day'
		) AS gs
	),

	base_schedules AS (
		SELECT
			sch.id,
			sch.schedule_date,
			sch.vehicle_id,
			sch.driver_id
		FROM public.vehicle_schedules AS sch
		WHERE sch.schedule_date BETWEEN v_month_start AND v_month_end
			AND (in_vehicle_id IS NULL OR in_vehicle_id = 0 OR sch.vehicle_id = in_vehicle_id)
			AND (in_driver_id IS NULL OR in_driver_id = 0 OR sch.driver_id = in_driver_id)
	),

	schedule_work AS (
		SELECT
			bs.id AS schedule_id,
			bs.schedule_date,
			bs.vehicle_id,
			bs.driver_id,
			min(r.st_free_start) AS work_start,
			max(r.st_free_end) AS work_end
		FROM base_schedules AS bs
		LEFT JOIN LATERAL public.vehicle_run_inf_on_schedule(bs.id) AS r ON true
		GROUP BY
			bs.id,
			bs.schedule_date,
			bs.vehicle_id,
			bs.driver_id
	),

	daily_work AS (
		SELECT
			sw.schedule_date AS day,
			sw.vehicle_id,
			sw.driver_id,
			sum(
				CASE
					WHEN sw.work_start IS NULL THEN 0
					WHEN sw.work_end IS NULL THEN 0
					WHEN least(sw.work_end, v_period_end) <= greatest(sw.work_start, v_period_start) THEN 0
					ELSE extract(
						epoch FROM least(sw.work_end, v_period_end) - greatest(sw.work_start, v_period_start)
					)
				END
			) AS seconds_worked
		FROM schedule_work AS sw
		GROUP BY
			sw.schedule_date,
			sw.vehicle_id,
			sw.driver_id
	),

	pairs AS (
		SELECT DISTINCT
			bs.vehicle_id,
			bs.driver_id
		FROM base_schedules AS bs
	),
	result_rows AS (
		SELECT
			p.driver_id,
			p.vehicle_id,
			json_agg(
				json_build_object(
					'day', d.day,
					'is_day_off', extract(isodow FROM d.day) IN (6, 7),
					'hours', coalesce(floor(dw.seconds_worked / 3600), 0)::int
				)
				ORDER BY d.day
			) AS time_data
		FROM pairs AS p
		CROSS JOIN days AS d
		LEFT JOIN daily_work AS dw ON dw.day = d.day
			AND dw.driver_id IS NOT DISTINCT FROM p.driver_id
			AND dw.vehicle_id IS NOT DISTINCT FROM p.vehicle_id
		GROUP BY
			p.driver_id,
			p.vehicle_id
		HAVING coalesce(sum(dw.seconds_worked), 0) > 0
	)
	-- result_rows AS (
	-- 	SELECT
	-- 		p.driver_id,
	-- 		p.vehicle_id,
	-- 		json_agg(
	-- 			json_build_object(
	-- 				'day', d.day,
	-- 				'is_day_off', extract(isodow FROM d.day) IN (6, 7),
	-- 				'hours', coalesce(floor(dw.seconds_worked / 3600), 0)::int
	-- 			)
	-- 			ORDER BY d.day
	-- 		) AS time_data
	-- 	FROM pairs AS p
	-- 	CROSS JOIN days AS d
	-- 	LEFT JOIN daily_work AS dw ON dw.day = d.day
	-- 		AND dw.driver_id IS NOT DISTINCT FROM p.driver_id
	-- 		AND dw.vehicle_id IS NOT DISTINCT FROM p.vehicle_id
	-- 	GROUP BY
	-- 		p.driver_id,
	-- 		p.vehicle_id
	-- )

	SELECT
		public.drivers_ref(dr) AS drivers_ref,
		public.vehicles_ref(v) AS vehicles_ref,
		rr.time_data
	FROM result_rows AS rr
	LEFT JOIN public.drivers AS dr ON dr.id = rr.driver_id
	LEFT JOIN public.vehicles AS v ON v.id = rr.vehicle_id
	ORDER BY
		dr.name,
		v.plate;
END;
$BODY$;
