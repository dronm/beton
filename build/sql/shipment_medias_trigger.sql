-- Trigger: shipment_media_trigger_before on public.shipment_media

-- DROP TRIGGER shipment_media_trigger_before ON public.shipment_media;


CREATE TRIGGER shipment_media_trigger_before
  BEFORE INSERT
  ON public.shipment_media
  FOR EACH ROW
  EXECUTE PROCEDURE public.shipment_media_process();

