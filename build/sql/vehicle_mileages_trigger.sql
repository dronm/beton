-- Trigger: vehicle_mileages_trigger_after

-- DROP TRIGGER IF EXISTS vehicle_mileages_trigger_after ON public.vehicle_mileages;

CREATE OR REPLACE TRIGGER vehicle_mileages_fuel_consumption_ai
    AFTER INSERT OR UPDATE
    ON public.vehicle_mileages
    FOR EACH ROW
    EXECUTE FUNCTION public.vehicle_mileages_process();

