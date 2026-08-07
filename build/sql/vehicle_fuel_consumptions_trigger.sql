	CREATE OR REPLACE FUNCTION public.vehicle_mileages_insert_fuel_consumption()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE
	AS $function$
	BEGIN
		PERFORM public.vehicle_fuel_consumption_insert(
			NEW.vehicle_id,
			NEW.for_date,
			NEW.mileage,
			NEW.timing
		);

		RETURN NEW;
	END;
	$function$;


	DROP TRIGGER IF EXISTS vehicle_mileages_fuel_consumption_ai
		ON public.vehicle_mileages;

	CREATE TRIGGER vehicle_mileages_fuel_consumption_ai
		AFTER INSERT
		ON public.vehicle_mileages
		FOR EACH ROW
		EXECUTE FUNCTION public.vehicle_mileages_insert_fuel_consumption();
