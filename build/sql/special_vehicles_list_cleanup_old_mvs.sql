-- Cleanup function to drop old materialized views
CREATE OR REPLACE FUNCTION public.special_vehicles_list_cleanup_old_mvs(p_days_to_keep int DEFAULT 7)
RETURNS void AS $$
DECLARE
    mv_record record;
BEGIN
    FOR mv_record IN 
        SELECT matviewname 
        FROM pg_matviews 
        WHERE schemaname = 'public' 
        AND matviewname LIKE 'special_vehicles_list_%'
        AND matviewname < 'special_vehicles_list_' || to_char(CURRENT_DATE - p_days_to_keep, 'YYYYMMDD')
    LOOP
        EXECUTE format('DROP MATERIALIZED VIEW IF EXISTS public.%I', mv_record.matviewname);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

