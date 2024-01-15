-- FUNCTION: public.get_schedule_for_all2(date, date, integer)

 DROP FUNCTION IF EXISTS public.get_schedule_for_all2(date, date, integer);

CREATE OR REPLACE FUNCTION public.get_schedule_for_all2(
	in_date_from date,
	in_date_to date,
	in_vehicle_id integer)
    RETURNS TABLE(
    	day date,
    	day_descr text,
    	dow integer,
    	dow_descr text,
    	week_end integer,
    	plate text,
    	owner text,
    	day_no_shift boolean,
    	production_base_descr text,
    	production_base_id int,
    	vehicle_id int,
    	driver_id int,
    	driver_descr text
    ) 
    LANGUAGE 'sql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
	SELECT
		dt::date AS day,
		date8_descr(dt::date)::text AS day_descr,
		EXTRACT(DOW FROM dt::date)::int AS dow,
		dow_descr_short(dt::date)::text AS dow_descr,
		CASE EXTRACT(DOW FROM dt::date)
			WHEN 0 THEN 1
			WHEN 6 THEN 1
			ELSE 0
		END AS week_end,
		v.plate::text,
		--v.owner::text,
		vehicle_owner_on_date(v.vehicle_owners, in_date_from)->>'descr' AS owner,
		v.id IS NULL AS day_no_shift,
		bs.name AS production_base_descr,
		bs.id AS  production_base_id,
		v.id AS vehicle_id,
		sched.driver_id,
		dr.name::text AS driver_descr

	FROM generate_series(in_date_from, in_date_to,'1 day') AS dt
	LEFT JOIN (
		--DISTINCT ON (s.vehicle_id, s.schedule_date)
		SELECT
			s.vehicle_id,
			s.schedule_date,
			s.production_base_id,
			s.driver_id
		FROM vehicle_schedules AS s
		WHERE s.schedule_date BETWEEN in_date_from AND in_date_to
		AND coalesce(in_vehicle_id, 0) = 0 OR s.vehicle_id = in_vehicle_id
	) AS sched ON sched.schedule_date = dt::date
	LEFT JOIN vehicles AS v ON v.id = sched.vehicle_id
	LEFT JOIN production_bases AS bs ON bs.id = sched.production_base_id
	LEFT JOIN drivers AS dr ON dr.id = sched.driver_id
	ORDER BY
		dt,
		owner,
		plate;
$BODY$;
ALTER FUNCTION public.get_schedule_for_all2(date, date, integer)
    OWNER TO ;

