	-- ********** Adding new table from model **********
	CREATE TABLE public.order_contacts
	(
		id serial NOT NULL,
		order_id int REFERENCES orders(id),
		contact_id int REFERENCES contacts(id),
		CONSTRAINT order_contacts_pkey PRIMARY KEY (id)
	);

	DROP INDEX IF EXISTS order_contacts_order_id_contact_id_idx;
	CREATE UNIQUE INDEX order_contacts_order_id_contact_id_idx
	ON order_contacts(order_id,contact_id);

