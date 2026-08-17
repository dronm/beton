ALTER TABLE order_garbage 
	ADD COLUMN IF NOT EXISTS order_id int,
	ADD COLUMN IF NOT EXISTS ref_1c jsonb
	;
