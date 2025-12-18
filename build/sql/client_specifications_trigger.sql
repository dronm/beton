-- Trigger:client_specification_trigger_before on public.client_specifications

-- DROP TRIGGER client_specification_trigger_before ON public.client_specifications;

CREATE TRIGGER client_specification_trigger_before
BEFORE INSERT OR UPDATE
  ON public.client_specifications
  FOR EACH ROW
  EXECUTE PROCEDURE public.client_specifications_process();



