-- Function to create materialized view for a specific date
CREATE OR REPLACE FUNCTION public.special_vehicles_list_create_mv(p_date timestamp)
RETURNS text AS $$
DECLARE
    view_name text;
    index_name text;
BEGIN
    view_name := 'special_vehicles_list_' || to_char(p_date, 'YYYYMMDD');
    index_name := 'idx_' || view_name || '_id';

    -- Clean up any leftover materialized view or orphaned type
    EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS public.%I CASCADE', view_name);

    -- Now safely create the materialized view
    EXECUTE format('
        CREATE MATERIALIZED VIEW public.%I AS
        SELECT * FROM public.special_vehicles_list(%L)
    ', view_name, p_date);

    -- Create unique index for future concurrent refreshes
    EXECUTE format('
        CREATE UNIQUE INDEX %I ON public.%I (id)
    ', index_name, view_name);

    RETURN view_name;
END;
$$ LANGUAGE plpgsql;


