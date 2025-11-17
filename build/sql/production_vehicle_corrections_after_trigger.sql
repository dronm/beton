
CREATE OR REPLACE TRIGGER production_vehicle_corrections_after_trigger
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.production_vehicle_corrections
    FOR EACH ROW
    EXECUTE FUNCTION public.production_vehicle_corrections_process();

