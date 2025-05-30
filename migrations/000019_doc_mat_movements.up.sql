	CREATE TABLE public.doc_material_movements
	(id serial NOT NULL,
		date_time timestamp NOT NULL,
		number  varchar(11),
		processed bool,
		material_id int REFERENCES raw_materials(id),
		production_base_from_id int REFERENCES production_bases(id),
		production_base_to_id int REFERENCES production_bases(id),
		quant  numeric(19,2),
		user_id int REFERENCES users(id),
		CONSTRAINT doc_material_movements_pkey PRIMARY KEY (id)
	);

