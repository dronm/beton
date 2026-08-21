BEGIN;	
	-- ********** Adding new table from model **********
	CREATE TABLE public.shipment_weight_redirection_payments
	(
		shipment_id int NOT NULL REFERENCES shipments(id),
		user_id int NOT NULL REFERENCES users(id),
		created_at timestampTZ DEFAULT now(),
		CONSTRAINT shipment_weight_redirection_payments_pkey PRIMARY KEY (shipment_id)
	);

	DROP INDEX IF EXISTS shipment_weight_redirection_payments_created_at;
	CREATE INDEX shipment_weight_redirection_payments_created_at
	ON shipment_weight_redirection_payments(created_at);

	DROP INDEX IF EXISTS shipment_weight_redirection_payments_user_id;
	CREATE INDEX shipment_weight_redirection_payments_user_id
	ON shipment_weight_redirection_payments(user_id);

COMMIT;
