-- Function: set_vehicle_schedule_free(in_schedule_id integer, in_production_base_id integer)

-- DROP FUNCTION set_vehicle_schedule_free(in_schedule_id integer, in_production_base_id integer);

CREATE OR REPLACE FUNCTION set_vehicle_schedule_free(in_schedule_id integer, in_production_base_id integer)
  RETURNS void AS
$BODY$
DECLARE cur_state vehicle_states;
	cur_state_id int;
	cur_date date;	
	v_tracker_id character varying(15);
BEGIN
	--RAISE EXCEPTION 'in_production_base_id=%', in_production_base_id;
	SELECT state,id INTO cur_state,cur_state_id FROM vehicle_schedule_states WHERE schedule_id=in_schedule_id ORDER BY date_time DESC LIMIT 1;
	
	IF (cur_state = 'out'::vehicle_states) 
	OR (cur_state = 'out_from_shift'::vehicle_states)
	THEN
		--get previous state
		SELECT
			state
		INTO
			cur_state
		FROM vehicle_schedule_states
		WHERE schedule_id = in_schedule_id
		ORDER BY date_time DESC
		LIMIT 1 OFFSET 1;
		
		--delete out comment which will delete out state
		DELETE FROM out_comments WHERE vehicle_schedule_id=in_schedule_id;
	END IF;
	
	IF cur_state != 'free'::vehicle_states THEN
		SELECT schedule_date INTO cur_date FROM vehicle_schedules WHERE id = in_schedule_id;
		
		IF (cur_date <> get_shift_start(current_timestamp::timestamp without time zone)::date ) THEN
			RAISE EXCEPTION 'Нельзя освободить автомобиль на будущую дату!';
		END IF;
		
		v_tracker_id = get_vehicle_tracker_id_on_schedule_id(in_schedule_id);
		INSERT INTO vehicle_schedule_states
		(date_time, state, schedule_id, tracker_id, production_base_id)
		VALUES(
			current_timestamp,
			'free'::vehicle_states,
			in_schedule_id,
			get_vehicle_tracker_id_on_schedule_id(in_schedule_id),
			--veh_cur_production_base_id(v_tracker_id)
			in_production_base_id
		);
	END IF;

--EXCEPTION WHEN raise_exception THEN
--	RAISE EXCEPTION 'Нет возможности добавить автомобиль!';
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION set_vehicle_schedule_free(in_schedule_id integer, in_production_base_id integer) OWNER TO ;

