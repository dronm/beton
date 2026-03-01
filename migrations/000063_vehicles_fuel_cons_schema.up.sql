ALTER TABLE public.vehicles ADD COLUMN fuel_consumption_schema_id int REFERENCES fuel_consumption_schema(id);

