-- Trigger: pump_vehicles_trigger_before on public.pump_vehicles

-- DROP TRIGGER pump_vehicles_trigger_before ON public.pump_vehicles;

CREATE TRIGGER pump_vehicles_trigger_before
  BEFORE INSERT OR UPDATE
  ON public.pump_vehicles
  FOR EACH ROW
  EXECUTE PROCEDURE public.pump_vehicles_process();

