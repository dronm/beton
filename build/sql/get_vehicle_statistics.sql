-- FUNCTION: public.get_vehicle_statistics(date)

-- DROP FUNCTION IF EXISTS public.get_vehicle_statistics(date);

CREATE OR REPLACE FUNCTION public.get_vehicle_statistics(
	in_date date)
    RETURNS TABLE(key text, val text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
DECLARE
	ROUND_AVG_MINUTES int = 5;
	ROUND_MIN_MINUTES int = 30;

	v_date_time_from timestamp;
	v_date_time_from_shift_start timestamp;
	v_date_time_to timestamp;
	v_round_avg_interval interval;
	v_round_min_interval interval;
	v_avg_interval_count int;
	
	v_at_base_avg interval;
	v_work_avg interval;
	v_run_avg interval;
	v_at_dest_avg interval;
	v_end_time_interval interval;
	v_first_shift_start_interval interval;
	v_day_shift_length_interval interval;	
BEGIN
	/*
		All statistics data from 8-00(constant_first_shift_start_time+01:00) to 20-00
		
	*/
	v_date_time_from_shift_start = in_date +constant_first_shift_start_time()::interval;
	v_date_time_from =  v_date_time_from_shift_start + '01:00'::interval;
	v_first_shift_start_interval = constant_first_shift_start_time()::interval;
	v_day_shift_length_interval = constant_day_shift_length()::interval;
	
	IF (in_date<>CURRENT_DATE) THEN
		v_end_time_interval = v_day_shift_length_interval;
		v_date_time_to = v_date_time_from + v_end_time_interval;
		v_avg_interval_count = ceil(EXTRACT(EPOCH FROM v_end_time_interval/(ROUND_AVG_MINUTES*60) ))::int;		
		
	ELSE
		v_date_time_to = LEAST(CURRENT_TIMESTAMP::timestamp without time zone, in_date + v_first_shift_start_interval+v_day_shift_length_interval);
		--13 hours *60*60 = 46800sec/ (5min*60sec) = 156
		v_avg_interval_count = ceil(EXTRACT(EPOCH FROM (v_date_time_to::time-v_first_shift_start_interval)/(ROUND_AVG_MINUTES*60) ))::int;		
		v_end_time_interval = LEAST(CURRENT_TIMESTAMP::time::interval-v_first_shift_start_interval, v_day_shift_length_interval);
	END IF;
	
	v_date_time_to = round_minutes(v_date_time_to, ROUND_AVG_MINUTES);	
	
	v_round_avg_interval = (ROUND_AVG_MINUTES || ' minutes ')::interval;
	v_round_min_interval = (ROUND_MIN_MINUTES || ' minutes ')::interval;

	--************************************** FROM 7-00 ***********************************
	SELECT date_trunc('second',AVG(tm)) INTO v_at_base_avg FROM at_base_time(v_date_time_from_shift_start,v_date_time_to);
	SELECT date_trunc('second',AVG(tm)) INTO v_run_avg FROM at_run_time(v_date_time_from_shift_start,v_date_time_to);
	SELECT date_trunc('second',AVG(tm)) INTO v_work_avg FROM at_work_time(v_date_time_from_shift_start,v_date_time_to);
	SELECT date_trunc('second',AVG(tm)) INTO v_at_dest_avg FROM at_dest_time(v_date_time_from_shift_start,v_date_time_to);
	--*********************************************************

	
	RETURN QUERY
		WITH veh_cnt AS (
			SELECT d,
			(SELECT ARRAY[busy_cnt,free_cnt] FROM veh_count_at_moment(d)) AS all_cnt
			FROM generate_series(v_date_time_from, v_date_time_to, v_round_avg_interval) AS d		
		),
		min_time AS (
			SELECT m.d_30
			FROM(
				SELECT d_30,AVG(cnt.all_cnt[2]) AS avg_30
				FROM generate_series(v_date_time_from, v_date_time_to, v_round_min_interval) AS d_30
				LEFT JOIN (SELECT * FROM veh_cnt) AS cnt ON cnt.d>=d_30 AND cnt.d<(d_30+v_round_min_interval)
				GROUP BY d_30
			) AS m
			ORDER BY m.avg_30 LIMIT 1
		),
		min_time_descr AS (SELECT time5_descr(d_30::time)::text || '-' || time5_descr((d_30+v_round_min_interval)::time)::text AS descr FROM min_time)

		SELECT
		'Среднее кол. свободных автом. (' || ROUND_AVG_MINUTES::text || ' мин.)' AS key,
		(SELECT round(SUM(all_cnt[2])/v_avg_interval_count,2)::text FROM veh_cnt) AS val

		UNION ALL

		SELECT
		'Среднее кол. занятых автом. (' || ROUND_AVG_MINUTES::text || ' мин.)' AS key,
		(SELECT round(SUM(all_cnt[1])/v_avg_interval_count,2)::text FROM veh_cnt) AS val

		UNION ALL

		SELECT
		'Макс. автом. на базе в миним. получасе ' || (SELECT descr FROM min_time_descr) AS key,
		(SELECT MAX(all_cnt[2])::text FROM veh_cnt WHERE d>=(SELECT d_30 FROM min_time) AND d<((SELECT d_30 FROM min_time)+v_round_avg_interval)) AS val

		UNION ALL

		SELECT
		'Дозаказать автомашин на завтра' AS key,
		(SELECT get_required_veh_count())::text AS val
		
		UNION ALL

		SELECT
		'Среднее время рейса' AS key,
		time5_descr(v_run_avg::time)::text AS val
			

		UNION ALL

		SELECT
		'Среднее время на объекте' AS key,
		time5_descr(v_at_dest_avg::time)::text AS val

		UNION ALL

		SELECT
		'Среднее время на базе' AS key,
		time5_descr(v_at_base_avg::time)::text AS val

		UNION ALL

		SELECT
		'Коэф-нт сред. на базе к раб. врем. ' || time5_descr(v_at_base_avg::time)::text || '/' || time5_descr(v_work_avg::time)::text AS key,
		(
			round( (EXTRACT(EPOCH FROM v_at_base_avg)/EXTRACT(EPOCH FROM v_work_avg))::numeric ,2)*100::numeric
		)::text || ' %' AS val

		UNION ALL

		SELECT
		'Коэф-нт раб. врем. ко всему врем. ' || time5_descr(v_work_avg::time)::text || '/' || time5_descr(v_end_time_interval::time)::text AS key,
		(
			round( (EXTRACT(EPOCH FROM v_work_avg)/EXTRACT(EPOCH FROM v_end_time_interval))::numeric ,2)*100::numeric
		)::text || ' %' AS val;
		

		
END;
$BODY$;

ALTER FUNCTION public.get_vehicle_statistics(date)
    OWNER TO beton;

