-- Trigger: ra_material_facts_before

-- DROP TRIGGER ra_material_facts_before ON public.ra_material_facts;

CREATE TRIGGER ra_material_facts_before
    BEFORE INSERT OR DELETE OR UPDATE 
    ON public.ra_material_facts
    FOR EACH ROW
    EXECUTE PROCEDURE public.ra_material_facts_process();


-- Trigger: ra_material_facts_after

-- DROP TRIGGER ra_material_facts_after ON public.ra_material_facts;

CREATE TRIGGER ra_material_facts_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.ra_material_facts
    FOR EACH ROW
    EXECUTE PROCEDURE public.ra_material_facts_process();
