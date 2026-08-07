-- Trigger: fuel_corrections_trigger_before on public.fuel_corrections

-- DROP TRIGGER fuel_corrections_trigger_before ON public.fuel_corrections;

CREATE TRIGGER fuel_corrections_trigger_before
  BEFORE INSERT OR UPDATE OR DELETE
  ON public.fuel_corrections
  FOR EACH ROW
  EXECUTE PROCEDURE public.fuel_corrections_process();


-- DROP TRIGGER fuel_corrections_trigger_after ON public.fuel_corrections;
/*
CREATE TRIGGER fuel_corrections_trigger_after
  AFTER INSERT OR UPDATE
  ON public.fuel_corrections
  FOR EACH ROW
  EXECUTE PROCEDURE public.fuel_corrections_process();

*/
