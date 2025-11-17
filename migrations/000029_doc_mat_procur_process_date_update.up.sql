begin;

DROP TRIGGER doc_material_procurements_before ON public.doc_material_procurements;
DROP TRIGGER doc_material_procurements_after ON public.doc_material_procurements;

update doc_material_procurements set process_date_time = date_time where process_date_time is null;


CREATE TRIGGER doc_material_procurements_before
    BEFORE INSERT OR DELETE OR UPDATE 
    ON public.doc_material_procurements
    FOR EACH ROW
    EXECUTE PROCEDURE public.doc_material_procurements_process();

CREATE TRIGGER doc_material_procurements_after
    AFTER INSERT OR DELETE OR UPDATE 
    ON public.doc_material_procurements
    FOR EACH ROW
    EXECUTE PROCEDURE public.doc_material_procurements_process();    

commit;
