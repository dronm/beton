
-- Trigger: user_operations_trigger_before on public.user_operations

-- DROP TRIGGER user_operations_trigger_before ON public.user_operations;


CREATE TRIGGER user_operations_trigger_before
  AFTER UPDATE OR INSERT
  ON public.user_operations
  FOR EACH ROW
  EXECUTE PROCEDURE public.user_operations_process();

