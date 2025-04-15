-- Function: public.shipment_process()

-- DROP FUNCTION public.shipment_process();

CREATE OR REPLACE FUNCTION public.shipment_process()
  RETURNS trigger AS
$BODY$
DECLARE quant_rest numeric;
	v_vehicle_load_capacity vehicles.load_capacity%TYPE DEFAULT 0;
	--v_vehicle_feature vehicles.feature%TYPE;
	v_ord_date_time timestamp;
	v_destination_id int;
	--v_tracker_id varchar(15);
	--v_shift_open boolean;
BEGIN
	/*
	IF (TG_OP='UPDATE' AND NEW.shipped AND OLD.shipped) THEN
		--closed shipment, but trying to change smth
		RAISE EXCEPTION 'Для возможности изменения отмените отгрузку!';
	END IF;
	*/

	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE' AND OLD.shipped=true) THEN
		--register actions
		PERFORM ra_materials_remove_acts('shipment'::doc_types,NEW.id);
		PERFORM ra_material_consumption_remove_acts('shipment'::doc_types,NEW.id);
	END IF;
	
	IF (TG_WHEN='BEFORE' AND TG_OP='UPDATE'
	AND (OLD.vehicle_schedule_id<>NEW.vehicle_schedule_id OR OLD.id<>NEW.id)
	)
	THEN
		--
		DELETE FROM vehicle_schedule_states t WHERE t.shipment_id = OLD.id AND t.schedule_id = OLD.vehicle_schedule_id;	
	END IF;
	
	-- vehicle data
	/*
	IF (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN

		IF (v_vehicle_feature IS NULL)
		OR (
			(v_vehicle_feature<>const_own_vehicles_feature_val())
			AND (v_vehicle_feature<>const_backup_vehicles_feature_val()) 
		) THEN
			SELECT orders.destination_id INTO v_destination_id FROM orders WHERE orders.id=NEW.order_id;
			IF v_destination_id <> const_self_ship_dest_id_val() THEN
				RAISE EXCEPTION 'Данному автомобилю запрещено вывозить на этот объект!';
			END IF;
		END IF;
		
		--IF (TG_OP='INSERT' AND coalesce(v_tracker_id, '') <> '') THEN
			--NEW.production_base_id = veh_cur_production_base_id(v_tracker_id);
		--END IF;
	END IF;
	*/
	
	--checkings for bereg only! (current_database()::text <> 'concrete1') AND 
	IF (TG_OP='INSERT' OR (TG_OP='UPDATE' AND NEW.shipped=false AND OLD.shipped=false)) THEN
		SELECT
			v.load_capacity
		INTO
			v_vehicle_load_capacity
		FROM vehicle_schedules AS vs
		LEFT JOIN vehicles AS v ON v.id = vs.vehicle_id
		WHERE vs.id = NEW.vehicle_schedule_id;	
	
		-- ********** check balance ****************************************
		SELECT
			o.quant - SUM(COALESCE(s.quant,0)),
			o.date_time
		INTO
			quant_rest,
			v_ord_date_time
		FROM orders AS o
		LEFT JOIN shipments AS s ON s.order_id=o.id	
		WHERE o.id = NEW.order_id
		GROUP BY o.quant,o.date_time;

		--order shift date MUST overlap shipment shift date!		
		--IF get_shift_start(NEW.date_time)<>get_shift_start(v_ord_date_time) THEN
		--	RAISE EXCEPTION 'Заявка из другой смены!';
		--END IF;
		

		IF (TG_OP='UPDATE') THEN
			quant_rest:= quant_rest + OLD.quant;
		END IF;
		
		IF (quant_rest<NEW.quant::numeric) THEN
			RAISE EXCEPTION 'Остаток по данной заявке: %, запрошено: %',quant_descr(quant_rest::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- ********** check balance ****************************************

		
		-- *********  check load capacity *************************************		
		IF v_vehicle_load_capacity < NEW.quant THEN
			RAISE EXCEPTION 'Грузоподъемность автомобиля: "%", запрошено: %',quant_descr(v_vehicle_load_capacity::numeric),quant_descr(NEW.quant::numeric);
		END IF;
		-- *********  check load capacity *************************************
	END IF;

	IF TG_OP='UPDATE' THEN
		IF (NEW.shipped AND OLD.shipped=false) THEN
			NEW.ship_date_time = current_timestamp;
			
			--Если есть привязанное производство - пересчитать
			--возможно изменение отклонений при списании материалов по подбору
			UPDATE productions
			SET
				material_tolerance_violated = productions_get_mat_tolerance_violated(
					production_site_id,
					production_id
				)				
			WHERE shipment_id=NEW.id;
			
		ELSEIF (OLD.shipped AND NEW.shipped=false) THEN
			NEW.ship_date_time = null;
		END IF;
		
		IF (NEW.order_id <> OLD.order_id) THEN
			/** смена заявки
			 * 1) Удалить vehicle_schedule_states сданным id отгрузки и статусом at_dest, как будто и не доехал еще
			 * 2) Исправить все оставшиеся vehicle_schedule_states where shipment_id = NEW.id на новый destionation_id из orders
			 */
			DELETE FROM vehicle_schedule_states WHERE shipment_id = NEW.id AND state= 'at_dest'::vehicle_states;
			UPDATE vehicle_schedule_states
			SET
				destination_id = (SELECT orders.destination_id FROM orders WHERE orders.id=NEW.order_id)
			WHERE shipment_id = NEW.id;
		END IF;
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.shipment_process()
  OWNER TO ;

