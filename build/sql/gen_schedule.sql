-- FUNCTION: public.gen_schedule(in_edit_user_id int, in_production_base_id int, in_vehicle_id int, in_dt_from timestamp without time zone, in_dt_to timestamp without time zone, in_mon boolean, in_tue boolean, in_wnd boolean, in_thr boolean, in_fr boolean, in_std boolean, in_snd boolean)

-- DROP FUNCTION public.gen_schedule(in_edit_user_id int, in_production_base_id int, in_vehicle_id int, in_dt_from timestamp without time zone, in_dt_to timestamp without time zone, in_mon boolean, in_tue boolean, in_wnd boolean, in_thr boolean, in_fr boolean, in_std boolean, in_snd boolean);

CREATE OR REPLACE FUNCTION public.gen_schedule(
	in_edit_user_id int,
	in_production_base_id int,
	in_vehicle_id int,
	in_dt_from timestamp without time zone,
	in_dt_to timestamp without time zone,
	in_mon boolean,
	in_tue boolean,
	in_wnd boolean,
	in_thr boolean,
	in_fr boolean,
	in_std boolean,
	in_snd boolean
)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
	dt timestamp without time zone;
	day_of_week int;
	query_text text:= '';
	query_num int:=0;
	v_driver_id int;
BEGIN
--RAISE EXCEPTION 'in_production_base_id=%',in_production_base_id;
	DELETE FROM vehicle_schedules WHERE
		production_base_id = in_production_base_id
		AND vehicle_id = in_vehicle_id
		AND schedule_date BETWEEN in_dt_from AND in_dt_to;
		
	SELECT v.driver_id INTO v_driver_id FROM vehicles AS v
	WHERE v.id = in_vehicle_id;

	dt = in_dt_from;
	WHILE dt <= in_dt_to LOOP
		day_of_week = EXTRACT(DOW FROM dt);
		IF (in_mon = TRUE AND day_of_week=1)
		OR (in_tue = TRUE AND day_of_week=2)
		OR (in_wnd = TRUE AND day_of_week=3)
		OR (in_thr = TRUE AND day_of_week=4)
		OR (in_fr = TRUE AND day_of_week=5)
		OR (in_std = TRUE AND day_of_week=6)
		OR (in_snd = TRUE AND day_of_week=0) THEN
			IF (query_num>0) THEN
				query_text = query_text || ',';
			END IF;
			query_text = query_text || '(''' || dt::date::text || '''::date, ' ||
				in_edit_user_id::text || ',' ||
				in_production_base_id::text || ',' ||
				in_vehicle_id::text || ',' ||
				v_driver_id::text || ', true)';
			query_num = query_num + 1;
		END IF;
		dt = dt + interval '1 day';
	END LOOP;

	IF (query_num>0) THEN
		--RAISE EXCEPTION 'INSERT INTO vehicle_schedules (schedule_date,production_base_id,vehicle_id,driver_id,auto_gen) VALUES %',query_text;
		EXECUTE 'INSERT INTO vehicle_schedules (schedule_date, edit_user_id, production_base_id, vehicle_id, driver_id, auto_gen) VALUES ' || query_text;
	END IF;
	

END;
$BODY$;

ALTER FUNCTION public.gen_schedule(in_edit_user_id int, in_production_base_id int, in_vehicle_id int, in_dt_from timestamp without time zone, in_dt_to timestamp without time zone, in_mon boolean, in_tue boolean, in_wnd boolean, in_thr boolean, in_fr boolean, in_std boolean, in_snd boolean)
    OWNER TO ;

