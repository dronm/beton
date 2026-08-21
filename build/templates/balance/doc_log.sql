-- Table: public.doc_log

-- DROP TABLE IF EXISTS public.doc_log;

CREATE TABLE IF NOT EXISTS public.doc_log
(
    id bigint NOT NULL DEFAULT nextval('doc_log_id_seq'::regclass),
    doc_type doc_types,
    doc_id integer,
    date_time timestamp without time zone,
    CONSTRAINT doc_log_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

-- DROP INDEX IF EXISTS public.doc_log_date_time_index;

CREATE INDEX IF NOT EXISTS doc_log_date_time_index
    ON public.doc_log USING btree
    (date_time ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
-- Index: doc_log_doc_index

-- DROP INDEX IF EXISTS public.doc_log_doc_index;

CREATE INDEX IF NOT EXISTS doc_log_doc_index
    ON public.doc_log USING btree
    (doc_type ASC NULLS LAST, doc_id ASC NULLS LAST)
    WITH (fillfactor=100, deduplicate_items=True)
    TABLESPACE pg_default;
