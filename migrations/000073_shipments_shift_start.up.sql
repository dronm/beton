begin;
 DROP TRIGGER IF EXISTS audit_log_shipments ON public.shipments;
 DROP TRIGGER IF EXISTS shipment_process_after_insert ON public.shipments;
 DROP TRIGGER IF EXISTS shipment_process_after_update ON public.shipments;
 DROP TRIGGER IF EXISTS shipment_process_before_delete ON public.shipments;
 DROP TRIGGER IF EXISTS shipment_process_before_insert ON public.shipments;
 DROP TRIGGER IF EXISTS shipment_process_before_update ON public.shipments;

ALTER TABLE shipments ADD COLUMN shift_start_ts timestamp;

UPDATE shipments SET shift_start_ts = get_shift_start(ship_date_time);

CREATE INDEX IF NOT EXISTS shipments_shift_start_ts_idx
ON shipments (shift_start_ts DESC);

CREATE OR REPLACE TRIGGER audit_log_shipments
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.shipments
    FOR EACH ROW
    EXECUTE FUNCTION public.audit_log_process();
CREATE OR REPLACE TRIGGER shipment_process_after_insert
    AFTER INSERT
    ON public.shipments
    FOR EACH ROW
    EXECUTE FUNCTION public.set_vehicle_busy();
CREATE OR REPLACE TRIGGER shipment_process_after_update
    AFTER UPDATE 
    ON public.shipments
    FOR EACH ROW
    EXECUTE FUNCTION public.set_vehicle_busy();
CREATE OR REPLACE TRIGGER shipment_process_before_delete
    BEFORE DELETE
    ON public.shipments
    FOR EACH ROW
    EXECUTE FUNCTION public.set_vehicle_free();
CREATE OR REPLACE TRIGGER shipment_process_before_insert
    BEFORE INSERT
    ON public.shipments
    FOR EACH ROW
    EXECUTE FUNCTION public.shipment_process();
CREATE OR REPLACE TRIGGER shipment_process_before_update
    BEFORE UPDATE 
    ON public.shipments
    FOR EACH ROW
    EXECUTE FUNCTION public.shipment_process();

CREATE TRIGGER shipments_set_shift_start_ts_trg
BEFORE INSERT OR UPDATE OF ship_date_time
ON shipments
FOR EACH ROW
EXECUTE FUNCTION shipments_set_shift_start_ts();

commit;
