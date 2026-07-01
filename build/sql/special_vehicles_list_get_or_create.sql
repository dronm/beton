-- This funciton is called from Vehicle_Controller->get_special_vehicles_list()
-- Function to get data from materialized view or create it on the fly
CREATE OR REPLACE FUNCTION public.special_vehicles_list_get_or_create(p_date timestamp)
RETURNS TABLE(
    id int,
    vehicles_ref json,
    tracker_id text,
    make text,
    tracker_no_signal bool,
    no_tracker bool,
    mileage numeric,
    timing interval,
    fuel_flow_start int,
    fuel_flow_in int,
    fuel_flow_out int,
    fuel_flow_end int,
    map_picture text
) AS $$
DECLARE
    view_name text;
BEGIN
    -- Check if materialized view exists
    IF public.special_vehicles_list_mv_exists(p_date) THEN
        view_name := 'special_vehicles_list_' || to_char(p_date, 'YYYYMMDD');
        
        -- Return data from materialized view
        RETURN QUERY EXECUTE format('SELECT * FROM public.%I', view_name);
    ELSE
        -- Create materialized view and return data
        view_name := public.special_vehicles_list_create_mv(p_date);
        
        -- Return data from newly created materialized view
        RETURN QUERY EXECUTE format('SELECT * FROM public.%I', view_name);
    END IF;
END;
$$ LANGUAGE plpgsql;


