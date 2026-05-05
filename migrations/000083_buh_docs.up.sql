
begin;

	drop view if exists transp_nakl;
	DROP TABLE IF EXISTS public.buh_docs;
	CREATE TABLE public.buh_docs
	(
		id serial NOT NULL,
		ref_1c jsonb,
		faktura_ref_1c jsonb,
		items jsonb,CONSTRAINT buh_docs_pkey PRIMARY KEY (id)
	);

	CREATE TABLE public.buh_doc_shipments
	(
		order_id int NOT NULL REFERENCES orders(id),
		shipment_id int NOT NULL REFERENCES shipments(id),
		buh_doc_id int REFERENCES buh_docs(id),
		CONSTRAINT buh_doc_shipments_pkey PRIMARY KEY (order_id,shipment_id)
	);

	DROP INDEX IF EXISTS buh_doc_shipments_buh_doc_id_idx;
	CREATE INDEX buh_doc_shipments_buh_doc_id_idx
	ON buh_doc_shipments(buh_doc_id);

commit;

