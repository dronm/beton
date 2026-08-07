-- Trigger: ra_fuel_flow_before

-- DROP TRIGGER ra_fuel_flow_before ON public.ra_fuel_flow;

CREATE TRIGGER ra_fuel_flow_before
    BEFORE INSERT OR DELETE OR UPDATE 
    ON public.ra_fuel_flow
    FOR EACH ROW
    EXECUTE PROCEDURE public.ra_fuel_flow_process();


-- Trigger: ra_fuel_flow_after

-- DROP TRIGGER ra_fuel_flow_after ON public.ra_fuel_flow;

CREATE TRIGGER ra_fuel_flow_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.ra_fuel_flow
    FOR EACH ROW
    EXECUTE PROCEDURE public.ra_fuel_flow_process();

