ALTER TABLE public.shipment_weights 
	ADD COLUMN IF NOT EXISTS ship_weighing_cause ship_weighing_causes,
	ADD COLUMN IF NOT EXISTS uploaded_at timestamp
;

