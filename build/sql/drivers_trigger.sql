-- Trigger: drivers_trigger_before on public.drivers

-- DROP TRIGGER drivers_trigger_before ON public.drivers;

CREATE TRIGGER drivers_trigger_before
  BEFORE INSERT OR UPDATE
  ON public.drivers
  FOR EACH ROW
  EXECUTE PROCEDURE public.drivers_process();

