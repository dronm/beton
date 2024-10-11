create trigger shipment_process_before_delete before
delete
    on
    public.shipments for each row execute function set_vehicle_free()
    
create trigger shipment_process_after_insert after
insert
    on
    public.shipments for each row execute function set_vehicle_busy()    
    
create trigger shipment_process_after_update after
update
    on
    public.shipments for each row execute function set_vehicle_busy()
    
create trigger shipment_process_before_insert before
insert
    on
    public.shipments for each row execute function shipment_process()
    
create trigger shipment_process_before_update before
update
    on
    public.shipments for each row execute function shipment_process()            
