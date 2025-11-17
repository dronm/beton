-- Table: public.production_vehicle_corrections

-- DROP TABLE IF EXISTS public.production_vehicle_corrections;

CREATE TABLE IF NOT EXISTS public.production_vehicle_corrections
(
    production_site_id integer NOT NULL,
    production_id integer NOT NULL,
    vehicle_id integer NOT NULL,
    date_time timestamp with time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    user_id integer NOT NULL,
    CONSTRAINT production_vehicle_corrections_pkey PRIMARY KEY (production_site_id, production_id),
    CONSTRAINT production_vehicle_corrections_production_site_id_fkey FOREIGN KEY (production_site_id)
        REFERENCES public.production_sites (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT production_vehicle_corrections_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT production_vehicle_corrections_vehicle_id_fkey FOREIGN KEY (vehicle_id)
        REFERENCES public.vehicles (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;
