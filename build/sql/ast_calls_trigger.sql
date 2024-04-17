-- Trigger: ast_calls_trigger_before

-- DROP TRIGGER ast_calls_trigger_before ON public.ast_calls;

CREATE TRIGGER ast_calls_trigger_before
    BEFORE INSERT OR UPDATE 
    ON public.ast_calls
    FOR EACH ROW
    EXECUTE PROCEDURE public.ast_calls_process();
