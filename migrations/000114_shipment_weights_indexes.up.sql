BEGIN;
	DROP INDEX IF EXISTS shipment_weights_cause_idx;
	CREATE INDEX shipment_weights_cause_idx
	ON shipment_weights(ship_weighing_cause);

	DROP INDEX IF EXISTS shipment_weights_date_time_idx;
	CREATE INDEX shipment_weights_date_time_idx
	ON shipment_weights(date_time);
COMMIT;
