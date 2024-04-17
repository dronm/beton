-- Trigger: doc_material_procurements2_after

--DROP TRIGGER doc_material_procurements2_after ON public.doc_material_procurements2;

CREATE TRIGGER doc_material_procurements2_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.doc_material_procurements2
    FOR EACH ROW
    EXECUTE PROCEDURE public.doc_material_procurements2_process();    

