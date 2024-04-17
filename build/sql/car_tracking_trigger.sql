-- Trigger: car_tracking_after_insert

 --DROP TRIGGER car_tracking_after_insert ON public.car_tracking;

CREATE TRIGGER car_tracking_after_insert
    AFTER INSERT
    ON public.car_tracking
    FOR EACH ROW
    EXECUTE PROCEDURE public.geo_zone_check();
    
/*    
-- Trigger: car_tracking_before_insert

-- DROP TRIGGER IF EXISTS car_tracking_before_insert ON public.car_tracking;

CREATE TRIGGER car_tracking_before_insert
    BEFORE INSERT
    ON public.car_tracking
    FOR EACH ROW
    EXECUTE FUNCTION public.bad_coord_check();    
*/    
