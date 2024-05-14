-- Table: public.replicate_events

-- DROP TABLE IF EXISTS public.replicate_events;

CREATE UNLOGGED TABLE IF NOT EXISTS public.replicate_events
(
    event_id text COLLATE pg_catalog."default",
    params text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.replicate_events
    OWNER TO ;

