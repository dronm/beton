-- VIEW: material_store_for_order_list

--DROP VIEW material_store_for_order_list;

CREATE OR REPLACE VIEW material_store_for_order_list AS
	SELECT
		t.production_site_id AS id,
		coalesce(mat.name, '') AS name,
		production_sites_ref(pst) AS production_sites_ref,
		t.load_capacity,
		coalesce(bal.quant, 0) AS balance,
		bal.material_id AS material_id,
		pst.production_base_id
		
	FROM store_map_to_production_sites AS t	
	LEFT JOIN production_sites AS pst ON pst.id = t.production_site_id
	
	LEFT JOIN rg_material_facts_balance(
		'{}'::integer[],
		(SELECT array_agg(id) FROM raw_materials WHERE dif_store)
	) AS bal ON bal.production_site_id = t.production_site_id
	LEFT JOIN raw_materials AS mat ON mat.id=bal.material_id
	WHERE t.load_capacity > 0
	ORDER BY pst.name, mat.name
	;
	
ALTER VIEW material_store_for_order_list OWNER TO ;
