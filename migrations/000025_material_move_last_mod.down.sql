begin; 
DROP VIEW public.doc_material_movements_list;

ALTER TABLE public.doc_material_movements DROP COLUMN last_modif_user_id;
ALTER TABLE public.doc_material_movements DROP COLUMN last_modif_date_time;


commit;
