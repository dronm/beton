ALTER TABLE shipment_weights 
	ADD COLUMN IF NOT EXISTS number text,
	ADD COLUMN IF NOT EXISTS comment_text text
;
