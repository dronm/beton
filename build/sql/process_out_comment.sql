-- FUNCTION: public.process_out_comment()

-- DROP FUNCTION IF EXISTS public.process_out_comment();

CREATE OR REPLACE FUNCTION public.process_out_comment()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
DECLARE init_state vehicle_states;
/*
	v_veh_at_work_count bigint;
	veh_count int;
	v_vehicle_main boolean;
*/	
BEGIN
	IF (TG_OP = 'DELETE') THEN
		/*
		SELECT is_vehicle_main(v.feature) INTO v_vehicle_main FROM vehicle_schedules AS vs
		LEFT JOIN vehicles AS v ON v.id=vs.vehicle_id
		WHERE vs.id=OLD.vehicle_schedule_id;

		IF (v_vehicle_main) THEN
			--check max allowed vehicles count
			SELECT * INTO v_veh_at_work_count FROM get_working_vehicles_count_main(
				(SELECT vehicle_schedules.schedule_date FROM vehicle_schedules WHERE vehicle_schedules.id = OLD.vehicle_schedule_id)
			);

			veh_count = constant_max_vehicle_at_work();
			IF v_veh_at_work_count>=veh_count THEN
				RAISE EXCEPTION 'Максимально допустимое количество машин на линии: %. Нет возможности добавить еще.',veh_count;
			END IF;
		END IF;
		*/	
		DELETE FROM vehicle_schedule_states WHERE schedule_id=OLD.vehicle_schedule_id AND (state='out'::vehicle_states) OR (state='out_from_shift'::vehicle_states);
		RETURN OLD;
	ELSIF (TG_OP = 'INSERT') THEN
		SELECT state INTO init_state FROM vehicle_schedule_states WHERE schedule_id=NEW.vehicle_schedule_id ORDER BY date_time LIMIT 1;
		INSERT INTO vehicle_schedule_states (date_time,state,schedule_id) VALUES (current_timestamp,
		CASE init_state
			WHEN 'shift'::vehicle_states THEN 'out_from_shift'::vehicle_states
			ELSE 'out'::vehicle_states
		END,
		NEW.vehicle_schedule_id);
		RETURN NEW;
	END IF;
END;
$BODY$;

ALTER FUNCTION public.process_out_comment()
    OWNER TO beton;

