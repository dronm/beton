-- FUNCTION: public.vehicle_mileages_insert_fuel_consumption()

 --DROP FUNCTION IF EXISTS public.vehicle_mileages_insert_fuel_consumption();

CREATE OR REPLACE FUNCTION public.vehicle_mileages_process()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
	BEGIN
		PERFORM public.vehicle_fuel_consumption_insert(
			NEW.vehicle_id,
			NEW.for_date,
			NEW.mileage,
			NEW.timing
		);

		RETURN NEW;
	END;
	
$BODY$;
