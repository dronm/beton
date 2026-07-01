-- Trigger: fuel_consumptions_trigger_before on public.fuel_consumptions

--DROP TRIGGER fuel_consumptions_trigger_before ON public.fuel_consumptions;
/*
CREATE TRIGGER fuel_consumptions_trigger_before
  BEFORE UPDATE OR DELETE
  ON public.fuel_consumptions
  FOR EACH ROW
  EXECUTE PROCEDURE public.fuel_consumptions_process();
*/

--DROP TRIGGER fuel_consumptions_trigger_after ON public.fuel_consumptions;
CREATE TRIGGER fuel_consumptions_trigger_after
  AFTER INSERT OR UPDATE
  ON public.fuel_consumptions
  FOR EACH ROW
  EXECUTE PROCEDURE public.fuel_consumptions_process();
