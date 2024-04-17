-- Trigger: quality_passports_before

-- DROP TRIGGER quality_passports_before ON public.quality_passports;

CREATE TRIGGER quality_passports_before
    BEFORE INSERT
    ON public.quality_passports
    FOR EACH ROW
    EXECUTE PROCEDURE public.quality_passports_process();    
