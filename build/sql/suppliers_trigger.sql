-- Trigger: suppliers_trigger_before on public.suppliers

-- DROP TRIGGER suppliers_trigger_before ON public.suppliers;

CREATE TRIGGER suppliers_trigger_before
  BEFORE INSERT OR UPDATE
  ON public.suppliers
  FOR EACH ROW
  EXECUTE PROCEDURE public.suppliers_process();

