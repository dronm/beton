-- View: public.broken_trackers_list_view

-- DROP VIEW public.broken_trackers_list_view;

CREATE OR REPLACE VIEW public.broken_trackers_list_view
 AS
 SELECT sub.plate,
    sub.tracker_id,
    sub.last_data
   FROM ( SELECT DISTINCT ON (v.id) v.plate,
            v.tracker_id,
            ( SELECT car_tracking.period + age(now(), timezone('UTC'::text, now())::timestamp with time zone)
                   FROM car_tracking
                  WHERE car_tracking.car_id::text = v.tracker_id::text
                  ORDER BY car_tracking.period DESC
                 LIMIT 1) AS last_data
           FROM vehicle_schedule_states st
             LEFT JOIN vehicle_schedules vs ON vs.id = st.schedule_id
             LEFT JOIN vehicles v ON v.id = vs.vehicle_id
          WHERE st.date_time >= (now() - '1 day'::interval) AND st.date_time <= now() AND st.state = 'free'::vehicle_states AND v.tracker_id IS NOT NULL AND v.tracker_id::text <> ''::text
          ORDER BY v.id) sub
  WHERE (now() - sub.last_data::timestamp with time zone) > '1 day'::interval;

ALTER TABLE public.broken_trackers_list_view
    OWNER TO ;

