-- View: doc_material_procurements_list

-- DROP VIEW doc_material_procurements_list;

CREATE OR REPLACE VIEW doc_material_procurements_list AS 
 SELECT
 	doc.id,
	doc.number,
	doc.date_time,
	doc.processed,
	doc.supplier_id,
	suppliers_ref(sup) AS suppliers_ref,
	doc.carrier_id,
	suppliers_ref(car) AS carriers_ref,
	doc.material_id,
	materials_ref(mat) AS materials_ref,
	doc.cement_silos_id,
	cement_silos_ref(silo) AS cement_silos_ref,
	doc.driver,
	doc.vehicle_plate,
	doc.quant_gross,
	doc.quant_net,
	store,
	doc.production_base_id,
	production_bases_ref(bs) AS production_bases_ref,
	coalesce(doc_quant_net, 0) AS doc_quant_net,
	doc.sender_name,
	doc.doc_ref,
	doc.user_id,
	doc.doc_quant_gross,
	users_ref(u) AS users_ref,
	doc.comment_text,
	users_ref(u_last) AS last_modif_users_ref,
	doc.last_modif_date_time
	
   FROM doc_material_procurements doc
     LEFT JOIN suppliers sup ON sup.id = doc.supplier_id
     LEFT JOIN suppliers car ON car.id = doc.carrier_id
     LEFT JOIN raw_materials mat ON mat.id = doc.material_id
     LEFT JOIN cement_silos silo ON silo.id = doc.cement_silos_id
     LEFT JOIN production_bases bs ON bs.id = doc.production_base_id
     LEFT JOIN users AS u ON u.id = doc.user_id
     LEFT JOIN users AS u_last ON u_last.id = doc.last_modif_user_id
     
  ORDER BY doc.date_time DESC;

ALTER TABLE doc_material_procurements_list
  OWNER TO beton;

