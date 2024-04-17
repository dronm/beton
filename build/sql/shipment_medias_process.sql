-- Function: shipment_media_process()

-- DROP FUNCTION shipment_media_process();

CREATE OR REPLACE FUNCTION shipment_media_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='BEFORE' AND TG_OP='INSERT') THEN
		SELECT
			st.shipment_id,
			sh.order_id
		INTO
			NEW.shipment_id,
			NEW.order_id
			
		FROM vehicle_schedule_states AS st
		LEFT JOIN shipments AS sh ON sh.id = st.shipment_id
		WHERE st.schedule_id = (
			SELECT sch.id
			FROM vehicle_schedules AS sch
			WHERE sch.schedule_date = now()::date
				AND sch.driver_id = NEW.driver_id
			LIMIT 1
		)
		ORDER BY st.date_time DESC
		LIMIT 1;
	
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION shipment_media_process()
  OWNER TO ;

