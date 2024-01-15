-- Trigger: sms_for_sending_trigger_after on public.sms_for_sending

-- DROP TRIGGER sms_for_sending_trigger_after ON public.sms_for_sending;


CREATE TRIGGER sms_for_sending_trigger_after
  AFTER INSERT
  ON public.sms_for_sending
  FOR EACH ROW
  EXECUTE PROCEDURE public.sms_for_sending_process();

