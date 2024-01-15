-- Trigger:client_tels_trigger_before on public.client_tels

-- DROP TRIGGER client_tels_trigger_before ON public.client_tels;

CREATE TRIGGER items_trigger_before
BEFORE INSERT OR UPDATE
  ON public.client_tels
  FOR EACH ROW
  EXECUTE PROCEDURE public.client_tels_process();


