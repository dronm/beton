
-- Function: public.vehicles_fuel_consumption(in_vehicle_id int, in_date_from timestampTZ, in_date_to timestampTZ);

-- DROP FUNCTION public.vehicles_fuel_consumption(in_vehicle_id int, in_date_from timestampTZ, in_date_to timestampTZ);

-- calculates fuel consumption for a vehicle and a given period.
-- mileage and timing should be calculated first and stored in vehicle_mileages.
-- If a vehicle has a special fuel schema, then this schema used,
-- otherwise a common vehicle schema is used.

CREATE OR REPLACE FUNCTION public.vehicles_fuel_consumption(in_vehicle_id int, in_date_from timestampTZ, in_date_to timestampTZ)
  RETURNS int AS
$BODY$
	SELECT 

$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
