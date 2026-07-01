BEGIN;

ALTER TABLE fuel_consumptions
	ADD COLUMN IF NOT EXISTS mileage int,
	ADD COLUMN IF NOT EXISTS timing interval,
	ADD COLUMN IF NOT EXISTS fuel_consumption_schema_id int,
	ADD CONSTRAINT fk_fuel_consumptions_schema_id
		FOREIGN KEY (fuel_consumption_schema_id)
		REFERENCES fuel_consumption_schema (id);

COMMIT;
