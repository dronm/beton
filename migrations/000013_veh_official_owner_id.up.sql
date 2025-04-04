		ALTER TABLE public.vehicles ADD COLUMN official_vehicle_owner_id int REFERENCES vehicle_owners(id);

