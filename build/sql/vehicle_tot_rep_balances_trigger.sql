-- Trigger: vehicle_tot_rep_balances_trigger_after on public.vehicle_tot_rep_balances

-- DROP TRIGGER vehicle_tot_rep_balances_trigger_after ON public.vehicle_tot_rep_balances;


CREATE TRIGGER vehicle_tot_rep_balances_trigger_after
  AFTER UPDATE OR INSERT OR DELETE
  ON public.vehicle_tot_rep_balances
  FOR EACH ROW
  EXECUTE PROCEDURE public.vehicle_tot_rep_balances_process();

