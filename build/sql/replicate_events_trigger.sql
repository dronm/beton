-- Trigger: replicate_events_after_insert

-- DROP TRIGGER IF EXISTS replicate_events_after_insert ON public.replicate_events;

CREATE OR REPLACE TRIGGER replicate_events_after_insert
    AFTER INSERT
    ON public.replicate_events
    FOR EACH ROW
    EXECUTE FUNCTION public.replicate_events_process();
