-- View: public.pump_vehicles_list

-- DROP VIEW public.pump_vehicles_list;

CREATE OR REPLACE VIEW public.pump_vehicles_list
 AS
 SELECT pv.id,
    pv.vehicle_id,
    pv.phone_cel,
    pv.pump_price_id,
    ppr.name AS pump_price_descr,
    v.plate,
    (((v.plate::text || ' '::text) || v.make::text) || ' '::text) || v.owner::text AS vehicle_descr,
    pv.driver_ship_inform
    
   FROM pump_vehicles pv
     LEFT JOIN vehicles v ON v.id = pv.vehicle_id
     LEFT JOIN pump_prices ppr ON ppr.id = pv.pump_price_id
  ORDER BY v.plate;

ALTER TABLE public.pump_vehicles_list
    OWNER TO beton;

