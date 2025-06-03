begin;		
	ALTER TABLE public.doc_material_movements ADD COLUMN carrier_id int REFERENCES suppliers(id);
	ALTER TABLE public.doc_material_movements ADD COLUMN vehicle_plate  varchar(10);
commit;

