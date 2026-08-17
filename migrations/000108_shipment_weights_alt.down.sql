ALTER TABLE public.shipment_weights 
	DROP COLUMN IF EXISTS material,
	DROP COLUMN IF EXISTS sender_name,
	DROP COLUMN IF EXISTS sender_client,
	DROP COLUMN IF EXISTS unloading_warehouse;


