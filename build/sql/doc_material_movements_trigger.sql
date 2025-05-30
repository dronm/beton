
--DROP TRIGGER public.doc_material_movements_before;
-- before trigger
CREATE TRIGGER doc_material_movements_before
	BEFORE INSERT OR UPDATE OR DELETE ON public.doc_material_movements
	FOR EACH ROW EXECUTE PROCEDURE public.doc_material_movements_process();

-- after trigger

--DROP TRIGGER public.doc_material_movements_after;
CREATE TRIGGER doc_material_movements_after
	AFTER INSERT OR UPDATE OR DELETE ON public.doc_material_movements
	FOR EACH ROW EXECUTE PROCEDURE public.doc_material_movements_process();

