-- Trigger: vehicle_schedules_trigger_after

-- DROP TRIGGER IF EXISTS vehicle_schedules_trigger_after ON public.vehicle_schedules;

CREATE OR REPLACE TRIGGER vehicle_schedules_trigger_after
    AFTER UPDATE OR DELETE
    ON public.vehicle_schedules
    FOR EACH ROW
    EXECUTE FUNCTION public.vehicle_schedules_after_process();

