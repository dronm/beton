
ALTER TABLE public.doc_material_procurements 
	ADD COLUMN last_modif_user_id int REFERENCES users(id),
	ADD COLUMN last_modif_date_time timestampTZ;
