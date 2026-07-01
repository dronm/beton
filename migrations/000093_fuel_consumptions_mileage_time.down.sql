BEGIN;

ALTER TABLE fuel_consumptions DROP COLUMN IF EXISTS mileage, 
ALTER TABLE fuel_consumptions DROP COLUMN IF EXISTS timing;
ALTER TABLE fuel_consumptions DROP COLUMN IF EXISTS fuel_consumption_schema_id;

COMMIT;
