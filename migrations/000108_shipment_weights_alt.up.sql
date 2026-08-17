ALTER TABLE public.shipment_weights 
	ADD COLUMN IF NOT EXISTS material text,
	ADD COLUMN IF NOT EXISTS sender_name text,
	ADD COLUMN IF NOT EXISTS sender_client text,
	ADD COLUMN IF NOT EXISTS unloading_warehouse text;

