-- Function: vehicle_tot_rep_balances_process()

-- DROP FUNCTION vehicle_tot_rep_balances_process();

CREATE OR REPLACE FUNCTION vehicle_tot_rep_balances_process()
  RETURNS trigger AS
$BODY$
DECLARE
	v_delta numeric(15,2);
	v_period date;
	v_vehicle_owner_id int;
BEGIN
	IF TG_OP='UPDATE' AND OLD.period <> NEW.period THEN
		RAISE EXCEPTION 'Нельзя менять период записи. Удалите запись.';
	END IF;
		
	IF TG_OP='INSERT' THEN
		v_delta = NEW.value;
		v_period = NEW.period;
		v_vehicle_owner_id = NEW.vehicle_owner_id;
		
	ELSIF TG_OP='UPDATE' THEN
		v_delta = NEW.value - OLD.value;
		v_period = NEW.period;
		v_vehicle_owner_id = NEW.vehicle_owner_id;
		
	ELSE
		v_period = OLD.period;
		v_delta = OLD.value * -1;
		v_vehicle_owner_id = OLD.vehicle_owner_id;
	END IF;	

	UPDATE vehicle_tot_rep_balances
	SET value = value - v_delta
	WHERE period > v_period AND vehicle_owner_id = v_vehicle_owner_id;
	
	DELETE FROM vehicle_tot_rep_balances
	WHERE period > v_period AND vehicle_owner_id = v_vehicle_owner_id AND coalesce(value,0) = 0;
	
	IF TG_OP='UPDATE' OR TG_OP='INSERT' THEN
		RETURN NEW;
	ELSE
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vehicle_tot_rep_balances_process()
  OWNER TO ;

