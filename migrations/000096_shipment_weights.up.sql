	CREATE TABLE public.shipment_weights
	(
		shipment_id int NOT NULL REFERENCES shipments(id),
		date_time timestampTZ NOT NULL,
		quant_gross  numeric(19,2) DEFAULT 0,
		quant_net  numeric(19,2) DEFAULT 0,
		CONSTRAINT shipment_weights_pkey PRIMARY KEY (shipment_id)
	);

