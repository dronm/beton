-- Trigger: const_ping1c_trigger_after

-- DROP TRIGGER IF EXISTS const_ping1c_trigger_after ON public.const_ping1c;

CREATE OR REPLACE TRIGGER const_ping1c_trigger_after
    AFTER UPDATE
    ON public.const_ping1c
    FOR EACH ROW
    EXECUTE FUNCTION public.const_ping1c_process();

