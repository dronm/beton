-- Trigger: order_trigger_after

-- DROP TRIGGER IF EXISTS order_trigger_after ON public.orders;

CREATE OR REPLACE TRIGGER order_trigger_after
    AFTER INSERT OR UPDATE OR DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_after_process();

    
-- DROP TRIGGER IF EXISTS order_trigger_before_delete ON public.orders;

CREATE OR REPLACE TRIGGER order_trigger_before_delete
    BEFORE DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_delete();
    
-- DROP TRIGGER IF EXISTS order_process_before_insert ON public.orders;

CREATE OR REPLACE TRIGGER order_process_before_insert
    BEFORE INSERT
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_process();
    
-- DROP TRIGGER IF EXISTS order_process_before_update ON public.orders;

CREATE OR REPLACE TRIGGER order_process_before_update
    BEFORE UPDATE 
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_process();            

