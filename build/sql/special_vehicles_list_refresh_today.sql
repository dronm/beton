
-- Function to refresh materialized view for the current date
CREATE OR REPLACE FUNCTION public.special_vehicles_list_refresh_today()
RETURNS void AS $$
DECLARE
    view_name text;
BEGIN
    view_name := 'special_vehicles_list_' || to_char(CURRENT_DATE, 'YYYYMMDD');
    
    -- Check if today's view exists and refresh it concurrently
    IF public.special_vehicles_list_mv_exists(CURRENT_DATE) THEN
        EXECUTE format('REFRESH MATERIALIZED VIEW CONCURRENTLY public.%I', view_name);
    END IF;
END;
$$ LANGUAGE plpgsql;
