
ALTER TABLE public.shipment_weights 
	DROP COLUMN IF EXISTS ship_weighing_cause,
	DROP COLUMN IF EXISTS uploaded_at
;
