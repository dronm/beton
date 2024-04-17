-- Trigger: gornyi_carrier_match_trigger_after

-- DROP TRIGGER gornyi_carrier_match_trigger_after ON public.gornyi_carrier_match;

CREATE TRIGGER gornyi_carrier_match_trigger_after
    AFTER INSERT OR UPDATE 
    ON public.gornyi_carrier_match
    FOR EACH ROW
    EXECUTE PROCEDURE public.gornyi_carrier_match_process();
