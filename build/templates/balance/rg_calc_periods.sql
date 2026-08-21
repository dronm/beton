-- Table: public.rg_calc_periods

-- DROP TABLE IF EXISTS public.rg_calc_periods;

CREATE TABLE IF NOT EXISTS public.rg_calc_periods
(
    reg_type reg_types NOT NULL,
    date_time timestamp without time zone NOT NULL,
    CONSTRAINT rg_calc_periods_pkey PRIMARY KEY (reg_type)
)
;

