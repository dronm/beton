-- Trigger: order_trigger_after

-- DROP TRIGGER IF EXISTS order_trigger_after ON public.orders;

CREATE OR REPLACE TRIGGER order_trigger_after
    AFTER INSERT OR UPDATE OR DELETE
    ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.order_after_process();
