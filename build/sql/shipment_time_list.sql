-- View: public.shipment_time_list

-- DROP VIEW public.shipment_time_list;

CREATE OR REPLACE VIEW public.shipment_time_list
 AS
 SELECT sh.id,
    o.client_id,
    cl.name AS client_descr,
    o.destination_id,
    dest.name AS destination_descr,
    sh.quant,
    vh.vh_plate AS vehicle_plate,
    vh.dr_id AS driver_id,
    vh.dr_name AS driver_descr,
    vh.assign_date_time,
    time5_descr(vh.assign_date_time) AS assign_date_time_descr,
    sh.ship_date_time,
    time5_descr(sh.ship_date_time) AS ship_date_time_descr,
        CASE
            WHEN round((date_part('epoch'::text, COALESCE(vh.assign_date_time - (( SELECT t2.date_time
               FROM shipments t1
                 LEFT JOIN vehicle_schedule_states t2 ON t2.shipment_id = t1.id AND t2.state = 'busy'::vehicle_states
              WHERE t1.date_time < sh.date_time AND get_shift_start(t1.date_time) = get_shift_start(sh.date_time)
              ORDER BY t1.date_time DESC
             LIMIT 1)), '00:00:00'::interval)) / 60::double precision)::numeric, 0) > 0::numeric THEN round((date_part('epoch'::text, COALESCE(vh.assign_date_time - (( SELECT t2.date_time
               FROM shipments t1
                 LEFT JOIN vehicle_schedule_states t2 ON t2.shipment_id = t1.id AND t2.state = 'busy'::vehicle_states
              WHERE t1.date_time < sh.date_time AND get_shift_start(t1.date_time) = get_shift_start(sh.date_time)
              ORDER BY t1.date_time DESC
             LIMIT 1)), '00:00:00'::interval)) / 60::double precision)::numeric, 0)
            ELSE 0::numeric
        END AS dispatcher_fail_min,
    shipment_time_norm(sh.quant::numeric) AS ship_time_norm,
    round((date_part('epoch'::text, sh.ship_date_time - vh.assign_date_time) / 60::double precision)::numeric, 0) - shipment_time_norm(sh.quant::numeric)::numeric AS operator_fail_min,
        CASE
            WHEN round((date_part('epoch'::text, COALESCE(vh.assign_date_time - (( SELECT t2.date_time
               FROM shipments t1
                 LEFT JOIN vehicle_schedule_states t2 ON t2.shipment_id = t1.id AND t2.state = 'busy'::vehicle_states
              WHERE t1.date_time < sh.date_time AND get_shift_start(t1.date_time) = get_shift_start(sh.date_time)
              ORDER BY t1.date_time DESC
             LIMIT 1)), '00:00:00'::interval)) / 60::double precision)::numeric, 0) > 0::numeric THEN round((date_part('epoch'::text, COALESCE(vh.assign_date_time - (( SELECT t2.date_time
               FROM shipments t1
                 LEFT JOIN vehicle_schedule_states t2 ON t2.shipment_id = t1.id AND t2.state = 'busy'::vehicle_states
              WHERE t1.date_time < sh.date_time AND get_shift_start(t1.date_time) = get_shift_start(sh.date_time)
              ORDER BY t1.date_time DESC
             LIMIT 1)), '00:00:00'::interval)) / 60::double precision)::numeric, 0)
            ELSE 0::numeric
        END + (round((date_part('epoch'::text, sh.ship_date_time - vh.assign_date_time) / 60::double precision)::numeric, 0) - shipment_time_norm(sh.quant::numeric)::numeric) AS total_fail_min
   FROM shipments sh
     LEFT JOIN orders o ON o.id = sh.order_id
     LEFT JOIN clients cl ON cl.id = o.client_id
     LEFT JOIN destinations dest ON dest.id = o.destination_id
     LEFT JOIN ( SELECT t.shipment_id,
            max(t.date_time) AS assign_date_time,
            vh_1.plate AS vh_plate,
            vs.driver_id AS dr_id,
            dr.name AS dr_name
           FROM vehicle_schedule_states t
             LEFT JOIN vehicle_schedules vs ON vs.id = t.schedule_id
             LEFT JOIN vehicles vh_1 ON vh_1.id = vs.vehicle_id
             LEFT JOIN drivers dr ON dr.id = vs.driver_id
          WHERE t.state = 'assigned'::vehicle_states
          GROUP BY t.shipment_id, vh_1.plate, vs.driver_id, dr.name) vh ON vh.shipment_id = sh.id
  ORDER BY sh.ship_date_time DESC;

ALTER TABLE public.shipment_time_list
    OWNER TO beton;

GRANT ALL ON TABLE public.shipment_time_list TO beton;
GRANT SELECT ON TABLE public.shipment_time_list TO premier;


