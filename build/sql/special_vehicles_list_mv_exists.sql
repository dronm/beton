-- Function to check if materialized view exists for a specific date
CREATE OR REPLACE FUNCTION public.special_vehicles_list_mv_exists(p_date timestamp)
RETURNS boolean AS $$
DECLARE
    view_name text;
    exists_flag boolean;
BEGIN
    view_name := 'special_vehicles_list_' || to_char(p_date, 'YYYYMMDD');
    
    SELECT EXISTS (
        SELECT 1 
        FROM pg_matviews 
        WHERE schemaname = 'public' 
        AND matviewname = view_name
    ) INTO exists_flag;
    
    RETURN exists_flag;
END;
$$ LANGUAGE plpgsql STABLE;

