-- View: public.car_tracking_malfunctions_list

-- DROP VIEW public.car_tracking_malfunctions_list;

CREATE OR REPLACE VIEW public.car_tracking_malfunctions_list
 AS
 SELECT vh.plate,
    vh.tracker_id
   FROM vehicle_schedules vs
     LEFT JOIN vehicles vh ON vh.id = vs.vehicle_id
  WHERE vs.schedule_date = now()::date AND (( SELECT vss.state
           FROM vehicle_schedule_states vss
          WHERE vss.schedule_id = vs.id
          ORDER BY vss.date_time DESC
         LIMIT 1)) = 'busy'::vehicle_states AND COALESCE(vh.tracker_id::text, ''::text) <> ''::text AND (now() - ((( SELECT tr.period
           FROM car_tracking tr
          WHERE tr.car_id::text = vh.tracker_id::text
          ORDER BY tr.period DESC
         LIMIT 1)) + (now() - timezone('utc'::text, now())::timestamp with time zone))::timestamp with time zone) >= '01:00:00'::interval;

ALTER TABLE public.car_tracking_malfunctions_list
    OWNER TO ;


