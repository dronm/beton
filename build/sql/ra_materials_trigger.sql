-- Trigger: ra_materials_after

-- DROP TRIGGER ra_materials_after ON public.ra_materials;

CREATE TRIGGER ra_materials_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.ra_materials
    FOR EACH ROW
    EXECUTE PROCEDURE public.ra_materials_process();
    
    
    
-- Trigger: ra_materials_before

-- DROP TRIGGER ra_materials_before ON public.ra_materials;

CREATE TRIGGER ra_materials_before
    BEFORE INSERT OR DELETE OR UPDATE 
    ON public.ra_materials
    FOR EACH ROW
    EXECUTE PROCEDURE public.ra_materials_process();    
