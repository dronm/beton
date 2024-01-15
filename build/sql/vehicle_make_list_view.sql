-- View: public.vehicle_make_list_view

-- DROP VIEW public.vehicle_make_list_view;

CREATE OR REPLACE VIEW public.vehicle_make_list_view
 AS
 SELECT DISTINCT ON (vehicles.make) vehicles.make
   FROM vehicles
  ORDER BY vehicles.make;

ALTER TABLE public.vehicle_make_list_view
    OWNER TO beton;

