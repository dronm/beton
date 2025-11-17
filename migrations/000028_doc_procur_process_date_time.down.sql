
begin;
	DROP VIEW doc_material_procurements_list;
	ALTER TABLE public.doc_material_procurements DROP COLUMN process_date_time;
commit;
