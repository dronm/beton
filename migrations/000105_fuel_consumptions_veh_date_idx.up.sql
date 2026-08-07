CREATE UNIQUE INDEX fuel_consumptions_vehicle_date_idx 
ON fuel_consumptions (vehicle_id, date_time);
