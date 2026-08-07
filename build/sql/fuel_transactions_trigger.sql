-- Trigger: fuel_transactions_trigger_before on public.fuel_transactions

--DROP TRIGGER fuel_transactions_trigger_before ON public.fuel_transactions;

CREATE TRIGGER fuel_transactions_trigger_before
  BEFORE UPDATE OR DELETE OR INSERT
  ON public.fuel_transactions
  FOR EACH ROW
  EXECUTE PROCEDURE public.fuel_transactions_process();

--DROP TRIGGER fuel_transactions_trigger_after ON public.fuel_transactions;
/*
CREATE TRIGGER fuel_transactions_trigger_after
  AFTER INSERT OR UPDATE
  ON public.fuel_transactions
  FOR EACH ROW
  EXECUTE PROCEDURE public.fuel_transactions_process();
*/
